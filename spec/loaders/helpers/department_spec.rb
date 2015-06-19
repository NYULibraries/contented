require File.expand_path('../../../spec_helper.rb', __FILE__)

describe 'department' do
  let(:data) { 'Pass Something' }
  let(:department) { Nyulibraries::SiteLeaf::Loaders::Helpers::Department.new(data) }

  # Entire testing depends upon the structure of @data variable so will hold off until it is done

  describe '.new' do
    subject { department }
    context 'when all arguments are passed' do
      it 'should not raise error' do
        expect { department }.not_to raise_error
      end
    end
    context 'when argument is missing' do
      let(:data) { '' }
      it 'should raise error' do
        expect { department }.to raise_error(ArgumentError)
      end
    end
  end
end

describe 'departments' do
  let(:departments) { Nyulibraries::SiteLeaf::Loaders::Helpers::Departments }

  describe '#self.load' do
    subject { departments.load }
    context 'loops over the spreadsheet and enumerates each row into a department object'  do
      it 'should return an array of all departments' do
        # pending
      end
    end
  end
end
