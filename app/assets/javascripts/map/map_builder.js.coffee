class @MapBuilder
  constructor: ->
    @setContainerHeight()
    window.markers = []

    @initMap()
    @initDirections()

  setContainerHeight: ->
    $(window).on 'load resize', ->
      parent_h = $(window).height() - 155
      results_parent = $('#results_placeholder').parent()

      $('#map').height(parent_h)
      $('#results_placeholder').height(parent_h - 300)
      $('#results_placeholder').width(results_parent.width())

  initMap: =>
    window.map = Gmaps.build('Google')

    map.buildMap { provider: {}, internal: {id: 'map'}}, =>
      map.getMap().setZoom(16)
      map.getMap().setCenter(new google.maps.LatLng(gon.hotel.lat, gon.hotel.lng))

      map.addMarker
        lat: gon.hotel.lat
        lng: gon.hotel.lng
        marker_title: gon.hotel.title

      reloadMarkers()
      centerMap()

      google.maps.event.addDomListener window, 'load',
      google.maps.event.addDomListener window, 'resize', ->
        centerMap()

  initDirections: ->
    setDirectionsRenderer()
    traceRoute()
    initPrint()

  window.reloadMarkers = ->
    console.log markers
    unless markers == undefined
      i = 0
      while i < markers.length
        markers[i].setMap(null)
        markers[i] = null
        i++

    $.getJSON '/hotels/markers', { booking_ids: related_ids, current_hotel_id: gon.hotel.booking_id }, (jsonData) =>
      window.markers = window.map.addMarkers(jsonData)
      map.bounds.extendWith(markers)

  window.centerMap = ->
    google.maps.event.trigger map.getMap(), 'resize'
    map.getMap().setZoom 15
    map.getMap().setCenter(new google.maps.LatLng(gon.hotel.lat, gon.hotel.lng))

  related_ids = ->
    $.map $(document).find('[data-hotel-id]'), (el) ->
      $(el).data('hotelId')

  setDirectionsRenderer = ->
    window.directionsDisplay = new google.maps.DirectionsRenderer()
    window.directionsService = new google.maps.DirectionsService()

  traceRoute = ->
    $(document).on 'click', '.routes a', (e) ->
      e.preventDefault()

      $parent = $(@).parents('.routes')
      travelMode = $(@).data('travelMode')
      printHeader = $(@).data('printHeader')

      window.currentHotel =
        id: $parent.data('bookingId')
        notifyPartnerUrl: $parent.data('notifyPartnerUrl')

      preparePrint = (data) ->
        buildStaticMap(data)
        $('.page-header h1.visible-print').html(printHeader)
        $('#print-button').removeClass('hidden')

      buildStaticMap = (data) ->
        polyline = data.routes[0].overview_polyline
        $img = $('#static-map')
        $img.attr('src', 'https://maps.googleapis.com/maps/api/staticmap?size=800x500&path=weight:5%7Ccolor:red%7Cenc:' + polyline)

      request =
        origin: new google.maps.LatLng(gon.hotel.lat, gon.hotel.lng)
        destination: new google.maps.LatLng($parent.data('lat'), $parent.data('lng'))
        travelMode: google.maps.TravelMode[travelMode]

      directionsService.route request, (response, status) ->
        if status == google.maps.DirectionsStatus.OK
          directionsDisplay.setDirections(response)
          directionsDisplay.setMap(map.getMap())
          directionsDisplay.setPanel document.getElementById("directions-panel")

          preparePrint(response)

      return

  initPrint = ->
    $(document).on 'click', '#print-button', (e) ->
      e.preventDefault()

      if window.currentHotel
        $.ajax
          url: window.currentHotel.notifyPartnerUrl
          method: 'POST'
          data:
            map: $('#static-map').attr('src')
          success: ->
            window.print()
