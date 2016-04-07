require 'spec_helper'

RSpec.configure do |c|
  c.include Contented::Conversions::Collections::Helpers::PresenterHelpers, :include_presenter_helpers
end

describe Contented::Conversions::Collections::Helpers::PresenterHelpers, :include_presenter_helpers do
  describe "#wrap_in_quotes" do
    let(:wrapped_string)   {wrap_in_quotes(raw_string)}
    context "when string is nil" do
      let(:raw_string)    { nil }
      it 'should return nil' do
        expect(wrapped_string).to be nil
      end
    end
    context "when string is empty" do
      let(:raw_string)    { '' }
      it 'should return nil' do
        expect(wrapped_string).to be nil
      end
    end
    context "when string is not nil" do
      let(:raw_string)    { "something" }
      it 'should return string wrapped in single quotes' do
        expect(wrapped_string).to eq "'something'"
      end
      context "and string has single quotes" do
        let(:raw_string)    { "'something'" }
        it 'should return string wrapped in single quotes and escape single quotes' do
          expect(wrapped_string).to eq "'''something'''"
        end
      end
    end
  end
end
