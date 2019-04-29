local world = {time = 0, camX = -960, camY = -540, crabsLimit = 1, recordList = {}, ost = false, tiles = {}}

for i = -1000, 1000 do
  world.tiles[i] = {}
  for j = -1000, 1000 do
    world.tiles[i][j] = math.ceil(algs.rand() * 16)
  end
end

world.ost = assets.sounds["Mixdown"]:play()
world.ost:pause()

function world.reset()
  for k, v in pairs(crabs.crabs) do
    crabs.remove(k)
  end
  
  for k, v in pairs(fx.vfx) do
    fx.vfx[k] = nil
  end
  
  for k, v in pairs(fx.sfx) do
    fx.sfx[k] = nil
  end
  
  world.time, world.camX, world.camY, world.crabsLimit = 0, -960, -540, 1
  
  player.homeCrab = crabs.add(0, 0)
  
  if windows.getWindow("startScreen") then windows.deleteWindow("startScreen") end
  if windows.getWindow("endScreen") then windows.deleteWindow("endScreen") end
  
  world.ost:stop()
  world.ost = assets.sounds["Mixdown"]:play()
  world.ost:setVolume(0.2)
  world.ost:setLooping(true)
end

local crabsProgression = {30, 60 * 10, 60 * 20, 60 * 30, 60 * 40, 60 * 50, 60 * 60, 60 * 70, 60 * 80, 60 * 90, 60 * 100, 60 * 110}

function world.update()
  if world.time >= crabsProgression[world.crabsLimit] then world.crabsLimit = world.crabsLimit + 1 if world.crabsLimit > #crabsProgression then world.crabsLimit = #crabsProgression end end
  
  if crabs.crabsTotal < world.crabsLimit then
    --[[ local rand, x, y = algs.rand()
    print(rand)
    if rand < 0.25 then
      x, y = player.homeCrab.x + 960 + 128, player.homeCrab.y - 540 + algs.rand() * 1080
    elseif rand < 0.5 then
      x, y = player.homeCrab.x - 960 + algs.rand() * 1920, player.homeCrab.y + 540 + 128
    elseif rand < 0.75 then
      x, y = player.homeCrab.x - 960 - 128, player.homeCrab.y - 540 + algs.rand() * 1080
    else
      x, y = player.homeCrab.x - 960 + algs.rand() * 1920, player.homeCrab.y - 540 - 128
    end ]]
    
    local free, crabsPlacement, x, y = false, {}
    for k, v in pairs(crabs.crabs) do
      crabsPlacement[#crabsPlacement + 1] = {x0 = v.x - 128, y0 = v.y - 128, x1 = v.x + 128, y1 = v.y + 128}
    end
    while free == false do
      free, x, y = true, world.camX + algs.rand() * 1920, world.camY + algs.rand() * 1080
      for k, v in pairs(crabsPlacement) do
        if algs.AABBvsAABB(x - 128, y - 128, x + 128, y + 128, v.x0, v.y0, v.x1, v.y1) then free = false break end
      end
    end
    
    crabs.add(x, y)
  end
  
  player.update()
  crabs.update()
  
  if input.key["lalt"] >= 1 then
    world.camX = world.camX + (input.mouse_x - 960) * 0.25
    world.camY = world.camY + (input.mouse_y - 540) * 0.25
  end
  
  world.time = world.time + 1
end

function world.draw()
  love.graphics.setColor(1, 1, 1, 1)
  
  for i = math.floor(world.camX / 128), math.floor(world.camX / 128) + 15 do
    for j = math.floor(world.camY / 128), math.floor(world.camY / 128) + 9 do
      love.graphics.draw(assets.images["terrain"], assets.quads["terrain" .. world.tiles[i][j]], i * 128, j * 128)
    end
  end
  
  player.draw()
  crabs.draw()
  
  fx.draw()
end

return world