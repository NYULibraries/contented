require 'spec_helper'

RSpec.configure do |c|
  c.include Contented::Conversions::Collections::Helpers::GoogleSpreadsheetHelpers, :include_google_spreadsheet_helpers
end

describe Contented::Conversions::Collections::Helpers::GoogleSpreadsheetHelpers, :include_google_spreadsheet_helpers do
  let(:google_sheet_json_hash) { {'gsx$key' => {'$t' => 'value'}} }
  let(:useful_hash)            {useful_spreadsheet_hash(google_sheet_json_hash)}
  
  describe "#useful_spreadsheet_hash" do
    it 'should be a hash' do
      expect(useful_hash.class).to be Hash
    end
    it 'should have a key' do
      expect(useful_hash.keys.first).to eq "key"
    end
    it 'should have a value' do
      expect(useful_hash["key"]).to eq "value"
    end
  end
end
