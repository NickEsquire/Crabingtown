local fx = {vfx = {}, sfx = {}, effects = {}}

fx.effects["light"] = {img = assets.images["light"], ofx = -12, ofy = -256, time = 40}
fx.effects["sacrifice"] = {img = assets.images["sacrifice"], ofx = -12, ofy = -32, time = 40, up = true}

fx.effects["ssling"] = {img = assets.images["shotSling"], ofx = -12, ofy = -12, time = 20, quad = "shotSling"}
fx.effects["sbow"] = {img = assets.images["shotBow"], ofx = -12, ofy = -12, time = 20, quad = "shotBow"}
fx.effects["scatapult"] = {img = assets.images["shotCatapult"], ofx = -12, ofy = -12, time = 20, quad = "shotCatapult"}
fx.effects["sballista"] = {img = assets.images["shotBallista"], ofx = -12, ofy = -12, time = 20, quad = "shotBallista"}
fx.effects["scannon"] = {img = assets.images["shotCannon"], ofx = -12, ofy = -12, time = 20, quad = "shotCannon"}
fx.effects["sartillery"] = {img = assets.images["shotArtillery"], ofx = -12, ofy = -12, time = 20, quad = "shotArtillery"}
fx.effects["slaser"] = {img = assets.images["shotLaser"], ofx = -12, ofy = -12, time = 20, quad = "shotLaser"}

fx.effects["hsling"] = {img = assets.images["hitSling"], ofx = -12, ofy = -12, time = 20, quad = "hitSling"}
fx.effects["hbow"] = {img = assets.images["hitBow"], ofx = -12, ofy = -12, time = 20, quad = "hitBow"}
fx.effects["hcatapult"] = {img = assets.images["hitCatapult"], ofx = -12, ofy = -12, time = 20, quad = "hitCatapult"}
fx.effects["hballista"] = {img = assets.images["hitBallista"], ofx = -12, ofy = -12, time = 20, quad = "hitBallista"}
fx.effects["hcannon"] = {img = assets.images["hitCannon"], ofx = -12, ofy = -12, time = 20, quad = "hitCannon"}
fx.effects["hartillery"] = {img = assets.images["hitArtillery"], ofx = -12, ofy = -12, time = 20, quad = "hitArtillery"}
fx.effects["hlaser"] = {img = assets.images["hitLaser"], ofx = -12, ofy = -12, time = 20, quad = "hitLaser"}

function fx.add(x, y, r, effect, delay, anchor)
  local vfx = {}
  
  vfx.x = x + fx.effects[effect].ofx
  vfx.y = y + fx.effects[effect].ofy
  vfx.r = r
  vfx.time = fx.effects[effect].time
  vfx.delay = delay
  vfx.img = fx.effects[effect].img
  vfx.up = fx.effects[effect].up
  vfx.quad = fx.effects[effect].quad
  if anchor ~= nil then vfx.anchor = anchor end
  
  fx.vfx[vfx] = vfx
end

function fx.draw()
  for k, v in pairs(fx.vfx) do
    if v.delay > 0 then
      v.delay = v.delay - 1
    elseif v.time > 0 then
      if v.anchor ~= nil then
        if v.up then v.y = v.y - 4 if v.sacsnd == nil then local sfx = assets.sounds["sacrifice"]:play() sfx:setPitch(0.95 + algs.rand() * 0.1) sfx:setVolume(0.5) v.sacsnd = true end end
        love.graphics.draw(v.img, v.x + v.anchor.x, v.y + v.anchor.y)
      elseif v.quad ~= nil then
        love.graphics.draw(v.img, assets.quads[v.quad .. 5 - math.floor(v.time / 5)], v.x, v.y, v.r)
      else
        love.graphics.draw(v.img, v.x, v.y, v.r)
      end
      
      v.time = v.time - 1
    else
      fx.vfx[k] = nil
    end
  end
end

return fx