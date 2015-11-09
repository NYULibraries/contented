require File.expand_path('../../../../spec_helper.rb', __FILE__)

def google_spreadsheet_attributes
  %w[about address buttons departments
  email expertise guides image jobtitle
  keywords location netid phone space
  status subtitle title twitter]
end


describe 'GooglSpreadsheetPerson' do
  let(:json_data) { "{}" }
  subject(:google_spreadsheet_person) { Conversion::Collections::PeopleHelpers::GoogleSpreadsheetPerson.new(json_data) }
  context "when no JSON formatted data is provided" do
    google_spreadsheet_attributes.each do |attribute|
      it "should not have #{attribute}" do
        expect(google_spreadsheet_person.send( attribute.to_sym )).to be_nil
      end
    end

    it "should be able to convert to markdown" do
      expect(google_spreadsheet_person).to respond_to :to_markdown
    end

    it "should be a person" do
      expect(google_spreadsheet_person).to be_a_kind_of(Conversion::Collections::PeopleHelpers::Person)
    end
  end
  context "when proper JSON formatted data is provided" do
    let(:json_data) {
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
    google_spreadsheet_attributes.each do |attribute|
      it "should have #{attribute}" do
        expect(google_spreadsheet_person.send( attribute.to_sym )).not_to be_nil
      end
    end

    it "should have the #{google_spreadsheet_attributes.size} instance variables" do
      expect(google_spreadsheet_person.instance_variables.size).to eql(google_spreadsheet_attributes.size)
    end

    it "should be able to convert to markdown" do
      expect(google_spreadsheet_person).to respond_to :to_markdown
    end

    it "should be a person" do
      expect(google_spreadsheet_person).to be_a_kind_of(Conversion::Collections::PeopleHelpers::Person)
    end
  end
end
