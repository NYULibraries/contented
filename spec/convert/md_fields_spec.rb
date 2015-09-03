require File.expand_path('../../spec_helper.rb', __FILE__)

describe 'MDFields' do
  let(:md_fields) { Conversion::Helpers::MDFields }
  let(:data) { Hashie::Mash.new(libid: { tx: 'Library; NYU' }) }
  let(:key) { 'lib_id' }

  describe '#convert_to_column_names' do
    subject { md_fields.convert_to_column_names(key) }
    context "Removes Spaces(' ') and underscore(_) and makes it all lowercase to match object names of Spreadsheet JSON" do
      let(:key) { 'lib_id ANSWERS' }
      it { should eql 'libidanswers' }
    end
  end

  describe '#asset' do
    subject { md_fields.asset(data, key) }
    context 'Returns the MD format for assets with path and name' do
      let(:data) { Hashie::Mash.new(libid: { tx: 'ID>123' }) }
      it { should eql "\n  - path: \"ID\"\n    name: \"123\"\n" }
    end
  end

  describe '#list_or_instance' do
    subject { md_fields.list_or_instance(data, key, val) }
    context 'Returns a list from semi-colon(;) seperated values into YAML Format' do
      let(:val) { 'list' }
      it { should eql "\n  - \"Library\"\n  - \"NYU\"" }
    end
    context 'Returns instances of semi-colon(;) seperated values into YAML Format' do
      let(:val) { 'instance' }
      it { should eql "\n  Library\n  NYU" }
    end
  end

  describe '#list' do
    subject { md_fields.list(data, key, val) }
    context 'Returns a list from semi-colon(;) seperated values into YAML Format' do
      let(:val) { 'list' }
      it { should eql "lib_id:\n  - \"Library\"\n  - \"NYU\"\n" }
    end
    context 'Returns instances of semi-colon(;) seperated values into YAML Format' do
      let(:val) { 'instance' }
      it { should eql "lib_id:\n  Library\n  NYU\n" }
    end
    context 'Returns the MD format for assets with path and name' do
      let(:val) { 'assets' }
      it { should eql "lib_id:\n  - path: \"Library\"\n  - path: \"NYU\"\n" }
    end
  end

  describe '#multi_line' do
    subject { md_fields.multi_line(data, key) }
    context 'Returns a multi-line elements with : | at the start and a line break at first comma' do
      let(:data) { Hashie::Mash.new(libid: { tx: 'Library, NYU' }) }
      let(:key) { 'lib_id' }
      it { should eql "lib_id: |\n  Library\n  NYU\n" }
    end
  end

  describe '#block_title' do
    subject { md_fields.block_title(data, key, val) }
    context 'Returns the raw data from the spreadsheet cell preceded by the Key' do
      let(:data) { Hashie::Mash.new(libid: { tx: 'Library, NYU' }) }
      let(:val) { false }
      it { should eql "lib_id \n\nLibrary, NYU\n" }
    end
    context 'Returns the raw data from the spreadsheet cell preceded by the Key + title' do
      let(:data) { Hashie::Mash.new(libid: { tx: 'Library, NYU' }, title: { tx: 'NYU' }) }
      let(:val) { true }
      it { should eql "lib_id NYU\n\nLibrary, NYU\n" }
    end
  end

  describe '#block' do
    subject { md_fields.block(data, key) }
    context 'Returns the raw data from the spreadsheet cell preceded by What We do' do
      let(:data) { Hashie::Mash.new(whatwedo: { tx: 'Library, NYU' }) }
      let(:key) { 'whatwedo' }
      it { should eql "whatwedo \n\nLibrary, NYU\n" }
    end
    context 'Returns the raw data from the spreadsheet cell preceded by the Key' do
      let(:data) { Hashie::Mash.new(service: { tx: 'Library, NYU' }, title: { tx: 'NYU' }) }
      let(:key) { 'service' }
      it { should eql "service \n\nLibrary, NYU\n" }
    end
  end
end
