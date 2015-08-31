$(function() {

  $('ul[data-rss]').each(function() {

    var list = $(this);
    var url = list.data('rss');
    var limit = list.data('limit');

    $.ajax({
      url: 'https://ajax.googleapis.com/ajax/services/feed/load',
      dataType: 'jsonp',
      data: {
        v: '1.0',
        q: url,
        num: limit
      },
      success: function(response) {
        if (response.responseData && response.responseData.feed && response.responseData.feed.entries) {
          $(response.responseData.feed.entries).each(function() {
            addFeedItem(list, this);
          });
        }
      }
    });

  });

  function addFeedItem(list, item) {
    if (item.title && item.link) {
      var li = $('<li class="item"><h1 class="item__title"><a href="' + item.link + '" target="_blank">' + item.title + '</a></h1></li>');

      if (item.publishedDate) {
        var text = "";
        var date_parts = item.publishedDate.match(/0?([0-9]{1,2}) ([a-z]+) ([0-9]{4})/i);
        if (date_parts.length == 4) {
          text = date_parts[2] + ' ' + date_parts[1] + ', ' + date_parts[3];
        }
        if (item.author) text += ' by ' + item.author;
        var byline = $('<p class="item__meta">').text(text);
        li.append(byline)
      }

      list.append(li);
    }
  }

});