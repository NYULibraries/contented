require 'spec_helper'

RSpec.configure do |c|
  c.include Contented::Helpers::TitleHelpers, :include_helpers
end

describe Contented::Helpers::TitleHelpers, :include_helpers do
  describe "#titlize" do
    context "when argument has spaces" do
      it "should remove leading whitespaces" do
        expect(titlize(" leading-whitespaces")).to eq("leading-whitespaces")
        expect(titlize("  leading-whitespaces")).to eq("leading-whitespaces")
        expect(titlize("   leading-whitespaces")).to eq("leading-whitespaces")
      end
      it "should remove trailing whitespaces" do
        expect(titlize("trailing-whitespaces ")).to eq("trailing-whitespaces")
        expect(titlize("trailing-whitespaces  ")).to eq("trailing-whitespaces")
        expect(titlize("trailing-whitespaces   ")).to eq("trailing-whitespaces")
      end
      it "should convert inside whitespaces to dashes" do
        expect(titlize("test one")).to eq("test-one")
        expect(titlize("test number two")).to eq("test-number-two")
        expect(titlize(" test number five ")).to eq("test-number-five")
      end
    end
    context "when argument has apostrophes" do
      it "should remove them" do
        expect(titlize("test'one")).to eq("testone")
      end
    end
    context "when argument has spaces and apostrophes" do
      it "should convert spaces to dashes and remove apostrophes" do
        expect(titlize(" test 'o'ne  ")).to eq("test-one")
      end
    end
  end
end
