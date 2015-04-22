require File.expand_path('../../spec_helper.rb', __FILE__)

describe Staff do
 
  let(:staff) { Staff.new(page_id, spreadsheet) }
 
  describe ".new" do
    subject { staff }
    context "when all arguments are passed" do
      it { should be_instance_of Staff }
      it { should_not raise_error }
    end
    context "when some arguments are missing" do
      it { should raise_error }
    end
  end
 
  describe "#create_staff_posts_from_sheet" do
    subject { staff.create_staff_posts_from_sheet }
    it "should create new posts" do
      #pending
    end
  end
 
end
