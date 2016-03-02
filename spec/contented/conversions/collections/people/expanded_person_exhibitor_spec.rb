require 'spec_helper'

def json_data_expand_attributes
  %w[buttons departments
  email expertise guides image jobtitle
  keywords location phone space
  status subtitle title twitter publications]
end

# PHONE format : (555) 555-5555
PHONE_REGEX = /^[(]\d{3}[)][ ]\d{3}[-]\d{4}$/
# departemnts format should be anything before any opening parenthesis '('
DEPARTMENTS_REGEX = /^[^()]+$/
# Location and space almost have the same regex should not have greater than '>'
LOCATION_SPACE_REGEX = /^[^>]+$/

describe 'ExpandedPersonExhibitor' do
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
               Position_Work_Space: "Earth > America > New York",
               Division_Name: "Division of Tests"
            }
         ]
      }.to_json
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
      "gsx$location" => {
        :$t => "20 Cooper Square"
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
  let(:person) { Contented::Conversions::Collections::People::Person.new(peoplesync) }
  let(:person_sheet) { Contented::Conversions::Collections::People::GoogleSpreadsheetPerson.new(people_sheet) }
  let(:expanded_person) { Contented::Conversions::Collections::People::ExpandedPerson.new(person, person_sheet) }
  subject(:expanded_person_exhibitor) { Contented::Conversions::Collections::People::ExpandedPersonExhibitor.new(expanded_person) }
  context 'when no JSON formatted data is provided' do
    let (:peoplesync) { '{}' }
    let (:people_sheet) { '{}' }

    json_data_expand_attributes.each do |attribute|
      it "should not have #{attribute}" do
        next if attribute == 'title'
        expect(expanded_person_exhibitor.send( attribute.to_sym )).to be_nil
      end
    end

    it "can have blank title but never nil" do
      expect(expanded_person_exhibitor.title).to_not be_nil
    end

    json_data_expand_attributes.each do |attribute|
      it "should have #{attribute}" do
         expect(expanded_person_exhibitor).to respond_to attribute
      end
    end
  end

  context 'when only json_data_expand is provided i.e. spreadsheet data' do
    let(:peoplesync) { '{}'}

    json_data_expand_attributes.each do |attribute|
      it "should have #{attribute}" do
        expect(expanded_person_exhibitor.send( attribute.to_sym )).not_to be_nil
      end
    end

    json_data_expand_attributes.each do |attribute|
      it "should have #{attribute}" do
        expect(expanded_person_exhibitor).to respond_to attribute
      end
    end
  end

  context 'when only json_data is provided i.e. peoplesync data' do
    let(:people_sheet) { '{}' }

    json_data_expand_attributes.each do |attribute|
      it "should have #{attribute}" do
        expect(expanded_person_exhibitor).to respond_to attribute
      end
    end

    it "should have proper phone format" do
      expect(expanded_person_exhibitor.phone).to match PHONE_REGEX
    end

    it "should have proper department format" do
      expect(expanded_person_exhibitor.departments).to match DEPARTMENTS_REGEX
    end

    it "should have proper location format" do
      expect(expanded_person_exhibitor.location).to match LOCATION_SPACE_REGEX
    end

    it "should have proper space format" do
      expect(expanded_person_exhibitor.space).to match LOCATION_SPACE_REGEX
    end
  end

  context 'when proper JSON formatted data is provided' do

    json_data_expand_attributes.each do |attribute|
      it "should have #{attribute}" do
        expect(expanded_person_exhibitor.send( attribute.to_sym )).not_to be_nil
      end
    end

    it "should have proper location format mapped from config file" do
      expect(expanded_person_exhibitor.location).to eql "Cooper Union Library"
    end

    json_data_expand_attributes.each do |attribute|
      it "should have #{attribute}" do
        expect(expanded_person_exhibitor).to respond_to attribute
      end
    end
  end
end
