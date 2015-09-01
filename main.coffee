require "./lib/canvas-to-blob"
require "./lib/keyboard"

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
  return if e.code is "F12" # Don't eat debugger

  e.preventDefault()
  console.log e

  if e.ctrlKey
    switch e.code
      when "KeyS"
        game.save()
  else
    switch e.code 
      when "F1"
        game.launchPixelEditor()
      when "KeyA"
        game.tileCol 10 
      when "KeyB"
        game.tileCol 11
      when "KeyC"
        game.tileCol 12
      when "KeyD"
        game.tileCol 13
      when "KeyE"
        game.tileCol 14
      when "KeyF"
        game.tileCol 15

  if 48 <= e.keyCode <= 57
    num = e.keyCode - 48
    if e.shiftKey
      game.tileRow num
    else
      game.tileCol num
