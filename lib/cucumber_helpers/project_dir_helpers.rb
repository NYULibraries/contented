module CucumberHelpers
  module ProjectDirHelpers
    def project_dir
      File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
    end
  end
end