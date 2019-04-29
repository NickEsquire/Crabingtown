local trading = {items = {}}

trading.items["sling"] = {dmg = 0.25, rof = 60, prc = 2}
trading.items["bow"] = {dmg = 1, rof = 120, prc = 5}
trading.items["catapult"] = {dmg = 3, rof = 240, prc = 10}
trading.items["ballista"] = {dmg = 4, rof = 250, prc = 12}
trading.items["cannon"] = {dmg = 10, rof = 250, prc = 20}
trading.items["artillery"] = {dmg = 20, rof = 300, prc = 40}
trading.items["laser"] = {dmg = 10, rof = 120, prc = 100}

function trading.trade(crab, item)
  if crab.people >= trading.items[item].prc + 2 then
    crab.people = crab.people - trading.items[item].prc
    table.insert(crab.weapons, {dmg = trading.items[item].dmg, rof = trading.items[item].rof, cld = trading.items[item].rof, nam = item})
    
    for i = 1, trading.items[item].prc do
      local ofx, ofy = -64 + algs.rand() * 128, -64 + algs.rand() * 128
      fx.add(ofx, ofy, 0, "light", i * 2, crab)
      fx.add(ofx, ofy, 0, "sacrifice", i * 2, crab)
    end
    
    return true
  else
    return false
  end
end

return trading