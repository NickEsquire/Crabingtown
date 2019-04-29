local algs = {}

local rand = {i = 0, r = {}}
for i = 1, 65536 do
  rand.r[i] = math.random()
end

function algs.rand()
  if rand.i < 65536 then rand.i = rand.i + 1 else rand.i = 1 end
  return rand.r[rand.i]
end

function algs.dist(x1, y1, x2, y2)
  return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2))
end

function algs.angleTo(x1, y1, x2, y2)
  return math.atan2(x2 - x1, y1 - y2) - math.rad(90)
end

function algs.POINTvsAABB(x, y, x1, y1, x2, y2)
  if x >= x1 and x <= x2 and y >= y1 and y <= y2 then return true else return false end
end

function algs.AABBvsAABB(xmin1, ymin1, xmax1, ymax1, xmin2, ymin2, xmax2, ymax2)
  if xmin1 > xmax2 or xmax1 < xmin2 then return false end
  if ymin1 > ymax2 or ymax1 < ymin2 then return false end
  return true
end

function algs.LINEvsAABB(lx1, ly1, lx2, ly2, x1, y1, x2, y2)
  
end

function algs.LINEvsLINE(ax, ay, bx, by, cx, cy, dx, dy)
  local vax = bx - ax
  local vay = by - ay

  local vbx = dx - cx
  local vby = dy - cy

  local dot = vax * vby - vay * vbx

  if dot == 0 then return false, nil, nil end

  local vcx = cx - ax
  local vcy = cy - ay

  local t = (vcx * vby - vcy * vbx) / dot

  if t < 0 or t > 1 then return false, nil, nil end

  local u = (vcx * vay - vcy * vax) / dot

  if u < 0 or u > 1 then return false, nil, nil end

  return true, ax + t * vax, ay + t * vay
end

function algs.CIRCLEvsLINE(cx, cy, cr, x1, y1, x2, y2)
  local dist, dir
  local seg = algs.Dist(x1, y1, x2, y2)
  local ang = algs.AngleTo(x1, y1, x2, y2)
  local ax = x2 - x1 ay = y2 - y1
  local bx = cx - x1 by = cy - y1
  local dot = ax * bx + ay * by
  local len = dot / seg

  if len >= 0 and len <= seg then
    local lx = x1 + math.cos(ang) * len
    local ly = y1 + math.sin(ang) * len
    dist = algs.Dist(lx, ly, cx, cy)
    dir = algs.AngleTo(lx, ly, cx, cy)
  elseif len < 0 then
    dist = algs.Dist(x1, y1, cx, cy)
    dir = algs.AngleTo(x1, y1, cx, cy)
  elseif len > seg then
    dist = algs.Dist(x2, y2, cx, cy)
    dir = algs.AngleTo(x2, y2, cx, cy)
  end

  if cr > dist then
    return true, cr - dist + 0.49, dir
  else
    return false
  end
end

function algs.LINEvsCIRCLE(cx, cy, radius, pt1, pt2)
    local dx, dy, A, B, C, det, t

    dx = pt2.x - pt1.x
    dy = pt2.y - pt1.y

    A = dx * dx + dy * dy
    B = 2 * (dx * (pt1.x - cx) + dy * (pt1.y - cy))
    C = (pt1.x - cx) * (pt1.x - cx) + (pt1.y - cy) * (pt1.y - cy) - radius * radius

    det = B * B - 4 * A * C
    
    if A <= 0.0000001 or det < 0 then
      return {}
    elseif det == 0 then
      local d = algs.dist(pt1.x, pt1.y, pt2.x, pt2.y)
      t = -B / (2 * A)
      local in1 = {x = pt1.x + t * dx, y = pt1.y + t * dy}
      local d1 = algs.dist(pt1.x, pt1.y, in1.x, in1.y)
      
      if d1 <= d then
        return {{x = in1.x, y = in1.y}}
      else
        return {}
      end
    else
      local d = algs.dist(pt1.x, pt1.y, pt2.x, pt2.y)
      t = (-B + math.sqrt(det)) / (2 * A)
      local in1 = {x = pt1.x + t * dx, y = pt1.y + t * dy}
      local d1 = algs.dist(pt1.x, pt1.y, in1.x, in1.y)
      t = (-B - math.sqrt(det)) / (2 * A)
      local in2 = {x = pt1.x + t * dx, y = pt1.y + t * dy}
      local d2 = algs.dist(pt1.x, pt1.y, in2.x, in2.y)
      
      if d1 < d and d2 < d then
        if algs.dist(pt1.x, pt1.y, in1.x, in1.y) < algs.dist(pt1.x, pt1.y, in2.x, in2.y) then
          return {[1] = {x = in1.x, y = in1.y}, [2] = {x = in2.x, y = in2.y}}
        else
          return {[1] = {x = in2.x, y = in2.y}, [2] = {x = in1.x, y = in1.y}}
        end
      elseif d1 < d then
        return {{x = in1.x, y = in1.y}}
      elseif d2 < d then
        return {{x = in2.x, y = in2.y}}
      else
        return {}
      end
    end
end

function algs.POINTvsPOLYGON(px, py, vs)
  local cr, intrs = 0, {}

  for i = 2, #vs do
    local b, x, y = algorythms.LINEvsLINE(-1, py, px, py, vs[i - 1][1], vs[i - 1][2], vs[i][1], vs[i][2])
    if b == true and intrs[x .. " " .. y] == nil then cr = cr + 1 intrs[x .. " " .. y] = true end
  end
  local b, x, y = algorythms.LINEvsLINE(-1, py, px, py, vs[#vs][1], vs[#vs][2], vs[1][1], vs[1][2])
  if b == true and intrs[x .. " " .. y] == nil then cr = cr + 1 end

  if math.fmod(cr, 2) == 0 then return false else return true end
end

function algs.POLYGONvsPOLYGON(A, B)
  
end

return algs
