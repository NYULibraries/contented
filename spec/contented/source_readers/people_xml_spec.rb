require 'spec_helper'

describe Contented::SourceReaders::PeopleXML do
  let(:xml_file) { './spec/fixtures/source_readers/people.xml' }
  let(:people_xml) { Contented::SourceReaders::PeopleXML.new(xml_file) }

  describe '#file' do
    subject { people_xml.file }
    it { is_expected.to eql xml_file }
  end

  describe '#people' do
    subject { people_xml.people }
    it { is_expected.to be_a Array }
    its(:count) { is_expected.to eql 2 }
  end

  describe '#each' do
    it 'should loop over an array of people' do
      people_xml.each do |person|
        expect(person).to be_a Hash
      end
    end
  end
end
