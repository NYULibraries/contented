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
    Contented::SourceReaders::Scheduall.class_variable_set :@@driver, driver
    allow(driver).to receive(:new).and_return driver_client
  end

  describe '#initialize' do
    it 'sets @client to driver' do
      expect(scheduall.client).to be driver_client
    end

    it 'sets @data to nil' do
      expect(scheduall.data).to be(nil)
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

  end
end