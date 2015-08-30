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
