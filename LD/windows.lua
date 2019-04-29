local windows = {windows = {}, queue = {}}

windows.mouse = {window = "", object = "", timer = 0}
windows.mouseB1 = {window = "", object = "", timer = 0}
windows.mouseB2 = {window = "", object = "", timer = 0}
windows.mouseB3 = {window = "", object = "", timer = 0}

function windows.newWindow(name, priority, x, y, width, height, visible, interactable, mainFunction, enterFunction, overlapFunction, leaveFunction)
  local window = {}
  window.name = name
  window.index = tostring(window)
  window.x = x
  window.y = y
  window.width = width
  window.height = height
  
  window.visible = visible
  window.interactable = interactable
  
  window.mainFunction = mainFunction
  window.enterFunction = enterFunction
  window.overlapFunction = overlapFunction
  window.leaveFunction = leaveFunction
  
  window.objects = {}
  window.queue = {}
  
  window.leftClicked = ""
  
  window.canvas = love.graphics.newCanvas(width, height)
  
  windows.windows[name] = window
  if priority == -1 then table.insert(windows.queue, windows.windows[name]) else table.insert(windows.queue, priority, windows.windows[name]) end
  
  return window
end

function windows.newWindowObject(window, name, priority, x, y, width, height, interactable, images, texts, overlapFunction)
  local object = {}
  object.window = window
  object.name = name
  object.index = tostring(object)
  object.priority = priority
  object.x = x
  object.y = y
  object.width = width
  object.height = height
  
  object.interactable = interactable
  
  object.images = images
  object.texts = texts
  
  object.overlapFunction = overlapFunction
  object.enterFunction = function() end
  object.leaveFunction = function() end
  
  windows.windows[window].objects[name] = object
  table.insert(windows.windows[window].queue, windows.windows[window].objects[name])
  
  windows.windows[window].queue = lume.sort(windows.windows[window].queue, "priority")
  
  return object
end

function windows.getWindow(name)
  return windows.windows[name]
end

function windows.getWindowObject(window, name)
  if windows.windows[window] then return windows.windows[window].objects[name] end
end

function windows.deleteWindow(name)
  local priority
  for k, v in ipairs(windows.queue) do
    if v.name == name then priority = k break end
  end
  if priority ~= nil then
    if windows.windows[name].leaveFunction ~= nil then windows.windows[name].leaveFunction() end
    windows.windows[name].canvas:release()
    table.remove(windows.queue, priority)
    windows.windows[name] = nil
    if windows.mouse.window == name then
      windows.mouse.window = ""
      windows.mouse.object = ""
      windows.mouse.timer = -1
    end
    
    return true
  else
    return false
  end
end

function windows.deleteWindowObject(window, name)
  for k, v in pairs(windows.windows[window].queue) do
    if v.name == name then table.remove(windows.windows[window].queue, k) break end
  end
  windows.windows[window].objects[name] = nil
end

function windows.mouseDrag(object, x, y, image)
  local main = function() if input.mouse[1].t <= 0 then windows.newWindow("mouseDrop", -1, 0, 0, 1, 1, false, false, function() windows.deleteWindow("mouseDrop") end) windows.getWindow("mouseDrop").object = windows.getWindow("mouseDrag").object windows.deleteWindow("mouseDrag") else windows.getWindow("mouseDrag").x = input.mouse_x + x windows.getWindow("mouseDrag").y = input.mouse_y + y end end
  windows.newWindow("mouseDrag", -1, input.mouse_x + x, input.mouse_y + y, 1, 1, true, false, main)
  windows.newWindowObject("mouseDrag", "itemImage", 0, 0, 0, 0, 0, false, {{layer = true, image = image, offsetX = 0, offsetY = 0}}, {})
  windows.getWindow("mouseDrag").object = object
end

function windows.objectDrag(object, noWindowFunction)
  if not windows.getWindow("mouseDrag") and input.mouse[1].t >= 1 and (input.mouse[1].t >= 20 or math.abs(input.mouseDeltaX) + math.abs(input.mouseDeltaY) >= 4) then
    windows.mouseDrag(object, -48, -48, object.images[1].image)
    windows.newWindow("groundDrop", 1, 0, 0, 1920, 1080, false, true, function() if not windows.getWindow("mouseDrag") then windows.deleteWindow("groundDrop") end end, nil, function() windows.objectDrop(nil, noWindowFunction) end)
  end
