local assets = {images = {}, meshes = {}, quads = {}, sounds = {}, fonts = {}}

assets.fonts["ps2p"] = love.graphics.newFont(dataFolder .. "PressStart2P-Regular.ttf")
assets.fonts["ps2p"]:setFilter("nearest", "nearest", 1)
love.graphics.setFont(assets.fonts["ps2p"])

assets.images["blackPix"] = love.graphics.newImage(dataFolder .. "blackPix.png")

assets.images["arrow"] = love.graphics.newImage(dataFolder .. "arrow.png")

assets.images["terrain"] = love.graphics.newImage(dataFolder .. "terrain.png")
local sw, sh = assets.images["terrain"]:getDimensions()
for i = 1, 4 do
  for j = 1, 4 do
    assets.quads["terrain" .. i * 4 - 4 + j] = love.graphics.newQuad(i * 128 - 128, j * 128 - 128, 128, 128, sw, sh)
  end
end

assets.images["crabBody"] = love.graphics.newImage(dataFolder .. "crabBody.png")
assets.images["crabBacklegs"] = love.graphics.newImage(dataFolder .. "crabBacklegs.png")
assets.images["crabPincerbig"] = love.graphics.newImage(dataFolder .. "crabPincerbig.png")
assets.images["crabPincersmall"] = love.graphics.newImage(dataFolder .. "crabPincersmall.png")

assets.images["crabShadow"] = love.graphics.newImage(dataFolder .. "crabShadow.png")

assets.images["crabLegl"] = love.graphics.newImage(dataFolder .. "crabLegl.png")
local sw, sh = assets.images["crabLegl"]:getDimensions()
for i = 1, 9 do
  assets.quads["crabLegl" .. i] = love.graphics.newQuad(i * 135 - 135, 0, 135, 170, sw, sh)
end

assets.images["crabLegr"] = love.graphics.newImage(dataFolder .. "crabLegr.png")
local sw, sh = assets.images["crabLegr"]:getDimensions()
for i = 1, 9 do
  assets.quads["crabLegr" .. i] = love.graphics.newQuad(i * 135 - 135, 0, 135, 170, sw, sh)
end


assets.images["light"] = love.graphics.newImage(dataFolder .. "light.png")
assets.images["sacrifice"] = love.graphics.newImage(dataFolder .. "sacrifice.png")

assets.images["shotSling"] = love.graphics.newImage(dataFolder .. "shotSling.png")
local sw, sh = assets.images["shotSling"]:getDimensions()
for i = 1, 5 do
  assets.quads["shotSling" .. i] = love.graphics.newQuad(i * 24 - 24, 0, 24, 24, sw, sh)
end

assets.images["shotBow"] = love.graphics.newImage(dataFolder .. "shotBow.png")
local sw, sh = assets.images["shotBow"]:getDimensions()
for i = 1, 5 do
  assets.quads["shotBow" .. i] = love.graphics.newQuad(i * 24 - 24, 0, 24, 24, sw, sh)
end

assets.images["shotCatapult"] = love.graphics.newImage(dataFolder .. "shotCatapult.png")
local sw, sh = assets.images["shotCatapult"]:getDimensions()
for i = 1, 5 do
  assets.quads["shotCatapult" .. i] = love.graphics.newQuad(i * 24 - 24, 0, 24, 24, sw, sh)
end

assets.images["shotBallista"] = love.graphics.newImage(dataFolder .. "shotBallista.png")
local sw, sh = assets.images["shotBallista"]:getDimensions()
for i = 1, 5 do
  assets.quads["shotBallista" .. i] = love.graphics.newQuad(i * 24 - 24, 0, 24, 24, sw, sh)
end

assets.images["shotCannon"] = love.graphics.newImage(dataFolder .. "shotCannon.png")
local sw, sh = assets.images["shotCannon"]:getDimensions()
for i = 1, 5 do
  assets.quads["shotCannon" .. i] = love.graphics.newQuad(i * 24 - 24, 0, 24, 24, sw, sh)
end

