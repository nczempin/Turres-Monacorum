map = {
	width = 11,
	height = 11,
	baseX = 3,
	baseY = 5,
	waves = {
		{
			delay = 2,
			waveCreeps = {
				{
					enemyType = 1,
					towerType = 7,
					x = 11,
					y = 11,
					delay = 3,
					count = 1
				},
			},
		},
		{
			missionText = "While the lasers seem to have an effect on the aliens, the residual energy wasn't enough to stop them from damaging our main generator.\nI've rerouted some power from the secondary EPS conduits, let's blast it into their next wave. Good luck! ",
			setMass = 0,
			setEnergy = 350,
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
			setMass = 60,
			setEnergy = 0,
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
			setMass = 15,
			setEnergy = 0,
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
		},},
	tower = {
		{
			towerType = 10,
			x = 5,
			y = 5,
		},
		{
			towerType = 10,
			x = 6,
			y = 5,
		},
		{
			towerType = 10,
			x = 7,
			y = 5,
		},
		{
			towerType = 10,
			x = 8,
			y = 5,
		},
		{
			towerType = 10,
			x = 9,
			y = 5,
		},
		{
			towerType = 10,
			x = 10,
			y = 5,
		},
		{
			towerType = 10,
			x = 11,
			y = 5,
		},
		{
			towerType = 10,
			x = 11,
			y = 6,
		},
		{
			towerType = 10,
			x = 11,
			y = 7,
		},
		{
			towerType = 10,
			x = 11,
			y = 8,
		},
		{
			towerType = 10,
			x = 11,
			y = 9,
		},
		{
			towerType = 10,
			x = 11,
			y = 10,
		},
		{
			towerType = 8,
			x = 10,
			y = 11,
		},

	},
	random = {
	},
	mass = 10,
	energy = 25
}