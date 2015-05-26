# global variables

isIE8 = false
isIE9 = false
$windowWidth = undefined
$windowHeight = undefined
$pageArea = undefined
isMobile = false

#Main Function

window.Main = do ->
  #function to detect explorer browser and its version

  runInit = ->
    if /MSIE (\d+\.\d+);/.test(navigator.userAgent)
      ieversion = new Number(RegExp.$1)
      if ieversion == 8
        isIE8 = true
      else if ieversion == 9
        isIE9 = true
    if /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
      isMobile = true
    return

  #function to adjust the template elements based on the window size

  runElementsPosition = ->
    $windowWidth = $(window).width()
    $windowHeight = $(window).height()
    $pageArea = $windowHeight - $('body > .navbar').outerHeight() - $('body > .footer').outerHeight()
    if !isMobile
      $('.sidebar-search input').removeAttr('style').removeClass 'open'
    runContainerHeight()
    return

  #function to adapt the Main Content height to the Main Navigation height

  runContainerHeight = ->
    mainContainer = $('.main-content > .container')
    mainNavigation = $('.main-navigation')
    if $pageArea < 760
      $pageArea = 760
    if mainContainer.outerHeight() < mainNavigation.outerHeight() and mainNavigation.outerHeight() > $pageArea
      mainContainer.css 'min-height', mainNavigation.outerHeight()
    else
      mainContainer.css 'min-height', $pageArea
    if $windowWidth < 768
      mainNavigation.css 'min-height', $windowHeight - $('body > .navbar').outerHeight()
    setTimeout ->
      $('#page-sidebar .sidebar-wrapper').css('height', $windowHeight - $('body > .navbar').outerHeight()).scrollTop(0).perfectScrollbar 'update'
    , 0
    return

  #function to activate the Tooltips, if present

  runTooltips = ->
    if $('.tooltips').length
      $('.tooltips').tooltip()
    return

  #function to open quick sidebar

  runQuickSideBar = ->
    $('.sb-toggle').on 'click', (e) ->
      if $(this).hasClass('open')
        $(this).not('.sidebar-toggler ').find('.fa-indent').removeClass('fa-indent').addClass 'fa-outdent'
        $('.sb-toggle').removeClass 'open'
        $('#page-sidebar').css right: -$('#page-sidebar').outerWidth()
      else
        $(this).not('.sidebar-toggler ').find('.fa-outdent').removeClass('fa-outdent').addClass 'fa-indent'
        $('.sb-toggle').addClass 'open'
        $('#page-sidebar').css right: 0
      e.preventDefault()
      return

    $('#page-sidebar .sidebar-back').on 'click', (e) ->
      $(this).closest('.tab-pane').css right: 0
      e.preventDefault()
      return
    $('#page-sidebar .sidebar-wrapper').perfectScrollbar
      wheelSpeed: 50
      minScrollbarLength: 20
      suppressScrollX: true
    $('#sidebar-tab a').on 'shown.bs.tab', (e) ->
      $('#page-sidebar .sidebar-wrapper').perfectScrollbar 'update'
      return
    return

  #function to activate the Popovers, if present

  runPopovers = ->
    if $('.popovers').length
      $('.popovers').popover()
    return

  #function to allow a button or a link to open a tab

  runShowTab = ->
    if $('.show-tab').length
      $('.show-tab').on 'click', (e) ->
        e.preventDefault()
        tabToShow = $(this).attr('href')
        if $(tabToShow).length
          $('a[href="' + tabToShow + '"]').tab 'show'
        return
    if getParameterByName('tabId').length
      $('a[href="#' + getParameterByName('tabId') + '"]').tab 'show'
    return

  #function to reduce the size of the Main Menu

  runNavigationToggler = ->
    $('.navigation-toggler').on 'click', ->
      if !$('body').hasClass('navigation-small')
        $('body').addClass 'navigation-small'
      else
        $('body').removeClass 'navigation-small'
      return
    return

  #function to activate the 3rd and 4th level menus

  runNavigationMenu = ->
    $('.main-navigation-menu li.active').addClass 'open'
    $('.main-navigation-menu > li a').on 'click', ->
      if $(this).parent().children('ul').hasClass('sub-menu') and (!$('body').hasClass('navigation-small') or $windowWidth < 767 or !$(this).parent().parent().hasClass('main-navigation-menu'))
        if !$(this).parent().hasClass('open')
          $(this).parent().addClass 'open'
          $(this).parent().parent().children('li.open').not($(this).parent()).not($('.main-navigation-menu > li.active')).removeClass('open').children('ul').slideUp 200
          $(this).parent().children('ul').slideDown 200, ->
            runContainerHeight()
            return
        else
          if !$(this).parent().hasClass('active')
            $(this).parent().parent().children('li.open').not($('.main-navigation-menu > li.active')).removeClass('open').children('ul').slideUp 200, ->
              runContainerHeight()
              return
          else
            $(this).parent().parent().children('li.open').removeClass('open').children('ul').slideUp 200, ->
              runContainerHeight()
              return
      return
    return

  runCustomCheck = ->
    $('input[type="checkbox"].flat-grey, input[type="radio"].flat-grey').iCheck
      checkboxClass: 'icheckbox_flat-grey'
      radioClass: 'iradio_flat-grey'
      increaseArea: '10%'

  #function to avoid closing the dropdown on click

  runDropdownEnduring = ->
    if $('.dropdown-menu.dropdown-enduring').length
      $('.dropdown-menu.dropdown-enduring').click (event) ->
        event.stopPropagation()
        return
    return

  #function to return the querystring parameter with a given name.

  getParameterByName = (name) ->
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]')
    regex = new RegExp('[\\?&]' + name + '=([^&#]*)')
    results = regex.exec(location.search)
    if results == null then '' else decodeURIComponent(results[1].replace(/\+/g, ' '))


  { init: ->
    runInit()
    runElementsPosition()
    runNavigationToggler()
    runNavigationMenu()
    runDropdownEnduring()
    runTooltips()
    runPopovers()
    runShowTab()
    runQuickSideBar()
    runCustomCheck()
  }

Main.init()
