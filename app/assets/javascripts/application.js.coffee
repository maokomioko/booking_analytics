#= require jquery2
#= require jquery.turbolinks
#= require turbolinks

#= require jquery_ujs
#= require jquery.remotipart

#= require_tree .

ready = ->
  $("#calendar").mCustomScrollbar
    theme: "dark"


$(document).ready(ready)
