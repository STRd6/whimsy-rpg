require "cornerstone"

{width, height} = require "./pixie"

module.exports = (I={}, self=Model(I)) ->
  I.blocks ?= [{x: 128, y: 128}]
  
  self.extend
    draw: (canvas) ->
      canvas.fill("#f00")
      I.blocks.forEach ({x, y}) ->
        canvas.drawRect
          x: x
          y: y
          width: 32
          height: 32
          color: "blue"

    update: ->

    touch: ({x, y}) ->
      I.blocks.push {x: x * width, y: y * height}

    move: ->
    release: ->

  return self
