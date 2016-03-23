require 'spec_helper'

def json_data_expand_attributes
  %w[buttons departments
  email expertise guides image jobtitle
  keywords library phone space
  status subtitle title twitter publications]
end

describe Contented::Conversions::Collections::People::ExpandedPersonExhibitor do

  let(:unmapped_library) { "Bobst Library" }
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
               Supervisory_Org_Name: "LITS",
               Business_Title: "Super Fancy Title",
               Position_Work_Space: "New York > #{unmapped_library} > Web Services",
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
      "gsx$library" => {
        :$t => "   20 Cooper Square   "
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

  describe '.new' do

    subject(:expanded_person_exhibitor) { Contented::Conversions::Collections::People::ExpandedPersonExhibitor.new(expanded_person) }

    context 'when only a spreadsheet is provided' do
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

      it "should have proper library format mapped from config file" do
        expect(expanded_person_exhibitor.library).to eql "Cooper Union Library"
      end
    end

    context 'when only PeopleSync data is provided' do
      let(:people_sheet) { '{}' }

      json_data_expand_attributes.each do |attribute|
        it "should have #{attribute}" do
          expect(expanded_person_exhibitor).to respond_to attribute
        end
      end

      it "should have proper phone format" do
        expect(expanded_person_exhibitor.phone).to eql '(555) 555-5555'
      end

      it "should have proper department format" do
        expect(expanded_person_exhibitor.departments).to eql "LITS"
      end

      describe 'library value' do
        subject { expanded_person_exhibitor.library }
        context 'when library has a mappable corrected value' do
          let(:unmapped_library) { "Bobst Library" }
          it { should eql "Elmer Holmes Bobst Library" }
        end
        context 'when library has unmappable value' do
          let(:unmapped_library) { "Unknown Library" }
          it { should eql unmapped_library }
        end
      end

      it "should have proper space format" do
        expect(expanded_person_exhibitor.space).to eql 'Web Services'
      end
    end

    context 'when both PeopleSync and spreadsheet data are provided' do

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

    context 'when no data is provided from either PeopleSync or a spreasheet' do
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
  end
end
