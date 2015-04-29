root = exports ? window
root.staff = []
class Parse_Classes
	@parseJson : (data)->
		for e in data.events
			root.staff.push new Classes(e.title,e.start,e.end,e.description,e.location.name,e.campus.name,e.presenter,e.seats,e.seats_taken)

class Time
	constructor: (date) ->			
		@time = @parseDate(date)

	parseDate : (date)->
		the_date = date.substring(0,date.indexOf("T"));
		[year, month, today ] = the_date.split("-")
		the_time = date.substring(date.indexOf("T")+1).substring(0,5);
		[hour, min] = the_time.split(":")
		new Date(year, month, today, hour, min, 0, 0); 

class Classes
	constructor: (name,start,end,description,location,campus,teacher,seats,seats_taken) ->	
		@name = name
		@start = new Time(start)
		@end = new Time(end)
		@description = description	
		@location = location
		@campus = campus
		@teacher = teacher
		@seats = seats
		@seats_taken = seats_taken

		
Print = -> 
	for e in root.staff				
		if document.URL.indexOf("/department/"+e.campus.toLowerCase()) > 0
			x = "print"
		else
			x = "printall"		
		document.getElementById(x).innerHTML += "<BR><b>CLASS:</b>"
		document.getElementById(x).innerHTML += "<BR>name: "+e.name		
		document.getElementById(x).innerHTML += "<BR>start date: "+e.start.time.getMonth()+"/"+e.start.time.getDate()
		document.getElementById(x).innerHTML += "<BR>start time: "+e.start.time.getHours()+":"+e.start.time.getMinutes()
		document.getElementById(x).innerHTML += "<BR>end date: "+e.end.time.getMonth()+"/"+e.end.time.getDate()
		document.getElementById(x).innerHTML += "<BR>end time: "+e.end.time.getHours()+":"+e.end.time.getMinutes()
		document.getElementById(x).innerHTML += "<BR>description: "+e.description
		document.getElementById(x).innerHTML += "<BR>location: "+e.location
		document.getElementById(x).innerHTML += "<BR>campus: "+e.campus
		document.getElementById(x).innerHTML += "<BR>teacher: "+e.teacher
		document.getElementById(x).innerHTML += "<BR>seats: "+e.seats
		document.getElementById(x).innerHTML += "<BR>seats taken: "+e.seats_taken		
			
			
		
		

getClasses_print = ->  	
	$.getJSON 'https://api2.libcal.com/1.0/events?iid=1287&cal_id=144&key=6c79e5927411143f2ddb85e3b2e1ea46&callback=?', (data) ->   
		Parse_Classes.parseJson(data)		
		Print()
		return
	return  	
	

if document.URL.indexOf("/department") > 0
  getClasses_print()
