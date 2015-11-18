require 'spec_helper'

describe GatherContent::Departments, vcr: true do
  let(:project_id) { '57459' }
  # let(:json_string) { File.read(File.join(File.dirname(__FILE__), '../fixtures/departments.json')) }
  let(:departments) { GatherContent::Departments.new(project_id) }
  describe '.new' do
    subject { departments }
    it { is_expected.to be_a GatherContent::Departments }
    it 'should set the project id' do
      expect(departments.project_id).to eql '57459'
    end
    it 'should set items' do
      expect(departments.items).to be_a GatherContent::Api::Items
    end
  end
  describe '#to_a' do
    subject { departments.to_a }
    it { is_expected.to be_a Array }
  end
end
