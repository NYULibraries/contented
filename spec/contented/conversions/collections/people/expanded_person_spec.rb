require 'spec_helper'
include Contented::Conversions::Collections::People

describe ExpandedPerson do
  let(:person) { Person.new(peoplesync) }
  let(:google_spreadsheet_person) { GoogleSpreadsheetPerson.new(google_spreadsheet) }

  subject { ExpandedPerson.new(person, google_spreadsheet_person) }
  context 'when no PeopleSync or Google Spreadsheet data are passed in' do
    let(:peoplesync) { '{}' }
    let(:google_spreadsheet) { '{}' }

    its(:person) { is_expected.to_not be_nil }
    its(:google_spreadsheet_person) { is_expected.to_not be_nil }
    its("instance_variables.size") { is_expected.to eql 2 }
  end
  context "when bothe PeopleSync and Google Spreadsheet data are passed in" do
    let(:peoplesync) { FactoryGirl.build(:peoplesync).to_json }
    let(:google_spreadsheet) { FactoryGirl.build(:google_spreadsheet).to_json }

    its(:email_address) { is_expected.to eql "lib-no-reply@nyu.edu" }
    its(:email) { is_expected.to eql "xx99@nyu.edu" }
    its(:address) { is_expected.to eql "70 Washington Square South" }
    its(:buttons) { is_expected.to eql "mailto:xx99@nyu.edu" }
    its(:departments) { is_expected.to eql "Web Services, LITS" }
    its(:parentdepartment) { is_expected.to eql "LITS" }
    its(:subjectspecialties) { is_expected.to eql "First Subject:\n- First Specialty\n- Second Specialty\nSecond Subject:\n- 'Quoted: specialty'\n- Last Specialty\n" }
    its(:guides) { is_expected.to eql "title: Title ;\nlibguide_id: number" }
    its(:image) { is_expected.to eql "image.png" }
    its(:jobtitle) { is_expected.to eql "Jobtitle" }
    its(:keywords) { is_expected.to eql "histories" }
    its(:library) { is_expected.to eql "  20 Cooper Square  " }
    its(:work_phone) { is_expected.to eql "+1 (555) 5555555" }
    its(:phone) { is_expected.to eql "(555) 555-5555" }
    its(:space) { is_expected.to eql "Office LC12" }
    its(:status) { is_expected.to eql "Status" }
    its(:subtitle) { is_expected.to eql "Reference Associate" }
    its(:title) { is_expected.to eql "Mr Robot" }
    its(:twitter) { is_expected.to eql "@handle" }
    its(:publications) { is_expected.to eql "rss: http://www.refworks.com/123&rss" }
    its(:blog) { is_expected.to eql "rss: rss.xml" }
    its(:about) { is_expected.to eql "This is test data about" }
    its("all_positions_jobs.first") { is_expected.to include "Position_Work_Space" => "New York > Bobst Library > LITS > Web Services" }

    its("instance_variables.size") { is_expected.to eql 2 }
    its("person.instance_variables.size") { is_expected.to eql 6 }
    its("google_spreadsheet_person.instance_variables.size") { is_expected.to eql 21 }
  end
end
