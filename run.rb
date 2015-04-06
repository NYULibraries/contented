# Require compass first so the extensions see it
require 'compass'
# Need to require bootstrap before sprockets loads
# since that's how the bootstrap gem determines if we're
# asset pipelining
require 'bootstrap-sass'
require 'nyulibraries-assets'
require 'fileutils'
require 'rails'
require 'jquery-rails'
require 'microservice_precompiler'
# Get the various paths
nyulibraries_assets_base =  "#{Compass::Frameworks['nyulibraries-assets'].stylesheets_directory}/.."
nyulibraries_assets_javascripts_path = "#{nyulibraries_assets_base}/javascripts"
nyulibraries_assets_images_path = "#{nyulibraries_assets_base}/images"
bootstrap_assets_base = "#{Compass::Frameworks['bootstrap'].stylesheets_directory}/.."
bootstrap_javascripts_path = "#{bootstrap_assets_base}/javascripts"
bootstrap_images_path = "#{bootstrap_assets_base}/images"
# Clean up old compiled css
FileUtils.rm_rf "./assets/stylesheets"
# Copy the bootstrap glyphicons to assets/images
FileUtils.cp_r "#{bootstrap_images_path}", "./assets"
# Copy the nyulibraries images to assets/images
FileUtils.cp_r "#{nyulibraries_assets_images_path}", "./assets"
precompiler = MicroservicePrecompiler::Builder.new
precompiler.build_path = "./dist"
precompiler.send(:sprockets_env).append_path bootstrap_javascripts_path
precompiler.send(:sprockets_env).append_path nyulibraries_assets_javascripts_path
precompiler.project_root = "./assets"
precompiler.sprockets_build [:javascripts] # Compile Javascript
precompiler.compass_build # compile CSS
# Copy images to dist
FileUtils.cp_r "./assets/images", "./dist"
# Copy stylesheets to dist/stylesheets
FileUtils.cp_r "./assets/stylesheets", "./dist"
# Clean up and  remove the stylesheets directory from assets
FileUtils.rm_rf "./assets/stylesheets"
# copy images to dist
FileUtils.cp_r "./images", "./dist/images/"
