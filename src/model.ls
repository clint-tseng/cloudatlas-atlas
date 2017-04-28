{ Model, attribute, from, List } = require(\janus)
{ width-of } = require('./util')
$ = require(\jquery)

class Global extends Model
  shadow: -> this

class Atlas extends Model
  @attribute(\stories, class extends attribute.CollectionAttribute
    default: -> new Stories([ new Story({ id, atlas: this.model }) for id from 1 to 6 ])
  )

  @bind(\frame_count, from(\scenes).flatMap (.watchAt(-1).flatMap (.watch(\frame_end))))
  @bind(\window_width, from(width-of($('body'))))
  @bind(\scaling_factor, from(\frame_count).and(\window_width).all.map (/))

class Story extends Model
  @bind(\scenes, from(\atlas).watch(\scenes).and(\id).all.flatMap((all-scenes, id) ->
    all-scenes.filter (.watch(\story).map (is id))
  ))

class Stories extends List
  @model-class = Story

class Scene extends Model

class Scenes extends List
  @model-class = Scene

class Actor extends Model


module.exports = { Global, Atlas, Story, Stories, Scene, Scenes, Actor }

