require 'spec_helper'

describe Contented::Collections::Person do
  let(:raw) do
    {
      :Net_ID=>"jd123",
      :First_Name=>"Jane",
      :Last_Name=>"Doe Márquez",
      :Job_Title=>"Curator: Health Sciences Librarian And Other",
      :Departments=>"KARMS/Metadata Production and Management (Adjuncts); Another Department",
      :Parent_Department=>"Knowledge Access & Resource Management Services",
      :Work_Phone=>"+1 212 998 1234",
      :Email_Address=>"dj123@nyu.edu",
      :Building_Address_Line_1=>"70 Washington Square South, New York, NY 10012",
      :Location=>"Elmer Holmes Bobst Library",
      :Name=>"Jane Doe Márquez",
      :Nickname=>"(Janie)",
      :about_you=>"
        I am responsible for:

        * Instruction, Reference, Collection Development, and Faculty liaison for the NYU Rory Meyers College of Nursing,
        * Steinhardt School Departments of Occupational Therapy, Physical Therapy, and Communication Sciences and Disorders.
      ",
      :Liaison_Relationships=>"NYU Rory Meyers College of Nursing; NYU Steinhardt School - Division of Physical Therapy, Division of Occupational Therapy, Division of Communicative Sciences & Disorders",
      :Appointment_Request_button=>"mailto:jane.doe@nyu.edu",
      :Publications_Rss=>"http://www.refworks.com/refshare/?site=010331135918800000/RWWS1A706085/Jacobs%20articles%20RSS&rss",
      :Publications_URL=>"http://www.refworks.com/refshare/?site=010331135918800000/RWWS1A706085/Jacobs%20articles%20RSS&amp;rss%27",
      :LibGuides_Author_Profile_Url=>"https://guides.nyu.edu/prf.php?account_id=2111",
      :LibGuides_Account_ID=>"2111",
      :Guide_ID_Numbers=>"1845658, 276823",
      :ORCID=>"orcid.org/0000-0002-9959-5627",
      :Twitter=>"NYUSciHealthLib",
      :LinkedIn=>"jane-doe-1b960512",
      :Blog_Title=>"Discovering Health Evidence Blog ",
      :Blog_RSS=>"https://wp.nyu.edu/discoveringevidence/rss",
      :Blog_URL=>"https://wp.nyu.edu/discoveringevidence/",
      :Subject_Specialties=>
      {
        :Area_Cultural_Studies=>nil,
        :Arts=>nil,
        :History=>nil,
        :Business=>nil,
        :Education=>nil,
        :Humanities=>nil,
        :Health=>"Health Sciences, Medicine (Bobst), Nursing",
        :Language_Linguistics=>nil,
        :Media_Communication_Journalism=>'Another',
        :Science_Engineering=>nil,
        :Social_Sciences=>"​",
        :Special_Collections=>nil
      }
    }
  end
  let(:save_location) { '.' }
  let(:person) { Contented::Collections::Person.new(raw) }

  describe '#raw' do
    subject { person.raw }
    it { is_expected.to be_a Hash }
    it { is_expected.to eql raw }
  end

  describe '#person' do
    subject { person.person }
    it { is_expected.to be_a OpenStruct }
  end

  describe 'attributes on person passed through by method_missing' do
    subject { person }
    its(:net_id) { is_expected.to eql 'jd123' }
    its(:first_name) { is_expected.to eql 'Jane' }
    its(:last_name) { is_expected.to eql 'Doe Marquez' }
    its(:parent_department) { is_expected.to eql 'Knowledge Access & Resource Management Services' }
    its(:work_phone) { is_expected.to eql "+1 212 998 1234" }
    its(:email_address) { is_expected.to eql 'dj123@nyu.edu' }
    its(:building_address_line_1) { is_expected.to eql '70 Washington Square South, New York, NY 10012' }
    its(:name) { is_expected.to eql 'Jane Doe Marquez' }
    its(:nickname) { is_expected.to eql "(Janie)" }
    its(:about_you) { is_expected.to eql 'I am responsible for:

        * Instruction, Reference, Collection Development, and Faculty liaison for the NYU Rory Meyers College of Nursing,
        * Steinhardt School Departments of Occupational Therapy, Physical Therapy, and Communication Sciences and Disorders.' }
    its(:appointment_request_button) { is_expected.to eql 'mailto:jane.doe@nyu.edu' }
    its(:publications_rss) { is_expected.to eql 'http://www.refworks.com/refshare/?site=010331135918800000/RWWS1A706085/Jacobs%20articles%20RSS&rss' }
    its(:publications_url) { is_expected.to eql 'http://www.refworks.com/refshare/?site=010331135918800000/RWWS1A706085/Jacobs%20articles%20RSS&amp;rss%27' }
    its(:libguides_author_profile_url) { is_expected.to eql 'https://guides.nyu.edu/prf.php?account_id=2111' }
    its(:libguides_account_id) { is_expected.to eql '2111' }
    its(:guide_id_numbers) { is_expected.to eql '1845658, 276823' }
    its(:orcid) { is_expected.to eql 'orcid.org/0000-0002-9959-5627' }
    its(:twitter) { is_expected.to eql 'NYUSciHealthLib' }
    its(:linkedin) { is_expected.to eql 'jane-doe-1b960512' }
    its(:blog_title) { is_expected.to eql 'Discovering Health Evidence Blog' }
    its(:blog_rss) { is_expected.to eql 'https://wp.nyu.edu/discoveringevidence/rss' }
    its(:blog_url) { is_expected.to eql 'https://wp.nyu.edu/discoveringevidence/' }
  end

  describe '#title' do
    subject { person.title }
    it { is_expected.to eql 'Jane Doe Marquez' }
  end

  describe '#filename' do
    subject { person.filename }
    it { is_expected.to eql 'jane-doe-marquez' }
  end

  describe '#job_title' do
    subject { person.job_title }
    it { is_expected.to eql 'Health Sciences Librarian & Other' }
  end

  describe '#departments' do
    subject { person.departments }
    context 'when parent department is Knowledge Access & Resource Management Services' do
      it { is_expected.to eql ['Metadata Production & Management', 'Another Department', 'Knowledge Access & Resource Management Services'] }
    end
    context 'when parent department is not KARMS' do
      before { allow(person.person).to receive(:parent_department).and_return('Anything But KARMS') }
      it { is_expected.to eql ['Metadata Production & Management', 'Another Department'] }
    end
  end

  describe '#location' do
    subject { person.location }
    context 'when building address equals location' do
      before { allow(person).to receive(:location).and_return(raw[:Building_Address_Line_1]) }
      it { is_expected.to be_nil }
    end
    context 'when building address does not equal location' do
      it { is_expected.to eql "Elmer Holmes Bobst Library" }
    end
  end

  describe '#liaison_relationships' do
    subject { person.liaison_relationships }
    it { is_expected.to eql ['NYU Rory Meyers College of Nursing', 'NYU Steinhardt School - Division of Physical Therapy, Division of Occupational Therapy, Division of Communicative Sciences & Disorders'] }
  end

  describe '#subject_specialties' do
    subject { person.subject_specialties }
    context 'when subject specialties exists' do
      it { is_expected.to include "Health" => ["Health Sciences", "Medicine (Bobst)", "Nursing"] }
      it { is_expected.to include "Media, Communication & Journalism" => ["Another"] }
    end
    context 'when subject specialties is nil' do
      before { allow(person).to receive(:subject_specialties).and_return(nil) }
      it { is_expected.to be_nil }
    end
  end

  describe '#image', vcr: true do
    subject { person.image }
    context 'when user image does not exist on S3' do
        it { is_expected.to be_nil }
    end
    context 'when user image does exists on S3' do
      before { allow(person).to receive(:filename).and_return('barnaby-alter') }
      it { is_expected.to eql 'https://s3.amazonaws.com/nyulibraries-www-assets/people-images/barnaby-alter.jpg' }
    end
  end

  describe '#doesnt_exist' do
    subject { person.doesnt_exist }
    it 'should throw a NoMethodError error' do
      expect { subject }.to raise_error NoMethodError
    end
  end

  describe "#to_liquid_hash", vcr: true do
    subject { person.to_liquid_hash }

    its(['title']) { is_expected.to eql 'Jane Doe Marquez' }
    its(['nickname']) { is_expected.to eql "'(Janie)'" }
    its(['job_title']) { is_expected.to eql 'Health Sciences Librarian & Other' }
    its(['location']) { is_expected.to eql 'Elmer Holmes Bobst Library' }
    its(['building_address_line_1']) { is_expected.to eql '70 Washington Square South, New York, NY 10012' }
    its(['parent_department']) { is_expected.to eql 'Knowledge Access & Resource Management Services' }
    its(['departments']) { is_expected.to be_a Array }
    its(['departments']) { is_expected.to include 'Metadata Production & Management' }
    its(['subject_specialties']) { is_expected.to be_a Hash }
    its(['subject_specialties', 'Health']) { is_expected.to be_a Array }
    its(['subject_specialties', 'Health']) { is_expected.to include 'Health Sciences' }
    its(['subject_specialties', 'Health']) { is_expected.to include "'Medicine (Bobst)'" }
    its(['subject_specialties', 'Health']) { is_expected.to include 'Nursing' }
    its(['subject_specialties', 'Media, Communication & Journalism']) { is_expected.to be_a Array }
    its(['subject_specialties', 'Media, Communication & Journalism']) { is_expected.to include 'Another' }
    its(['liaison_relationships']) { is_expected.to be_a Array }
    its(['liaison_relationships']) { is_expected.to include 'NYU Rory Meyers College of Nursing' }
    its(['liaison_relationships']) { is_expected.to include 'NYU Steinhardt School - Division of Physical Therapy, Division of Occupational Therapy, Division of Communicative Sciences & Disorders' }
    its(['linkedin']) { is_expected.to eql 'jane-doe-1b960512' }
    its(['email_address']) { is_expected.to eql 'dj123@nyu.edu' }
    its(['work_phone']) { is_expected.to eql "'+1 212 998 1234'" }
    its(['twitter']) { is_expected.to eql 'NYUSciHealthLib' }
    its(['image']) { is_expected.to eql nil }
    its(['appointment_request_button']) { is_expected.to eql 'mailto:jane.doe@nyu.edu' }
    its(['libguides_account_id']) { is_expected.to eql '2111' }
    its(['guide_id_numbers']) { is_expected.to eql '1845658, 276823' }
    its(['libguides_author_profile_url']) { is_expected.to eql 'https://guides.nyu.edu/prf.php?account_id=2111' }
    its(['publications_rss']) { is_expected.to eql 'http://www.refworks.com/refshare/?site=010331135918800000/RWWS1A706085/Jacobs%20articles%20RSS&rss' }
    its(['publications_url']) { is_expected.to eql 'http://www.refworks.com/refshare/?site=010331135918800000/RWWS1A706085/Jacobs%20articles%20RSS&amp;rss%27' }
    its(['blog_rss']) { is_expected.to eql 'https://wp.nyu.edu/discoveringevidence/rss' }
    its(['blog_title']) { is_expected.to eql 'Discovering Health Evidence Blog' }
    its(['blog_url']) { is_expected.to eql 'https://wp.nyu.edu/discoveringevidence/' }
    its(['orcid']) { is_expected.to eql 'orcid.org/0000-0002-9959-5627' }
    its(['first_name']) { is_expected.to eql 'Jane' }
    its(['last_name']) { is_expected.to eql 'Doe Marquez' }
    its(['sort_title']) { is_expected.to eql 'Doe Marquez, Jane' }
    its(['about_you']) do
      is_expected.not_to include <<~MARKDOWN
        'I am responsible for:

                * Instruction, Reference, Collection Development, and Faculty liaison for the NYU Rory Meyers College of Nursing,
                * Steinhardt School Departments of Occupational Therapy, Physical Therapy, and Communication Sciences and Disorders.'
      MARKDOWN
    end
    its(['about_you']) do
      is_expected.not_to include <<~MARKDOWN
        I am responsible for:

                * Instruction, Reference, Collection Development, and Faculty liaison for the NYU Rory Meyers College of Nursing,
                * Steinhardt School Departments of Occupational Therapy, Physical Therapy, and Communication Sciences and Disorders.
      MARKDOWN
    end
  end
end
