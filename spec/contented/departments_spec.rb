require 'spec_helper'

describe Contented::Departments, vcr: true do
  let(:project_id) { '57459' }
  let(:departments) { Contented::Departments.new(project_id) }
  describe '.new' do
    subject { departments }
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
    subject { departments.project_id }
    it { is_expected.to eql project_id }
  end
  describe '#each' do
    subject { departments }
    it { is_expected.to be_a Enumerable }
    it 'should contain Item objects' do
      departments.each do |item|
        expect(item).to be_a GatherContent::Api::Item
        expect(item).to be_a Contented::Department
      end
    end
  end
  describe '#item_class' do
    subject { departments.send(:item_class) }
    it { is_expected.to eql Contented::Department }
  end
end
