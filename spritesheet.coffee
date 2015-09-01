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

  ctx = spriteSource.getContext("2d")

  data.getImage(I.name)
  .then (img) ->
    ctx.drawImage(img, 0, 0)
  .done()

  self =
    save: ->
      spriteSource.toBlob (blob) ->
        data.upload I.name, blob
        .done()
  
    draw: (canvas, index, x, y) ->
      {x:sx, y:sy} = self.tilePosition(index)

      canvas.drawImage spriteSource, sx, sy, I.tileWidth, I.tileHeight, x, y, I.tileWidth, I.tileHeight

    drawSource: (canvas, x, y) ->
      canvas.drawImage spriteSource, x, y
  
    tilePosition: (index) ->
      x: index % 16 * I.tileWidth
      y: Math.floor(index / 16) * I.tileHeight
  
    set: (index, data) ->
      {x, y} = self.tilePosition(index)
  
      ctx.putImageData(data, x, y)
  
    getImageData: (index) ->
      {x, y} = self.tilePosition(index)
  
      ctx.getImageData(x, y, I.tileWidth, I.tileHeight)
