Data = require "./data"

module.exports = (I={}, self=Model(I)) ->
  defaults I,
    width: 32
    height: 18
    name: "resources/room0"

  view = null

  data = Data()
  data.getBuffer(I.name)
  .then (buffer) ->
    view = new Uint8Array(buffer)
  .done()

  self =
    get: (x, y) ->
      if 0 <= y < I.height
        if 0 <= x < I.width
          view?[y * I.width + x]

    set: (x, y, value) ->
      if 0 <= y < I.height
        if 0 <= x < I.width
          view?[y * I.width + x] = value

    each: (fn) ->
      I.height.times (y)->
        I.width.times (x) ->
          fn(x, y, self.get(x, y))

    save: ->
      data.upload I.name, new Blob [view], type: "application/octet-stream"
