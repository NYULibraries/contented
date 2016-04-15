FactoryGirl.define do
  factory :google_spreadsheet, class: Hash do
    skip_create

    id do
      {
        :$t => "https://spreadsheets.google.com/feeds/list/V8nNaf-000k1dESZGCwBvkuxoCe000k1dESZGCwBvkuxoCe/0/public/values/bpgoi"
      }
    end
    updated do
      {
        :$t => "2015-10-28T18:47:00.245Z"
      }
    end
    category do
      [{
        scheme: "http://schemas.google.com/spreadsheets/2006",
        term: "http://schemas.google.com/spreadsheets/2006#list"
      }]
    end
    title do
      {
        type: "text",
        :$t => "xx99"
      }
    end
    content do
      {
        type: "text",
        :$t => ""
      }
    end
    link do
      [{
        rel: "self",
        type: "application/atom+xml",
        href: "https://spreadsheets.google.com/feeds/list/V8nNaf-000k1dESZGCwBvkuxoCe000k1dESZGCwBvkuxoCe/0/public/values/bpgoi"
      }]
    end

    send :"gsx$netid" do
      { :$t => "xx99" }
    end
    send :"gsx$subtitle" do
      { :$t => "Reference Associate" }
    end
    send :"gsx$subject_specialties" do
      { :$t => <<EOF
First Subject:
- First Specialty
- Second Specialty
Second Subject:
- 'Quoted: specialty'
- Last Specialty
EOF
       }
    end
    send :"gsx$twitter" do
      { :$t => "@handle" }
    end
    send :"gsx$image" do
      { :$t => "image.png" }
    end
    send :"gsx$buttons" do
      { :$t => "mailto:xx99@nyu.edu" }
    end
    send :"gsx$guides" do
      { :$t => "title: Title ;\nlibguide_id: number" }
    end
    send :"gsx$publications" do
      { :$t => "rss: http://www.refworks.com/123&rss" }
    end
    send :"gsx$blog" do
      { :$t => "rss: rss.xml" }
    end
    send :"gsx$keywords" do
      { :$t => "histories" }
    end
    send :"gsx$about" do
      { :$t => "This is test data about" }
    end
    send :"gsx$title" do
      { :$t => "Mr Robot" }
    end
    send :"gsx$phone" do
      { :$t => "(555) 555-5555" }
    end
    send :"gsx$email" do
      { :$t => "xx99@nyu.edu" }
    end
    send :"gsx$address" do
      { :$t => "70 Washington Square South" }
    end
    send :"gsx$departments" do
      { :$t => "Web Services, LITS" }
    end
    send :"gsx$library" do
      { :$t => "  20 Cooper Square  " }
    end
    send :"gsx$space" do
      { :$t => "Office LC12" }
    end
    send :"gsx$status" do
      { :$t => "Status" }
    end
    send :"gsx$jobtitle" do
      { :$t => "Jobtitle" }
    end

    initialize_with { attributes }
  end
end
