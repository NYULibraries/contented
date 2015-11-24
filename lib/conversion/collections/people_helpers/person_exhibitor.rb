require_relative 'expanded_person'

module Conversion
  module Collections
    module PeopleHelpers
      # Parses the person data into the required format.
      class Person_Exhibitor < ExpandedPerson

        def initialize(json_data='{}', json_data_expand='{}')
          super(json_data, json_data_expand)
          correct_job_position
          parse_departments
          parse_location
        end

        def parse_phone
          if phone
            @phone = phone.scan(/\d/).join('')
          else
            @phone = work_phone.scan(/\d/).join('')
          end
          @phone = @phone[1..-1] if @phone.size == 11
          @phone = '(' + @phone[0..2] + ') ' + @phone[3..5] + '-' + @phone[6..-1]
        end

        def correct_job_position
          all_positions_jobs.each { |job| @correct_job_position ||= job if job['Is_Primary_Job'] }
        end

        def parse_departments
          if @departments.nil? && @correct_job_position['Supervisory_Org_Name']
            @departments = @correct_job_position['Supervisory_Org_Name'] + '('
            @departments = @departments.slice(0..(@departments.index('(') - 1)).strip
          end
        end

        def parse_location
          if @location.nil? && @correct_job_position['Position_Work_Space']
            @location = @correct_job_position['Position_Work_Space'].split('>')[1].strip
          end
          puts @location
        end
      end
    end
  end
end

PEOPLESYNC = {
         NetID: "xx123",
         Employee_ID: "N00000001",
         Last_Name: "Lastname",
         First_Name: "Firstname",
         Primary_Work_Space_Address: "10 Number Place",
         Work_Phone: "+1 (555) 5555555",
         Email_Address: "no-reply@nyu.edu",
         All_Positions_Jobs:[
            {
               Job_Profile: "000000 - Some Job Profile",
               Is_Primary_Job: "1",
               Job_Family_Group: "NYU - Something",
               Supervisory_Org_Name: "Some Group",
               Business_Title: "Super Fancy Title",
               Position_Work_Space: "Earth > America > New York > New York",
               Division_Name: "Division of Tests"
            }
         ]
      }.to_json

PEOPLE_SHEET = {
        id: {
          :$t => "https://spreadsheets.google.com/feeds/list/V8nNaf-000k1dESZGCwBvkuxoCe000k1dESZGCwBvkuxoCe/0/public/values/bpgoi"
        },
        updated: {
          :$t => "2015-10-28T18:47:00.245Z"
        },
        category: [{
            scheme: "http://schemas.google.com/spreadsheets/2006",
            term: "http://schemas.google.com/spreadsheets/2006#list"
        }],
        title: {
            type: "text",
            :$t => "xx99"
        },
        content: {
            type: "text",
            :$t => ""
        },
        link: [{
            rel: "self",
            type: "application/atom+xml",
            href: "https://spreadsheets.google.com/feeds/list/V8nNaf-000k1dESZGCwBvkuxoCe000k1dESZGCwBvkuxoCe/0/public/values/bpgoi"
        }],
        "gsx$netid" => {
          :$t => "xx99"
        },
        "gsx$subtitle" => {
          :$t => "subtitle"
        },
        "gsx$expertise" => {
          :$t => "Everything"
        },
        "gsx$twitter" => {
          :$t => "tweeter"
        },
        "gsx$image" => {
          :$t => "image"
        },
        "gsx$buttons" => {
          :$t => "buttons"
        },
        "gsx$guides" => {
          :$t => "title: Title ;\nlibguide_id: number"
        },
        "gsx$publications" => {
          :$t => "Publications"
        },
        "gsx$keywords" => {
          :$t => "Key Word"
        },
        "gsx$about" => {
          :$t => "This is test data about"
        },
        "gsx$title" => {
          :$t => "Title"
        },
        "gsx$phone" => {
          :$t => "(555) 555-5555"
        },
        "gsx$email" => {
          :$t => "not@nemail"
        },
        "gsx$address" => {
          :$t => "123 Sesame St"
        },
        "gsx$departments" => {
          :$t => "Astroland"
        },
        "gsx$location" => {
          :$t => "Coney Island"
        },
        "gsx$space" => {
          :$t => "Some Floor"
        },
        "gsx$status" => {
          :$t => "Status"
        },
        "gsx$jobtitle" => {
          :$t => "Jobtitle"
        }
      }.to_json


Conversion::Collections::PeopleHelpers::Person_Exhibitor.new(PEOPLESYNC,'{}')
