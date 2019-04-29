local crabs = {crabs = {}, crabsTotal = 0}

local a45, a22p5 = math.pi / 4, math.pi / 8

local newLvl = {10, 20, 40, 80, 160, 320, 640}

local slightAnim = {0.025, 0.05, 0.1, 0.075, 0.025, -0.075, -0.025}

local weapons = {"sling", "bow", "catapult", "ballista", "cannon", "artillery", "laser"}

local buyingSequence = {}
buyingSequence[1] = {1, 2, 3, 4, 5, 6, 7}
buyingSequence[2] = {1}
buyingSequence[3] = {1, 1, 1, 2, 3, 3, 3, 4, 5, 6, 6, 6, 7}
buyingSequence[4] = {1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7}
buyingSequence[5] = {1, 2, 3}
buyingSequence[6] = {1, 1, 1, 2}
buyingSequence[7] = {1, 1, 1, 2, 7}
buyingSequence[8] = {1, 2, 4, 6}
buyingSequence[9] = {2}
buyingSequence[10] = {}
buyingSequence[12] = {}
buyingSequence[13] = {}
buyingSequence[14] = {}
buyingSequence[15] = {}
buyingSequence[16] = {}

function crabs.add(x, y)
  local crab = {}
  
  crab.x = x
  crab.y = y
  crab.angle = 0
  crab.velocityX = 0
  crab.velocityY = 0
  
  crab.level = 1
  crab.range = 640
  
  crab.speed = 1
  crab.steps = 0
  crab.timer = 100
  crab.cangle = -1
  
  crab.bait = 0
  
  crab.targets = {}
  crab.target = 1
  
  crab.people = 5 + world.crabsLimit * world.crabsLimit * 0.5
  
  crab.weapons = {}
  
  crab.buyingSequence = buyingSequence[math.floor(algs.rand() * 8) + 1]
  crab.buyingStep = 1
  crab.buyingUrge = 0
  
  crab.animBody = math.floor(algs.rand() * 7) + 1
  crab.animPincerbig = math.floor(algs.rand() * 7) + 1
  crab.animPincersmall = math.floor(algs.rand() * 7) + 1
  crab.animBacklegs = math.floor(algs.rand() * 7) + 1
  crab.animLegs = {1, 3, 5, 7}
  
  crabs.crabs[crab] = crab
  
  crabs.crabsTotal = crabs.crabsTotal + 1
  
  return crab
end

function crabs.remove(crab)
  crabs.crabs[crab] = nil
  crabs.crabsTotal = crabs.crabsTotal - 1
end

