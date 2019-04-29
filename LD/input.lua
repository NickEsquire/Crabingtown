local input = {key = {}, keydouble = {}, keypressed = {}, keyreleased = {}, keytime = {}, mouse = {}, mousedouble = {}, mousepressed = {}, mousereleased = {}, mousetime = {}}

input.mouse_x, input.mouse_y, input.mouse_wheel, input.mouseDeltaX, input.mouseDeltaY, input.mousePrevX, input.mousePrevY = 0, 0, 0, 0, 0, 0, 0
input.mouse[1] = {t = 0, x = 0, y = 0}
input.mouse[2] = {t = 0, x = 0, y = 0}
input.mouse[3] = {t = 0, x = 0, y = 0}
input.mouse[4] = {t = 0, x = 0, y = 0}
input.mouse[5] = {t = 0, x = 0, y = 0}

for k, v in pairs(input.mouse) do
  input.mousedouble[k] = {s = false, x1 = 0, y1 = 0, x2 = 0, y2 = 0}
end

input.key["a"] = 0
input.key["b"] = 0
input.key["c"] = 0
input.key["d"] = 0
input.key["e"] = 0
input.key["f"] = 0
input.key["g"] = 0
input.key["h"] = 0
input.key["i"] = 0
input.key["j"] = 0
input.key["k"] = 0
input.key["l"] = 0
input.key["m"] = 0
input.key["n"] = 0
input.key["o"] = 0
input.key["p"] = 0
input.key["q"] = 0
input.key["r"] = 0
input.key["s"] = 0
input.key["t"] = 0
input.key["u"] = 0
input.key["v"] = 0
input.key["w"] = 0
input.key["x"] = 0
input.key["y"] = 0
input.key["z"] = 0
input.key["0"] = 0
input.key["1"] = 0
input.key["2"] = 0
input.key["3"] = 0
input.key["4"] = 0
input.key["5"] = 0
input.key["6"] = 0
input.key["7"] = 0
input.key["8"] = 0
input.key["9"] = 0
input.key["kp0"] = 0
input.key["kp1"] = 0
input.key["kp2"] = 0
input.key["kp3"] = 0
input.key["kp4"] = 0
input.key["kp5"] = 0
input.key["kp6"] = 0
input.key["kp7"] = 0
input.key["kp8"] = 0
input.key["kp9"] = 0
input.key["escape"] = 0
input.key["return"] = 0
input.key["space"] = 0
input.key["lshift"] = 0
input.key["rshift"] = 0
input.key["lctrl"] = 0
input.key["rctrl"] = 0
input.key["lalt"] = 0
input.key["ralt"] = 0
input.key["tab"] = 0
input.key["f1"] = 0

for k, v in pairs(input.key) do
  input.keydouble[k] = false
end

function input.update()
  for k, v in pairs(input.keypressed) do
    input.key[k] = input.key[k] + 1
  end

  for k, v in pairs(input.keyreleased) do
    input.key[k] = 0 input.keyreleased[k] = nil
  end

  for k, v in pairs(input.keytime) do
    input.keytime[k] = input.keytime[k] + 1
    if input.keytime[k] >= 15 then input.keytime[k] = nil input.keydouble[k] = false end
  end

  for k, v in pairs(input.mousepressed) do
    input.mouse[k].t = input.mouse[k].t + 1
  end

  for k, v in pairs(input.mousereleased) do
    input.mouse[k].t = 0 input.mousereleased[k] = nil
  end

  for k, v in pairs(input.mousetime) do
    input.mousetime[k].t = input.mousetime[k].t + 1
    if input.mousetime[k].t >= 15 then input.mousetime[k] = nil input.mousedouble[k].s = false end
  end

  if input.mouse_wheel ~= 0 then input.mouse_wheel = 0 end
  
  input.mouseDeltaX, input.mouseDeltaY = input.mouse_x - input.mousePrevX, input.mouse_y - input.mousePrevY
  input.mousePrevX, input.mousePrevY = input.mouse_x, input.mouse_y
end

function love.mousemoved(x, y, dx, dy)
  input.mouse_x, input.mouse_y = x / renderScale.x, y / renderScale.y
end

function love.mousepressed(x, y, b)
  input.mouse[b].t = 1 input.mouse[b].x = x input.mouse[b].y = y input.mousepressed[b] = true input.mousereleased[b] = nil
  if input.mousetime[b] ~= nil and math.abs(input.mousetime[b].x - x) < 10 and math.abs(input.mousetime[b].y - y) < 10 then
    input.mousetime[b].t = 15
    input.mousedouble[b].s = true input.mousedouble[b].x1 = input.mousetime[b].x input.mousedouble[b].y1 = input.mousetime[b].y input.mousedouble[b].x2 = x input.mousedouble[b].y2 = y
  else
    input.mousetime[b] = {t = 1, x = x, y = y}
  end
end

function love.mousereleased(x, y, b)
  input.mouse[b].t = -1 input.mousepressed[b] = nil input.mousereleased[b] = true
end

function love.wheelmoved(x, y)
  input.mouse_wheel = y
end

function love.keypressed(k)
  if input.key[k] ~= nil then input.key[k] = 1 input.keypressed[k] = true input.keyreleased[k] = nil if input.keytime[k] == nil then input.keytime[k] = 1 else input.keytime[k] = 15 input.keydouble[k] = true end end

  if k == "escape" then love.event.quit() end
end

function love.keyreleased(k)
  if input.key[k] ~= nil then input.key[k] = -1 input.keypressed[k] = nil input.keyreleased[k] = true end
end

return input
