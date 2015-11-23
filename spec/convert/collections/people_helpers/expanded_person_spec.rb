require File.expand_path('../../../../spec_helper.rb', __FILE__)

def expanded_person_attributes
  %w[netid employee_id last_name first_name
  primary_work_space_address work_phone
  email_address all_positions_jobs
  about address buttons departments
  email expertise guides image jobtitle
  keywords location phone space
  status subtitle title twitter publications]
end


describe 'ExpandedPerson' do
  let(:json_data) { "{}" }
  context "when no JSON formatted data is provided" do
    subject(:expanded_person) { Conversion::Collections::PeopleHelpers::ExpandedPerson.new(json_data) }
    expanded_person_attributes.each do |attribute|
      it "should not have #{attribute}" do
        expect(expanded_person.send( attribute.to_sym )).to be_nil
      end
    end

    it "should be able to convert to markdown" do
      expect(expanded_person).to respond_to :to_markdown
    end

    it "should be a person" do
      expect(expanded_person).to be_a_kind_of(Conversion::Collections::PeopleHelpers::Person)
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
    let(:json_data_expand) {
      {
        id: {
          :$t => "https://spreadsheets.google.com/feeds/list/V8nNaf-000k1dESZGCwBvkuxoCe000k1dESZGCwBvkuxoCe/0/public/values/bpgoi"
        },
        updated: {
          :$t => "2015-10-28T18:47:00.245Z"
        },
        category: [{
            scheme: "http://schemas.google.com/spreadsheets/2006",
            term: "http://schemas.google.com/spreadsheets/2006#list"
        }],
        title: {
            type: "text",
            :$t => "xx99"
        },
        content: {
            type: "text",
            :$t => ""
        },
        link: [{
            rel: "self",
            type: "application/atom+xml",
            href: "https://spreadsheets.google.com/feeds/list/V8nNaf-000k1dESZGCwBvkuxoCe000k1dESZGCwBvkuxoCe/0/public/values/bpgoi"
        }],
        "gsx$netid" => {
          :$t => "xx99"
        },
        "gsx$subtitle" => {
          :$t => "subtitle"
        },
        "gsx$expertise" => {
          :$t => "Everything"
        },
        "gsx$twitter" => {
          :$t => "tweeter"
        },
        "gsx$image" => {
          :$t => "image"
        },
        "gsx$buttons" => {
          :$t => "buttons"
        },
        "gsx$guides" => {
          :$t => "title: Title ;\nlibguide_id: number"
        },
        "gsx$publications" => {
          :$t => "Publications"
        },
        "gsx$keywords" => {
          :$t => "Key Word"
        },
        "gsx$about" => {
          :$t => "This is test data about"
        },
        "gsx$title" => {
          :$t => "Title"
        },
        "gsx$phone" => {
          :$t => "(555) 555-5555"
        },
        "gsx$email" => {
          :$t => "not@nemail"
        },
        "gsx$address" => {
          :$t => "123 Sesame St"
        },
        "gsx$departments" => {
          :$t => "Astroland"
        },
        "gsx$location" => {
          :$t => "Coney Island"
        },
        "gsx$space" => {
          :$t => "Some Floor"
        },
        "gsx$status" => {
          :$t => "Status"
        },
        "gsx$jobtitle" => {
          :$t => "Jobtitle"
        }
      }.to_json
    }
    subject(:expanded_person) { Conversion::Collections::PeopleHelpers::ExpandedPerson.new(json_data, json_data_expand) }

    expanded_person_attributes.each do |attribute|
      it "should have #{attribute}" do
        expect(expanded_person.send( attribute.to_sym )).not_to be_nil
      end
    end

    it "should have the #{expanded_person_attributes.size} instance variables" do
      expect(expanded_person.instance_variables.size).to eql(expanded_person_attributes.size)
    end

    it "should be able to convert to markdown" do
      expect(expanded_person).to respond_to :to_markdown
    end

    it "should be a person" do
      expect(expanded_person).to be_a_kind_of(Conversion::Collections::PeopleHelpers::Person)
    end
  end
end
