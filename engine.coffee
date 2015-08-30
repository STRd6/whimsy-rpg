TouchCanvas = require "touch-canvas"

module.exports = ({update, draw, width, height}) ->
  dt = 1/60

  canvas = TouchCanvas
    width: width
    height: height

  step = (timestamp) ->
    try
      update(dt)
    catch e
      console.error e

    try
      draw(canvas)
    catch e
      console.error e

    window.requestAnimationFrame step

  window.requestAnimationFrame step

  element = document.createElement "div"
  element.className = "engine"
  element.appendChild canvas.element()

  element: ->
    element

  attachCanvasListeners: (receiver) ->
    canvas.on "touch", receiver.touch
    canvas.on "move", receiver.move
    canvas.on "release", receiver.release
