require "cornerstone"
Spritesheet = require "./spritesheet"

{width, height} = require "./pixie"

tileSize = 32

module.exports = (I={}, self=Model(I)) ->
  I.blocks ?= [{x: 4, y: 4, index: 0}]

  sheet = Spritesheet
    width: 512
    height: 512
    tileWidth: 32
    tileHeight: 32

  self.extend
    draw: (canvas) ->
      canvas.fill("#f00")

      I.blocks.forEach ({x, y, index}) ->
        sheet.draw canvas, index, x * tileSize, y * tileSize

    update: ->

    touch: ({x, y}) ->
      x = Math.floor x * width / tileSize
      y = Math.floor y * height / tileSize

      I.blocks.push {x: x, y: y, index: 0}
    move: ->
    release: ->

    launchPixelEditor: ->
      index = 0
      pixelEditor = window.open "http://www.danielx.net/pixel-editor", null, "width=800,height=600"

      window.addEventListener "message", (event) ->
        if event.source is pixelEditor
          data = event.data
          console.log data
          
          # TODO: Send existing image to pixel editor
          
          if data.status is "ready"
            pixelEditor.postMessage
              method: "resize"
              params: [{
                width: 32
                height: 32
              },
                sheet.getImageData(index)
              ]
            , "*"

            pixelEditor.postMessage
              method: "eval"
              params: [CoffeeScript.compile """
                self.actions.pop() # Remove old save

                self.resize
                  width: 32
                  height: 32

                self.on "change", ->
                  self.sendToParent self.canvas.context().getImageData(0, 0, 32, 32)
                  self.markClean()

              """, bare: true]
            , "*"
          
          else if data instanceof ImageData
            sheet.set(index, data)

  return self
