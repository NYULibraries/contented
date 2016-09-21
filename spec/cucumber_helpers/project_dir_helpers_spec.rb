require 'spec_helper'
require 'cucumber_helpers/project_dir_helpers'

RSpec.configure do |c|
  c.include CucumberHelpers::ProjectDirHelpers, :include_helpers
end

describe CucumberHelpers::ProjectDirHelpers, :include_helpers do
  describe "project_dir" do
    subject{ project_dir }
    it { is_expected.to eq File.expand_path(File.join(__FILE__, "..", "..", "..")) }
  end
end
