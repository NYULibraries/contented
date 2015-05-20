# Require compass first so the extensions see it
require 'compass'
# Need to require bootstrap before sprockets loads
# since that's how the bootstrap gem determines if we're
# asset pipelining
require 'nyulibraries-assets'
require 'fileutils'
require 'microservice_precompiler'
require 'liquid'
# Get the various paths
<<<<<<< HEAD
class Setup_nyulibraries_assets
	def initialize
		init_nyulibraries_assets_compass
		init_bootstrap_compass
		setup_dirs
		compile_Microservice_Precompiler
		compile_liquid
		setup_siteleaf_structure
		cleanup
	end
	def init_nyulibraries_assets_compass
		@nyulibraries_assets_base =  "#{Compass::Frameworks['nyulibraries-assets'].stylesheets_directory}/.."
		@nyulibraries_assets_javascripts_path = "#{@nyulibraries_assets_base}/javascripts"
		@nyulibraries_assets_images_path = "#{@nyulibraries_assets_base}/images"
	end
	def init_bootstrap_compass
		@bootstrap_assets_base = "#{Compass::Frameworks['bootstrap'].stylesheets_directory}/.."
		@bootstrap_javascripts_path = "#{@bootstrap_assets_base}/javascripts"
		@bootstrap_images_path = "#{@bootstrap_assets_base}/images"
	end
	def setup_dirs
		#Create javascripts Directory
		FileUtils.mkdir_p "./javascripts"
		# Copy the bootstrap glyphicons to assets/images
		FileUtils.cp_r "#{@bootstrap_images_path}", "./assets"
		# Copy the nyulibraries images to assets/images
		FileUtils.cp_r "#{@nyulibraries_assets_images_path}", "./assets"
	end
	def compile_Microservice_Precompiler
		precompiler = MicroservicePrecompiler::Builder.new
		precompiler.build_path = "./"
		precompiler.send(:sprockets_env).append_path @bootstrap_javascripts_path
		precompiler.send(:sprockets_env).append_path @nyulibraries_assets_javascripts_path
		precompiler.project_root = "./assets"
		precompiler.sprockets_build [:javascripts] # Compile Javascript
		precompiler.compass_build # compile CSS
	end
	def compile_liquid
		records = Dir.glob("_includes/**/*")
		records.each do |liquid_file|
  			next if File.directory? liquid_file
  			file = File.read("#{liquid_file}")
  			template = Liquid::Template.parse(file).render
		end
	end
	def setup_siteleaf_structure
		# Copy images to dist
		#FileUtils.cp_r "./assets/images/.", "./images"    # NOTE: Uncomment this to get all images to.
		# Copy stylesheets to dist/stylesheets
		FileUtils.cp_r "./assets/stylesheets", "./"
	end
	def cleanup
		# Clean up and  remove the stylesheets directory from assets
		FileUtils.rm_rf "./assets/stylesheets"
		# Clean up and  remove the images directory from assets
		FileUtils.rm_rf "./assets/images"
		# Clean up and  remove the jquery.js files because they are alread present in application.js
		FileUtils.rm %w( ./javascripts/jquery.js ./javascripts/jquery_ujs.js )
	end
end

Setup_nyulibraries_assets.new()
=======
class SetupNyulibrariesAssets
  def initialize
    init_nyulibraries_assets_compass
    init_bootstrap_compass
    setup_dirs
    compile_coffee_scss
    compile_liquid
    setup_siteleaf_structure
    cleanup
  end

  def assets_root
    "#{Compass::Frameworks['nyulibraries-assets'].stylesheets_directory}/.."
  end

  def init_nyulibraries_assets_compass
    @nyulibraries_assets_js = "#{assets_root}/javascripts"
    @nyulibraries_assets_images_path = "#{assets_root}/images"
  end

  def init_bootstrap_compass
    @bootstrap = "#{Compass::Frameworks['bootstrap'].stylesheets_directory}/.."
    @bootstrap_js = "#{@bootstrap}/javascripts"
    @bootstrap_images_path = "#{@bootstrap}/images"
  end

  def setup_dirs
    # Create javascripts Directory
    FileUtils.mkdir_p './javascripts'
    # Copy the bootstrap glyphicons to assets/images
    FileUtils.cp_r "#{@bootstrap_images_path}", './assets'
    # Copy the nyulibraries images to assets/images
    FileUtils.cp_r "#{@nyulibraries_assets_images_path}", './assets'
  end

  def compile_coffee_scss
    precompiler = MicroservicePrecompiler::Builder.new
    precompiler.build_path = './'
    precompiler.send(:sprockets_env).append_path @bootstrap_js
    precompiler.send(:sprockets_env).append_path @nyulibraries_assets_js
    precompiler.project_root = './assets'
    precompiler.sprockets_build [:javascripts] # Compile Javascript
    precompiler.compass_build # compile CSS
  end

  def compile_liquid
    records = Dir.glob('_includes/**/*')
    records.each do |liquid_file|
      next if File.directory? liquid_file
      file = File.read("#{liquid_file}")
      Liquid::Template.parse(file).render
    end
  end

  def setup_siteleaf_structure
    # Copy images to dist
    # NOTE: Uncomment this to get all images to.
    # FileUtils.cp_r "./assets/images/.", "./images"
    # Copy stylesheets to dist/stylesheets
    FileUtils.cp_r './assets/stylesheets', './'
  end

  def cleanup
    # Clean up and  remove the stylesheets directory from assets
    FileUtils.rm_rf './assets/stylesheets'
    # Clean up and  remove the images directory from assets
    FileUtils.rm_rf './assets/images'
    # remove jquery.js files because they are already present in application.js
    FileUtils.rm %w( ./javascripts/jquery.js ./javascripts/jquery_ujs.js )
  end
end

SetupNyulibrariesAssets.new
>>>>>>> feature/restruct
