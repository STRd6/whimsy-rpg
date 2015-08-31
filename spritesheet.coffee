Sprite = require "sprite"
Data = require "./data"

module.exports = (I={}) ->
  defaults I,
    width: 512
    height: 512
    tileWidth: 32
    tileHeight: 32
    name: "resources/sheet0.png"

  data = Data()

  spriteSource = document.createElement "canvas"
  spriteSource.width = I.width
  spriteSource.height = I.height

  updating = true
  shouldUpdate = false
  updateImage = ->
    if updating
      shouldUpdate = true
      return

    updating = true

    spriteSource.toBlob (blob) ->
      data.upload I.name, blob
      .finally ->
        updating = false
        if shouldUpdate
          shouldUpdate = false
          updateImage()
      .done()
  
  ctx = spriteSource.getContext("2d")

  data.getImage(I.name)
  .then (img) ->
    ctx.drawImage(img, 0, 0)
    updating = false
    shouldUpdate = false
  .done()

  sprites = [0..15].map (n) ->
    Sprite(spriteSource, n * I.tileWidth, 0, I.tileWidth, I.tileHeight)

  draw: (canvas, index, x, y) ->
    sprites[index].draw canvas, x, y

  set: (index, data) ->
    # TODO: Find the right place
    x = index * I.tileWidth
    y = 0

    ctx.putImageData(data, x, y)

    updateImage()

  getImageData: (index) ->
    # TODO: y values
    x = index * I.tileWidth
    y = 0

    ctx.getImageData(x, y, I.tileWidth, I.tileHeight)