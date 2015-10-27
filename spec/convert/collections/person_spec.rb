require File.expand_path('../../../spec_helper.rb', __FILE__)

describe 'Person' do
  let(:person) { Conversion::Collections::PeopleHelpers::Person }
  let(:element) { nil }
  let(:peoplesync) do
    JSON.parse('{ "Last_Name": "Last Name", "First_Name": "First Name",
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
    it 'sheet_person parameter is nil so should raise error' do
      expect { person.new(nil, 'json_person', 'location_map') }.to raise_error(ArgumentError)
    end
    it 'json_person parameter is nil so should raise error' do
      expect { person.new('sheet_person', nil, 'location_map') }.to raise_error(ArgumentError)
    end
    it 'location_map parameter is nil so should raise error' do
      expect { person.new('sheet_person', 'json_person', nil) }.to raise_error(ArgumentError)
    end
    it 'sheet_person parameter is nil so should raise error' do
      expect { person.new('sheet_person', 'json_person', 'location_map') }.to_not raise_error(ArgumentError)
    end
  end

  describe '#to_json' do
    context 'should return person JSON with all the peoplesync attributes added to it' do
      let(:element) do
        JSON.parse('{"title":{"tx":""},"phone":{"tx":""},"email":{"tx":""},"address":{"tx":""},
          "location":{"tx":""},"space":{"tx":""},"departments":{"tx":""},"jobtitle":{"tx":""}}'.delete("\n"))
      end
      it 'should return JSON with all Peoplesync data' do
        person.new(element, peoplesync, 'location_map').to_json == JSON.parse('{"title":{"tx":"First Name Last Name"},
          "phone":{"tx":"(212) 222-2222"},"email":{"tx":"mock@nyu.edu"}, "address":{"tx":"Bobst"},
          "location":{"tx":"Elmer Holmes Bobst Library"}, "space":{"tx":"3FL"},
          "departments":{"tx":"Department"}, "jobtitle":{"tx":"Job Title"}}'.delete("\n"))
      end
    end
  end

  describe '#title' do
    subject { person.new('sheet_person', peoplesync, 'location_map').title }
    context 'title attribute should be initialized with first name + last name' do
      it { should eql 'First Name Last Name' }
    end
  end

  describe '#phone' do
    subject { person.new('sheet_person', peoplesync, 'location_map').phone }
    context 'phone attribute should be initialized with Work_Phone' do
      it { should eql '(212) 222-2222' }
    end
  end

  describe '#email' do
    subject { person.new('sheet_person', peoplesync, 'location_map').email }
    context 'email attribute should be initialized with Email_Address' do
      it { should eql 'mock@nyu.edu' }
    end
  end

  describe '#address' do
    subject { person.new('sheet_person', peoplesync, 'location_map').address }
    context 'address attribute should be initialized with Primary_Work_Space_Address' do
      it { should eql 'Bobst' }
    end
  end

  describe '#jobtitle' do
    subject { person.new('sheet_person', peoplesync, 'location_map').jobtitle }
    context 'address attribute should be initialized with Business_Title' do
      it { should eql 'Job Title' }
    end
  end

  describe '#departments' do
    subject { person.new('sheet_person', peoplesync, 'location_map').departments }
    context '' do
      it { should eql 'Department' }
    end
  end

  describe '#location' do
    subject { person.new('sheet_person', peoplesync, 'location_map').location }
    context '' do
      it { should eql 'Bobst Library' }
    end
  end

  describe '#space' do
    subject { person.new('sheet_person', peoplesync, 'location_map').space }
    context '' do
      it { should eql '3FL' }
    end
  end

  describe '#modify_phone' do
    subject { person.new('sheet_person', peoplesync, 'location_map').modify_phone(element) }
    context 'Phone number is modified to remove +1 and add - after 6 digits' do
      let(:element) { '+1 (212) 2222222' }
      it { should eql '(212) 222-2222' }
    end
    context 'if Phone Number is nil then blank string is returned' do
      it { should eql '' }
    end
  end

  describe '#modify_departments' do
    subject { person.new('sheet_person', peoplesync, 'location_map').modify_departments(element) }
    context 'should return the dpeartment name only i.e. anything before the braces' do
      let(:element) { 'Public Services (Adjuncts)' }
      it { should eql 'Public Services' }
    end
    context 'if department name is nil then blank string is returned' do
      it { should eql '' }
    end
  end

  describe '#parse_location' do
    subject { person.new('sheet_person', peoplesync, 'location_map').parse_location(element) }
    context 'should return the location i.e. after the first > sign' do
      let(:element) { 'Washington Square Campus > Bobst Library > 519' }
      it { should eql 'Bobst Library' }
    end
    context 'if location is nil then blank string is returned' do
      it { should eql '' }
    end
  end

  describe '#map_to_location' do
    subject { person.new('sheet_person', peoplesync, Conversion::Collections::People.new(JSON.parse('{}')).location_map).map_to_location(element) }
    context 'if not present in location_map.yml then returns the parsed location' do
      let(:element) { 'Washington Square Campus > Elmer Holmes Bobst Library > 519' }
      it { should eql 'Elmer Holmes Bobst Library' }
    end
    context 'rectifies the location from peoplesync data using the location_map.yml' do
      let(:element) { 'Washington Square Campus > Bobst Library > 519' }
      it { should eql 'Elmer Holmes Bobst Library' }
    end
    context 'if location is nil then blank string is returned' do
      it { should eql '' }
    end
  end

  describe '#parse_space' do
    subject { person.new('sheet_person', peoplesync, 'location_map').parse_space(element) }
    context 'should return the location i.e. after the second > sign' do
      let(:element) { 'Washington Square Campus > Bobst Library > 519' }
      it { should eql '519' }
    end
    context 'if space is nil then blank string is returned' do
      it { should eql '' }
    end
  end

  describe '#valid_job_position' do
    subject { person.new('sheet_person', peoplesync, 'location_map').valid_job_position(element) }
    context 'if Is_Primary_Job == 1 in any element of the array then that job is returned' do
      let(:element) { JSON.parse('[{ "Is_Primary_Job": "1" }]') }
      it { should eql JSON.parse('{"Is_Primary_Job": "1"}') }
    end
    context 'if Is_Primary_Job == 0 in all the elements of array parameter then nil is returned' do
      let(:element) { JSON.parse('[{ "Is_Primary_Job": "0" }]') }
      it { should eql JSON.parse('{}') }
    end
  end

  describe '#parse_job_title' do
    subject { person.new('sheet_person', peoplesync, 'location_map').parse_job_title }
    context 'should return the location i.e. after the second > sign' do
      it { should eql 'Job Title' }
    end
  end
end
