$(document).on 'turbolinks:load', ->

  # set default checkbox on load page by availability checked="checked" for skip cache Firefox
  checkboxSub = '.question_box .subscribe'

  if $(checkboxSub).length
    if $(checkboxSub).attr('checked')
      $(checkboxSub).prop( "checked", true )
    else
      $(checkboxSub).prop( "checked", false )


  $('.question_box').on 'click', '.subscribe', (e) ->

    e.preventDefault()

    window.qnaToken = document.querySelector('[name="csrf-token"]').getAttribute('content')
    window.qnaQuestionId = $( ".question_box" ).data('questionId')
    window.qnaSubscribe = this

    if window.qnaSubscribe.checked
      $.ajax
        type: 'POST'
        url: '/subscriptions'
        data: question_id: window.qnaQuestionId
        headers: {
          'X-CSRF-Token': window.qnaToken
        }
        success: ->
          $(window.qnaSubscribe).attr( "checked", "checked" )
          $(window.qnaSubscribe).prop( "checked", true )
          return
    else
      $.ajax
        type: 'DELETE'
        url: '/subscriptions'
        data: question_id: window.qnaQuestionId
        headers: {
          'X-CSRF-Token': window.qnaToken
        }
        success: ->
          $(window.qnaSubscribe).attr( "checked", null )
          $(window.qnaSubscribe).prop( "checked", false )
          return

    return
  return
