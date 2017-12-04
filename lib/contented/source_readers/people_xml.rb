# 
module Contented
  module SourceReaders
    class PeopleXML
      include Enumerable

      attr_accessor :file, :people

      def initialize(file)
        @file = file
        xml_string = File.read(file)
        @people = OpenStruct.new(Hash.from_xml(xml_string))
      end

      def each(&block)
        people.each(&block)
      end
    end
  end
end
