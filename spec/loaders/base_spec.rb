require File.expand_path('../../spec_helper.rb', __FILE__)

describe Base do
	
	before :all do

  end

  let(:base) { Base.new}
 
	describe ".new" do
  	subject { base }
    it "Authenticate Siteleaf" do
    	#Siteleaf::User.find('me')
    end
  end

  describe "#create_post" do
		subject { base.create_post }
    it "should create new posts" do
      #pending
    end
	end

	def "#delete_all_posts" do
		subject { base.delete_all_posts }
		context "when page_id arguments is passed" do
    	it "should delete all posts in that page_id" do
      	#pending
    	end
    end
	end

	def "#theme" do
		subject { base.theme }
		context "Return Theme" do
      #Siteleaf::Theme.find_by_site_id(ENV['SITELFEAF_ID'])
    end		
	end

	def "#spreadsheet_to_json" do 
		subject { base.spreadsheet_to_json }
		context "when spreasheet url is passed" do
			it "should return parsed JSON" do
     		#JSON.parse(open(spreadsheet).read)
    	end
    end    
  end

end
