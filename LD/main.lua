function love.load()
  love.window.setMode(1600, 900, {vsync = true, fullscreen = false})

	dimX, dimY = love.graphics.getDimensions()
	renX, renY = 1920, 1080
	renderScale = {x = dimX / renX, y = dimY / renY}

	globalRender = love.graphics.newCanvas(renX, renY)

	if success == true then dataFolder = "root/" else dataFolder = "" end

	lume = require("_lume")
  slam = require("_slam")

	input = require("input")
	algs = require("algs")
  windows = require("windows")
  
  assets = require("assets")
  
  UI = require ("UI")
  fx = require("fx")
  
	world = require("world")
  player = require("player")
  crabs = require("crabs")
  
  trading = require("trading")
  
  world.crabsLimit = 12
  UI.startScreen()
end

function love.update(dt)
  world.update()
  
  windows.update()
  
	input.update()
end

function love.draw()
  love.graphics.setCanvas(globalRender)
	love.graphics.clear(0.5, 0.5, 0.5, 1)
	love.graphics.push()
	love.graphics.translate(-math.floor(world.camX), -math.floor(world.camY))
  world.draw()
	love.graphics.pop()
  
  windows.draw()
  
	love.graphics.setCanvas()
  love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(globalRender, 0, 0, 0, renderScale.x, renderScale.y)
	love.graphics.print(love.timer.getFPS())
end

function love.quit()
end