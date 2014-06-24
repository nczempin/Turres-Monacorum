function love.turris.newPlayer()

  local o = {}

  o.mass = 99999
  o.energy = 99999

  o.massDisplayDisabled = false
  o.energyDisplayDisabled = false
  
  
  o.laserTowerDisplayDisabled = false
  o.energyTowerDisplayDisabled = false
  o.massTowerDisplayDisabled = false

  o.addMass = function(mass)
    o.mass = o.mass + mass
  end

  o.addEnergy = function(energy)
    o.energy = o.energy + energy
  end

  o.setMass = function(mass)
    o.mass = mass
  end

  o.setEnergy = function(energy)
    o.energy = energy
  end

  return o

end