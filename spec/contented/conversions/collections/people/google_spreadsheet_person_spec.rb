require 'spec_helper'

def google_spreadsheet_attributes
  %w[address buttons departments
  email expertise guides image jobtitle
  keywords library netid phone space
  status subtitle title twitter publications blog about
  liaison_relationship
  ]
end


describe 'GooglSpreadsheetPerson' do
  let(:json_data) { '{}' }
  subject(:google_spreadsheet_person) { Contented::Conversions::Collections::People::GoogleSpreadsheetPerson.new(json_data) }
  context "when no JSON formatted data is provided" do
    google_spreadsheet_attributes.each do |attribute|
      it "should not have #{attribute}" do
        expect(google_spreadsheet_person.send( attribute.to_sym )).to be_nil
      end
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
        "gsx$blog" => {
          :$t => "rss: rss.xml"
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
        },
        "gsx$liaison_relationship" => {
          :$t => "liason relationship"
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
  end
end
