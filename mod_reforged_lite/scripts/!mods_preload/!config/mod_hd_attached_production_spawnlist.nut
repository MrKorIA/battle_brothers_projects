// Набеги на пристройки (порт из mod_hardened): защитники автодетект-получастроек
// (производственных). Hardened использовал динамический спавн HD_AttachedProduction
// (крестьяне + ополчение); в lite — статичные ванильные списки, культура поселения
// выбирается в attached_location.createDefenders.
::Const.World.Spawn.HD_AttachedProduction <- [
	{
		MovementSpeedMult = 0.75,
		VisibilityMult = 1.0,
		VisionMult = 0.75,
		Body = "figure_civilian_01",
		Troops = [
			{
				Type = ::Const.World.Spawn.Troops.Peasant,
				Num = 4
			},
			{
				Type = ::Const.World.Spawn.Troops.Militia,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 0.75,
		VisibilityMult = 1.0,
		VisionMult = 0.75,
		Body = "figure_civilian_03",
		Troops = [
			{
				Type = ::Const.World.Spawn.Troops.Peasant,
				Num = 5
			},
			{
				Type = ::Const.World.Spawn.Troops.Militia,
				Num = 3
			},
			{
				Type = ::Const.World.Spawn.Troops.MilitiaRanged,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 0.75,
		VisibilityMult = 1.0,
		VisionMult = 0.75,
		Body = "figure_civilian_01",
		Troops = [
			{
				Type = ::Const.World.Spawn.Troops.Peasant,
				Num = 3
			},
			{
				Type = ::Const.World.Spawn.Troops.Militia,
				Num = 2
			}
		]
	}
];
// Южный вариант: работники поселений + рабы, вместо северного ополчения
::Const.World.Spawn.HD_AttachedProductionSouthern <- [
	{
		MovementSpeedMult = 0.75,
		VisibilityMult = 1.0,
		VisionMult = 0.75,
		Body = "figure_civilian_06",
		Troops = [
			{
				Type = ::Const.World.Spawn.Troops.SouthernPeasant,
				Num = 4
			},
			{
				Type = ::Const.World.Spawn.Troops.Slave,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 0.75,
		VisibilityMult = 1.0,
		VisionMult = 0.75,
		Body = "figure_civilian_06",
		Troops = [
			{
				Type = ::Const.World.Spawn.Troops.SouthernPeasant,
				Num = 5
			},
			{
				Type = ::Const.World.Spawn.Troops.Slave,
				Num = 2
			},
			{
				Type = ::Const.World.Spawn.Troops.Conscript,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 0.75,
		VisibilityMult = 1.0,
		VisionMult = 0.75,
		Body = "figure_civilian_06",
		Troops = [
			{
				Type = ::Const.World.Spawn.Troops.SouthernPeasant,
				Num = 3
			},
			{
				Type = ::Const.World.Spawn.Troops.Slave,
				Num = 1
			},
			{
				Type = ::Const.World.Spawn.Troops.Conscript,
				Num = 1
			}
		]
	}
];
