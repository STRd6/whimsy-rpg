Sprite = require "sprite"

module.exports = (I={}) ->
  defaults I,
    width: 512
    height: 512
    tileWidth: 32
    tileHeight: 32

  spriteSource = document.createElement "canvas"
  spriteSource.width = I.width
  spriteSource.height = I.height

  ctx = spriteSource.getContext("2d")
  ctx.fillStyle = "#0ff"
  ctx.fillRect(0, 0, I.width, I.height)

  sprites = [0..15].map (n) ->
    Sprite(spriteSource, n * I.tileWidth, 0, I.tileWidth, I.tileHeight)

  draw: (canvas, index, x, y) ->
    sprites[index].draw canvas, x, y

  set: (index, data) ->
    # TODO: Find the right place
    x = index * I.tileWidth
    y = 0

    ctx.putImageData(data, x, y)

  getImageData: (index) ->
    # TODO: 
    x = index * I.tileWidth
    y = 0

    ctx.getImageData(x, y, I.tileWidth, I.tileHeight)
