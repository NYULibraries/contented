require 'spec_helper'
require 'yaml'

def load_yaml_file(filename)
  yml = File.read(filename)
  YAML.safe_load(yml)
end

describe Contented::SourceReaders::Scheduall do
  let(:driver) { double 'driver' }
  let(:host_credentials) { Hash.new host: 'host.nyu.edu', password: 'password', username: 'nyuser' }
  let(:scheduall) { Contented::SourceReaders::Scheduall.new(host_credentials) }
  let(:driver_client) { double('driver_client') }
  let(:technologies) { load_yaml_file('./spec/fixtures/scheduall_technology.yml') }

  before do
    Contented::SourceReaders::Scheduall.stub(:driver).and_return(driver)
    allow(driver).to receive(:new).and_return driver_client
  end

  describe '#initialize' do
    it 'sets @client to driver' do
      expect(scheduall.client).to be driver_client
    end

    it 'sets @data to empty hash' do
      expect(scheduall.data).to eq({})
    end
  end

  describe '#close' do
    before { allow(driver_client).to receive(:close).and_return true }

    it "calls driver's close method" do
      expect(driver_client).to receive(:close)
      scheduall.close
    end
  end

  describe '#rooms' do
    before { allow(driver_client).to receive(:execute).and_return(technologies) }

    describe 'fetch_technologies' do
      subject { scheduall.send :fetch_technologies }

      it { is_expected.to be_a Enumerable }
      its(:count) { is_expected.to eql technologies.count }

      it 'strips ids' do
        expect(subject.first["room_id"]).to eq technologies.first["room_id"].strip
        expect(subject.first["building_id"]).to eq technologies.first["building_id"].strip
        expect(subject.first["technology_id"]).to eq technologies.first["technology_id"].strip
      end

      it 'assigns return value to @data' do
        subject
        expect(scheduall.data).to eq subject
      end
    end

    describe 'normalize_rooms_by_id' do
      subject { scheduall.send :normalize_rooms_by_id }

      let(:denormalized) { load_yaml_file('./spec/fixtures/denormalized_rooms.yml') }
      let(:normalized) { load_yaml_file('./spec/fixtures/normalized_rooms.yml') }

      before { scheduall.instance_variable_set :@data, denormalized }

      it 'retains all unique room_id keys' do
        uniq_ids = denormalized.map { |v| v["room_id"] }.uniq
        overlap = subject.keys & uniq_ids

        expect(overlap.length).to eq uniq_ids.length
      end

      it 'merges room_description, room_building_description, & building_id properties' do
        subject.each do |id, props|
          expect(props.key?("room_description")).to be true
          expect(props.key?("room_building_description")).to be true
          expect(props.key?("building_id")).to be true
        end
      end

      describe 'room_technologies property' do
        it 'provides room_technologies array to each key' do
          subject.each do |k, v|
            expect(v["room_technologies"]).to be_a Array
          end
        end

        it 'strips first word from each entry' do
          expect(subject.dig("3937", "room_technologies")).to include("Keyboard")
          expect(subject.dig("3937", "room_technologies")).to include("Internet Connection")
          expect(subject.dig("2696", "room_technologies")).to include("Internet Connection")
        end
      end

      it 'assigns return value to @data' do
        subject
        expect(scheduall.data).to eq subject
      end
    end

    describe 'merge_config_values' do
      subject { scheduall.send :merge_config_values }

      # assumes buildings_yaml and rooms_yaml functions
      let(:rooms_yaml) { load_yaml_file('./spec/fixtures/config/rooms.yml') }
      let(:buildings_yaml) { load_yaml_file('./spec/fixtures/config/buildings.yml') }
      let(:normalized) { load_yaml_file('./spec/fixtures/normalized_rooms.yml') }

      before do
        scheduall.instance_variable_set :@data, normalized
        scheduall.stub(:rooms_yaml).and_return rooms_yaml
        scheduall.stub(:buildings_yaml).and_return buildings_yaml
      end

      it 'merges building_address value based on building_id' do
        subject.each do |k, props|
          expect(props["building_address"]).to eq "19 University Place"
        end
      end

      it 'merges room configuration data' do
        expect(subject['3937']['room_capacity']).to eq 25
        expect(subject['2696']['room_capacity']).to eq 30
        expect(subject['2696']['room_notes']).to eq 'Not a general purpose classroom'
      end

      it 'assigns return value to @data' do
        subject
        expect(scheduall.data).to eq subject
      end
    end
  end

  describe '#each' do
    before do
      scheduall.stub(:data).and_return Hash.new('123' => {}, '456' => {})
    end

    it 'loops over the @data' do
      scheduall.each do |room|
        expect room.to be_a Hash
      end
    end
  end
end
