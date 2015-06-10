root = exports ? window
root.ans = []
class Parse_Answers
  @parseJson : (data)->
    topics = []
    for e in data.data.faqs
      for topic in e.topics
        topics.push topic.name
      root.ans.push new Answers(e.owner.name,e.question,e.answer,e.updated,e.votes.yes,e.votes.no,topics,e.totalhits)

class Time_answer
  constructor: (date) ->
    @time = @parseDate(date)

  parseDate : (date)->
    [year, month, today ] = date.substring(0,date.indexOf(" ")).split("-")
    new Date(year, month, today, 0, 0, 0, 0)

class Answers
  constructor: (name,question,answer,updated,votes_yes,votes_no,topics,total_hits) ->
    @name = name
    @question = question
    @answer = answer.replace("<p>","").replace("</p>","")
    @updated = new Time_answer(updated)
    @votes_yes = votes_yes
    @votes_no = votes_no
    @topics = topics
    @total_hits = total_hits

Print_Ans = ->
  for e in root.ans
    document.getElementById("libanswers").innerHTML += "<BR>name: "+e.name
    document.getElementById("libanswers").innerHTML += "<BR>question: "+e.question
    document.getElementById("libanswers").innerHTML += "<BR>answer: "+e.answer
    document.getElementById("libanswers").innerHTML += "<BR>updated: "+e.updated.time.getMonth()
    document.getElementById("libanswers").innerHTML += "<BR>votes_yes: "+e.votes_yes
    document.getElementById("libanswers").innerHTML += "<BR>votes_no: "+e.votes_no
    for t in e.topics
      document.getElementById("libanswers").innerHTML += "<BR>topics: "+t
    document.getElementById("libanswers").innerHTML += "<BR>total_hits: "+e.total_hits

getAnswers_print = ->
  $.getJSON 'https://api2.libanswers.com/1.0/faqs?iid=315&callback=?',(data) ->
    Parse_Answers.parseJson(data)
    Print_Ans()
    return
  return

if document.URL.indexOf("/libanswers") > 0
  getAnswers_print()