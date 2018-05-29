# Converts XML from original campusmedia application to normalized yaml
require 'yaml'
require 'ox'

ROOM_ATTRS = ["notes", "capacity", "instructions", "image"]
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
    # transforms keys to string, nil values to empty strings
    transformed = attr_hash.reduce({}) do |h, (k, v)|
      h.merge({ k.to_s => ( v.nil? ? '' : v) })
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

def write_to_yaml(hash, dir, filename)
  File.open(filename, 'w') { |file| file.write(hash.to_yaml) }
end

write_to_yaml normalize(rooms, ROOM_ATTRS), 'rooms.yml'
write_to_yaml normalize(buildings, BUILDING_ATTRS), 'buildings.yml'
