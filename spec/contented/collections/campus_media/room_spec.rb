describe Contented::Collections::CampusMedia::Room do
  klass = Contented::Collections::CampusMedia::Room
  raw_rooms = load_yaml('spec/fixtures/normalized_rooms.yml').values

  let(:id) { '2696' }
  let(:raw_data) { raw_rooms.find { |r| r['id'] == id } }
  let(:save_location) { './spec/test_output' }
  let(:http) { double 'http' }

  FIXTURES = {
    rooms: File.read("spec/fixtures/config/rooms.yml"),
    buildings: File.read("spec/fixtures/config/buildings.yml"),
    technology: File.read("spec/fixtures/config/technology.yml"),
  }.freeze

  before do
    allow(http).
      to receive(:get).with(/rooms.yml/).
      and_return OpenStruct.new(body: FIXTURES[:rooms])

    allow(http).
      to receive(:get).with(/buildings.yml/).
      and_return OpenStruct.new(body: FIXTURES[:buildings])

    allow(http).
      to receive(:get).with(/technology.yml/).
      and_return OpenStruct.new(body: FIXTURES[:technology])

    stub_const "HTTParty", http
  end

  describe '::rooms_config' do
    subject { klass.rooms_config }

    it { is_expected.to be_a Hash }

    it 'props are converted to symbols' do
      all_symbols = subject.values.map(&:keys).flatten.all? { |key| key.is_a? Symbol }
      expect(all_symbols).to be true
    end

    it 'id keys symbolized' do
      all_symbols = subject.keys.all? { |k| k.is_a? Symbol }
      expect(all_symbols).to be true
    end
  end

  describe '::buildings_config' do
    subject { klass.buildings_config }

    it { is_expected.to be_a Hash }

    it 'props are converted to symbols' do
      all_symbols = subject.values.map(&:keys).flatten.all? { |key| key.is_a? Symbol }
      expect(all_symbols).to be true
    end

    it 'id keys symbolized' do
      subject.keys.all? { |k| k.is_a? Symbol }
    end
  end

  describe '::technology_config' do
    subject { klass.technology_config }

    it { is_expected.to be_a Hash }

    it 'symbolizes keys' do
      all_main_keys_symbols = subject.keys.all? { |k| k.is_a? Symbol }
      expect(all_main_keys_symbols).to be true

      all_props_symbolized = subject.values.map(&:keys).flatten.all? { |k| k.is_a? Symbol }
      expect(all_props_symbolized).to be true
    end
  end

  describe '::equipment' do
    subject { klass.equipment }

    it { is_expected.to be_a Hash }
    its([:'CM-Installed Wireless Keyboard']) do
      is_expected.to be_deep_equal(
        label: 'Wireless Keyboard',
        description: 'Used for typing things',
        type: "equipment"
      )
    end
  end

  describe '::features_with_labels' do
    subject { klass.features }

    it { is_expected.to be_a Hash }
    its([:'CM-Wireless Internet Connection']) do
      is_expected.to eql(
        label: 'Wireless Internet Connection',
        type: 'feature'
      )
    end
  end

  describe '::defaults' do
    before do
      allow(klass).
        to receive(:rooms_config).
        and_return(
          default: {
            links: nil,
            policies: nil,
            buttons: nil,
            keywords: nil,
            help: {
              text: nil,
              phone: nil,
              email: nil,
            },
            body: nil,
          },
        )
    end

    subject { klass.defaults }

    its([:links]) { is_expected.to be_a Hash }
    its([:policies]) { is_expected.to be_a Hash }
    its([:buttons]) { is_expected.to be_a Hash }
    its([:keywords]) { is_expected.to be_a Array }

    its([:help]) { is_expected.to be_a Hash }
    its([:help, :phone]) { is_expected.to be nil }
    its([:help, :text]) { is_expected.to be nil }
    its([:help, :email]) { is_expected.to be nil }

    its([:body]) { is_expected.to be nil }
  end

  describe '::merge_defaults!' do
    before do
      allow(klass).
        to receive(:defaults).
        and_return(
          links: {
            :'Default Link' => 'defaultlink1.com',
            :'Default Link2' => 'defaultlink2.com',
          },
          policies: {
            :'Policy Link' => 'policy.com',
          },
          buttons: {
            :'Button Link' => 'button.com',
          },
          keywords: ['key', 'word'],
          help: {
            text: 'Feel free to reach out',
            phone: '212 222 2222',
            email: 'email@email.com',
          },
          body: 'This is a placeholder body',
        )
    end

    subject { klass.merge_defaults!(dummy_data) }

    let(:dummy_data) do
      {
        links: {
          :'Link 3' => 'link3.com',
        },
        policies: {
          :'Extra policy' => 'policy2.com',
        },
        buttons: {
          :'More Buttons' => 'button2.com',
        },
        keywords: ['more', 'special', 'words'],
        help: {
          phone: '212 555 5555',
        },
        body: 'Now this body should appear',
      }
    end

    let(:merged) do
      {
        links: {
          :'Default Link' => 'defaultlink1.com',
          :'Default Link2' => 'defaultlink2.com',
          :'Link 3' => 'link3.com',
        },
        policies: {
          :'Policy Link' => 'policy.com',
          :'Extra policy' => 'policy2.com',
        },
        buttons: {
          :'Button Link' => 'button.com',
          :'More Buttons' => 'button2.com',
        },
        keywords: ['key', 'word', 'more', 'special', 'words'],
        help: {
          text: 'Feel free to reach out',
          phone: '212 555 5555',
          email: 'email@email.com',
        },
        body: 'Now this body should appear',
      }
    end

    its([:links]) { is_expected.to eql merged[:links] }
    its([:policies]) { is_expected.to eql merged[:policies] }
    its([:buttons]) { is_expected.to eql merged[:buttons] }
    its([:keywords]) { is_expected.to eql merged[:keywords] }
    its([:help]) { is_expected.to be_deep_equal merged[:help] }
    its([:body]) { is_expected.to eql merged[:body] }
    its(:object_id) { is_expected.to eql dummy_data.object_id }
  end

  describe '#initialize' do
    let(:room) { klass.new(raw_data, save_location) }

    before do
      allow(klass).
        to receive(:defaults).
        and_return(
          links: {
            :'Default Link' => 'defaultlink1.com',
            :'Default Link2' => 'defaultlink2.com',
          },
          policies: {
            :'Policy Link' => 'policy.com',
          },
          buttons: {
            :'Button Link' => 'button.com',
          },
          keywords: ['key', 'word'],
          help: {
            text: 'Feel free to reach out',
            phone: '212 222 2222',
            email: 'email@email.com',
          },
          body: 'This is a placeholder body',
        )
    end

    describe '#raw' do
      subject { room.raw }

      it { is_expected.to be_a Hash }

      it 'string keys are converted to symbols' do
        all_symbols = subject.keys.all? { |k| k.is_a? Symbol }
        expect(all_symbols).to be true
      end
    end

    describe '#filename' do
      subject { room.filename }

      it { is_expected.to eql '19-university-place-209' }

      it 'handles complex descriptions' do
        complex_room = klass.new(raw_data.merge(title: '19  University Place  88 8 '), '.')
        expect(complex_room.filename).to eql "19-university-place-209"
      end
    end

    describe '#save_location' do
      subject { room.save_location }

      it { is_expected.to include save_location }
    end

    describe '#[attribute]' do
      subject { room }

      its(:id) { is_expected.to eql id }

      describe 'include ::rooms_config values & merges with defaults' do
        its(:title) { is_expected.to eql '19 University Place 209' }
        its(:links) do
          is_expected.to be_deep_equal(
            :'Default Link' => 'defaultlink1.com',
            :'Default Link2' => 'defaultlink2.com',
            Instructions: '19_University_Instructions.pdf'
          )
        end

        its(:capacity) { is_expected.to eql 30 }
        its(:image) { is_expected.to eql '19University229.jpg' }
        its(:departments) { is_expected.to eql 'Campus Media' }
        its(:policies) { is_expected.to be_deep_equal(:'Policy Link' => 'policy.com') }
        its(:buttons) { is_expected.to be_deep_equal(:'Button Link' => 'button.com') }
        its(:published) { is_expected.to be true }
        its(:type) { is_expected.to eql nil }
        its(:help) do
          is_expected.to be_deep_equal(
            text: 'Feel free to reach out',
            phone: '212 222 2222',
            email: '19Univ@nyu.edu'
          )
        end
        its(:access) { is_expected.to eql 'All' }
        its(:keywords) { is_expected.to eql ['key', 'word', '19 University'] }
        its(:description) { is_expected.to eql 'Placeholder description text' }
        its(:floor) { is_expected.to eql 1 }
      end

      describe 'includes ::buildings_config values' do
        its(:address) { is_expected.to eql '19 University Place' }
      end

      describe 'includes ::technology_config values' do
        its(:features) { is_expected.to eql ['Wireless Internet Connection'] }
        its(:equipment) { is_expected.to eql("Wireless Keyboard" => "Used for typing things") }
      end
    end

    describe '#to_markdown' do
      subject { room.send(:to_markdown) }

      # buildings_config
      it { is_expected.to include "address: 19 University Place" }

      # rooms_config
      it { is_expected.to include "capacity: 30" }
      it { is_expected.to include "links:" }
      it { is_expected.to include "Default Link: defaultlink1.com" }
      it { is_expected.to include "Default Link2: defaultlink2.com" }
      it { is_expected.to include "Instructions: 19_University_Instructions.pdf" }
      it { is_expected.to include "image: 19University229.jpg" }
      it { is_expected.to include "departments: Campus Media" }
      it { is_expected.to include "published: true" }
      it { is_expected.to include "buttons:" }
      it { is_expected.to include "Button Link: button.com" }
      it { is_expected.to include "policies:" }
      it { is_expected.to include "Policy Link: policy.com" }
      it { is_expected.to include "description: Placeholder description text" }
      it { is_expected.to include "type:" }
      it { is_expected.to include "help:" }
      it { is_expected.to include "text: Feel free to reach out" }
      it { is_expected.to include "phone: 212 222 2222" }
      it { is_expected.to include "email: 19Univ@nyu.edu" }
      it { is_expected.to include "keywords:" }
      it { is_expected.to include "key" }
      it { is_expected.to include "word" }
      it { is_expected.to include "19 University" }
      it { is_expected.to include "This is a body paragraph about 19 University Place" }

      #tech_config
      it { is_expected.to include "features:" }
      it { is_expected.to include "Wireless Internet Connection" }
      it { is_expected.to include "technology:" }
      it { is_expected.to include "Wireless Keyboard: Used for typing things" }
      # title
      it { is_expected.to include "title: 19 University Place 209" }
    end

    describe '#save_as_markdown!' do
      before { room.save_as_markdown! }

      it 'writes file to directory' do
        file_exists = File.exist?(
          File.expand_path(File.dirname(File.dirname(__FILE__))).
            split('/')[0...-2].join('/') +
            '/test_output/19_university_place_209.markdown'
        )

        expect(file_exists).to be true
      end
    end
  end
end
