require File.expand_path('../../spec_helper.rb', __FILE__)

describe 'Empty_Theme' do
  let(:empty_theme) { Empty_Theme.new }

  describe '.new' do
    subject { empty_theme }
    context 'Empty theme files in siteleaf for a clean push' do
      it 'Empties Siteleaf Theme Files' do
        # pending
      end
    end
  end
end
