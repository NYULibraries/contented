require 'spec_helper'

describe Contented::SourceReaders::Scheduall do
  let(:driver) { double 'driver' }
  let(:host_credentials) { Hash.new host: 'host.nyu.edu', password: 'password', username: 'nyuser' }
  let(:scheduall) { Contented::SourceReaders::Scheduall.new(host_credentials) }
  let(:driver_client) { double('driver_client') }
  let(:technologies) { load_yaml('./spec/fixtures/scheduall_technology.yml') }

  before do
    Contented::SourceReaders::Scheduall.stub(:driver).and_return(driver)
    allow(driver).to receive(:new).and_return driver_client
    allow(driver_client).to receive(:execute).and_return(technologies)
  end

  describe '#fetch_rooms' do
    describe 'fetch_technologies' do
      subject { scheduall.send :fetch_technologies }

      it { is_expected.to be_a Array }
      its(:count) { is_expected.to eql technologies.count }

      it 'strips ids' do
        expect(subject.first["id"]).to eq technologies.first["id"].strip
        expect(subject.first["building_id"]).to eq technologies.first["building_id"].strip
        expect(subject.first["technology_id"]).to eq technologies.first["technology_id"].strip
      end
    end

    describe 'normalize_rooms_by_id' do
      denormalized = load_yaml('./spec/fixtures/denormalized_rooms.yml')

      subject { scheduall.send :normalize_rooms_by_id, denormalized }

      it 'retains all unique room_id keys' do
        uniq_ids = denormalized.map { |v| v["id"] }.uniq
        overlap = subject.keys & uniq_ids

        expect(overlap.length).to eq uniq_ids.length
      end

      it 'merges all properties' do
        subject.each do |id, props|
          expect(props.key?("room_description")).to be true
          expect(props.key?("building_description")).to be true
          expect(props.key?("building_id")).to be true
          expect(props.key?("id")).to be true
        end
      end

      describe 'equipment property' do
        it 'provides equipment array to each key' do
          subject.each_value do |props|
            expect(props["technology"]).to be_a Array
          end
        end

        it 'Inserts values into array' do
          expect(subject.dig("3937", "technology")).to include("CM-Installed Wireless Keyboard")
          expect(subject.dig("3937", "technology")).to include("CM-Wireless Internet Connection")
          expect(subject.dig("2696", "technology")).to include("CM-Wireless Internet Connection")
        end
      end
    end
  end

  describe '#rooms' do
    subject { scheduall.rooms }

    it { is_expected.to be_an Array }
    its(:count) { is_expected.to eql 0 }

    context 'rooms fetched' do
      normalized_rooms = load_yaml('./spec/fixtures/normalized_rooms.yml')

      before do
        allow(scheduall).to receive :fetch_rooms do
          scheduall.instance_variable_set(:@rooms, normalized_rooms)
        end

        scheduall.fetch_rooms
      end

      subject { scheduall.rooms }

      it { is_expected.to be_an Array }
      its(:count) { is_expected.to eql normalized_rooms.length }
    end
  end

  describe '#each' do
    before do
      scheduall.stub(:rooms).and_return Hash.new('123' => {}, '456' => {})
    end

    it 'loops over the #rooms array' do
      scheduall.each do |room|
        expect room.to be_a Hash
      end
    end
  end
end
