this.converted_gladiator_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.converted_gladiator";
		this.m.Name = "Обращённый гладиатор";
		this.m.Icon = "ui/backgrounds/background_61.png";
		this.m.HiringCost = 200;
		this.m.DailyCost = 28; //default gladiator is ~38
		this.m.Excluded = [
			"trait.superstitious",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.fear_nobles",
			"trait.weasel",
			"trait.night_blind",
			"trait.legend_fear_dark",
			"trait.sureshot",
			"trait.ailing",
			"trait.asthmatic",
			"trait.clubfooted",
			"trait.hesitant",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure",
			"trait.gluttonous",
			"trait.fat",
			"trait.drunkard",
			"trait.greedy",
			"trait.slack"
		];

//		this.m.Modifiers.Terrain = [
//				0.0, // ?
//				0.0, //ocean
//				0.0, //plains
//				0.0, //swamp
//				0.0, //hills
//				0.0, //forest
//				0.0, //forest
//				0.0, //forest_leaves
//				0.0, //autumn_forest
//				0.0, //mountains
//				0.0, // ?
//				0.0, //farmland
//				0.0, // snow
//				0.0, // badlands
//				0.0, //highlands
//				0.05, //steppes
//				0.0, //ocean
//				0.1, //desert
//				0.1 //oasis
//			];

//		this.m.PerkTreeDynamic = {
//			Weapon = [
//				this.Const.Perks.PolearmTree,
//				this.Const.Perks.SwordTree,
//				this.Const.Perks.ThrowingTree,
//				this.Const.Perks.CleaverTree,
//				this.Const.Perks.FlailTree,
//				this.Const.Perks.SpearTree,
//				this.Const.Perks.DaggerTree,
//				this.Const.Perks.ShieldTree,
//				this.Const.Perks.FistsTree
//			],
//			Defense = [
//				this.Const.Perks.HeavyArmorTree,
//				this.Const.Perks.MediumArmorTree,
//				this.Const.Perks.LightArmorTree
//			],
//			Traits = [
//				this.Const.Perks.ViciousTree,
//				this.Const.Perks.IndestructibleTree,
//				this.Const.Perks.AgileTree,
//				this.Const.Perks.LargeTree,
//				this.Const.Perks.FitTree
//			],
//			Enemy = [
//				this.Const.Perks.CivilizationTree
//			],
//			Class = [
//				this.Const.Perks.BeastClassTree
//			],
//			Magic = [
//				this.Const.Perks.RetiredGladiatorTreeLight
//			]
//		}
	}

	function onBuildDescription()
	{
		return "{%name% долго и упорно сражался, ведь когда вы встретили его, он был рабом, не имевшим с вами ничего общего. | %name% вырос рядом с вами в опытного воина - в таких условиях, где другие сбежали бы, поджав хвост. | %name% подавал большие надежды, когда вы впервые встретили его.} {Откованный в южном зное и отточенный в боях, %name% - прекрасное дополнение к любому боевому отряду. | То, кем был %name%, уже не имеет значения, главное, что жизнь в рабстве давно позади и он волен поступать так, как ему заблагорассудится. | %name% отточил свое тело и разум, чтобы стать не только бойцом, но и мыслителем. Когда он не сражается, он думает о том, как лучше защитить себя и других. Когда он не думает, он сохраняет вашу жизнь.}";
		//"{%name% долго и упорно сражался: когда вы встретили его, он был рабом, не имевшим с вами ничего общего. | %name% вырос рядом с вами в опытного воина - в таких условиях, что другие сбежали бы, поджав хвост. | %name% подавал большие надежды, когда вы впервые встретили его.} {Откованный в южном зное и отточенный в боях, %name% - прекрасное дополнение к любому боевому отряду. | То, кем был %name%, уже не имеет значения: главное, что жизнь в рабстве осталась позади и он волен поступать так, как ему заблагорассудится. | %name% отточил своё тело и разум, чтобы стать не только бойцом, но и мыслителем. Когда он не сражается, он думает о том, как лучше защитить себя и других. Когда он не думает, он спасает вам жизнь.}"
	}

	// function onSetAppearance()
	// {
	// 	local actor = this.getContainer().getActor();
	// 	local tattoo_body = actor.getSprite("tattoo_body");
	// 	local tattoo_head = actor.getSprite("tattoo_head");

	// 	if (this.Math.rand(1, 100) <= 25)
	// 	{
	// 		local body = actor.getSprite("body");
	// 		tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
	// 		tattoo_body.Visible = true;
	// 	}

	// 	if (this.Math.rand(1, 100) <= 30)
	// 	{
	// 		tattoo_head.setBrush("scar_02_head");
	// 		tattoo_head.Visible = true;
	// 	}
	// }

	// function updateAppearance()
	// {
	// 	local actor = this.getContainer().getActor();
	// 	local tattoo_body = actor.getSprite("tattoo_body");

	// 	if (tattoo_body.HasBrush)
	// 	{
	// 		local body = actor.getSprite("body");
	// 		tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
	// 	}
	// }

});

