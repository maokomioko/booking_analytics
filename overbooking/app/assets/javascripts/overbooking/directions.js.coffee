class @Directions
  constructor: ->
    @initGlobals()
    @traceRoute()
    @initPrint()

  initGlobals: ->
    $.getJSON location.toString(), {}, (hotelJson) ->
      window.hotel = hotelJson
      window.map = Gmaps.build('Google')

      map.buildMap { provider: {}, internal: {id: 'map'}}, ->
        map.addMarker
          lat: window.hotel.lat
          lng: window.hotel.lng
          marker_title: window.hotel.name
          picture:
            url: 'http://maps.google.com/mapfiles/kml/paddle/blu-stars.png'
            width: 64
            height: 64

        $.getJSON window.hotel.markers_path, {}, (markersJson) ->
          markers = map.addMarkers(markersJson)
          map.bounds.extendWith(markers)
          map.getMap().setZoom(18)
          map.getMap().setCenter(new google.maps.LatLng(window.hotel.lat, window.hotel.lng))
          $(document).trigger('mapReady')

      window.directionsDisplay = new google.maps.DirectionsRenderer()
      window.directionsService = new google.maps.DirectionsService()

  traceRoute: ->
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
        origin: new google.maps.LatLng(window.hotel.lat, window.hotel.lng)
        destination: new google.maps.LatLng($parent.data('lat'), $parent.data('lng'))
        travelMode: google.maps.TravelMode[travelMode]

      directionsService.route request, (response, status) ->
        if status == google.maps.DirectionsStatus.OK
          directionsDisplay.setDirections(response)
          directionsDisplay.setMap(map.getMap())
          directionsDisplay.setPanel document.getElementById("directions-panel")

          preparePrint(response)

      return

  initPrint: ->
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