function crabs.update()
  for k, v in pairs(crabs.crabs) do
    if algs.AABBvsAABB(world.camX, world.camY, world.camX + 1920, world.camY + 1080, v.x - 256, v.y - 256, v.x + 256, v.y + 256) then
      -- Crab movement (unconditional)
      if v.timer == 0 then
        v.timer = -1
        v.steps = math.floor(algs.rand() * 100) + 100
        if v.cangle == -1 then
          if k == player.homeCrab then
            v.angle = v.bait * a45
          else
            v.bait = math.floor(algs.rand() * 7)
            v.angle = v.bait * a45
          end
        else
          v.angle = v.cangle v.cangle = -1
        end
        v.velocityX = math.cos(v.angle) * v.speed
        v.velocityY = math.sin(v.angle) * v.speed
      elseif v.timer > 0 then
        v.timer = v.timer - 1
      else
        if v.steps > 0 then
          v.x = v.x + v.velocityX
          v.y = v.y + v.velocityY
          v.steps = v.steps - 1
          for kt, vt in pairs(crabs.crabs) do
            if k ~= kt then
              if algs.AABBvsAABB(v.x - 128, v.y - 128, v.x + 128, v.y + 128, vt.x - 128, vt.y - 128, vt.x + 128, vt.y + 128) then
                local dist = algs.dist(v.x, v.y, vt.x, vt.y)
                if dist < 256 then
                  dist = 256 - dist
                  local cangle = algs.angleTo(v.x, v.y, vt.x, vt.y)
                  if v.people <= 0 or player.homeCrab.people <= 0 then v.cangle = cangle + math.rad(135) + algs.rand() * math.rad(90) end
                  v.x = v.x + math.cos(cangle + math.pi) * (dist / 2)
                  v.y = v.y + math.sin(cangle + math.pi) * (dist / 2)
                  v.timer = v.steps
                  v.steps = 0
                  if vt.people <= 0 or player.homeCrab.people <= 0 then vt.cangle = cangle - math.rad(45) + algs.rand() * math.rad(90) end
                  vt.x = vt.x + math.cos(cangle) * (dist / 2)
                  vt.y = vt.y + math.sin(cangle) * (dist / 2)
                  vt.timer = vt.steps
                  vt.steps = 0
                end
              end
            end
          end
        else
          v.steps = -1
          v.timer = math.floor(algs.rand() * 100) + 100
        end
      end
      
      if v.people > 0 then
        -- Population increment
        if v.people >= 2 then v.people = v.people + 0.005 + (v.people / 1000) end
        
        -- Check population for growing up
        if v.level < 8 and v.people >= newLvl[v.level] then v.level = v.level + 1 end
        
        -- Collect enemies in range
        v.targets = {}
        for kt, vt in pairs(crabs.crabs) do
          if k ~= kt and vt.people > 0 and algs.dist(v.x, v.y, vt.x, vt.y) < v.range then
            if kt == player.homeCrab then
              v.targets = {}
              table.insert(v.targets, vt)
              break
            else
              table.insert(v.targets, vt)
            end
          end
        end
        
        -- AI buying algorithm
        if k ~= player.homeCrab then
          if v.people >= trading.items[weapons[v.buyingSequence[v.buyingStep]]].prc + 2 then v.buyingUrge = v.buyingUrge + 0.00001 end
          
          if algs.rand() < v.buyingUrge and trading.trade(v, weapons[v.buyingSequence[v.buyingStep]]) then
            v.buyingUrge = 0
            if v.buyingStep < #v.buyingSequence then v.buyingStep = v.buyingStep + 1 end
          end
        end
        
        -- Fire weapons if reloaded at chosen target
        if #v.targets > 0 then
          if v.target > #v.targets then v.target = 1 end
          
          local angle = algs.angleTo(v.x, v.y, v.targets[v.target].x, v.targets[v.target].y)
          
          for kw, vw in pairs(v.weapons) do
            if v.targets[v.target].people > 0 then
              if vw.cld <= 0 then
                v.targets[v.target].people = v.targets[v.target].people - vw.dmg
                vw.cld = vw.cld + vw.rof * (1 + algs.rand() / 5)
                
                local ang = angle - 0.25 + algs.rand() * 0.5
                
                fx.add(v.x + math.cos(ang) * 64, v.y + math.sin(ang) * 64, angle, "s" .. vw.nam, 0)
                fx.add(v.targets[v.target].x - 64 + algs.rand() * 128, v.targets[v.target].y - 64 + algs.rand() * 128, angle + math.pi, "h".. vw.nam, 4)
                
                if player.homeCrab.people > 0 then
                  local dist = math.abs(v.x - player.homeCrab.x) + math.abs(v.y - player.homeCrab.y)
                  
                  if dist <= 1000 then
                    local hit, sfx = assets.sounds["hit"]:play()
                    hit:setVolume(1 - (dist / 1000))
                    
                    if vw.nam == "sling" then sfx = assets.sounds["shotSling"]:play() end
                    if vw.nam == "bow" then sfx = assets.sounds["shotBow"]:play() end
                    if vw.nam == "catapult" then sfx = assets.sounds["shotCatapult"]:play() end
                    if vw.nam == "ballista" then sfx = assets.sounds["shotBallista"]:play() end
                    if vw.nam == "cannon" then sfx = assets.sounds["shotCannon"]:play() end
                    if vw.nam == "artillery" then sfx = assets.sounds["shotArtillery"]:play() end
                    if vw.nam == "laser" then sfx = assets.sounds["shotLaser"]:play() end
                    
                    sfx:setVolume(1 - (dist / 1000))
                  end
                end
              end
            else
              break
            end
          end
        end
        
        -- Reloading weapons
        for kw, vw in pairs(v.weapons) do
          if vw.cld > 0 then vw.cld = vw.cld - 1 elseif vw.cld < 0 then vw.cld = 0 end
        end
      else
        crabs.remove(k)
      end
    else
      crabs.remove(k)
    end
  end
