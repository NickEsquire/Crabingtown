local UI = {}

function UI.show()
  local blankf = function() end
  
  for i = 0, 7 do
    windows.newWindow("a" .. i, 1, 928 + math.cos(math.rad(i * 45)) * 192, 508 + math.sin(math.rad(i * 45)) * 192, 64, 64, true, true, blankf, blankf, blankf, blankf)
    windows.newWindowObject("a" .. i, "base", 0, 0, 0, 64, 64, true, {{image = assets.images["arrow"], clr = {1, 1, 1, 0.5}, offsetX = 32, offsetY = 32, r = math.rad(i * 45), sx = 1, sy = 1, ox = 32, oy = 32}}, {}, function() if input.mouse[1].t == 1 then player.homeCrab.bait = i end end)
  end
end

function UI.hide()
  for i = 0, 7 do windows.deleteWindow("a" .. i) end
end

function UI.startScreen()
  local blankf = function() end
  
  windows.newWindow("startScreen", -1, 0, 0, 1920, 1080, true, true, blankf, blankf, blankf, blankf)
  
  windows.newWindowObject("startScreen", "base", 0, 0, 0, 1920, 1080, true, {{image = assets.images["blackPix"], clr = {1, 1, 1, 0.5}, offsetX = 0, offsetY = 0, r = 0, sx = 1920, sy = 1080, ox = 0, oy = 0}}, {}, blankf)
  windows.newWindowObject("startScreen", "start", 1, 0, 540, 472, 80, true, {}, {{text = "START", offsetX = 0, offsetY = 0, r = 0, sx = 8, sy = 8, ox = 0, oy = 0}}, function() if input.mouse[1].t == 1 then world.reset() UI.show() end end)
  windows.newWindowObject("startScreen", "quit", 2, 0, 740, 376, 80, true, {}, {{text = "QUIT", offsetX = 0, offsetY = 0, r = 0, sx = 8, sy = 8, ox = 0, oy = 0}}, function() if input.mouse[1].t == 1 then love.event.quit() end end)
  
  windows.newWindowObject("startScreen", "help", 3, 1920 - 800, 0, 0, 0, false, {}, {
      {text = "* LMB on arrows to bait your Crab", offsetX = 0, offsetY = 0, r = 0, sx = 2, sy = 2, ox = 0, oy = 0},
      {text = "towards arrow's direction", offsetX = 0, offsetY = 16 * 4, r = 0, sx = 2, sy = 2, ox = 0, oy = 0},
      {text = "* TAB to change target", offsetX = 0, offsetY = 16 * 8, r = 0, sx = 2, sy = 2, ox = 0, oy = 0},
      {text = "* 1 - Sling for 2 ppl", offsetX = 0, offsetY = 16 * 12, r = 0, sx = 2, sy = 2, ox = 0, oy = 0},
      {text = "* 2 - Bow for 5 ppl", offsetX = 0, offsetY = 16 * 16, r = 0, sx = 2, sy = 2, ox = 0, oy = 0},
      {text = "* 3 - Catapult for 10 ppl", offsetX = 0, offsetY = 16 * 20, r = 0, sx = 2, sy = 2, ox = 0, oy = 0},
      {text = "* 4 - Ballista for 12 ppl", offsetX = 0, offsetY = 16 * 24, r = 0, sx = 2, sy = 2, ox = 0, oy = 0},
      {text = "* 5 - Cannon for 20 ppl", offsetX = 0, offsetY = 16 * 28, r = 0, sx = 2, sy = 2, ox = 0, oy = 0},
      {text = "* 6 - Artillery for 40 ppl", offsetX = 0, offsetY = 16 * 32, r = 0, sx = 2, sy = 2, ox = 0, oy = 0},
      {text = "* 7 - Laser for 100 ppl", offsetX = 0, offsetY = 16 * 36, r = 0, sx = 2, sy = 2, ox = 0, oy = 0},
      {text = "* the more ppl you have -", offsetX = 0, offsetY = 16 * 44, r = 0, sx = 2, sy = 2, ox = 0, oy = 0},
      {text = "the larger population growth", offsetX = 0, offsetY = 16 * 48, r = 0, sx = 2, sy = 2, ox = 0, oy = 0},
      {text = "* If population reaches 0...", offsetX = 0, offsetY = 16 * 52, r = 0, sx = 2, sy = 2, ox = 0, oy = 0},
      {text = "- game over", offsetX = 0, offsetY = 16 * 56, r = 0, sx = 2, sy = 2, ox = 0, oy = 0},
      {text = "* P.S: 1 is also game over", offsetX = 0, offsetY = 16 * 64, r = 0, sx = 2, sy = 2, ox = 0, oy = 0}
      }, function() end)
end

function UI.endScreen()
  local blankf = function() end
  
  UI.hide()
  
  windows.newWindow("endScreen", -1, 0, 0, 1920, 1080, true, true, blankf, blankf, blankf, blankf)
  
  windows.newWindowObject("endScreen", "base", 0, 0, 0, 1920, 1080, true, {{image = assets.images["blackPix"], clr = {1, 1, 1, 0.75}, offsetX = 0, offsetY = 0, r = 0, sx = 1920, sy = 1080, ox = 0, oy = 0}}, {}, blankf)
  
  windows.newWindowObject("endScreen", "restart", 1, 794, 200, 332, 40, true, {}, {{text = "RESTART", offsetX = 0, offsetY = 0, r = 0, sx = 4, sy = 4, ox = 0, oy = 0}}, function() if input.mouse[1].t == 1 then world.reset() UI.show() end end)
  windows.newWindowObject("endScreen", "quit", 2, 866, 980, 188, 40, true, {}, {{text = "QUIT", offsetX = 0, offsetY = 0, r = 0, sx = 4, sy = 4, ox = 0, oy = 0}}, function() if input.mouse[1].t == 1 then love.event.quit() end end)
  
  table.insert(world.recordList, world.time)
  world.recordList = lume.sort(world.recordList, function(a, b) return a > b end)
  if #world.recordList > 20 then for i = 21, #world.recordList do world.recordList[i] = nil end end
  
  local scores = {}
  for i = 1, #world.recordList do
    scores[i] = {text = world.recordList[i], offsetX = 0, offsetY = i * 32 - 32, r = 0, sx = 2, sy = 2, ox = 0, oy = 0}
  end
  
  windows.newWindowObject("endScreen", "scores", 2, 898, 300, 0, 0, false, {}, scores, function() end)
  
  windows.newWindowObject("endScreen", "sorry", 2, 0, 1080 - 16, 0, 0, false, {}, {{text = "Didn't have time for balance, so there is none, whatsoever. Sorry.", offsetX = 0, offsetY = 0, r = 0, sx = 1, sy = 1, ox = 0, oy = 0}}, function() end)
end

return UI
