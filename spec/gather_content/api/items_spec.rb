require 'spec_helper'

describe GatherContent::Api::Items do
  let(:items) { GatherContent::Api::Items.new('57459') }
  describe '#each' do
    subject { items.each }
    it { is_expected.to be_a Array }
  end
end
