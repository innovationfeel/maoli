ready = ->
  $('.carousel').carousel()

  $('#header .nav-toggle').on 'click', ->
    $(this).toggleClass('on')
    toggleMenu('#header .xs-main-menu')
    return false
    
  $('.scroll').click ->
    if $(this).hasClass('xs-menu-link')
      hideMainMenu()
    $('html, body').animate {
      scrollTop: $('#' + $(this).attr('target')).offset().top
    }, 700
    return false


#   allImages = ''
#   i = 0
#   while i < 5
#     width  = getRandomSize(200, 400)
#     height = getRandomSize(200, 400)
#     allImages += '<img src="https://placekitten.com/' + width + '/' + height + '" alt="pretty kitty">'
#     i++
#   $('#').append(allImages)
#
#
# getRandomSize = (min, max) ->
#   Math.round Math.random() * (max - min) + min

toggleMenu = (menu) ->
  currentMarginRight = $(menu).css('margin-right')
  console.log(currentMarginRight)
  if currentMarginRight == '0px'
    newMarginRight = '-100%'
    $('#projects-screen').show()
    $('#about-us-screen').show()
    $('#contact-us-screen').show()
    $('#show-project').show()
  else
    newMarginRight = '0'
    $('#projects-screen').hide()
    $('#about-us-screen').hide()
    $('#contact-us-screen').hide()
    $('#show-project').hide()
  $(menu).animate({'margin-right': newMarginRight})

hideMainMenu = ->
  $('#projects-screen').show()
  $('#about-us-screen').show()
  $('#contact-us-screen').show()
  $('#header .nav-toggle').removeClass('on')
  $('#header .xs-main-menu').animate({'margin-right': '-100%'})

# Because of the turbolinks
$(document).ready(ready)
$(document).on('page:load', ready)
