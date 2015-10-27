require File.expand_path('../../../spec_helper.rb', __FILE__)

describe 'People' do
  let(:people) { Conversion::Collections::People }
  let(:raw_person_sheet) do
    JSON.parse('{"netid":{"tx":"mock"},"title":{"tx":"First Name Last Name"},
          "phone":{"tx":"(212) 222-2222"},"email":{"tx":"mock@nyu.edu"}, "address":{"tx":"Bobst"},
          "location":{"tx":"Elmer Holmes Bobst Library"}, "space":{"tx":"3FL"},
          "departments":{"tx":"Department"}, "jobtitle":{"tx":"Job Title"}}'.delete("\n"))
  end
  let(:element) { nil }
  let(:peoplesync) do
    JSON.parse('{ "NetID": "mock","Last_Name": "Last Name", "First_Name": "First Name",
       "Primary_Work_Space_Address": "Bobst",
       "Work_Phone": "+1 (212) 2222222",
       "Email_Address": "mock@nyu.edu",
       "All_Positions_Jobs": [{
          "Is_Primary_Job": "1",
          "Supervisory_Org_Name": "Department",
          "Business_Title": "Job Title",
          "Position_Work_Space": "Washington Square Campus > Bobst Library > 3FL"
          }]}'.delete("\n"))
  end

  describe '#initialize' do
    it 'should raise error if parameter is nil' do
      expect{ people.new(nil) }.to raise_error(ArgumentError)
    end
    it 'should not raise error if parameter is not nil' do
      expect{ people.new(JSON.parse('{}')) }.to_not raise_error
    end
  end
end
