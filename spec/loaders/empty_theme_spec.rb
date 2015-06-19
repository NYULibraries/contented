require File.expand_path('../../spec_helper.rb', __FILE__)

describe 'Empty_Theme' do
  let(:empty_theme) { Nyulibraries::SiteLeaf::Loaders::Empty_Theme.new }

  describe '.new' do
    subject { empty_theme }
    context 'Empty theme files in siteleaf for a clean push' do
      it 'Empties Siteleaf Theme Files' do
        # Doesn't need to be tested as it deleting all theme files on siteleaf
      end
    end
  end
end
