require 'spec_helper'

def attributes
  %w[netid last_name first_name work_phone
  email_address all_positions_jobs]
end

describe 'Person' do
  let(:json_data) { "{}" }
  subject(:person) { Contented::Conversions::Collections::People::Person.new(json_data) }
  context "when no JSON formatted data is provided" do
    attributes.each do |attribute|
      next if attribute == 'all_positions_jobs'
      it "should not have #{attribute}" do
        expect(person.send( attribute.to_sym )).to be_nil
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
        expect(person.send( attribute.to_sym )).not_to be_nil
      end
    end

    it "should have the #{attributes.size} instance variables" do
      expect(person.instance_variables.size).to eql(attributes.size)
    end
  end
end