end

function windows.objectDrop(B, dropFunction, additional)
  if windows.getWindow("mouseDrop") then dropFunction(windows.getWindow("mouseDrop").object, B, additional) end
end

function windows.shortcutNew(shortcut, window, name, dragable, dropable, priority, x, y, width, height, images, texts, additionalFunction)
  if shortcut == "base" then
    if dragable == true then
      windows.newWindow(window, priority, x, y, width, height, true, true, function() if windows.getWindow(window).delete == true then windows.deleteWindow(window) elseif windows.getWindow(window).grab ~= nil then windows.getWindow(window).grab() end end)
      backgroung = windows.newWindowObject(window, "background", 0, 0, 0, width, height, true, {{image = res.images[images[1][1]], offsetX = images[1][2], offsetY = images[1][3]}}, {}, function() if input.mouse[1].t == 1 then local x, y = input.mouse_x - windows.getWindow(window).x, input.mouse_y - windows.getWindow(window).y windows.getWindow(window).grab = function() if input.mouse[1].t > 0 then windows.getWindow(window).x = input.mouse_x - x windows.getWindow(window).y = input.mouse_y - y else windows.getWindow(window).grab = nil end end end end)
    else
      windows.newWindow(window, priority, x, y, width, height, true, true, function() if windows.getWindow(window).delete == true then windows.deleteWindow(window) end end)
      backgroung = windows.newWindowObject(window, "background", 0, 0, 0, width, height, true, {{image = res.images[images[1][1]], offsetX = images[1][2], offsetY = images[1][3]}}, {}, function() end)
    end
    overlay = windows.newWindowObject(window, "overlay", 50, 0, 0, -1, -1, true, {{image = res.images[images[2][1]], offsetX = images[2][2], offsetY = images[2][3]}}, {})
  elseif shortcut == "button" then
    windows.newWindowObject(window, name, priority, x, y, width, height, true, {{image = res.images[images[1][1]], offsetX = images[1][2], offsetY = images[1][3]}}, texts, function() if input.mouse[1].t == 1 then additionalFunction() end end)
  elseif shortcut == "slider" then
    windows.newWindowObject(window, name .. "Rail", priority, x, y, width, height, true, images, texts, function() end)
    windows.newWindowObject(window, name .. "Drag", priority, x, y, width, height, true, images, texts, function() end)
  end
end

