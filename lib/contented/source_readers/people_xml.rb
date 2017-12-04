require 'ox'
require 'ostruct'
#
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
        @people = Ox.load(xml_string, mode: :hash_no_attrs)[:DATA][:"staff-record"]
      end

      def each(&block)
        people.each(&block)
      end
    end
  end
end
