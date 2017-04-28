
# get jquery, wait for ready.
<- ($ = window.jQuery = window.$ = require(\jquery))

# basic requires.
{ Library, App } = require(\janus).application
stdlib = require(\janus-stdlib)
{ Global, Atlas, Scenes } = require('./model')

# basic app setup.
views = new Library()
stdlib.view.registerWith(views)
require('./view').registerWith(views)
global = new Global()
app = new App({ views, global })

# get and load data.
(scenes) <- $.getJSON('/data/json/scenes.json')
atlas = window.atlas = new Atlas( scenes: Scenes.deserialize(scenes) )
global.set(\atlas, atlas)

# render main view.
timeline = app.getView(atlas)
$('#timeline').append(timeline.artifact())
timeline.wireEvents()

