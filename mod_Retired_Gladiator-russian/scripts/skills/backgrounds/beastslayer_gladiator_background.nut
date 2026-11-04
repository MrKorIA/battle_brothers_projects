this.beastslayer_gladiator_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.beastslayer_gladiator";
		this.m.Name = "Охотник на вирмов";
		this.m.Icon = "ui/backgrounds/background_nosteponsnek.png";
		this.m.BackgroundDescription = "Вынужденный в детстве бороться с невозможными трудностями, %name% потряс всех, с одинаковой лёгкостью расправляясь как с гиенами, так и линдвурмами. Многие стекались посмотреть на великана, покрытого мускулами и шрамами, принеся ему богатство, достаточное, чтобы купить себе свободу и отправиться на север. Встретив со стороны северян лишь презрение, %name% отправился в пустоши, ища жарких схваток - и вот тогда, судьба свела вас, и вы завязали дружбу, которая, кажется, длится уже всю жизнь.";
		this.m.GoodEnding = "Когда озарённый Златоликим путь гладиатора подошёл к концу, %name% вернулся домой, на арену, - но не для сражений. Он стал сказителем, повествуя детям и простолюдинам о чудесах и чудищах, которых они никогда не смогут увидеть, запертые в стенах города. Его рассказы поражали и трогали многих, меняя их жизнь. Мало кто знал, что после его смерти истории, обретшие собственную жизнь, оставили куда больший след, чем великан, который когда-то прожил их.";
		this.m.BadEnding = "После того как его время в отряде подошло к концу, а странствующий гладиатор умер, %name% вернулся к привычной жизни в единении с природой, вдали от 'цивилизованного' мира. Что стало с ним, неизвестно, но некоторые до сих пор говорят о лесном великане... мстительном духе, который бродит по земле в поисках старого друга.";
		this.m.HiringCost = 10000000000;
		this.m.DailyCost = 40;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_nobles",
			"trait.weasel",
			"trait.gluttonous",
			"trait.greedy",
			"trait.disloyal",
			"trait.survivor",
			"trait.night_blind",
			"trait.legend_fear_dark",
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
			"trait.light"
		];
		this.m.Titles = [
			"Зверобой",
			"Силач",
			"Следопыт"
			"Убийца червей",
			"Душитель змей"
		];
			this.m.ExcludedTalents = [
			this.Const.Attributes.RangedDefense
		];
//		if (this.Math.rand(1, 2))
//		{
//			this.m.Bodies = this.Const.Bodies.Gladiator;
//			this.m.Faces = this.Const.Faces.SouthernMale;
//			this.m.Hairs = this.Const.Hair.SouthernMale;
//			this.m.HairColors = this.Const.HairColors.Southern;
//			this.m.Beards = this.Const.Beards.Southern;
//			this.m.BeardChance = 60;
//			this.m.Ethnicity = 1;
//		}
//		else
//		{
//			this.m.Bodies = this.Const.Bodies.AfricanGladiator;
//			this.m.Faces = this.Const.Faces.AfricanMale;
//			this.m.Hairs = this.Const.Hair.SouthernMale;
//			this.m.HairColors = this.Const.HairColors.African;
//			this.m.Beards = this.Const.Beards.Southern;
//			this.m.BeardChance = 60;
//			this.m.Ethnicity = 2;
//		}
        this.m.Bodies = this.Const.Bodies.Gladiator;
        this.m.Faces = this.Const.Faces.SouthernMale;
        this.m.Hairs = this.Const.Hair.SouthernMale;
        this.m.HairColors = this.Const.HairColors.Southern;
        this.m.Beards = this.Const.Beards.Southern;
        this.m.BeardChance = 60;
        this.m.Ethnicity = 1;

		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
		this.m.Level = 4;
//		this.m.BackgroundType = this.Const.BackgroundType.Combat;
		this.m.IsCombatBackground = true;
//		this.m.Modifiers.Gathering = this.Const.LegendMod.ResourceModifiers.Gather[2];
//		this.m.Modifiers.Stash = this.Const.LegendMod.ResourceModifiers.Stash[1];
//		this.m.Modifiers.Ammo = this.Const.LegendMod.ResourceModifiers.Ammo[2];
//		this.m.Modifiers.Hunting = this.Const.LegendMod.ResourceModifiers.Hunting[2];
//		this.m.Modifiers.Training = this.Const.LegendMod.ResourceModifiers.Training[2];
//		this.m.Modifiers.Terrain = [
//			0.0, // ?
//			0.0, //ocean
//			0.0, //plains
//			0.0, //swamp
//			0.0, //hills
//			0.0, //forest
//			0.0, //forest
//			0.0, //forest_leaves
//			0.0, //autumn_forest
//			0.01, //mountains
//			0.0, // ?
//			0.0, //farmland
//			0.0, // snow
//			0.05, // badlands
//			0.0, //highlands
//			0.05, //steppes
//			0.0, //ocean
//			0.3, //desert
//			0.3 //oasis
//		];
//		this.m.PerkTreeDynamic = {
//			Weapon = [
//				this.Const.Perks.PolearmTree,
//				this.Const.Perks.SwordTree,
//				this.Const.Perks.ShieldTree,
//				this.Const.Perks.DaggerTree,
//				this.Const.Perks.CleaverTree,
//				this.Const.Perks.FistsTree,
//				this.Const.Perks.ThrowingTree
//			],
//			Defense = [
//				this.Const.Perks.MediumArmorTree,
//				this.Const.Perks.HeavyArmorTree
//			],
//			Traits = [
//				this.Const.Perks.ViciousTree,
//				this.Const.Perks.IndestructibleTree,
//				this.Const.Perks.AgileTree,
//				this.Const.Perks.LargeTree,
//				this.Const.Perks.FitTree
//			],
//			Enemy = [
//				this.Const.Perks.BeastTree
//			],
//			Class = [
//				this.Const.Perks.BeastClassTree
//			],
//			Profession = [],
//			Magic = [
//				this.Const.Perks.RangerHuntMagicTree
//			]
//		}
	}
		
