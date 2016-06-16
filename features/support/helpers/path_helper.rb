module PathHelper
  def root_path
    File.join(domain, '/')
  end

  private
  def domain
    ENV['DOMAIN'] || raise("Must specify DOMAIN to run tests")
  end
end
