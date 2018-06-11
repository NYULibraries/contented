require 'spec_helper'

describe Contented::Collections::Room do
  raw_rooms = load_yaml('spec/fixtures/normalized_rooms.yml')
  id = '2696'
  raw_data = raw_rooms[id]

  FIXTURE_FILES = {
    rooms: 'spec/fixtures/config/rooms.yml',
    buildings: 'spec/fixtures/config/buildings.yml',
    technology: 'spec/fixtures/config/technology.yml',
  }.freeze

  before do
    stub_const('Contented::Collections::Room::ROOMS_CONFIG_FILE', FIXTURE_FILES[:rooms])
    stub_const('Contented::Collections::Room::BUILDINGS_CONFIG_FILE', FIXTURE_FILES[:buildings])
    stub_const('Contented::Collections::Room::EQUIPMENT_CONFIG_FILE', FIXTURE_FILES[:technology])
  end

  describe '::rooms_config' do
    subject { Contented::Collections::Room.rooms_config }

    it { is_expected.to be_a Hash }

    it 'props are converted to symbols' do
      subject.values.map(&:keys).all? { |key| key.is_a? Symbol }
    end

    it 'id keys remain strings' do
      subject.keys { |k| k.is_a? String }
    end
  end

  describe '::buildings_config' do
    subject { Contented::Collections::Room.rooms_config }

    it { is_expected.to be_a Hash }

    it 'props are converted to symbols' do
      subject.values.map(&:keys).all? { |key| key.is_a? Symbol }
    end

    it 'id keys remain strings' do
      subject.keys { |k| k.is_a? String }
    end
  end

  describe '::technology_config' do
    subject { Contented::Collections::Room.technology_config }

    it { is_expected.to be_a Hash }
  end

  describe '::equipment_with_labels' do
    subject { Contented::Collections::Room.equipment_with_labels }

    it { is_expected.to be_a Hash }

    it { is_expected.to eql({ 'CM-Installed Wireless Keyboard' => 'Wireless Keyboard' }) }
  end

  describe '::features_with_labels' do
    subject { Contented::Collections::Room.features_with_labels }

    it { is_expected.to be_a Hash }

    result = { 'CM-Wireless Internet Connection' => 'Wireless Internet Connection' }
    it { is_expected.to eql result }
  end

  describe '#initialize' do
    let(:room) { Contented::Collections::Room.new(raw_data, '.') }

    describe '#raw' do
      subject { room.raw }

      it { is_expected.to be_a Hash }

      it 'string keys are converted to symbols' do
        expect(subject).to eq(raw_data.transform_keys(&:to_sym))
      end
    end

    describe '#room' do
      subject { room.send(:room) }

      it { is_expected.to be_a OpenStruct }
    end

    describe '#filename' do
      subject { room.filename }

      it { is_expected.to eql id }
    end

    describe '#save_location' do
      subject { room.save_location }

      it { is_expected.to eql '.' }
    end

    describe 'attributes' do
      subject { room }

      its(:id) { is_expected.to eql id }

      describe 'includes default values' do
        its(:departments) { is_expected.to eql 'Campus Media' }
        its(:policies_url) { is_expected.to eql 'http://library.nyu.edu/policies' }
        its(:form_url) { is_expected.to eql 'http://library.nyu.edu/form' }
        its(:published) { is_expected.to be false }
        its(:type) { is_expected.to eql 'Lecture Room' }
        its(:help_text) { is_expected.to eql 'Placeholder text about contact info' }
        its(:help_phone) { is_expected.to eql '212 222 2222' }
        its(:help_email) { is_expected.to eql 'library-help@nyu.edu' }
        its(:access) { is_expected.to eql 'NYU Faculty' }
        its(:keywords) { is_expected.to eql ['campus', 'media'] }
        its(:description) { is_expected.to eql 'Placeholder description text' }
        its(:floor) { is_expected.to eql nil }
      end

      describe 'includes values from ::buildings_config' do
        its(:address) { is_expected.to eql '19 University Place' }
      end

      describe 'includes values ::rooms_config' do
        its(:capacity) { is_expected.to eql 30 }
        its(:instructions) { is_expected.to eql '19_University_Instructions.pdf' }
        its(:software) { is_expected.to be true }
        its(:image) { is_expected.to eql '19University229.jpg' }
        its(:notes) { is_expected.to eql 'Not a general purpose classroom' }
      end

      describe 'includes values from ::technology_config' do
        its(:features) { is_expected.to eql ['Wireless Internet Connection'] }
        its(:equipment) { is_expected.to eql ['Wireless Keyboard'] }
      end

      describe '#title' do
        subject { room.title }

        it { is_expected.to eql '19 University Place 229' }
      end
    end

    describe '#to_markdown' do
      subject { room.send(:to_markdown) }

      # buildings_config
      it { is_expected.to include "address: 19 University Place" }
      # it { is_expected.to include "title: " }

      # rooms_config
      it { is_expected.to include "capacity: 30" }
      it { is_expected.to include "links:" }
      it { is_expected.to include "Room Instructions: 19_University_Instructions.pdf" }
      it { is_expected.to include "Software List: true" }
      it { is_expected.to include "image: 19University229.jpg" }

      #tech_config
      it { is_expected.to include "features:" }
      it { is_expected.to include "Wireless Internet Connection" }
      it { is_expected.to include "equipment:" }
      it { is_expected.to include "Wireless Keyboard" }

      # defaults
      it { is_expected.to include "departments: Campus Media" }
      it { is_expected.to include "published: false" }
      it { is_expected.to include "buttons:" }
      it { is_expected.to include "Reserve Equipment for this Room: http://library.nyu.edu/form" }
      it { is_expected.to include "Not a general purpose classroom" }
      it { is_expected.to include "policies:" }
      it { is_expected.to include "Policies: http://library.nyu.edu/policies" }
      it { is_expected.to include "description: Placeholder description text" }
      it { is_expected.to include "type: Lecture Room" }
      it { is_expected.to include "help:" }
      it { is_expected.to include "text: Placeholder text about contact info" }
      it { is_expected.to include "keywords:" }
      it { is_expected.to include "campus" }
      it { is_expected.to include "media" }
      it { is_expected.to include "phone: 212 222 2222" }
      it { is_expected.to include "email: library-help@nyu.edu" }

      # complex
      it { is_expected.to include "title: 19 University Place 229" }
    end
  end
end
