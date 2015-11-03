require File.expand_path('../../../../spec_helper.rb', __FILE__)

def attributes
  %w[netid employee_id last_name first_name
  primary_work_space_address work_phone
  email_address all_positions_jobs]
end

describe 'Person' do
  let(:json_data) { "{}" }
  let(:person) { Conversion::Collections::PeopleHelpers::Person.new(json_data) }
  context "when no JSON formatted data is provided" do
    attributes.each do |attribute|
      it "should not have #{attribute}" do
        person.send( attribute.to_sym ).should be_nil
      end
    end
  end
  context "when proper JSON formatted data is provided" do
    let(:json_data) {
      {
         NetID: "xx123",
         Employee_ID: "N00000001",
         Last_Name: "Lastname",
         First_Name: "Firstname",
         Primary_Work_Space_Address: "10 Number Place",
         Work_Phone: "+1 (555) 5555555",
         Email_Address: "no-reply@nyu.edu",
         All_Positions_Jobs:[
            {
               Job_Profile: "000000 - Some Job Profile",
               Is_Primary_Job: "1",
               Job_Family_Group: "NYU - Something",
               Supervisory_Org_Name: "Some Group",
               Business_Title: "Super Fancy Title",
               Position_Work_Space: "Earth > America > New York > New York",
               Division_Name: "Division of Tests"
            }
         ]
      }.to_json
    }
    attributes.each do |attribute|
      it "should have #{attribute}" do
        person.send( attribute.to_sym ).should_not be_nil
      end
    end

    it "should have the #{attributes.size} instance variables" do
      person.instance_variables.size.should eql attributes.size
    end
  end
end
