require 'spec_helper'
include Contented::Conversions::Collections::People

describe ExpandedPersonExhibitor do
  let(:peoplesync) { FactoryGirl.build(:peoplesync).to_json }
  let(:google_spreadsheet) { FactoryGirl.build(:google_spreadsheet).to_json }
  let(:person) { Person.new(peoplesync) }
  let(:google_spreadsheet_person) { GoogleSpreadsheetPerson.new(google_spreadsheet) }
  let(:expanded_person) { ExpandedPerson.new(person, google_spreadsheet_person) }

  describe '.new' do
    subject(:expanded_person_exhibitor) { ExpandedPersonExhibitor.new(expanded_person) }

    context 'when only a spreadsheet is provided' do
      let(:peoplesync) { '{}' }

      its(:buttons) { is_expected.to eql "\n  mailto:xx99@nyu.edu" }
      its(:departments) { is_expected.to eql "\n  - 'Web Services, LITS'" }
      its(:email) { is_expected.to eql "xx99@nyu.edu" }
      its(:expertise) { is_expected.to eql "\n  - 'History'" }
      its(:guides) { is_expected.to eql "\n  title: Title\n  libguide_id: number" }
      its(:image) { is_expected.to eql "image.png" }
      its(:jobtitle) { is_expected.to eql "Jobtitle" }
      its(:keywords) { is_expected.to eql "\n  - 'histories'" }
      its(:library) { is_expected.to eql "Cooper Union Library" }
      its(:phone) { is_expected.to eql "(555) 555-5555" }
      its(:space) { is_expected.to eql "Office LC12" }
      its(:status) { is_expected.to eql "Status" }
      its(:subtitle) { is_expected.to eql "Reference Associate" }
      its(:title) { is_expected.to eql "Mr Robot" }
      its(:twitter) { is_expected.to eql "@handle" }
      its(:publications) { is_expected.to eql "\n  rss: http://www.refworks.com/123&rss" }
    end

    context 'when only PeopleSync data is provided' do
      let(:google_spreadsheet) { '{}' }

      its(:phone) { is_expected.to eql "(555) 555-5555" }
      its(:departments) { is_expected.to eql "LITS & Media Services" }
      its(:space) { is_expected.to eql "LITS" }

      describe 'library value' do
        subject { expanded_person_exhibitor.library }
        context 'when library has a mappable corrected value' do
          it { should eql "Elmer Holmes Bobst Library" }
        end
        context 'when library has unmappable value' do
          let(:peoplesync) { FactoryGirl.build(:peoplesync_with_unmapped_library).to_json }
          it { should eql "Unmapped Library" }
        end
      end

    end

    context 'when both PeopleSync and spreadsheet data are provided' do

      its(:buttons) { is_expected.to eql "\n  mailto:xx99@nyu.edu" }
      its(:departments) { is_expected.to eql "\n  - 'Web Services, LITS'" }
      its(:email) { is_expected.to eql "xx99@nyu.edu" }
      its(:expertise) { is_expected.to eql "\n  - 'History'" }
      its(:guides) { is_expected.to eql "\n  title: Title\n  libguide_id: number" }
      its(:image) { is_expected.to eql "image.png" }
      its(:jobtitle) { is_expected.to eql "Jobtitle" }
      its(:keywords) { is_expected.to eql "\n  - 'histories'" }
      its(:library) { is_expected.to eql "Cooper Union Library" }
      its(:phone) { is_expected.to eql "(555) 555-5555" }
      its(:space) { is_expected.to eql "Office LC12" }
      its(:status) { is_expected.to eql "Status" }
      its(:subtitle) { is_expected.to eql "Reference Associate" }
      its(:title) { is_expected.to eql "Mr Robot" }
      its(:twitter) { is_expected.to eql "@handle" }
      its(:publications) { is_expected.to eql "\n  rss: http://www.refworks.com/123&rss" }
    end

    context 'when no data is provided from either PeopleSync or a spreadsheet' do
      let (:peoplesync) { '{}' }
      let (:google_spreadsheet) { '{}' }

      its(:buttons) { is_expected.to be_nil }
      its(:departments) { is_expected.to be_nil }
      its(:email) { is_expected.to be_nil }
      its(:expertise) { is_expected.to be_nil }
      its(:guides) { is_expected.to be_nil }
      its(:image) { is_expected.to be_nil }
      its(:jobtitle) { is_expected.to be_nil }
      its(:keywords) { is_expected.to be_nil }
      its(:library) { is_expected.to be_nil }
      its(:phone) { is_expected.to be_nil }
      its(:space) { is_expected.to be_nil }
      its(:status) { is_expected.to be_nil }
      its(:subtitle) { is_expected.to be_nil }
      its(:twitter) { is_expected.to be_nil }
      its(:publications) { is_expected.to be_nil }

      its(:title) { is_expected.to eql " " }
    end
  end
end
