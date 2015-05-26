class Twitter
  constructor: (name,handle,time,msg) ->
    @name = name
    @handle = handle
    @time = time.replace('Posted on ','')
    @msg = msg

TweetFetcher = (id) ->
  @id = id
  @inst = 'twitter_' + (new Date).getTime()
  window[@inst] = this

TweetFetcher::fetch = (twit) ->
  @twit = twit
  s = document.createElement('script')
  s.src = 'https://cdn.syndication.twimg.com/widgets/timelines/'+@id+'?callback='+@inst+'.call'
  document.getElementsByTagName('head')[0].appendChild s

TweetFetcher::call = (res) ->
  raw = document.createElement('div')
  raw.innerHTML = res.body
  tweets = raw.querySelectorAll('li.tweet')
  output = []
  for tweet in tweets
    output.push new Twitter(tweet.querySelector('span.p-name').textContent,tweet.querySelector('span.p-nickname b').textContent,tweet.querySelector('time.dt-updated').getAttribute('aria-label'),tweet.querySelector('p.e-entry-title').innerHTML)
  @twit output

getTweets_print = (id,div_id,limit)->
  new TweetFetcher(id).fetch((tweets) ->
    i = 0
    for tweet in tweets
      i++
      document.getElementById(div_id).innerHTML += '<BR>'+tweet.msg+'<BR>'+tweet.name+' @'+tweet.handle+' &#149 '+tweet.time+'<BR>'
      if i > 10
        break
  )