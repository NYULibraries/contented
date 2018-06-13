require 'spec_helper'

describe Contented::Collections::CampusMedia::Room do
  klass = Contented::Collections::CampusMedia::Room
  raw_rooms = load_yaml('spec/fixtures/normalized_rooms.yml')
  id = '2696'
  raw_data = raw_rooms[id]
  save_location = './spec/test_output'.freeze

  FIXTURE_FILES = {
    rooms: 'spec/fixtures/config/rooms.yml',
    buildings: 'spec/fixtures/config/buildings.yml',
    technology: 'spec/fixtures/config/technology.yml',
  }.freeze

  before do
    stub_const("#{klass}::ROOMS_CONFIG_FILE", FIXTURE_FILES[:rooms])
    stub_const("#{klass}::BUILDINGS_CONFIG_FILE", FIXTURE_FILES[:buildings])
    stub_const("#{klass}::EQUIPMENT_CONFIG_FILE", FIXTURE_FILES[:technology])
  end

  describe '::rooms_config' do
    subject { klass.rooms_config }

    it { is_expected.to be_a Hash }

    it 'props are converted to symbols' do
      subject.values.map(&:keys).all? { |key| key.is_a? Symbol }
    end

    it 'id keys remain strings' do
      subject.keys { |k| k.is_a? String }
    end
  end

  describe '::buildings_config' do
    subject { klass.rooms_config }

    it { is_expected.to be_a Hash }

    it 'props are converted to symbols' do
      subject.values.map(&:keys).all? { |key| key.is_a? Symbol }
    end

    it 'id keys remain strings' do
      subject.keys { |k| k.is_a? String }
    end
  end

  describe '::technology_config' do
    subject { klass.technology_config }

    it { is_expected.to be_a Hash }
  end

  describe '::equipment_with_labels' do
    subject { klass.equipment_with_labels }

    expected = {
      'CM-Installed Wireless Keyboard' => {
        'label' => 'Wireless Keyboard',
        'description' => 'Used for typing things',
      },
    }


    it { is_expected.to be_a Hash }
    it { is_expected.to be_deep_equal expected }
  end

  describe '::features_with_labels' do
    subject { klass.features_with_labels }

    it { is_expected.to be_a Hash }

    result = { 'CM-Wireless Internet Connection' => 'Wireless Internet Connection' }
    it { is_expected.to eql result }
  end

  describe '#initialize' do
    let(:room) { klass.new(raw_data, save_location) }

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

      it { is_expected.to eql '2696_19Univ_229' }
    end

    describe '#save_location' do
      subject { room.save_location }

      it { is_expected.to include save_location }
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
        its(:software) { is_expected.to eql 'http://library.nyu.edu/software' }
        its(:image) { is_expected.to eql '19University229.jpg' }
        its(:notes) { is_expected.to eql 'Not a general purpose classroom' }
      end

      describe 'includes values from ::technology_config' do
        its(:features) { is_expected.to eql ['Wireless Internet Connection'] }
        its(:equipment) { is_expected.to eql("Wireless Keyboard" => "Used for typing things") }
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
      it { is_expected.to include "Software List: http://library.nyu.edu/software" }
      it { is_expected.to include "image: 19University229.jpg" }

      #tech_config
      it { is_expected.to include "features:" }
      it { is_expected.to include "Wireless Internet Connection" }
      it { is_expected.to include "technology:" }
      it { is_expected.to include "Wireless Keyboard: Used for typing things" }

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

      # other
      it { is_expected.to include "title: 19 University Place 229" }
    end

    describe '#save_as_markdown!' do
      subject { room.save_as_markdown! }

      it 'writes file to directory' do
        file_exists = File.exist?(
          File.expand_path(File.dirname(File.dirname(__FILE__)))
            .split('/')[0...-2].join('/') +
            '/test_output/2696_19Univ_229.markdown'
        )

        expect(file_exists).to be true
      end
    end
  end
end
