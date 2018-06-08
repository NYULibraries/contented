require 'spec_helper'

describe Contented::Collections::Room do
  raw_rooms = load_yaml('spec/fixtures/normalized_rooms.yml')
  id = '2696'
  raw_data = raw_rooms[id]

  before do
    stub_const('Contented::Collections::Room::ROOMS_CONFIG_FILE', 'spec/fixtures/config/rooms.yml')
    stub_const('Contented::Collections::Room::BUILDINGS_CONFIG_FILE', 'spec/fixtures/config/buildings.yml')
    stub_const('Contented::Collections::Room::EQUIPMENT_CONFIG_FILE', 'spec/fixtures/config/technology.yml')
  end

  describe '::rooms_config' do
    subject { Contented::Collections::Room.rooms_config }

    it { is_expected.to be_a Hash }

    it 'props are converted to symbols' do
      subject.values.map(&:keys).all? { |key| key.is_a? Symbol }
    end
  end

  describe '::buildings_config' do
    subject { Contented::Collections::Room.rooms_config }

    it { is_expected.to be_a Hash }

    it 'props are converted to symbols' do
      subject.values.map(&:keys).all? { |key| key.is_a? Symbol }
    end
  end

  describe '::equipment_config' do
    subject { Contented::Collections::Room.technology_config }

    it { is_expected.to be_a Hash }
  end

  describe '#initialize' do
    let(:room) { Contented::Collections::Room.new(raw_data) }

    describe '#raw' do
      subject { room.raw }

      it { is_expected.to be_a Hash }

      it 'String keys are converted to symbols' do
        expect(subject).to eq(raw_data.transform_keys(&:to_sym))
      end
    end

    describe '#room' do
      subject { room.send(:room) }

      it { is_expected.to be_a OpenStruct }

      it 'includes attributes which share ::ATTRIBUTE_KEYS' do
        intersection = Contented::Collections::Room::ATTRIBUTE_KEYS & room.raw.keys
        intersection.each do |key|
          expect(subject[key]).to be_truthy
        end
      end
    end

    describe '#filename' do
      subject { room.filename }

      it { is_expected.to eql id }
    end

    describe 'attributes' do
      subject { room }

      its(:id) { is_expected.to eql id }
      its(:address) { is_expected.to eql '19 University Place' }
      its(:notes) { is_expected.to eql 'Not a general purpose classroom' }
      its(:capacity) { is_expected.to eql 30 }
      its(:software) { is_expected.to be true }
      its(:image) { is_expected.to eql 'GlobalCenter261.jpg' }
      its(:equipment) { is_expected.to eql ['Wireless Keyboard'] }
      its(:features) { is_expected.to eql ['Wireless Internet Connection'] }
    end

  end

end