assets.images["shotArtillery"] = love.graphics.newImage(dataFolder .. "shotArtillery.png")
local sw, sh = assets.images["shotArtillery"]:getDimensions()
for i = 1, 5 do
  assets.quads["shotArtillery" .. i] = love.graphics.newQuad(i * 24 - 24, 0, 24, 24, sw, sh)
end

assets.images["shotLaser"] = love.graphics.newImage(dataFolder .. "shotLaser.png")
local sw, sh = assets.images["shotLaser"]:getDimensions()
for i = 1, 5 do
  assets.quads["shotLaser" .. i] = love.graphics.newQuad(i * 24 - 24, 0, 24, 24, sw, sh)
end

assets.images["hitSling"] = love.graphics.newImage(dataFolder .. "hitSling.png")
local sw, sh = assets.images["hitSling"]:getDimensions()
for i = 1, 5 do
  assets.quads["hitSling" .. i] = love.graphics.newQuad(i * 24 - 24, 0, 24, 24, sw, sh)
end

assets.images["hitBow"] = love.graphics.newImage(dataFolder .. "hitBow.png")
local sw, sh = assets.images["hitBow"]:getDimensions()
for i = 1, 5 do
  assets.quads["hitBow" .. i] = love.graphics.newQuad(i * 24 - 24, 0, 24, 24, sw, sh)
end

assets.images["hitCatapult"] = love.graphics.newImage(dataFolder .. "hitCatapult.png")
local sw, sh = assets.images["hitCatapult"]:getDimensions()
for i = 1, 5 do
  assets.quads["hitCatapult" .. i] = love.graphics.newQuad(i * 24 - 24, 0, 24, 24, sw, sh)
end

assets.images["hitBallista"] = love.graphics.newImage(dataFolder .. "hitBallista.png")
local sw, sh = assets.images["hitBallista"]:getDimensions()
for i = 1, 5 do
  assets.quads["hitBallista" .. i] = love.graphics.newQuad(i * 24 - 24, 0, 24, 24, sw, sh)
end

assets.images["hitCannon"] = love.graphics.newImage(dataFolder .. "hitCannon.png")
local sw, sh = assets.images["hitCannon"]:getDimensions()
for i = 1, 5 do
  assets.quads["hitCannon" .. i] = love.graphics.newQuad(i * 24 - 24, 0, 24, 24, sw, sh)
end

assets.images["hitArtillery"] = love.graphics.newImage(dataFolder .. "hitArtillery.png")
local sw, sh = assets.images["hitArtillery"]:getDimensions()
for i = 1, 5 do
  assets.quads["hitArtillery" .. i] = love.graphics.newQuad(i * 24 - 24, 0, 24, 24, sw, sh)
end

assets.images["hitLaser"] = love.graphics.newImage(dataFolder .. "hitLaser.png")
local sw, sh = assets.images["hitLaser"]:getDimensions()
for i = 1, 5 do
  assets.quads["hitLaser" .. i] = love.graphics.newQuad(i * 24 - 24, 0, 24, 24, sw, sh)
end

for i = 1, 8 do
  assets.images["lvl" .. i] = love.graphics.newImage(dataFolder .. "lvl" .. i .. ".png")
end

assets.sounds["Mixdown"] = love.audio.newSource(dataFolder .. "Mixdown.mp3", "static")

assets.sounds["shotSling"] = love.audio.newSource(dataFolder .. "shotSling.wav", "static")
assets.sounds["shotBow"] = love.audio.newSource(dataFolder .. "shotBow.wav", "static")
assets.sounds["shotCatapult"] = love.audio.newSource(dataFolder .. "shotCatapult.wav", "static")
assets.sounds["shotBallista"] = love.audio.newSource(dataFolder .. "shotBallista.wav", "static")
assets.sounds["shotArtillery"] = love.audio.newSource(dataFolder .. "shotArtillery.wav", "static")
assets.sounds["shotCannon"] = love.audio.newSource(dataFolder .. "shotCannon.wav", "static")
assets.sounds["shotLaser"] = love.audio.newSource(dataFolder .. "shotLaser.wav", "static")

assets.sounds["hit"] = love.audio.newSource(dataFolder .. "hit.wav", "static")

assets.sounds["sacrifice"] = love.audio.newSource(dataFolder .. "sacrifice.wav", "static")

return assets
