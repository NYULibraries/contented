require 'spec_helper'
require 'pry'

describe Contented::Collections::Room do
  raw_data = load_yaml('spec/fixtures/normalized_rooms.yml')['3937']

  before do
    stub_const('Contented::Collections::Room::ROOMS_CONFIG_FILE', 'spec/fixtures/config/rooms.yml')
    stub_const('Contented::Collections::Room::BUILDINGS_CONFIG_FILE', 'spec/fixtures/config/buildings.yml')
  end

  describe '::rooms_config' do
    subject { Contented::Collections::Room.rooms_config }

    it { is_expected.to be_a Hash }

    it 'appends room_ to each key' do
      subject.each_value do |props|
        props.each_key do |key|
          expect(key[0...5] == 'room_').to be(true)
        end
      end
    end
  end

  describe '::buildings_config' do
    subject { Contented::Collections::Room.rooms_config }

    it { is_expected.to be_a Hash }

    it 'appends building_ to each key' do
      subject.each_value do |props|
        props.each_key do |key|
          expect(key[0...5] == 'room_').to be(true)
        end
      end
    end
  end

  describe 'instance methods' do
    let(:room) { Contented::Collections::Room.new(raw_data) }

    describe '#initialize' do
      describe '#raw' do
        subject { room.raw }

        it { is_expected.to be_a Hash }

        it 'String keys are converted to symbols' do
          expect(subject).to eq(raw_data.transform_keys(&:to_sym))
        end
      end

      describe '#room' do
        subject { room.room }

        it { is_expected.to be_a OpenStruct }
      end
    end
  end

end
