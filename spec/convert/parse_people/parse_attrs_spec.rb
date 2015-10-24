require File.expand_path('../../../spec_helper.rb', __FILE__)

describe 'FieldFormat' do
  let(:parse_attrs) { Conversion::ParsePeople::ParseAttrs }
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

  describe '#modify_phone' do
    subject { parse_attrs.modify_phone(element) }
    context 'Phone number is modified to remove +1 and add - after 6 digits' do
      let(:element) { '+1 (212) 2222222' }
      it { should eql '(212) 222-2222' }
    end
    context 'if Phone Number is nil then blank string is returned' do
      it { should eql '' }
    end
  end

  describe '#modify_departments' do
    subject { parse_attrs.modify_departments(element) }
    context 'should return the dpeartment name only i.e. anything before the braces' do
      let(:element) { 'Public Services (Adjuncts)' }
      it { should eql 'Public Services' }
    end
    context 'if department name is nil then blank string is returned' do
      it { should eql '' }
    end
  end

  describe '#parse_location' do
    subject { parse_attrs.parse_location(element) }
    context 'should return the location i.e. after the first > sign' do
      let(:element) { 'Washington Square Campus > Bobst Library > 519' }
      it { should eql 'Bobst Library' }
    end
    context 'if location is nil then blank string is returned' do
      it { should eql '' }
    end
  end

  describe '#map_to_location' do
    subject { parse_attrs.map_to_location(element) }
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

  describe '#space' do
    subject { parse_attrs.space(element) }
    context 'should return the location i.e. after the second > sign' do
      let(:element) { 'Washington Square Campus > Bobst Library > 519' }
      it { should eql '519' }
    end
    context 'if space is nil then blank string is returned' do
      it { should eql '' }
    end
  end

  describe '#valid_job_position' do
    subject { parse_attrs.valid_job_position(element) }
    context 'if Is_Primary_Job == 1 in any element of the array then that job is returned' do
      let(:element) { JSON.parse('[{ "Is_Primary_Job": "1" }]') }
      it { should eql JSON.parse('{"Is_Primary_Job": "1"}') }
    end
    context 'if Is_Primary_Job == 0 in all the elements of array parameter then nil is returned' do
      let(:element) { JSON.parse('[{ "Is_Primary_Job": "0" }]') }
      it { should eql nil }
    end
  end

  describe '#contact_info' do
    subject { parse_attrs.contact_info(peoplesync, element) }
    context 'should copy the Peoplesync person_found Work_Phone and Email_Address to spreadsheet data' do
      let(:element) { JSON.parse('{"phone":{"tx":""},"email":{"tx":""}}') }
      it { should eql JSON.parse('{"phone":{"tx":"(212) 222-2222"}, "email":{"tx":"mock@nyu.edu"}}') }
    end
  end

  describe '#address_info' do
    subject { parse_attrs.address_info(peoplesync) }
    context 'should return Primary_Work_Space_Address or blank string if nil' do
      it { should eql 'Bobst' }
    end
  end

  describe '#location_info' do
    subject { parse_attrs.location_info(element, peoplesync['All_Positions_Jobs'][0]) }
    context 'should add location and space attribute to the result JSON i.e. person parameter or element in this case' do
      let(:element) { JSON.parse('{"location":{"tx":""},"space":{"tx":""}}') }
      it { should eql JSON.parse('{"location":{"tx":"Elmer Holmes Bobst Library"}, "space":{"tx":"3FL"}}') }
    end
  end

  describe '#job_info' do
    subject { parse_attrs.job_info(element, peoplesync['All_Positions_Jobs'][0]) }
    context 'should add departments and jobtitle attribute to the result JSON i.e. person parameter or element in this case' do
      let(:element) { JSON.parse('{"location":{"tx":""},"space":{"tx":""},"departments":{"tx":""},"jobtitle":{"tx":""}}') }
      it { should eql JSON.parse('{"location":{"tx":"Elmer Holmes Bobst Library"}, "space":{"tx":"3FL"},"departments":{"tx":"Department"},"jobtitle":{"tx":"Job Title"}}') }
    end
  end

  describe '#personnel_info' do
    subject { parse_attrs.personnel_info(peoplesync, element) }
    context 'should add all the peoplesync attribute to the result JSON i.e. person parameter or element in this case' do
      let(:element) do
        JSON.parse('{"phone":{"tx":""},"email":{"tx":""},"address":{"tx":""},"location":{"tx":""},
                    "space":{"tx":""},"departments":{"tx":""},"jobtitle":{"tx":""}}'.delete("\n"))
      end
      it '' do
        parse_attrs.personnel_info(peoplesync, element) == JSON.parse('{"phone":{"tx":"(212) 222-2222"},
          "email":{"tx":"mock@nyu.edu"},"address":{"tx":"Bobst"}, "location":{"tx":"Elmer Holmes Bobst Library"},
          "space":{"tx":"3FL"}, "departments":{"tx":"Department"}, "jobtitle":{"tx":"Job Title"}}'.delete("\n"))
      end
    end
  end

  describe '#correct_json_format' do
    subject { parse_attrs.correct_json_format(peoplesync, element) }
    context 'should return person JSON with all the peoplesync attributes added to it' do
      let(:element) do
        JSON.parse('{"title":{"tx":""},"phone":{"tx":""},"email":{"tx":""},"address":{"tx":""},
          "location":{"tx":""},"space":{"tx":""},"departments":{"tx":""},"jobtitle":{"tx":""}}'.delete("\n"))
      end
      it 'should return JSON with all Peoplesync data' do
        parse_attrs.correct_json_format(peoplesync, element) == JSON.parse('{"title":{"tx":"First Name Last Name"},
          "phone":{"tx":"(212) 222-2222"},"email":{"tx":"mock@nyu.edu"}, "address":{"tx":"Bobst"},
          "location":{"tx":"Elmer Holmes Bobst Library"}, "space":{"tx":"3FL"},
          "departments":{"tx":"Department"}, "jobtitle":{"tx":"Job Title"}}'.delete("\n"))
      end
    end
  end
end
