describe Contented::SourceReaders::Scheduall do
  let(:host_credentials) { { host: 'host.nyu.edu', password: 'password', username: 'nyuser' } }
  let(:scheduall) { Contented::SourceReaders::Scheduall.new(host_credentials) }
  let(:technologies) { load_yaml('./spec/fixtures/source_readers/scheduall_technology.yml') }

  before do
    tinytds_client = instance_double("TinyTds::Client", execute: technologies)
    class_double("TinyTds::Client", new: tinytds_client).as_stubbed_const
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

    describe 'fetch_filtered_technologies' do
      subject { scheduall.send :fetch_filtered_technologies }

      it { is_expected.to be_a Array }
      its(:count) { is_expected.to eql(technologies.count - 1) }

      it 'filters out invalid equipment' do
        expect(subject.all? { |props| props['technology_description'].include?('CM-Installed') || props['technology_description'].include?('CM-Wireless') })
      end
    end

    describe 'normalize_rooms_by_id' do
      subject { scheduall.send :normalize_rooms_by_id, denormalized }

      let(:denormalized) { load_yaml('./spec/fixtures/source_readers/denormalized_rooms.yml') }

      it 'retains all unique room_id keys' do
        uniq_ids = denormalized.map { |v| v["id"] }.uniq
        overlap = subject.keys & uniq_ids

        expect(overlap.length).to eq uniq_ids.length
      end

      it 'merges all properties' do
        subject.each do |id, props|
          expect(props.key?("title")).to be true
          expect(props.key?("location")).to be true
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

    context 'before rooms fetched' do
      it { is_expected.to be_an Array }
      its(:count) { is_expected.to eql 0 }
    end

    context 'when rooms fetched' do
      let(:normalized_rooms) { load_yaml('./spec/fixtures/campus_media_room/normalized_rooms.yml') }

      before do
        allow(scheduall).to receive :fetch_rooms do
          scheduall.instance_variable_set(:@rooms, normalized_rooms)
        end
        scheduall.fetch_rooms
      end

      it { is_expected.to be_an Array }
      its(:count) { is_expected.to eql normalized_rooms.length }
    end
  end

  describe '#each' do
    subject { scheduall.rooms }

    before do
      scheduall.stub(:rooms).and_return([{ '123' => {} }, { '456' => {} }])
    end

    it 'loops over the #rooms array' do
      scheduall.each do |r|
        expect(r).to be_a Hash
      end
    end
  end

  describe '#save_rooms!' do
    subject { scheduall.save_rooms!('./spec/test_output') }

    before { class_double("File", write: true).as_stubbed_const }

    it { is_expected.to be true }
  end

  describe '#public_technology?' do
    subject { scheduall.send(:public_technology?, tech_item) }
    let(:tech_item) { nil }

    context 'with a valid prefix' do
      describe "CM-Installed" do
        let(:tech_item) { 'CM-Installed random technology item' }
        it { is_expected.to be true }
      end

      describe "CM-Wirelss" do
        let(:tech_item) { 'CM-Installed random technology item' }
        it { is_expected.to be true }
      end
    end

    context 'with an invalid prefix' do
      let(:tech_item) { 'CM-GLOBAL random technology item' }
      it { is_expected.to be false }
    end
  end
end
