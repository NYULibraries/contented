rssfeedsetup = (feedurl,feedlimit) ->
  feedpointer = new (google.feeds.Feed)(feedurl)
  feedpointer.setNumEntries feedlimit
  feedpointer.load displayfeed

displayfeed = (result) ->
  if !result.error
    for e in result.feed.entries
      pubDate = ''+e.publishedDate
      pubDate = pubDate.substring(pubDate.indexOf(',')+1,pubDate.indexOf(':')-3)
      document.getElementById('rss').innerHTML += '<a href="'+e.link+'">'+e.title + '</a><BR> Posted ' +pubDate+'<BR>'

if document.URL.indexOf('/departments/') > 0
  $ ->
    rssfeedsetup document.getElementById('rss_feed').value, 5
