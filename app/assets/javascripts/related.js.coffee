class @Related
  constructor: ->
    @deleteRelated()
    @addRelated()
    @relatedPartnersUpdate()
    Related.initSelect2RelatedSearch()
    Related.initMap()

  deleteRelated: ->
    $('body').on 'click', '.remove-related', -> blockRowElement $(@).parents('tr')

  addRelated: ->
    $('body').on 'submit.rails', '.add-related-form', ->
      blockElement($('[data-partial="related_hotels"]'))

  relatedPartnersUpdate: ->
    $(document).on 'ajax:success', '.bulk-overbooking', ->
      blockRowElement $(@).parents('tr')
      $(@).parent().find('.bulk-overbooking.hidden').removeClass('hidden')
      $(@).addClass('hidden')
      unblockRowElement $(@).parents('tr')

  @initSelect2RelatedSearch: ->
    $select = $('#add_related_select2')

    $select.select2
      placeholder: $('[data-message="related_search_prompt"]').text()
      multiple: true
      containerCss:
        width: '100%'
      ajax:
        url: $select.data('url')
        dataType: 'json'
        quietMillis: 250
        data: (term, page) -> { q: term }
        results: (data, page) ->
          { results: data }

    return

  @initMap: ->
    window.map = Gmaps.build('Google')

    map.buildMap { provider: {}, internal: {id: 'map'}}, ->
      map.getMap().setZoom(16)
      map.getMap().setCenter(new google.maps.LatLng(gon.hotel.lat, gon.hotel.lng))

      map.addMarker
        lat: gon.hotel.lat
        lng: gon.hotel.lng
        marker_title: gon.hotel.title
        picture:
          url: 'http://maps.google.com/mapfiles/kml/paddle/blu-stars.png'
          width: 64
          height: 64

      related_ids = $.map $('.related-hotels-table').find('tr[data-hotel-id]'), (el) ->
        $(el).data('hotelId')

      $.getJSON '/hotels/markers', { booking_ids: related_ids }, (jsonData) ->
        markers = map.addMarkers(jsonData)
        map.bounds.extendWith(markers)
