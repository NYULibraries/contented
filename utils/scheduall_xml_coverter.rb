# Converts XML from original campusmedia application to normalized yaml
require 'yaml'
require 'ox'

ROOM_ATTRS = ["notes", "capacity", "instructions", "image", "software-image"]
BUILDING_ATTRS = ["address"]

def rooms
  xml_string = File.read("#{File.expand_path(File.dirname(File.dirname(__FILE__)))}/config/campusmedia/rooms-info.xml")
  Ox.load(xml_string, mode: :hash, skip: :skip_none).dig(:rooms, :room)
end

def buildings
  xml_string = File.read("#{File.expand_path(File.dirname(File.dirname(__FILE__)))}/config/campusmedia/buildings-info.xml")
  Ox.load(xml_string, mode: :hash, skip: :skip_none).dig(:buildings, :building)
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

def normalize(data, attrs, prefix_strip=0)
  data.reduce({}) do |normalized, arr|
    id = arr.find { |hash| hash.has_key?(:id) }[:id]
    id = id.slice(prefix_strip, id.length)
    props_array = arr.reject { |h| h.has_key?(:id) }
    props = hashify_props_array(props_array)
    normalized[id] = props.slice(*attrs)
    normalized
  end
end

def write_to_yaml(hash, filename)
  hash.each do |loc_key, loc_props|
    # converts numbers to int
    loc_props["capacity"] = loc_props["capacity"]&.to_i
    # converts empty hashes to nil
    hash[loc_key] = nil if loc_props.empty?
  end

  File.open("#{File.expand_path(File.dirname(File.dirname(__FILE__)))}/config/campusmedia/#{filename}", 'w') { |file| file.write(hash.to_yaml) }
end

write_to_yaml normalize(rooms, ROOM_ATTRS, 8), 'rooms.yml'
write_to_yaml normalize(buildings, BUILDING_ATTRS, 12), 'buildings.yml'
