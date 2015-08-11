require File.expand_path('../../spec_helper.rb', __FILE__)

describe 'FieldFormat' do
  let(:format) { FieldFormat }
  let(:element) { '' }

  describe '#strip_spaces_in_between' do
    subject { format.strip_spaces_in_between(element, ';') }
    context 'Strips spaces around the ";" second parameter' do
      let(:element) { 'testing  ;   test  ing   ;   testing' }
      it { should eql 'testing;test  ing;testing' }
    end
  end

  describe '#listify' do
    subject { format.listify(element) }
    context 'when element is empty' do
      it { should eql '' }
    end
    context 'listify semi-colon(;) seperated values into YAML Format' do
      let(:element) { 'Library; NYU' }
      it { should eql "\n  - \"Library\"\n  - \"NYU\"" }
    end
  end

  describe '#instancify' do
    subject { format.instancify(element) }
    context 'when element is empty' do
      it { should eql '' }
    end
    context 'Instancify semi-colon(;) seperated values into YAML Format' do
      let(:element) { 'Library; NYU' }
      it { should eql "\n  Library\n  NYU" }
    end
  end

  describe '#listify_assets' do
    subject { format.listify_assets(element) }
    context 'when element is empty' do
      it { should eql '' }
    end
    context 'Create list of path and names for assets' do
      let(:element) { 'Library, NYU' }
      it { should eql "\n  - path: \"Library, NYU\"" }
    end
  end

  describe '#break_address_2_lines' do
    subject { format.break_address_2_lines(element) }
    context 'when element is empty' do
      it { should eql '' }
    end
    context 'breaks the parameter into 2 lines at the first ,' do
      let(:element) { 'Library, NYU' }
      it { should eql "\n  Library\n  NYU" }
    end
  end
end
