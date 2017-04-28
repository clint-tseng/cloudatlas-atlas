{ DomView, template, find, from } = require(\janus)
$ = require(\jquery)

{ Atlas, Story, Scene } = require('./model')

px = (x) -> "#{x}px"

class TimelineView extends DomView
  @_dom = -> $('
    <div class="timeline">
      <div class="timeline-mini">
        <div class="ticks"/>
        <div class="control"/>
        <div class="stories"/>
      </div>
      <div class="timeline-main">
        <div class="stories"/>
      </div>
    </div>
  ')
  @_template = template(
    find('.timeline-mini .stories').render(from(\stories))
    find('.timeline-main .stories').render(from(\stories))
  )

class StoryView extends DomView
  @_dom = -> $('
    <div class="story">
      <div class="story-blocks"/>
    </div>
  ')

  @_template = template(
    find('.story').attr(\id, from(\id).map(-> "story-#it"))
    find('.story-blocks').render(from(\scenes)).options( renderItem: (.context(\block)) )
  )

class Block extends DomView
  @_dom = -> $('<div class="block"/>')
  @_template = template(
    find('.block').css(\left, from(\frame_start).and.app().watch(\global).watch(\atlas).watch(\scaling_factor).all.map ((/) >> px))
    find('.block').css(\width, from(\frame_length).and.app().watch(\global).watch(\atlas).watch(\scaling_factor).all.map (/))
  )

module.exports = {
  TimelineView
  StoryView

  registerWith: (library) ->
    library.register(Atlas, TimelineView)
    library.register(Story, StoryView)
    library.register(Scene, Block, context: \block )
}

