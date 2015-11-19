require_relative '../collections/people_helpers/expanded_person'

class MarkdownPresenter
  attr_reader :person
  def initialize(person)
    @person = person
  end

  def render
    render = ""
    (self.private_methods - Object.private_methods - Module.methods).each do |method_sym|
      render = "#{render}#{self.send(method_sym)}\n"
    end
    render
  end

private

  def yaml_start
    "---\n"
  end

  def subtitle
    "subtitle: '#{person.subtitle}'"
  end

  def job_title
    "job_title: '#{person.jobtitle}'"
  end

  def location
    "location: '#{person.location}'"
  end

  def space
    "space: '#{person.space}'"
  end

  def departments
    "departments: '#{person.departments}'"
  end

  def status
    "status: '#{person.status}'"
  end

  def expertise
    "expertise: '#{person.expertise}'"
  end

  def email
    "email: '#{person.email}'"
  end

  def phone
    "phone: '#{person.phone}'"
  end

  def twitter
    "twitter: '#{person.twitter}'"
  end

  def image
    "image: '#{person.image}'"
  end

  def buttons
    "buttons: '#{person.buttons}'"
  end

  def guides
    "guides: '#{person.guides}'"
  end

  # def publications
  #   "publications: '#{person.publications}'"
  # end

  def keywords
    "keywords: '#{person.keywords}'"
  end

  def title
    "title: '#{person.title}'"
  end

  def yaml_end
    "\n---\n"
  end

  def about_block
    "# About #{person.about}"
  end
end

# class Person
#   def initialize
#   end

#   def method_missing(m, *args, &block)
#     m
#   end
# end

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


person = Conversion::Collections::PeopleHelpers::ExpandedPerson.new(PEOPLESYNC, PEOPLE_SHEET)
markdownPresenter = MarkdownPresenter.new(person)
puts markdownPresenter.render