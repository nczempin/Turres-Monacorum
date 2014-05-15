map = {
	width = 7,
	height = 7,
	baseX = 4,
	baseY = 4,
	waves = {
		{
			delay = 5,
			waveCreeps = {
				{
					enemyType = 1,
					towerType = 7,
					x = 1,
					y = 1,
					delay = 3,
					count = 15
				},
				{
					enemyType = 2,
					towerType = 6,
					x = 7,
					y = 1,
					delay = 7,
					count = 5
				},
				{
					enemyType = 1,
					towerType = 7,
					x = 7,
					y = 7,
					delay = 3,
					count = 15
				},
				{
					enemyType = 2,
					towerType = 6,
					x = 1,
					y = 7,
					delay = 7,
					count = 5
				},
			},
		},
		{
			delay = 10,
			waveCreeps = {
				{
					enemyType = 1,
					towerType = 7,
					x = 1,
					y = 1,
					delay = 3,
					count = 25
				},
				{
					enemyType = 2,
					towerType = 6,
					x = 7,
					y = 1,
					delay = 7,
					count = 15
				},
				{
					enemyType = 1,
					towerType = 7,
					x = 7,
					y = 7,
					delay = 3,
					count = 15
				},
				{
					enemyType = 2,
					towerType = 6,
					x = 1,
					y = 7,
					delay = 7,
					count = 5
				},
			},
		},

	},
	ground = {
		color = {
			{127, 63, 0},
			{127, 63, 0},
			{63, 127, 0},
			{63, 127, 0},
		},
		img = "ground02",
	},
	random = {
		{
			towerType = 8,
			frequency = 10,
		},
		{
			towerType = 9,
			frequency = 10,
		},
	},
}