end

function crabs.draw()
  for k, v in pairs(crabs.crabs) do
    love.graphics.draw(assets.images["crabShadow"], v.x - 390, v.y - 310)
  end
  
  for k, v in pairs(crabs.crabs) do
    love.graphics.draw(assets.images["crabBacklegs"], v.x + 10, v.y - 113, slightAnim[math.floor(v.animBacklegs)] * 0.1, 1, 1, 210, 62)
    
    if v.animBacklegs < 7.75 then v.animBacklegs = v.animBacklegs + 0.25 else v.animBacklegs = 1 end
    
    love.graphics.draw(assets.images["crabLegl"], assets.quads["crabLegl" .. math.floor(v.animLegs[1])], v.x - 110, v.y - 50, 0.5, 1, 1, 121, 32)
    love.graphics.draw(assets.images["crabLegl"], assets.quads["crabLegl" .. math.floor(v.animLegs[3])], v.x - 110, v.y - 25, 0.25, 1, 1, 121, 32)
    love.graphics.draw(assets.images["crabLegr"], assets.quads["crabLegr" .. math.floor(v.animLegs[2])], v.x + 110, v.y - 50, -0.5, 1, 1, 17, 32)
    love.graphics.draw(assets.images["crabLegr"], assets.quads["crabLegr" .. math.floor(v.animLegs[4])], v.x + 110, v.y - 25, -0.25, 1, 1, 17, 32)
    
    if v.steps > 0 then
      for i = 1, 4 do
        if v.animLegs[i] < 9.75 then v.animLegs[i] = v.animLegs[i] + 0.25 else v.animLegs[i] = 1 end
      end
    end
    
    love.graphics.draw(assets.images["crabPincersmall"], v.x + 55, v.y - 1, slightAnim[math.floor(v.animPincersmall)], 1, 1, 56, 21)
    love.graphics.draw(assets.images["crabPincerbig"], v.x - 75, v.y - 1, slightAnim[math.floor(v.animPincerbig)], 1, 1, 75, 7)
    
    if v.timer > 0 then
      if v.animPincersmall < 7.75 then v.animPincersmall = v.animPincersmall + 0.25 else v.animPincersmall = 1 end
      if v.animPincerbig < 7.75 then v.animPincerbig = v.animPincerbig + 0.25 else v.animPincerbig = 1 end
    end
    
    love.graphics.draw(assets.images["crabBody"], v.x, v.y - 40, slightAnim[math.floor(v.animBody)] * 0.2, 1, 1, 130, 90)
    
    if v.animBody < 7.75 then v.animBody = v.animBody + 0.25 else v.animBody = 1 end
    
    love.graphics.draw(assets.images["lvl" .. v.level], v.x, v.y - 40, slightAnim[math.floor(v.animBody)] * 0.2, 1, 1, 130, 90)
  end
  
  if player.homeCrab.x ~= nil then
    local target = player.homeCrab.targets[player.homeCrab.target]
    if target ~= nil then
      love.graphics.setColor(1, 0, 0, 1)
      love.graphics.rectangle("line", target.x - 128, target.y - 128, 256, 256)
      love.graphics.setColor(1, 1, 1, 1)
    end
  end
end

return crabs