function windows.update()
  for k, v in ipairs(windows.queue) do
    if v.mainFunction ~= nil then v.mainFunction() end
  end
  
  local window, priorityWindow
  for i = #windows.queue, 1, -1 do
    if windows.queue[i].interactable and algs.POINTvsAABB(input.mouse_x, input.mouse_y, windows.queue[i].x, windows.queue[i].y, windows.queue[i].x + windows.queue[i].width, windows.queue[i].y + windows.queue[i].height) then
      window = windows.queue[i]
      priorityWindow = i
      break
    end
  end
  
  if window ~= nil and not (windows.mouse.timer == 0 and input.mouse[1].t >= 1) then 
    local windowObject, priorityObject
    for i = #window.queue, 1, -1 do
      if window.queue[i].interactable and algs.POINTvsAABB(input.mouse_x, input.mouse_y, window.x + window.queue[i].x, window.y + window.queue[i].y, window.x + window.queue[i].x + window.queue[i].width, window.y + window.queue[i].y + window.queue[i].height) == true then
        windowObject = window.queue[i]
        priorityObject = i
        break
      end
    end
    
    if input.mouse[1].t == 1 then
      if priorityWindow < #windows.queue then
        table.remove(windows.queue, priorityWindow)
        table.insert(windows.queue, window)
      end
    end
    
    if windows.mouse.window ~= window.name then
      if windows.mouse.window ~= "" and windows.getWindow(windows.mouse.window).leaveFunction then windows.getWindow(windows.mouse.window).leaveFunction() end
      if windows.getWindow(window.name).enterFunction then windows.getWindow(window.name).enterFunction() end
      windows.mouse.window = window.name
      windows.mouse.timer = 1
    else
      windows.mouse.timer = windows.mouse.timer + 1
    end
    
    if windows.mouse.object ~= windowObject.name then
      if windows.mouse.object ~= "" and windows.getWindowObject(windows.mouse.window, windows.mouse.object).leaveFunction then windows.getWindowObject(windows.mouse.window, windows.mouse.object).leaveFunction() end
      if windows.getWindowObject(window.name, windowObject.name).enterFunction then windows.getWindowObject(window.name, windowObject.name).enterFunction() end
      windows.mouse.object = windowObject.name
    end
    
    if window.overlapFunction ~= nil then window.overlapFunction() end
    
    if windowObject ~= nil then
      if windowObject.overlapFunction ~= nil then windowObject.overlapFunction() end
    elseif windows.mouse.object ~= "" then
      if windows.getWindowObject(windows.mouse.window, windows.mouse.object) and windows.getWindowObject(windows.mouse.window, windows.mouse.object).leaveFunction then windows.getWindowObject(windows.mouse.window, windows.mouse.object).leaveFunction() end
      windows.mouse.object = ""
    end
  else
    if windows.mouse.window ~= "" then
      if windows.getWindowObject(windows.mouse.window, windows.mouse.object) and windows.getWindowObject(windows.mouse.window, windows.mouse.object).leaveFunction then windows.getWindowObject(windows.mouse.window, windows.mouse.object).leaveFunction() end
      windows.mouse.object = ""
      if windows.getWindow(windows.mouse.window) and windows.getWindow(windows.mouse.window).leaveFunction then windows.getWindow(windows.mouse.window).leaveFunction() end
      windows.mouse.window = ""
      if input.mouse[1].t <= 1 then windows.mouse.timer = 0 else windows.mouse.timer = -1 end
    elseif windows.mouse.timer == -1 then
      if input.mouse[1].t == 0 then windows.mouse.timer = 0 end
    end
  end
end

function windows.draw()
  local canvas = love.graphics.getCanvas()
  for k, v in ipairs(windows.queue) do
    if v.visible == true then
      love.graphics.setColor(1, 1, 1, 1)
      for ko, vo in ipairs(v.queue) do
        for ki, vi in ipairs(vo.images) do
          if vi.layer == false then love.graphics.draw(vi.image, v.x + vo.x + vi.offsetX, v.y + vo.y + vi.offsetY) end
        end
      end
      
      love.graphics.setCanvas(v.canvas)
      love.graphics.clear()
      
      for ko, vo in ipairs(v.queue) do
        for ki, vi in ipairs(vo.images) do
          if vi.layer == nil then love.graphics.setColor(vi.clr) love.graphics.draw(vi.image, vo.x + vi.offsetX, vo.y + vi.offsetY, vi.r, vi.sx, vi.sy, vi.ox, vi.oy) end
        end
        love.graphics.setColor(1, 1, 1, 1)
        for kt, vt in ipairs(vo.texts) do
          if vt.layer == nil then love.graphics.print(vt.text, vo.x + vt.offsetX, vo.y + vt.offsetY, vt.r, vt.sx, vt.sy, vt.ox, vt.oy) end
        end
      end
      
      love.graphics.setCanvas(canvas)
      love.graphics.draw(v.canvas, v.x, v.y)
      
      for ko, vo in ipairs(v.queue) do
        for ki, vi in ipairs(vo.images) do
          if vi.layer == true then love.graphics.draw(vi.image, v.x + vo.x + vi.offsetX, v.y + vo.y + vi.offsetY) end
        end
      end
      
      --[[
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.rectangle("line", v.x, v.y, v.width, v.height)
      for ko, vo in ipairs(v.queue) do
        love.graphics.rectangle("line", v.x + vo.x, v.y + vo.y, vo.width, vo.height)
      end
      ]]
    end
  end
end

return windows