rssfeedsetup = (feedurl,feedlimit) ->
  feedpointer = new (google.feeds.Feed)(feedurl)
  feedpointer.setNumEntries feedlimit
  feedpointer.load displayfeed

displayfeed = (result) ->
  if !result.error
    for e in result.feed.entries
      document.getElementById('rss').innerHTML += e.title

if document.URL.indexOf('/departments/') > 0
  $ ->
    rssfeedsetup document.getElementById('rss_feed').value, 10
