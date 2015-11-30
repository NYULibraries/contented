require 'spec_helper'

describe GatherContent::Api::Items, vcr: true do
  let(:project_id) { '57459' }
  let(:items) { GatherContent::Api::Items.new(project_id) }
  describe '.new' do
    subject { items }
    context 'when project ID is passed in' do
      it { is_expected.to be_a GatherContent::Api::Items }
    end
    context 'when project ID is not passed in' do
      let(:project_id) { nil }
      it 'should raise an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end
  describe '#project_id' do
    subject { items.project_id }
    it { is_expected.to eql project_id }
  end
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
