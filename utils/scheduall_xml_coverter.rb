# Converts XML from original campusmedia application to normalized yaml
require 'yaml'
require 'ox'

ROOM_ATTRS = ["notes", "capacity", "instructions", "image", "software_image"]
BUILDING_ATTRS = ["address"]

def rooms
  xml_string = File.read("#{File.expand_path(File.dirname(File.dirname(__FILE__)))}/config/campusmedia/rooms-info.xml")
  Ox.load(xml_string, mode: :hash, skip: :skip_none)[:rooms][:room]
end

def buildings
  xml_string = File.read("#{File.expand_path(File.dirname(File.dirname(__FILE__)))}/config/campusmedia/buildings-info.xml")
  Ox.load(xml_string, mode: :hash, skip: :skip_none)[:buildings][:building]
end

def hashify_props_array(arr)
  # merge array into single hash
  props = arr.reduce({}) do |props, attr_hash|
    val = attr_hash.first[1]
    # excludes nil & empty valalues
    val.is_a?(String) && val.strip.length > 0 ? props.merge(attr_hash) : props
  end

  props.transform_keys { |k| k.to_s }
end

def normalize(data, attrs)
  data.reduce({}) do |normalized, arr|
    id = arr.find { |hash| hash.has_key?(:id) }[:id]
    props_array = arr.reject { |h| h.has_key?(:id) }
    props = hashify_props_array(props_array)
    normalized[id] = props.slice(*attrs)
    normalized
  end
end

def write_to_yaml(hash, filename)
  hash.each do |loc_key, loc_attrs|
    # converts numbers to int
    capacity = loc_attrs["capacity"]
    loc_attrs["capacity"] = capacity.to_i if capacity
    # converts empty hashes to nil
    hash[loc_key] = nil if loc_attrs.empty?
  end

  File.open("#{File.expand_path(File.dirname(File.dirname(__FILE__)))}/config/campusmedia/#{filename}", 'w') { |file| file.write(hash.to_yaml) }
end

write_to_yaml normalize(rooms, ROOM_ATTRS), 'rooms.yml'
write_to_yaml normalize(buildings, BUILDING_ATTRS), 'buildings.yml'
