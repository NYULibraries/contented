require File.expand_path('../../../spec_helper.rb', __FILE__)

describe 'GoogleSheet' do
  let(:google_sheet) { Conversion::Helpers::GoogleSheet }

  describe '#sheet' do
    subject { google_sheet.sheet('') }
    context 'Returns the content for worksheet number passed in the pararmeter' do
      # pending
    end
  end

  describe '#uri' do
    subject { google_sheet.uri('1') }
    context 'Should return the URL for the spreadsheet alongwith worksheet number' do
      it { should eql "http://spreadsheets.google.com/feeds/list/#{ENV['GOOGLE_SHEET_KEY']}/1/public/values?alt=json" }
    end
  end
end
