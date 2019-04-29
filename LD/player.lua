local player = {x = 0, y = 0, homeCrab = {people = 0}}

windows.newWindow("people", -1, 0, 16, 640, 32, true, false, function() end, function() end, function() end, function() end)
windows.newWindowObject("people", "base", 0, 0, 0, 0, 0, false, {}, {{text = "ppl:" .. 0, offsetX = 0, offsetY = 0, r = 0, sx = 2, sy = 2, ox = 0, oy = 0}}, function() end)

function player.update()
  if player.homeCrab.x ~= nil then
    windows.getWindow("people").objects["base"].texts[1].text = "ppl: " .. math.floor(player.homeCrab.people)
    
    if input.key["tab"] == 1 then player.homeCrab.target = player.homeCrab.target + 1 end

    if input.key["1"] == 1 then trading.trade(player.homeCrab, "sling") end
    if input.key["2"] == 1 then trading.trade(player.homeCrab, "bow") end
    if input.key["3"] == 1 then trading.trade(player.homeCrab, "catapult") end
    if input.key["4"] == 1 then trading.trade(player.homeCrab, "ballista") end
    if input.key["5"] == 1 then trading.trade(player.homeCrab, "cannon") end
    if input.key["6"] == 1 then trading.trade(player.homeCrab, "artillery") end
    if input.key["7"] == 1 then trading.trade(player.homeCrab, "laser") end

    if input.key["f1"] >= 1 then player.homeCrab.people = 1000 end
    
    world.camX = lume.lerp(world.camX, player.homeCrab.x - 960, 0.1)
    world.camY = lume.lerp(world.camY, player.homeCrab.y - 540, 0.1)
    
    if player.homeCrab.people <= 0 and not windows.getWindow("endScreen") then UI.endScreen() end
  end
end

function player.draw()

end

return player