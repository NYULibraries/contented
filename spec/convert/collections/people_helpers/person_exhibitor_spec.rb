require File.expand_path('../../../../spec_helper.rb', __FILE__)

def attributes
  %w[netid employee_id last_name first_name
  primary_work_space_address work_phone
  email_address all_positions_jobs
  about address buttons departments
  email expertise guides image jobtitle
  keywords location phone space
  status subtitle title twitter publications]
end

describe 'PersonExhibitor' do
  let(:json_data) { '{}' }
  subject(:person) { Conversion::Collections::PeopleHelpers::PersonExhibitor.new(json_data) }
  context 'when no JSON formatted data is provided' do
    attributes.each do |attribute|
      it 'should not have #{attribute}' do
        expect(person.send( attribute.to_sym )).to be_nil
      end
    end
  end
end
