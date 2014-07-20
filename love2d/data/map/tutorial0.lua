map = {
  width = 8,
  height = 7,
  baseX = 2,
  baseY = 4,
  mass = 999,
  energy = 999,
  tower = {
    {
      towerType = 10,
      x = 5,
      y = 4,
    },
    {
      towerType = 10,
      x = 3,
      y = 2,
    },
    {
      towerType = 10,
      x = 4,
      y = 2,
    },
    {
      towerType = 10,
      x =5,
      y = 2,
    },
   {
      towerType = 10,
      x =5,
      y = 3,
    },
    {
      towerType = 10,
      x = 6,
      y = 4,
    },
   {
      towerType = 10,
      x = 7,
      y = 4,
    },
    {
      towerType = 1,
      x = 4,
      y = 1,
    },
    {
      towerType = 1,
      x = 3,
      y = 1,
    },
    {
      towerType = 1,
      x = 2,
      y = 1,
    },
    {
      towerType = 1,
      x =1,
      y = 1,
    },
    {
      towerType = 3,
      x = 3,
      y = 7,
    },

  },
  random = {
  },
  waves = {
    {
      missionText = "hello",
      disableUI =
      {

        massDisplayDisabled = true,
        energyDisplayDisabled = true,


        laserTowerDisplayDisabled = true,
        energyTowerDisplayDisabled = false,
        massTowerDisplayDisabled = true

      },
      delay = 1,
      waveCreeps = {
        {
          enemyType = 1,
          towerType = 7,
          x = 8,
          y = 4,
          delay = 1,
          count = 5
        },
      },
    },
    {
      missionText = "While the lasers seem to have an effect on the aliens, the residual energy wasn't enough to stop them from damaging our main generator.\nI've rerouted some power from the secondary EPS conduits, let's blast it into their next wave. Good luck! ",
      addMass = 0,
      addEnergy = 350,
      delay = 5,
      waveCreeps = {
        {
          enemyType = 1,
          towerType = 7,
          x = 11,
          y = 11,
          delay = 4,
          count = 12
        },
      },
    },
    {
      missionText = "I gave it all we had; and still some of them made it through.\nWe were able to convert some of the destroyed aliens' biomass to construction material, it should be enough for an ENERGY TOWER. We're running out of time!",
      addMass = 60,
      addEnergy = 0,
      delay = 2,
      waveCreeps = {
        {
          enemyType = 2,
          towerType = 7,
          x = 11,
          y = 11,
          delay = 3,
          count = 1
        },
      },
    },
    {
      missionText = "Thas was close! And there are even more waves incoming, from new spawn points.\nBuild a MASS TOWER so we can build more towers out of dead aliens.\nWe cannot hold much longer!",
      addMass = 25,
      addEnergy = 0,
      delay = 5,
      waveCreeps = {
        {
          enemyType = 2,
          towerType = 7,
          x = 11,
          y = 11,
          delay = 6,
          count = 3
        },
        {
          enemyType = 1,
          towerType = 7,
          x = 2,
          y = 1,
          delay = 4,
          count = 12
        },
      },
    },}
}
