require File.expand_path('../../spec_helper.rb', __FILE__)

describe 'YamlMaker' do
  let(:yaml_maker) { Conversion::Helpers::YamlMaker }
  let(:data) { Hashie::Mash.new(libid: { t: 'Library; NYU' }) }
  let(:key) { 'lib_id' }

  describe '#slugify' do
    subject { yaml_maker.slugify(key) }
    context 'slugifies the name field by replacing spaces and hash (#) and making it all into lower case' do
      let(:key) { 'lib_id ANSWERS # lib' }
      it { should eql 'lib-id-answers-lib' }
    end
  end

  describe '#yaml_load' do
    subject { yaml_maker.yaml_load(key) }
    context 'Loads the structure (config/conversions/*.yml) file or else throw error' do
      let(:key) { 'xyz' }
      it 'should raise error' do
        expect { yaml_maker.yaml_load(key) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#blocks_of_data' do
    subject { yaml_maker.blocks_of_data(data, key, val) }
    context 'Returns a multi-line elements with : | at the start and a line break at first comma' do
      let(:val) { 'multi-line' }
      it { should eql "lib_id: |\n  Library; NYU\n" }
    end
    context 'Returns the raw text from the spreadsheet cell' do
      let(:val) { 'block' }
      it { should eql "lib_id \n\nLibrary; NYU\n" }
    end
  end

  describe '#singles_empty_or_not' do
    subject { yaml_maker.singles_empty_or_not(data, key) }
    context 'Returns nothing i.e. no empty quotes either' do
      let(:data) { Hashie::Mash.new(libid: { t: '' }) }
      it { should eql "lib_id: \n" }
    end
    context 'Returns the stringified form of the text in the spreadsheet cell' do
      let(:key) { 'lib_id' }
      it { should eql "lib_id: \"Library; NYU\"\n" }
    end
  end

  describe '#singles' do
    subject { yaml_maker.singles(data, key, val) }
    context 'Returns the stringified form of the text in the spreadsheet cell' do
      let(:val) { 'single' }
      it { should eql "lib_id: \"Library; NYU\"\n" }
    end
    context 'Returns false in non-stringified form if the spreadsheet cell is blank' do
      let(:data) { Hashie::Mash.new(libid: { t: '' }) }
      let(:val) { 'boolean' }
      it { should eql "lib_id: false\n" }
    end
    context 'Returns a boolean in non-stringified form from the spreadsheet cell' do
      let(:data) { Hashie::Mash.new(libid: { t: 'true' }) }
      let(:val) { 'boolean' }
      it { should eql "lib_id: true\n" }
    end
  end

  describe '#parse_yaml' do
    subject { yaml_maker.parse_yaml(data, key, val) }
    context 'Returns the raw text from the spreadsheet cell' do
      let(:val) { 'single' }
      it { should eql "lib_id: \"Library; NYU\"\n" }
    end
    context 'Returns a false boolean value if spreadsheet cell is blank' do
      let(:data) { Hashie::Mash.new(libid: { t: '' }) }
      let(:val) { 'boolean' }
      it { should eql "lib_id: false\n" }
    end
    context 'Returns a boolean value from spreadsheet cell' do
      let(:data) { Hashie::Mash.new(libid: { t: 'true' }) }
      let(:val) { 'boolean' }
      it { should eql "lib_id: true\n" }
    end
    context 'Returns a list from semi-colon(;) seperated values into YAML Format' do
      let(:val) { 'list' }
      it { should eql "lib_id:\n  - \"Library\"\n  - \"NYU\"\n" }
    end
    context 'Returns instances from semi-colon(;) seperated values into YAML Format' do
      let(:val) { 'instance' }
      it { should eql "lib_id:\n  Library\n  NYU\n" }
    end
    context 'Returns assets from semi-colon(;) seperated values into YAML Format' do
      let(:val) { 'assets' }
      it { should eql "lib_id:\n  - path: \"Library\"\n  - path: \"NYU\"\n" }
    end
    context 'Returns a multi-line elements with : | at the start and a line break at first comma' do
      let(:val) { 'multi-line' }
      it { should eql "lib_id: |\n  Library; NYU\n" }
    end
    context 'Returns the raw text from the spreadsheet cell' do
      let(:val) { 'block' }
      it { should eql "lib_id \n\nLibrary; NYU\n" }
    end
  end

  describe '#parse_md' do
    subject { yaml_maker.parse_md(data, key, val) }
    context 'Returns the value from the config .yml if new_line or hash or file_start or file_end' do
      let(:key) { 'new_line' }
      let(:val) { 'anything' }
      it { should eql 'anything' }
    end
  end
end
