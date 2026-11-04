::Const.Tactical.PlagueCloudParticles <- [
	{
		Delay = 0,
		Quantity = 50,
		LifeTimeQuantity = 0,
		SpawnRate = 9,
		Brushes = [
			"plague_light_01",
			"plague_light_02"
		],
		Stages = [
			{
				LifeTimeMin = 0.75,
				LifeTimeMax = 1.25,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 0.5,
				ScaleMax = 0.75,
				RotationMin = 0,
				RotationMax = 359,
				TorqueMin = -10,
				TorqueMax = 10,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = this.createVec(-0.5, 0.5),
				DirectionMax = this.createVec(0.5, 0.5),
				SpawnOffsetMin = this.createVec(-50, -40),
				SpawnOffsetMax = this.createVec(50, 20),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 4.0,
				LifeTimeMax = 6.0,
				ColorMin = this.createColor("ffffffed"),
				ColorMax = this.createColor("ffffffed"),
				ScaleMin = 0.75,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = this.createVec(-0.4, 0.6),
				DirectionMax = this.createVec(0.4, 0.6),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 1.0,
				ScaleMax = 1.5,
				VelocityMin = 10,
				VelocityMax = 30,
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			}
		]
	},
	{
		Delay = 0,
		Quantity = 10,
		LifeTimeQuantity = 0,
		SpawnRate = 2,
		Brushes = [
			"plague_light_03",
			"plague_light_04"
		],
		Stages = [
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 0.75,
				ScaleMax = 1.0,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = this.createVec(-0.5, 0.5),
				DirectionMax = this.createVec(0.5, 0.5),
				SpawnOffsetMin = this.createVec(-50, -40),
				SpawnOffsetMax = this.createVec(50, 10),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 4.0,
				LifeTimeMax = 6.0,
				ColorMin = this.createColor("ffffffef"),
				ColorMax = this.createColor("ffffffef"),
				ScaleMin = 1.0,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = this.createVec(-0.4, 0.6),
				DirectionMax = this.createVec(0.4, 0.6),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 1.0,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			}
		]
	}
];

::Const.Tactical.PlagueParticles <- [
	{
		Delay = 0,
		Quantity = 10,
		LifeTimeQuantity = 0,
		SpawnRate = 2,
		Brushes = [
			"plague_light_05",
			"plague_light_06"
		],
		Stages = [
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 0.75,
				ScaleMax = 1.0,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = this.createVec(-0.5, 0.5),
				DirectionMax = this.createVec(0.5, 0.5),
				SpawnOffsetMin = this.createVec(-50, -40),
				SpawnOffsetMax = this.createVec(50, 10),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 4.0,
				LifeTimeMax = 6.0,
				ColorMin = this.createColor("ffffffef"),
				ColorMax = this.createColor("ffffffef"),
				ScaleMin = 1.0,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = this.createVec(-0.4, 0.6),
				DirectionMax = this.createVec(0.4, 0.6),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 1.0,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			}
		]
	}
];