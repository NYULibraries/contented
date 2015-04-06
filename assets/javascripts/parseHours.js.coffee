root = exports ? window
root.lib = []
no_of_weeks = 2
class Dates
  constructor: (date,day,status,from,to) ->
    @day = day
    [year, month, today ] = date.split("-")
    @date = new Date(year,month-1,today)
    @status = status
    if from != undefined
      @from = @parseTime(from)
      @to = @parseTime(to)

  parseTime: (time) ->
    add = 0
    if time.indexOf("pm") > 0
      add = 12
    time = time.replace("am","").replace("pm","")
    [hour , min] = time.split ':'
    if min == undefined
      min = 0
    if add == 0 && parseInt(hour) == 12
      hour = 0
    hour = parseInt(hour) + parseInt(add)
    new Date(0,0,0,hour,min,0,0)

class Days
  constructor: (element) ->
    `const weekday =  new Array("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")`
    @days = []
    for i in [0..6] by 1
      if element[weekday[i]].times.status  == "open"
        from = element[weekday[i]].times.hours[0].from
        to = element[weekday[i]].times.hours[0].to
      @days[i] = new Dates(element[weekday[i]].date,weekday[i],element[weekday[i]].times.status,from,to)

class ContactInfo
  constructor: (contacts)->
    contacts = contacts.replace("<p>", "").replace("</p>","")
    [@phone, @email, @tmz, @address1, @address2] = contacts.split ';'.trim()

class Library
  constructor: (name,category,lat,lng,contact,week) ->
    @name =  name
    @category =  category
    @latitude = lat
    @longitude = lng
    @contact = new ContactInfo(contact)
    @parseWeek(week)

  parseWeek: (week) ->
    @week = []
    for i in [0..no_of_weeks-1] by 1
      @week[i]  = new Days(week[i])

  isCurrentlyOpen : () ->
    day = (new Date()).getDay()
    if @week[0].days[day].status == "24hours"
      return true
    if @week[0].days[day].status == "not-set"
      return false
    if @week[0].days[day].to.getHours() <  @week[0].days[day].from.getHours()
      if !(@week[0].days[day].from.getHours() <= (new Date()).getHours() && (new Date()).getHours() <=  @week[0].days[day].to.getHours())
        return true
    if @week[0].days[day].from.getHours() <= (new Date()).getHours() && (new Date()).getHours() <=  @week[0].days[day].to.getHours()
      if @week[0].days[day].to.getHours() != (new Date()).getHours() &&  @week[0].days[day].to.getMinutes() == 0
        flag = true
      if @week[0].days[day].from.getMinutes() <= (new Date()).getMinutes() && (flag || (new Date()).getMinutes() <= @week[0].days[day].to.getMinutes())
        return true
    return false

class HoursLibcal
  @parseJson : (data)->
    for i in [0..data.locations.length-1] by 1
      root.lib[i] = new Library(data.locations[i].name, data.locations[i].category, data.locations[i].lat, data.locations[i].long , data.locations[i].contact, data.locations[i].weeks)



map_init = (name,lat,lng) ->
  mapOptions =
    center: new google.maps.LatLng(lat, lng),
    zoom: 18
  new google.maps.Map(document.getElementById(name).children[1], mapOptions);

print = ->
  for i in [0..root.lib.length - 1] by 1
    if root.lib[i].category == 'library'
      document.getElementById(root.lib[i].name).children[0].innerHTML += root.lib[i].name
      map_init(root.lib[i].name,root.lib[i].latitude, root.lib[i].longitude)
      document.getElementById(root.lib[i].name).children[2].innerHTML += root.lib[i].contact.address1+"<BR>"+root.lib[i].contact.address2
      document.getElementById(root.lib[i].name).children[3].children[1].innerHTML += root.lib[i].contact.phone;
      document.getElementById(root.lib[i].name).children[4].children[1].innerHTML += root.lib[i].contact.email;
      #document.getElementById(name).children[5].children[0].innerHTML += "<b><font color=\""+colorOpen+"\">"+openOrNot+"</font></b>&nbsp&nbsp&nbsp&nbsp<b><font color=\""+colorOpen+"\">"+currOpenTime+"</font></b>" ;
      document.getElementById(root.lib[i].name).children[5].children[1].children[0].innerHTML += "OPEN HOURS ("+root.lib[i].contact.tmz+")"
      if root.lib[i].isCurrentlyOpen()
        if root.lib[i].week[0].days[(new Date()).getDay()].status == "24hours"
          document.getElementById(root.lib[i].name).children[5].children[0].innerHTML += "<b><font color=\"green\">OPEN&nbsp&nbsp&nbsp&nbsp24 HOURS</font></b>" ;
        else
          document.getElementById(root.lib[i].name).children[5].children[0].innerHTML += "<b><font color=\"green\">TODAYS HOURS&nbsp&nbsp&nbsp&nbsp"+root.lib[i].week[0].days[(new Date()).getDay()].from.getHours()+":"+root.lib[i].week[0].days[(new Date()).getDay()].from.getMinutes()+" to "+root.lib[i].week[0].days[(new Date()).getDay()].to.getHours()+":"+root.lib[i].week[0].days[(new Date()).getDay()].to.getMinutes()+"</font></b>" ;
      else
        document.getElementById(root.lib[i].name).children[5].children[0].innerHTML += "<b><font color=\"red\">CLOSED&nbsp&nbsp&nbsp&nbsp</font></b>" ;

      #document.getElementById("print").innerHTML += "<BR>" + root.lib[i].isCurrentlyOpen()

      #for j in [0..no_of_weeks - 1] by 1
        #for k in [0..6] by 1
          #document.getElementById("print").innerHTML += "<BR>"+root.lib[i].week[j].days[k].date + " " + root.lib[i].week[j].days[k].day + " " + root.lib[i].week[j].days[k].status + " " + root.lib[i].week[j].days[k].from + " " + root.lib[i].week[j].days[k].to

init = ->
  $.getJSON '//api3.libcal.com/api_hours_grid.php?iid=1287&format=json&weeks='+no_of_weeks+'&callback=?', (data) ->
    HoursLibcal.parseJson(data)
    print()
    return
  return

init()
