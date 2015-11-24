require File.expand_path('../../../../spec_helper.rb', __FILE__)

def person_exhibitor_attributes
  %w[netid employee_id last_name first_name
  primary_work_space_address work_phone
  email_address all_positions_jobs
  about address buttons departments
  email expertise guides image jobtitle
  keywords location phone space
  status subtitle title twitter publications]
end

describe 'PersonExhibitor' do
  subject(:person_exhibitor) { Conversion::Collections::PeopleHelpers::PersonExhibitor.new }
  context 'when no JSON formatted data is provided' do
    person_exhibitor_attributes.each do |attribute|
      it "should not have #{attribute}" do
        expect(person_exhibitor.send( attribute.to_sym )).to be_nil
      end
    end

    person_exhibitor_attributes.each do |attribute|
      it "should not have #{attribute}" do
         expect(person_exhibitor).to respond_to attribute
      end
    end
  end
end
