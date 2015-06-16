require File.expand_path('../../../spec_helper.rb', __FILE__)

describe 'department' do
  let(:data) { 'Pass Something' }
  let(:department) { Nyulibraries::SiteLeaf::Helpers::Department.new(data) }

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

  describe '#create_department' do
    subject { department.create_department }
    context 'creates a department in siteleaf as a whole'  do
      it 'should create an entire subpage and the corresponding posts' do
        # pending
      end
    end
  end

  describe '#make_page' do
    subject { department.make_page }
    context 'creates a sub-page for a department in siteleaf'  do
      it 'should return page' do
        # expect(department.make_page('Pass Something')).to be_instance_of(Siteleaf::Page)
        # pending
      end
    end
  end

  describe '#make_post' do
    subject { department.make_post }
    context 'creates posts in sub-page for a department in siteleaf'  do
      it 'should return posts' do
        # pending
      end
    end
  end

  describe '#title' do
    subject { department.title }
    context 'extracts title from data element'  do
      it 'should return title' do
        # pending
      end
    end
  end
end

describe 'departments' do
  let(:departments) { Nyulibraries::SiteLeaf::Helpers::Departments }

  describe '#self.load' do
    subject { departments.load }
    context 'loops over the spreadsheet and enumerates each row into a department object'  do
      it 'should return an array of all departments' do
        # expect(departments.load('pass Anything')[0]).to be_instance_of(Nyulibraries::SiteLeaf::Helpers::Department)
        # pending
      end
    end
  end
end
