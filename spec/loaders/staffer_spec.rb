require File.expand_path('../../spec_helper.rb', __FILE__)

describe 'Staffer' do
  let(:staffer) { Staffer.new }

  describe '#get_staff' do
    subject { staffer.get_staff }
    context 'should return metafields hash table' do
      # pending
    end
  end
end
