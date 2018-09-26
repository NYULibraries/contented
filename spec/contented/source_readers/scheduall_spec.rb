describe Contented::SourceReaders::Scheduall do
  let(:host_credentials) { { host: 'host.nyu.edu', password: 'password', username: 'nyuser' } }
  let(:scheduall) { Contented::SourceReaders::Scheduall.new(host_credentials) }
  let(:equipment) { load_yaml('./spec/fixtures/source_readers/scheduall_equipment.yml') }

  before do
    tinytds_client = instance_double("TinyTds::Client", execute: equipment)
    class_double("TinyTds::Client", new: tinytds_client).as_stubbed_const
  end

  describe '#fetch_rooms' do
    describe 'fetch_equipment' do
      subject { scheduall.send :fetch_equipment }

      it { is_expected.to be_a Array }
      its(:count) { is_expected.to eql equipment.count }

      it 'strips ids' do
        expect(subject.first["id"]).to eq equipment.first["id"].strip
        expect(subject.first["building_id"]).to eq equipment.first["building_id"].strip
        expect(subject.first["equipment_id"]).to eq equipment.first["equipment_id"].strip
      end
    end

    describe 'fetch_filtered_equipment' do
      subject { scheduall.send :fetch_filtered_equipment }

      it { is_expected.to be_a Array }
      its(:count) { is_expected.to eql(equipment.count - 1) }

      it 'filters out invalid equipment' do
        expect(subject.all? { |props| props['equipment_description'].include?('CM-Installed') || props['equipment_description'].include?('CM-Wireless') })
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
            expect(props["equipment"]).to be_a Array
          end
        end

        it 'Inserts values into array' do
          expect(subject.dig("3937", "equipment")).to include("CM-Installed Wireless Keyboard")
          expect(subject.dig("3937", "equipment")).to include("CM-Wireless Internet Connection")
          expect(subject.dig("2696", "equipment")).to include("CM-Wireless Internet Connection")
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

  describe '#public_equipment?' do
    subject { scheduall.send(:public_equipment?, equipment_item) }
    let(:equipment_item) { nil }

    context 'with a valid prefix' do
      describe "CM-Installed" do
        let(:equipment_item) { 'CM-Installed random equipment item' }
        it { is_expected.to be true }
      end

      describe "CM-Wirelss" do
        let(:equipment_item) { 'CM-Installed random equipment item' }
        it { is_expected.to be true }
      end
    end

    context 'with an invalid prefix' do
      let(:equipment_item) { 'CM-GLOBAL random equipment item' }
      it { is_expected.to be false }
    end
  end
end
