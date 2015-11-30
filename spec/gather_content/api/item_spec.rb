require 'spec_helper'

describe GatherContent::Api::Item, vcr: true do
  let(:item_id) { '2027930' }
  let(:item) { GatherContent::Api::Item.new(item_id) }
  describe '.new' do
    subject { item }
    context 'when item ID is passed in' do
      it { is_expected.to be_a GatherContent::Api::Item }
    end
    context 'when item ID is not passed in' do
      let(:item_id) { nil }
      it 'should raise an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end
  describe '#item_id' do
    subject { item.item_id }
    it { is_expected.to eql item_id }
  end
  describe '#get_item' do
    subject { item.get_item }
    it { is_expected.to be_a Hash }
  end
end