//	function setGender( _gender = -1 )
//	{
//		if (_gender == -1) _gender = ::Legends.Mod.ModSettings.getSetting("GenderEquality").getValue() == "Disabled" ? 0 : ::Math.rand(0, 1);
//
//		if (_gender != 1) return;
//		if (this.m.Ethnicity == 1)
//		{
//			this.m.Faces = this.Const.Faces.SouthernFemale;
//			this.m.Hairs = this.Const.Hair.SouthernFemale;
//			this.m.HairColors = this.Const.HairColors.Young;
//			this.m.Bodies = this.Const.Bodies.SouthernFemaleMuscular;
//		}
//		else
//		{
//			this.m.Faces = this.Const.Faces.AfricanFemale;
//			this.m.Hairs = this.Const.Hair.SouthernFemale;
//			this.m.HairColors = this.Const.HairColors.African;
//			this.m.Bodies = this.Const.Bodies.AfricanFemaleMuscular;
//		}
//
//		this.m.Beards = null;
//		this.m.BeardChance = 0;
//		this.addBackgroundType(this.Const.BackgroundType.Female);
//	}

	function onBuildDescription()
	{
//		if(this.isBackgroundType(this.Const.BackgroundType.Female))
//		{
			return "{Вынужденный в детстве бороться с невозможными трудностями, %name% потряс всех, с одинаковой лёгкостью расправляясь как с гиенами, так и линдвурмами. Многие стекались посмотреть на великана, покрытого мускулами и шрамами, принеся ему богатство, достаточное, чтобы купить себе свободу и отправиться на север. Встретив со стороны северян лишь презрение, %name% отправился в пустоши, ища жарких схваток - и вот тогда, судьба свела вас, и вы завязали дружбу, которая, кажется, длится уже всю жизнь.}";
//		}
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 25)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 30)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				18,
				23
			],
			Bravery = [
				18,
				23
			],
			Stamina = [
				14,
				20
			],
			MeleeSkill = [
				4,
				8
			],
			RangedSkill = [
				11,
				16
			],
			MeleeDefense = [
				4,
				7
			],
			RangedDefense = [
				-8,
				-8
			],
			Initiative = [
				10,
				25
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
		local actor = this.getContainer().getActor();
//		this.m.Container.add(this.new("scripts/skills/traits/huge_trait"));
//		actor.getSkills().add(this.new("scripts/skills/traits/huge_trait"));
//		actor.getSkills().add(this.new("scripts/skills/actives/throw_dirt_skill"));
        if (!actor.getSkills().hasSkill("trait.huge"))
        {
            actor.getSkills().add(this.new("scripts/skills/traits/huge_trait"));
        }
        if (!actor.getSkills().hasSkill("actives.throw_dirt"))
        {
            actor.getSkills().add(this.new("scripts/skills/actives/throw_dirt_skill"));
        }
//		this.m.Container.add(this.new("scripts/skills/actives/throw_dirt_skill"));
//		this.m.Container.add(this.new("scripts/skills/perks/perk_legend_throw_sand"));
	}

	function onAddEquipment()
	{
//		local talents = this.getContainer().getActor().getTalents();
//		talents.resize(this.Const.Attributes.COUNT, 0);
//		talents[this.Const.Attributes.RangedSkill] = 2;
//		talents[this.Const.Attributes.Hitpoints] = 1;
//		this.getContainer().getActor().fillTalentValues(2, true);
		local items = this.getContainer().getActor().getItems();
		local r;

		if (items.hasEmptySlot(this.Const.ItemSlot.Mainhand))
		{
			local weapons = [
				"weapons/oriental/saif",
				"weapons/oriental/nomad_mace",
				"weapons/fighting_axe",
				"weapons/fighting_spear"
			];

			if (this.Const.DLC.Wildmen)
			{
				weapons.extend([
					"weapons/two_handed_flanged_mace",
					"weapons/bardiche"
				]);
			}

			items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		}

		if (items.hasEmptySlot(this.Const.ItemSlot.Offhand))
		{
			local offhand = [
				"tools/throwing_net"
			];
			items.equip(this.new("scripts/items/" + offhand[this.Math.rand(0, offhand.len() - 1)]));
		}

        local armor = this.new(::MSU.Class.WeightedContainer([
            [1, "scripts/items/armor/oriental/gladiator_harness"]
        ]).roll());
//        items.equip(this.new(armor));

		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			armor.setUpgrade(this.new("scripts/items/armor_upgrades/light_gladiator_upgrade"));
		}
		else if (r == 2)
		{
			armor.setUpgrade(this.new("scripts/items/armor_upgrades/heavy_gladiator_upgrade"));
		}
		items.equip(armor);

//		items.equip(this.Const.World.Common.pickHelmet([
//			[1, "oriental/gladiator_helmet", this.Math.rand(13, 15)],
//			[1, ""]
//		]));
        r = this.Math.rand(0, 1);
        if (r == 1)
        {
            local helmet = ::MSU.Class.WeightedContainer([
                [1, "scripts/items/helmets/oriental/gladiator_helmet"]
            ]).roll();
            items.equip(this.new(helmet));
        }
	}

});

