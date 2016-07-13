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
    it { is_expected.to eql "---\n\nsubtitle: 'Reference Associate'\njob_title: 'Jobtitle'\nlocation: '20 Cooper Square'\nspace: 'Office LC12'\nparent_department: 'LITS'\ndepartments: \n  - 'Web Services, LITS'\nstatus: 'Status'\nsubject_specialties:\n  First Subject:\n  - First Specialty\n  - Second Specialty\n  Second Subject:\n  - 'Quoted: specialty'\n  - Last Specialty\nliaison_relationship: \nlinkedin: \nemail: 'xx99@nyu.edu'\nphone: '(555) 555-5555'\ntwitter: '@handle'\nimage: 'image.png'\nbuttons: \n  mailto:xx99@nyu.edu\nguides: \n  title: Title\n  libguide_id: number\npublications: \n  rss: http://www.refworks.com/123&rss\nblog: \n  rss: rss.xml\nkeywords: \n  - 'histories'\ntitle: 'Mr Robot'\nfirst_name: 'Mr'\nlast_name: 'Robot'\n\n---\n\nThis is test data about\n" }
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
          it { should eql "Unmapped location" }
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

      its(:title) { is_expected.to eql "" }
    end
  end
end
