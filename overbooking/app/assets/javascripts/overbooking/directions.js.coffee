class @Directions
  constructor: ->
    @initGlobals()
    @traceRoute()

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
      console.log('click')
      $parent = $(@).parents('.routes')
      travelMode = $(@).data('travelMode')

      request =
        origin: new google.maps.LatLng(window.hotel.lat, window.hotel.lng)
        destination: new google.maps.LatLng($parent.data('lat'), $parent.data('lng'))
        travelMode: google.maps.TravelMode[travelMode]

      directionsService.route request, (response, status) ->
        if status == google.maps.DirectionsStatus.OK
          directionsDisplay.setDirections(response)
          directionsDisplay.setMap(map.getMap())
          directionsDisplay.setPanel document.getElementById("directions-panel")

      return