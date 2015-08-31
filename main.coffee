require "./lib/canvas-to-blob"

require "cornerstone"
Engine = require "./engine"

{width, height} = require "./pixie"

style = document.createElement "style"
style.innerHTML = require "./style"
document.head.appendChild style

Game = require "./game"

global.game = Game(ENV?.APP_STATE)
global.appData = game.toJSON

engine = Engine
  width: width
  height: height
  update: game.update
  draw: game.draw

engine.attachCanvasListeners(game)

document.body.appendChild engine.element()

document.addEventListener "keydown", (e) ->
  e.preventDefault()
  console.log e

  if e.keyCode is 112 # F1
    game.launchPixelEditor()
