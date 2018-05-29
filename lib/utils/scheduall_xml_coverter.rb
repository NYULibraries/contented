# Converts XML from original campusmedia application to normalized yaml
require 'yaml'
require 'ox'

ROOM_ATTRS = ["notes", "capacity", "instructions", "image", "software_image"]
BUILDING_ATTRS = ["address"]

def rooms
  xml_string = File.read('rooms-info.xml')
  Ox.load(xml_string, mode: :hash, skip: :skip_none)[:rooms][:room]
end

def buildings
  xml_string = File.read('buildings-info.xml')
  Ox.load(xml_string, mode: :hash, skip: :skip_none)[:buildings][:building]
end

def hashify_props_array(arr)
  arr.reduce({}) do |props, attr_hash|
    # transforms keys to string, excludes nil/empty values
    transformed = attr_hash.reduce({}) do |h, (k, v)|
      h.merge(v && v.is_a?(String) && v.strip.length > 0 ? { k.to_s => v } : {})
    end

    props.merge(transformed)
  end
end

def normalize(data, attrs)
  data.reduce({}) do |normalized, arr|
    id = arr.find { |hash| hash.has_key?(:id) }[:id]
    props_array = arr.reject { |h| h.has_key?(:id) }
    props = hashify_props_array(props_array)
    normalized.merge({ id => props.slice(*attrs) })
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

  File.open(filename, 'w') { |file| file.write(hash.to_yaml) }
end

write_to_yaml normalize(rooms, ROOM_ATTRS), 'rooms.yml'
write_to_yaml normalize(buildings, BUILDING_ATTRS), 'buildings.yml'
