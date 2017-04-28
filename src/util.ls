{ Varying } = require(\janus)
$ = require(\jquery)

module.exports = {
  width-of: (elem) ->
    result = new Varying()
    update = -> result.set(elem.width())
    $(window).on(\resize, update)
    update()
    result
}

