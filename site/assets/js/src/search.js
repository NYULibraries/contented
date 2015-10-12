$(function() {

  var form = $(".section__search");
  var table = $(".table");
  var tbody = table.find("tbody");
  var theaders = table.find('th');
  var resetButton = $('.section__search__reset');
  var pagination = $('.pagination');

  var queryParser = function (a) {
    var i, p, b = {};
    if (a === "") {
      return {};
    }
    for (i = 0; i < a.length; i += 1) {
      p = a[i].split('=');
      if (p.length === 2) {
        b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "));
      }
    }
    return b;
  };

  var slugify = function(str) {
    return str.replace(/[^a-zA-Z0-9]+/ig, '-').replace(/^\-|\-$/ig, '').toLowerCase();
  };

  var getValues = function() {
    return form.find(':input').filter(function() {
      return !!$(this).val() && $(this).val() != $(this).attr('data-default');
    }).serialize();
  };

  var search = function() {
    updateSort();

    resetButton.toggleClass('is-hidden', !getValues());

    var params = queryParser(form.serialize().split('&'));
    params['engine_key'] = swiftypeEngineKey;
    params['per_page'] = pageSize;
    params['sort_field'] = { 'page': params['sort_field'] }
    params['sort_direction'] = { 'page': params['sort_direction'] }

    var collection = table.attr('data-collection');
    var filters = (collection) ? { 'collection': collection } : {};
    form.find('select').each(function() {
      if ($(this).val()){ filters[$(this).attr('name')] = $(this).val(); }
    });
    params['filters'] = { 'page': filters }

    table.addClass('is-loading');

    $.ajax({
      url: "https://api.swiftype.com/api/v1/public/engines/search.json",
      data: params,
      dataType: "json",
      method: "POST",
      success: renderResults
    })
    .fail(function(){
      tbody.html(renderMessage('Could not load results. <a href="">Try again?</a>'));
    })
    .always(function(){
      table.removeClass('is-loading');
    });
  };

  var renderResults = function(data) {
    tbody.html('');

    $.each(data.records, function (documentType, items) {
      if (items.length > 0) {
        $.each(items, function (idx, item) {
          renderRow(item).appendTo(tbody);
        });
      } else {
        tbody.html(renderMessage('No results found. <a href="?">Reset filters?</a>'));
      }
    });

    renderPagination(data.info);
  };

  var renderRow = function(item, colspan) {
    var tr = $('<tr class="table__row">');
    theaders.each(function() {
      var field = $(this).data('field');
      var td = $('<td class="table__cell">').append(renderCol(item, field));
      tr.append(td);
    });
    return tr;
  };

  var renderCol = function(item, key) {
    value = item[key];
    if (!value) { return ""; }
    if (key == 'title' && item.card_html) {
      return item.card_html;
    } else if (key == 'departments') {
      if (typeof(value) == "string") value = [value];
      return $.map(value, function(department) {
        return $('<a href="/'+key+'/'+slugify(department)+'"></a>').text(department)[0].outerHTML;
      }).join(', ');
    } else if ('service,space,location'.indexOf(key) > -1) {
      return $('<a href="/'+key+'s/'+slugify(value)+'"></a>').text(value);
    } else {
      if (typeof(value) == "string") { value = [value]; }
      return value.join(', ');
    }
  };

  var renderMessage = function(message) {
    return '<tr class="table__row empty"><td class="table__cell" colspan="'+theaders.length+'">'+message+'</td></tr>';
  };

  var renderPagination = function(resultInfo) {
    var maxPagesType, maxPages = -1;
    $.each(resultInfo, function(documentType, typeInfo) {
      if (typeInfo.num_pages > maxPages) {
        maxPagesType = documentType;
        maxPages = typeInfo.num_pages;
      }
    });
    var currentPage = resultInfo[maxPagesType].current_page,
      totalPages = resultInfo[maxPagesType].num_pages;

    pagination.html('');

    if (totalPages > 1) {

      if (currentPage > 1) {
        var i = currentPage - 1;
        pagination.append('<a href="?page='+i+'" class="pagination__prev ss-left" data-page="'+i+'">Previous</a>');
      }

      for (i=1;i<=totalPages;i++) {
        pagination.append($('<a href="?page='+i+'" class="pagination__link" data-page="'+i+'">'+i+'</a>').toggleClass('is-selected', (currentPage == i)));
      }

      if (currentPage < totalPages) {
        var i = currentPage + 1;
        pagination.append('<a href="?page='+i+'" class="pagination__next ss-right right" data-page="'+i+'">Next</a>');
      }

    }
  };

  var updateSort = function() {
    var sortField = form.find('input[name=sort_field]').val();
    var sortDirection = form.find('input[name=sort_direction]').val();

    theaders.removeAttr('data-sort');
    theaders.filter('[data-field='+sortField+']').attr('data-sort', sortDirection);
  };

  var updateForm = function() {
    before = form.serialize();
    form.trigger('reset').deserialize(location.search.substr(1));
    after = form.serialize();
    if (before != after) { search(); }
    Stretchy.resizeAll();
  };

  form.on('submit', function(e) {
    e.preventDefault();
    var values = getValues();
    history.pushState({'popstate': true}, '', ((values) ? '?'+values : location.pathname));
    search();
  });

  form.find(':input').on('change', function(e) {
    form.find('input[name=page]').val(1);
    form.trigger('submit');
  });

  table.find('.table__cell--sortable').on('click', function() {
    var direction = ($(this).attr('data-sort') == 'asc') ? 'desc' : 'asc';
    form.find('input[name=page]').val(1);
    form.find('input[name=sort_field]').val($(this).attr('data-field'));
    form.find('input[name=sort_direction]').val(direction);
    form.trigger('submit');
  });

  resetButton.on('click', function(e) {
    e.preventDefault();
    form.trigger('reset').trigger('submit');
    Stretchy.resizeAll();
  });

  pagination.on('click', 'a', function(e) {
    e.preventDefault();
    form.find('input[name=page]').val($(this).attr('data-page'));
    form.trigger('submit');

    $('html, body').animate({
      scrollTop: table.offset().top
    }, 500);
  });

  window.onpopstate = function(e) {
    updateForm();
  };

  // check on page load
  if (location.search.length > 1) {
    updateForm();
  }

});