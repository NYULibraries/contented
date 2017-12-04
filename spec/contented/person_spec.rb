require 'spec_helper'

describe Contented::Person do
  let(:raw) do
    {
      :Net_ID=>"jd123",
      :First_Name=>"Jane",
      :Last_Name=>"Doe",
      :Job_Title=>"Curator: Health Sciences Librarian",
      :Departments=>"KARMS/Metadata Production and Management",
      :Parent_Department=>"Science & Engineering",
      :Work_Phone=>"+1 212 998 1234",
      :Email_Address=>"dj123@nyu.edu",
      :Building_Address_Line_1=>"70 Washington Square South, New York, NY 10012",
      :Location=>"Elmer Holmes Bobst Library",
      :Name=>"Jane Doe",
      :Nickname=>"(Janie)",
      :about_you=>"I am responsible for Instruction, Reference, Collection Development, and Faculty liaison for the NYU Rory Meyers College of Nursing, Steinhardt School Departments of Occupational Therapy, Physical Therapy, and Communication Sciences and Disorders.",
      :Liaison_Relationships=>"NYU Rory Meyers College of Nursing; NYU Steinhardt School - Division of Physical Therapy, Division of Occupational Therapy, Division of Communicative Sciences & Disorders",
      :Appointment_Request_button=>"mailto:jane.doe@nyu.edu",
      :Publications_Rss=>"http://www.refworks.com/refshare/?site=010331135918800000/RWWS1A706085/Jacobs%20articles%20RSS&rss",
      :Publications_URL=>"http://www.refworks.com/refshare/?site=010331135918800000/RWWS1A706085/Jacobs%20articles%20RSS&amp;rss%27",
      :LibGuides_Author_Profile_Url=>"http://guides.nyu.edu/prf.php?account_id=2111",
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
        :Media_Communication_Journalism=>nil,
        :Science_Engineering=>nil,
        :Social_Sciences=>"​",
        :Special_Collections=>nil
      }
    }
  end
  let(:save_location) { '.' }
  let(:person) { Contented::Person.new(raw, save_location) }

  describe '#raw' do
    subject { person.raw }
    it { is_expected.to be_a Hash }
    it { is_expected.to eql raw }
  end

  describe '#save_location' do
    subject { person.save_location }
    it { is_expected.to eql '.' }
  end

  describe '#person' do
    subject { person.person }
    it { is_expected.to be_a OpenStruct }
  end

  describe '#net_id' do
    subject { person.net_id }
    it { is_expected.to eql 'jd123' }
  end

  describe '#subject_specialties' do
    subject { person.subject_specialties }
    it { is_expected.to eql '' }
  end

  describe '#doesnt_exist' do
    subject { person.doesnt_exist }
    it 'should throw a NoMethodError error' do
      expect { subject }.to raise_error NoMethodError
    end
  end
end
