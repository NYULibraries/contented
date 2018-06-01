require 'spec_helper'

def load_yaml_file(filename)
  yml = File.read(filename)
  YAML.safe_load(yml)
end

describe Contented::Collections::Room do

raw_data = load_yaml_file('spec/fixtures/normalized_and_merged_rooms.yml')
let(:room) { Contented::Collections::Room.new(raw_data) }

end
