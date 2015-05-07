require File.expand_path('../../spec_helper.rb', __FILE__)

describe 'Staffer' do
  let(:staffer) { Nyulibraries::SiteLeaf::Loaders::Staffer.new }

  describe '#get_staff' do
    subject { staffer.get_staff }
    context 'should return metafields hash table' do
      it 'should return metafields' do
        # pending
      end
    end
  end
end
