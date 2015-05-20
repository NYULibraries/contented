require File.expand_path('../../spec_helper.rb', __FILE__)

describe 'Dept_Attr' do
  let(:dept_attr) { Nyulibraries::SiteLeaf::Loaders::Dept_Attr.new }

  describe '#get_dept_meta' do
    subject { dept_attr.get_dept_meta }
    context 'should return metafields hash table' do
      it 'should return metafields' do
        # pending
      end
    end
  end

  describe '#get_dept_tags' do
    subject { dept_attr.get_dept_tags }
    context 'should return tags hash sets' do
      it 'should return tags' do
        # pending
      end
    end
  end
end
