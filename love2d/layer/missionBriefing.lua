local o = {}

o.text = ""
o.active = false
o.guiMenu = love.gui.newGui()
o.init = function(mission)
  o.text = mission.briefingText --or mission.description
  if o.text == null then
    o.active = false
    love.setgamestate(14, o.mission)

  else
    o.active = true
    o.btnOkay = o.guiMenu.newButton(W.getWidth() * 0.5 - 16, 364, 66, 42, "OK")
    o.mission = mission
    turGame.map.editMode = false;
  end
end

o.update = function(dt)
  o.guiMenu.update(dt)
  if not o.btnOkay or  o.btnOkay.isHit() then
    love.sounds.playSound("sounds/button_pressed.wav")
    love.setgamestate(14, o.mission)
    o.guiMenu.flushMouse()
  end
end

o.draw = function()
  local x1 = W.getWidth() * 0.125
  local x2 = W.getWidth() * 0.75
  local y1 = 160
  local rectX1 = x1 - 16
  local text = o.text
  local scale = 1
  local alignment = "left"
  if o.active then
    love.turris.drawMessage(x1,x2,y1,rectX1,text,scale,alignment)
  end
  G.setColor(255, 255, 255, 127)
  G.setFont(FONT)
  o.guiMenu.draw()
end


return o
