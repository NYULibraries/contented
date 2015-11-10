require 'spec_helper'

describe GatherContent::Department do
  let(:project_id) { '57459' }
  let(:json_string) { File.read(File.join(File.dirname(__FILE__), '../fixtures/department.json')) }
  let(:department) { GatherContent::Department.new(json_string) }
  describe '#title' do
    subject { department.title }
    it { is_expected.to eql 'Web Services' }
  end
  describe '#body' do
    subject { department.body }
    it { is_expected.to include "We provide administrative management and technical support for the Libraries’ website and BobCat, its primary discovery interface. We also develop and maintain web-based services and special projects." }
  end
end
