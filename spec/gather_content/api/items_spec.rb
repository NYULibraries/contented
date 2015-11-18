require 'spec_helper'

describe GatherContent::Api::Items, vcr: true do
  let(:project_id) { '57459' }
  let(:items) { GatherContent::Api::Items.new(project_id) }
  describe '#each' do
    subject { items }
    it { is_expected.to be_a Enumerable }
    it 'should contain Item objects' do
      items.each do |item|
        expect(item).to be_a GatherContent::Api::Item
      end
    end
  end
end
