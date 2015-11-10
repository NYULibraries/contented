module GatherContent
  class Departments
    include Enumerable
    attr_accessor :project_id

    def initialize(project_id='57459')
      @project_id = project_id
      @items = GatherContent::Api::Items.new(project_id)
    end

    def each(departments = Array.new)
      items.each do |item|
        departments << GatherContent::Department.new(item)
      end
      departments
    end

  end
end

# ---
# title: Data Services
# date: 2015-09-14 14:34:00 -04:00
# location: Elmer Holmes Bobst Library
# space: Room 511, Research Commons, 5th Floor South
# email: data.services@nyu.edu
# phone: "(212) 998-3434"
# twitter: nyudataservices
# blog:
#   title: Latest News
#   rss: https://nyudataservices.wordpress.com/feed/
#   link: http://nyudataservices.wordpress.com
# libcal_id: 990
# libanswers_id: 14698
# buttons:
#   Request an Appointment: http://www.example.org
# ---
#
# # What We Do
#
# Data Services provides consultation and instructional support for researchers and instructors using quantitative, qualitative, and geospatial (GIS) software and methods at NYU, and can advise on projects across the entire research data lifecycle, including access, analysis, collection development, data management, and data preservation.
