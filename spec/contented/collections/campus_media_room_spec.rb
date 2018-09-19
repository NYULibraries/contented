describe Contented::Collections::CampusMediaRoom do
  klass = Contented::Collections::CampusMediaRoom
  raw_rooms = load_yaml('spec/fixtures/campus_media_room/normalized_rooms.yml').values

  let(:id) { '2696' }
  let(:raw_data) { raw_rooms.find { |r| r['id'] == id } }

  FIXTURES = {
    rooms: File.read("spec/fixtures/config/rooms.yml"),
    buildings: File.read("spec/fixtures/config/buildings.yml"),
    technology: File.read("spec/fixtures/config/technology.yml"),
  }.freeze

  before do
    http = class_double('Faraday').as_stubbed_const(transfer_nested_constants: true)
    allow(http).
      to receive(:get).with(/rooms.yml/).
      and_return OpenStruct.new(body: FIXTURES[:rooms])

    allow(http).
      to receive(:get).with(/buildings.yml/).
      and_return OpenStruct.new(body: FIXTURES[:buildings])

    allow(http).
      to receive(:get).with(/technology.yml/).
      and_return OpenStruct.new(body: FIXTURES[:technology])
  end

  describe '::rooms_config' do
    subject { klass.rooms_config }

    it { is_expected.to be_a Hash }

    it 'props are converted to symbols' do
      all_symbols = subject.values.map(&:keys).flatten.all? { |key| key.is_a? Symbol }
      expect(all_symbols).to be true
    end

    it 'symbolizes keys' do
      expect(subject.deep_symbolize_keys).to be_deep_equal subject
    end
  end

  describe '::buildings_config' do
    subject { klass.buildings_config }

    it { is_expected.to be_a Hash }

    it 'props are converted to symbols' do
      all_symbols = subject.values.map(&:keys).flatten.all? { |key| key.is_a? Symbol }
      expect(all_symbols).to be true
    end

    it 'symbolizes keys' do
      expect(subject.deep_symbolize_keys).to be_deep_equal subject
    end
  end

  describe '::technology_config' do
    subject { klass.technology_config }

    it { is_expected.to be_a Hash }

    it 'symbolizes keys' do
      expect(subject.deep_symbolize_keys).to be_deep_equal subject
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

  describe '::features' do
    subject { klass.features }

    it { is_expected.to be_a Hash }
    its([:'CM-Wireless Internet Connection']) do
      is_expected.to be_deep_equal(
        label: 'Wireless Internet Connection',
        type: 'feature'
      )
    end
  end

  describe '::defaults' do
    subject { klass.defaults }

    it { is_expected.to be_deep_equal YAML.safe_load(FIXTURES[:rooms])['default'].deep_symbolize_keys }
  end

  describe '#initialize' do
    let(:room) { klass.new(raw_data) }

    describe '#published' do
      subject { room.published }

      it { is_expected.to be true }

      context 'with only wireless internet' do
        let(:id) { '3937' }

        it { is_expected.to be false }
      end
    end

    describe '#title' do
      subject { room.title }

      it { is_expected.to eql '19 University Place 209' }

      context 'with empty from fillins' do
        subject { room.title }

        before do
          raw_data[:title] = nil
          allow(klass).to receive(:rooms_config).and_return(id.to_sym => { title: nil })
        end

        it { is_expected.to eql "NO_TITLE_#{id}" }
      end
    end

    describe '#filename' do
      subject { room.filename }

      it { is_expected.to eql '19-university-place-209' }

      context 'with complex descriptions' do
        before do
          allow(klass)
            .to receive(:rooms_config)
            .and_return(id.to_sym => { title: '19  University Place  88 8 ' })
        end

        it { is_expected.to eql "19-university-place-88-8" }
      end

      context 'with a specified url' do
        let(:url) { '19-univ-place-209' }

        before do
          allow(klass)
            .to receive(:rooms_config)
            .and_return(id.to_sym => { url: url })
        end

        it { is_expected.to eql url }
      end
    end

    describe 'buttons' do
      subject { room.buttons }

      context 'with more than one button specified' do
        let(:new_button) { { 'new button' => 'buttonlink.com' } }

        before do
          new_buildings_config = YAML.safe_load(FIXTURES[:buildings]).transform_keys(&:to_s)
          new_buildings_config[raw_data['building_id']].
            merge!('buttons' => new_button)
          new_buildings_config.deep_symbolize_keys!

          allow(klass).
            to receive(:buildings_config).
            and_return(new_buildings_config)
        end

        it { is_expected.to be_deep_equal new_button }
      end
    end

    describe 'attributes' do
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
        its(:policies) { is_expected.to be_deep_equal(:'Policy Link' => 'policy.com') }
        its(:buttons) { is_expected.to be_deep_equal(:'Button Link' => 'button.com') }
        its(:published) { is_expected.to be true }
        its(:type) { is_expected.to eql '' }
        its(:help) do
          is_expected.to be_deep_equal(
            text: 'This help text is specific to 19 University Place',
            phone: '212 222 2222',
            email: '19Univ@nyu.edu'
          )
        end
        its(:keywords) { is_expected.to eql ['key', 'word', '19 University'] }
        its(:display_building_address) { is_expected.to be true }
      end

      describe 'includes ::buildings_config values' do
        its(:address) { is_expected.to eql '19 University Place, New York, NY' }
      end

      describe 'includes ::technology_config values' do
        its(:features) { is_expected.to eql ['Wireless Internet Connection'] }
        its(:equipment) { is_expected.to eql("Wireless Keyboard" => "Used for typing things") }
      end
    end

    describe '#to_liquid_hash' do
      subject { room.to_liquid_hash }
      # buildings_config
      its(["address"]) { is_expected.to eql "19 University Place, New York, NY" }
      its(["location"]) { is_expected.to eql "19 University Place" }

      # # rooms_config
      its(['capacity']) { is_expected.to eql 30 }
      its(['links']) { is_expected.to be_a Hash }
      its(['links', 'Default Link']) { is_expected.to eql 'defaultlink1.com' }
      its(['links', 'Default Link2']) { is_expected.to eql 'defaultlink2.com' }
      its(['links', 'Instructions']) { is_expected.to eql '19_University_Instructions.pdf' }
      its(['image']) { is_expected.to eql '19University229.jpg' }
      its(['published']) { is_expected.to be true }
      its(['buttons']) { is_expected.to be_a Hash }
      its(['buttons', 'Button Link']) { is_expected.to eql 'button.com' }
      its(['policies']) { is_expected.to be_a Hash }
      its(['policies', 'Policy Link']) { is_expected.to eql 'policy.com' }
      its(['help']) { is_expected.to be_a Hash }
      its(['help', 'text']) { is_expected.to eql 'This help text is specific to 19 University Place' }
      its(['help', 'phone']) { is_expected.to eql '212 222 2222' }
      its(['help', 'email']) { is_expected.to eql '19Univ@nyu.edu' }
      its(['keywords']) { is_expected.to be_a Array }
      its(['keywords']) { is_expected.to include 'key' }
      its(['keywords']) { is_expected.to include 'word' }
      its(['body']) { is_expected.to eql 'This is a body paragraph about 19 University Place' }
      its(['title']) { is_expected.to eql '19 University Place 209' }

      # tech_config
      its(['features']) { is_expected.to be_a Array }
      its(['features']) { is_expected.to include 'Wireless Internet Connection' }
      its(['equipment']) { is_expected.to be_a Hash }
      its(['equipment', 'Wireless Keyboard']) { is_expected.to eql 'Used for typing things' }
      its(['display_building_address']) { is_expected.to be true }
    end
  end
end
