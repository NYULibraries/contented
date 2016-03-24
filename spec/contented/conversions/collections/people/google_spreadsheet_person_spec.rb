require 'spec_helper'
include Contented::Conversions::Collections::People

describe GoogleSpreadsheetPerson do
  subject(:google_spreadsheet_person) { GoogleSpreadsheetPerson.new(google_spreadsheet) }

  context "when no google spreadsheet is provided" do
    let(:google_spreadsheet) { '{}' }

    its("instance_variables.size") { is_expected.to be 0 }
  end
  context "when proper google spreadsheet data is provided as JSON" do
    let(:google_spreadsheet) { FactoryGirl.build(:google_spreadsheet).to_json }

    its(:address) { is_expected.to eql "70 Washington Square South" }
    its(:buttons) { is_expected.to eql "mailto:xx99@nyu.edu" }
    its(:departments) { is_expected.to eql "Web Services, LITS" }
    its(:email) { is_expected.to eql "xx99@nyu.edu" }
    its(:expertise) { is_expected.to eql "History" }
    its(:guides) { is_expected.to eql "title: Title ;\nlibguide_id: number" }
    its(:image) { is_expected.to eql "image.png" }
    its(:jobtitle) { is_expected.to eql "Jobtitle" }
    its(:keywords) { is_expected.to eql "histories" }
    its(:library) { is_expected.to eql "  20 Cooper Square  " }
    its(:netid) { is_expected.to eql "xx99" }
    its(:phone) { is_expected.to eql "(555) 555-5555" }
    its(:space) { is_expected.to eql "Office LC12" }
    its(:status) { is_expected.to eql "Status" }
    its(:subtitle) { is_expected.to eql "Reference Associate" }
    its(:title) { is_expected.to eql "Mr Robot" }
    its(:twitter) { is_expected.to eql "@handle" }
    its(:publications) { is_expected.to eql "rss: http://www.refworks.com/123&rss" }
    its(:blog) { is_expected.to eql "rss: rss.xml" }
    its(:about) { is_expected.to eql "This is test data about" }
    its("instance_variables.size") { is_expected.to be 20 }
  end
end
