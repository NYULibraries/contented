require 'spec_helper'

def expanded_person_attributes
  %w[work_phone email_address all_positions_jobs
    address buttons departments
    email expertise guides image jobtitle
    keywords library phone space
    status subtitle title twitter publications
    liaison_relationship
  ]
end

describe Contented::Conversions::Collections::People::ExpandedPerson do
  let(:unmapped_library) { 'Bobst Library' }
  let(:peoplesync) {
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
          Position_Work_Space: "New York > #{unmapped_library} > LITS > Web Services",
          Division_Name: "Division of Tests"
        }
      ]
    } .to_json
  }
  let(:people_sheet) {
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
      "gsx$library" => {
        :$t => "  20 Cooper  "
      },
      "gsx$space" => {
        :$t => "Some Floor"
      },
      "gsx$status" => {
        :$t => "Status"
      },
      "gsx$jobtitle" => {
        :$t => "Jobtitle"
      },
      "gsx$liaison_relationship" => {
        :$t => "liason relationship"
      }
    }.to_json
  }
  subject(:expanded_person) { Contented::Conversions::Collections::People::ExpandedPerson.new(person, person_sheet) }
  context 'when no JSON formatted data is provided' do
    let(:person) { Contented::Conversions::Collections::People::Person.new('{}') }
    let(:person_sheet) { Contented::Conversions::Collections::People::GoogleSpreadsheetPerson.new('{}') }
    expanded_person_attributes.each do |attribute|
      it "should not have #{attribute}" do
        next if attribute == 'all_positions_jobs'
        expect(expanded_person.send( attribute.to_sym )).to be_nil
      end
    end

    it "can have empty array for all_positions_jobs but never nil" do
      expect(expanded_person.all_positions_jobs).to_not be_nil
    end
  end
  context "when proper JSON formatted data is provided" do
    let(:person) { Contented::Conversions::Collections::People::Person.new(peoplesync) }
    let(:person_sheet) { Contented::Conversions::Collections::People::GoogleSpreadsheetPerson.new(people_sheet) }
    expanded_person_attributes.each do |attribute|
      it "should have #{attribute}" do
        expect(expanded_person.send( attribute.to_sym )).not_to be_nil
      end
    end

    expanded_person_attributes.each do |attribute|
      it "should have #{attribute}" do
        expect(expanded_person).to respond_to attribute
      end
    end
  end
end
