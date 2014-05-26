class Dashing.Reviews extends Dashing.Widget

  @accessor 'quote', ->
    "“#{@get('current_review')?.body}”"

  ready: ->
    @currentIndex = 0
    @reviewElem = $(@node).find('.review-container')
    @nextReview()
    @startCarousel()

  onData: (data) ->
    @currentIndex = 0

  startCarousel: ->
    setInterval(@nextReview, 8000)

  nextReview: =>
    reviews = @get('reviews')
    if reviews
      @reviewElem.fadeOut =>
        @currentIndex = (@currentIndex + 1) % reviews.length
        @set 'current_review', reviews[@currentIndex]
        @reviewElem.fadeIn()
