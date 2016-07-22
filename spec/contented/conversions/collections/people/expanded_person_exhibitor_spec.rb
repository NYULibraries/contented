require 'spec_helper'
include Contented::Conversions::Collections::People

describe ExpandedPersonExhibitor do
  let(:peoplesync) { FactoryGirl.build(:peoplesync).to_json }
  let(:google_spreadsheet) { FactoryGirl.build(:google_spreadsheet).to_json }
  let(:person) { Person.new(peoplesync) }
  let(:google_spreadsheet_person) { GoogleSpreadsheetPerson.new(google_spreadsheet) }
  let(:expanded_person) { ExpandedPerson.new(person, google_spreadsheet_person) }
  let(:expanded_person_exhibitor) { ExpandedPersonExhibitor.new(expanded_person) }

  describe '#to_markdown' do
    subject { expanded_person_exhibitor.to_markdown }
    it { is_expected.to include "---\n\n" }
    it { is_expected.to include "subtitle: 'Reference Associate'\n" }
    it { is_expected.to include "job_title: 'Jobtitle'\n" }
    it { is_expected.to include "address: '70 Washington Square South'\n" }
    it { is_expected.to include "space: 'Office LC12'\n" }
    it { is_expected.to include "parent_department: 'LITS'\n" }
    it { is_expected.to include "departments: \n  - 'Web Services, LITS'\n" }
    it { is_expected.to include "status: 'Status'\n" }
    it { is_expected.to include "subject_specialties:\n  First Subject:\n  - First Specialty\n  - Second Specialty\n  Second Subject:\n  - 'Quoted: specialty'\n  - Last Specialty\n" }
    it { is_expected.to include "liaison_relationship: \n" }
    it { is_expected.to include "linkedin: \n" }
    it { is_expected.to include "email: 'xx99@nyu.edu'\n" }
    it { is_expected.to include "phone: '(555) 555-5555'\n" }
    it { is_expected.to include "twitter: '@handle'\n" }
    it { is_expected.to include "image: 'image.png'\n" }
    it { is_expected.to include "buttons: \n  mailto:xx99@nyu.edu\n" }
    it { is_expected.to include "guides: \n  title: Title\n  libguide_id: number\npublications: \n  rss: http://www.refworks.com/123&rss\nblog: \n  rss: rss.xml\n" }
    it { is_expected.to include "keywords: \n  - 'histories'\n" }
    it { is_expected.to include "title: 'Mr Robot'\n" }
    it { is_expected.to include "first_name: 'Mr'\n" }
    it { is_expected.to include "last_name: 'Robot'\n" }
    it { is_expected.to include "---\n\nThis is test data about\n" }

  end

  describe '.new' do
    subject { expanded_person_exhibitor }

    context 'when only a spreadsheet is provided' do
      let(:peoplesync) { '{}' }

      its(:buttons) { is_expected.to eql "\n  mailto:xx99@nyu.edu" }
      its(:departments) { is_expected.to eql "\n  - 'Web Services, LITS'" }
      its(:parentdepartment) { is_expected.to eql "LITS" }
      its(:email) { is_expected.to eql "xx99@nyu.edu" }
      its(:subjectspecialties) { is_expected.to eql "First Subject:\n- First Specialty\n- Second Specialty\nSecond Subject:\n- 'Quoted: specialty'\n- Last Specialty" }
      its(:guides) { is_expected.to eql "\n  title: Title\n  libguide_id: number" }
      its(:image) { is_expected.to eql "image.png" }
      its(:jobtitle) { is_expected.to eql "Jobtitle" }
      its(:keywords) { is_expected.to eql "\n  - 'histories'" }
      its(:address) { is_expected.to eql "70 Washington Square South" }
      its(:location) { is_expected.to eql "20 Cooper Square" }
      its(:phone) { is_expected.to eql "(555) 555-5555" }
      its(:space) { is_expected.to eql "Office LC12" }
      its(:status) { is_expected.to eql "Status" }
      its(:subtitle) { is_expected.to eql "Reference Associate" }
      its(:title) { is_expected.to eql "Mr Robot" }
      its(:twitter) { is_expected.to eql "@handle" }
      its(:blog) { is_expected.to eql "\n  rss: rss.xml" }
      its(:publications) { is_expected.to eql "\n  rss: http://www.refworks.com/123&rss" }
      its(:first_name) { is_expected.to be_nil }
      its(:last_name) { is_expected.to be_nil }
      its(:sort_title) { is_expected.to eql "Mr Robot" }
    end

    context 'when only PeopleSync data is provided' do
      let(:google_spreadsheet) { '{}' }

      its(:phone) { is_expected.to eql "(555) 555-5555" }
      its(:departments) { is_expected.to eql "LITS & Media Services" }
      its(:space) { is_expected.to eql "LITS" }

      describe 'location value' do
        subject { expanded_person_exhibitor.location }
        context 'when location has a mappable corrected value' do
          it { should eql "Elmer Holmes Bobst Library" }
        end
        context 'when location has unmappable value' do
          let(:peoplesync) { FactoryGirl.build(:peoplesync_with_unmapped_location).to_json }
          it { should be_nil }
        end
      end

    end

    context 'when both PeopleSync and spreadsheet data are provided' do

      its(:buttons) { is_expected.to eql "\n  mailto:xx99@nyu.edu" }
      its(:departments) { is_expected.to eql "\n  - 'Web Services, LITS'" }
      its(:parentdepartment) { is_expected.to eql "LITS" }
      its(:email) { is_expected.to eql "xx99@nyu.edu" }
      its(:subjectspecialties) { is_expected.to eql "First Subject:\n- First Specialty\n- Second Specialty\nSecond Subject:\n- 'Quoted: specialty'\n- Last Specialty" }
      its(:guides) { is_expected.to eql "\n  title: Title\n  libguide_id: number" }
      its(:image) { is_expected.to eql "image.png" }
      its(:jobtitle) { is_expected.to eql "Jobtitle" }
      its(:keywords) { is_expected.to eql "\n  - 'histories'" }
      its(:address) { is_expected.to eql "70 Washington Square South" }
      its(:location) { is_expected.to eql "20 Cooper Square" }
      its(:phone) { is_expected.to eql "(555) 555-5555" }
      its(:space) { is_expected.to eql "Office LC12" }
      its(:status) { is_expected.to eql "Status" }
      its(:subtitle) { is_expected.to eql "Reference Associate" }
      its(:title) { is_expected.to eql "Mr Robot" }
      its(:twitter) { is_expected.to eql "@handle" }
      its(:publications) { is_expected.to eql "\n  rss: http://www.refworks.com/123&rss" }
      its(:first_name) { is_expected.to eql "Mr" }
      its(:last_name) { is_expected.to eql "Robot" }
      its(:sort_title) { is_expected.to eql "Robot, Mr" }
    end

    context 'when no data is provided from either PeopleSync or a spreadsheet' do
      let (:peoplesync) { '{}' }
      let (:google_spreadsheet) { '{}' }

      its(:buttons) { is_expected.to be_nil }
      its(:departments) { is_expected.to be_nil }
      its(:parentdepartment) { is_expected.to be_nil }
      its(:email) { is_expected.to be_nil }
      its(:subjectspecialties) { is_expected.to be_nil }
      its(:guides) { is_expected.to be_nil }
      its(:image) { is_expected.to be_nil }
      its(:jobtitle) { is_expected.to be_nil }
      its(:keywords) { is_expected.to be_nil }
      its(:location) { is_expected.to be_nil }
      its(:phone) { is_expected.to be_nil }
      its(:space) { is_expected.to be_nil }
      its(:status) { is_expected.to be_nil }
      its(:subtitle) { is_expected.to be_nil }
      its(:twitter) { is_expected.to be_nil }
      its(:publications) { is_expected.to be_nil }
      its(:first_name) { is_expected.to be_nil }
      its(:last_name) { is_expected.to be_nil }

      its(:sort_title) { is_expected.to eql "" }
      its(:title) { is_expected.to eql "" }
    end
  end
end
