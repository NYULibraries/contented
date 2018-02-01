require 'ox'
require 'ostruct'
# Read XML file into an enumerable hash
module Contented
  module SourceReaders
    class PeopleXML
      include Enumerable

      attr_accessor :file, :people

      def initialize(file)
        unless File.exist?(file)
          raise ArgumentError.new("File doesn't exist")
        end
        @file = file
        xml_string = File.read(file)
        # hash_no_attrs => returns a hash and omits attributes from XML
        # skip_none => ensures that the whitespace is preserved, which is important for Markdown
        @people = Ox.load(xml_string, mode: :hash_no_attrs, skip: :skip_none)[:DATA][:"staff-record"]
      end

      def each(&block)
        people.each(&block)
      end
    end
  end
end
