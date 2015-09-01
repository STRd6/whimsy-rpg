require "cornerstone"
Room = require "./room"
Spritesheet = require "./spritesheet"

{width, height} = require "./pixie"
{line} = require "./util"

tileSize = 32

module.exports = (I={}, self=Model(I)) ->
  defaults I,
    activeIndex: 0

  room = Room()

  sheet = Spritesheet
    width: 512
    height: 512
    tileWidth: 32
    tileHeight: 32

  self.attrAccessor "activeIndex"

  previous = null

  self.extend
    draw: (canvas) ->
      room.each (x, y, index) ->
        sheet.draw canvas, index, x * tileSize, y * tileSize

    save: ->
      sheet.save()
      room.save()

    update: ->

    touch: ({x, y}) ->
      x = Math.floor x * width / tileSize
      y = Math.floor y * height / tileSize

      room.set x, y, self.activeIndex()

      previous = {x, y}

    move: ({x, y}) ->
      x = Math.floor x * width / tileSize
      y = Math.floor y * height / tileSize

      current = {x, y}

      line previous, current, (x, y) ->
        room.set x, y, self.activeIndex()

      previous = current

    release: ->

    launchPixelEditor: ->
      index = self.activeIndex()
      pixelEditor = window.open "http://www.danielx.net/pixel-editor", null, "width=800,height=600"

      window.addEventListener "message", (event) ->
        if event.source is pixelEditor
          data = event.data
          console.log data

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
