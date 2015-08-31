/** Config which form elements adjust their size based on their contents: */
if(!bowser.msie){ // Skip if this is IE
  document.body.setAttribute('data-stretchy-filter', '.section__search select');
  loadJS('/assets/js/dist/plugins/stretchy.min.js');
}

/** Push the footer to the bottom of the page if it's not already there */
function anchorFooter() {
  if(!window.getComputedStyle) return; // IE8

  $(window).on('load', function(){
    var footer = document.querySelector('.primary-footer');
    var footerBottom = footer.offsetTop + footer.offsetHeight;
    var windowBottom = window.innerHeight;

    if(footerBottom < windowBottom){
      var padding = windowBottom - footerBottom;

      // We add the padding to the main content since it sometimes has a border
      // that needs to extend the full length of the body
      var content = document.querySelector('.content');
      var style = window.getComputedStyle(content);
      var exisitingPadding = parseInt(style.paddingBottom);
      content.style.paddingBottom = padding + exisitingPadding + 'px';
    }
  });
}

function createAskLibrarianPopup(){
  $('.js-toggle-chat').on('click', function(e){
    e.preventDefault();
    document.body.classList.toggle('showing-chat-frame');
  });
}

function createCatalogSearchToggle(){
  $('.js-toggle-catalog').on('click', function(){
    $('.banner--search').slideToggle('fast');
    document.body.classList.toggle('showing-catalog-search');
  });
}

function createMapToggle(){
  $('.js-toggle-map').on('click', function(e){
    e.preventDefault();
    document.body.classList.toggle('showing-map');
    centerMap();
  });
}

function createMobileNavToggle(){
  $('.js-toggle-nav').on('click', function(){
    document.body.classList.toggle('showing-nav-overlay');
  });
}

/** Initializes LibCal hours widgets */
function checkAndCreateHoursWidgets(){
  var widgets = document.querySelectorAll('.hours-widget');

  if(widgets.length){
    loadJS("//api3.libcal.com/js/hours_grid.js?002", function(){
      for (var i = widgets.length - 1; i >= 0; i--) {
        var widget = widgets[i];
        var widgetId = widget.getAttribute('data-id');

        new $.LibCalWeeklyGrid( $(widget), {
          iid: 1287, lid: widgetId, weeks: 4
        });

        createHoursToggle();
      };
    });
  }
}

function createHoursToggle(){
  $('.hours-toggle').on('click', function(){
    var button = this;
    var $block = $(button).closest('.block--hours');
    var widget = $block.find('.hours-widget')[0];
    widget.classList.toggle('is-truncated');

    if(widget.classList.contains('is-truncated')){
      button.innerHTML = "See all hours"
      button.classList.remove('ss-navigateup');
      button.classList.add('ss-plus');
    } else {
      button.innerHTML = "See less hours"
      button.classList.add('ss-navigateup');
      button.classList.remove('ss-plus');
    }
  });
}

/** Banners w/ images need their height explicitly set so that vertical alignment works */
function checkBannerImages(){
  var bannerWrap = document.querySelector('.banner--with-image .wrap');
  if(bannerWrap){
    setBannerImageHeight(bannerWrap);
    $(window).on('resize', throttle(function(){
      bannerWrap.style.height = 0;
      setBannerImageHeight(bannerWrap);
    }, 250));
  }
}

/** Takes a group of blocks and determines the proper # of columns they should flex */
function flexBlocks(){
  var containers = document.querySelectorAll('.flex-blocks');

  for (var i = containers.length - 1; i >= 0; i--) {
    var container = containers[i];
    var blocks = container.querySelectorAll('.block');

    if(blocks.length > 1){
      var flexPercentage = (1 / blocks.length).toFixed(2) * 100;
      var flexClass = 'block--' + flexPercentage;

      for (var x = blocks.length - 1; x >= 0; x--) {
        var block = blocks[x];
        block.classList.add(flexClass);
      }
    }
  }
}

/** Equalize the height of blocks so they stack properly */
function equalizeBlocks() {
  var containers = document.querySelectorAll('.js-equalize');
  if(!containers.length) return;

  for (var i = containers.length - 1; i >= 0; i--) {
    var container = containers[i];
    var blocks = container.querySelectorAll('.block'); // .children instead?
    imagesLoaded(blocks, equalizeBlockHeights.call(this, blocks));

    $(window).on('resize', debounce(function(){
      equalizeBlockHeights(blocks, true);
    }, 100));
  }
}

function setBannerImageHeight(bannerWrap){
  var bannerInner = document.querySelector('.banner__inner');

  if(bannerInner.offsetHeight < bannerWrap.offsetHeight){
    bannerWrap.style.height = bannerWrap.offsetHeight + 'px';
  }
}

/** Auto search on 404 page */
function magicSearch(){
  $('a.magic-search').each(function() {
    var slug = location.pathname.replace(/.*\/|\..*/g, '');
    if (slug) $(this).text(slug).attr('href', '#stq='+slug)
  });
}

/** When DOM is ready, let's get started... */
$(function(){
  anchorFooter();
  checkAndCreateHoursWidgets();
  createAskLibrarianPopup();
  createCatalogSearchToggle();
  createMapToggle();
  createMobileNavToggle();
  equalizeBlocks();
  flexBlocks();
  magicSearch();

  // We need to wait for the image and fonts to fully load so we can get the correct height
  $(window).on('load', checkBannerImages);
});