this.retired_gladiator_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.retired_gladiator";
		this.m.Name = "Отставной гладиатор";
		this.m.Icon = "ui/backgrounds/background_ret_gladiator.png";
		this.m.BackgroundDescription = "Приятно снова оказаться под открытым небом - пусть вы уже не тот первоклассный боец, каким были раньше, но вы всё ещё можете поставить на место любого меченосца, будь то в канаве, в пустыне или на виду у беснующейся толпы.";
		this.m.GoodEnding = "Прервав свой отдых, вы вновь прославились, напомнив новым поколениям о своей силе. Многие гладиаторы, кочевники и другие бойцы приходили поглазеть на ваше возрожденное мастерство. Вместе с ними пришёл безымянный историк с севера, убедивший вас потратить на него своё время и покрывавший пергамент описаниями ваших подвигов в течение нескольких сезонов. Вы вернулись домой, и старость снова настигла вас, когда вы пересказывали историку свои сражения и победы. Историк удалился, поблагодарив вас за уделённое время. Вы ничего не ответили ему, чувствуя, что конец близок. Вы забираетесь на кровать и смотрите в потолок, закрывая глаза и вспоминая тех, кого вы встретили в своем последнем путешествии. Вдалеке звучит рог арены... быть может, небольшой отдых поможет вам успокоиться?";
		this.m.BadEnding = "Зов толпы был слишком громок, чтобы забыть его, но вы встретили его с мыслями о былых, лучших временах. Застигнутый врасплох и, возможно, без должного везения, вы застряли далеко от дома в безымянном уголке земли. Собравшись с силами и проделав долгий путь обратно, вы смотрите на небо и стараетесь как можно ярче прожить последние мгновения, когда в глубине вашего сознания в последний раз звучит рог. Так вот каково это...";
		this.m.HiringCost = 10000000000;
		this.m.DailyCost = 0;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.fear_nobles",
			"trait.weasel",
			"trait.greedy",
			"trait.legend_fear_dark",
			"trait.sureshot",
			"trait.disloyal",
			"trait.survivor",
			"trait.night_blind",
			"trait.ailing",
			"trait.asthmatic",
			"trait.clubfooted",
			"trait.hesitant",
			"trait.loyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.deathwish",
			"trait.dastard",
			"trait.insecure"
		];

		this.m.Titles = [
			"Бывалый",
			"Седой",
			"Древний",
			"Старый",
			"Столетний",
			"Пожилой"
		];

		this.m.ExcludedTalents = [
			this.Const.Attributes.Fatigue
		];

		this.m.Ethnicity = this.Math.rand(1, 2);
//		if (this.m.Ethnicity == 1)
//		{
//			this.m.Bodies = this.Const.Bodies.Gladiator;
//			this.m.Faces = this.Const.Faces.SouthernMale;
//			this.m.Hairs = this.Const.Hair.SouthernMale;
//			this.m.HairColors = this.Const.HairColors.Old;
//			this.m.Beards = this.Const.Beards.Southern;
//			this.m.BeardChance = 60;
//		}
//		else
//		{
//			this.m.Bodies = this.Const.Bodies.AfricanGladiator;
//			this.m.Faces = this.Const.Faces.AfricanMale;
//			this.m.Hairs = this.Const.Hair.SouthernMale;
//			this.m.HairColors = this.Const.HairColors.Old;
//			this.m.Beards = this.Const.Beards.Southern;
//			this.m.BeardChance = 60;
//		}
        this.m.Bodies = this.Const.Bodies.Gladiator;
        this.m.Faces = this.Const.Faces.SouthernMale;
        this.m.Hairs = this.Const.Hair.SouthernMale;
        this.m.HairColors = this.Const.HairColors.Old;
        this.m.Beards = this.Const.Beards.Southern;
        this.m.BeardChance = 60;

		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
		this.m.Level = 3;
//		this.m.BackgroundType = this.Const.BackgroundType.Combat;
		this.m.IsCombatBackground = true;
//		this.m.Modifiers.ArmorParts = this.Const.LegendMod.ResourceModifiers.ArmorParts[1];
//		this.m.Modifiers.Stash = this.Const.LegendMod.ResourceModifiers.Stash[1];
//		this.m.Modifiers.Repair = this.Const.LegendMod.ResourceModifiers.Repair[1];
//		this.m.Modifiers.Salvage = this.Const.LegendMod.ResourceModifiers.Salvage[1];
//		this.m.Modifiers.Training = this.Const.LegendMod.ResourceModifiers.Training[3];
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
//				0.05, // badlands
//				0.05, //highlands
//				0.1, //steppes
//				0.0, //ocean
//				0.2, //desert
//				0.2 //oasis
//			];
//
//		this.m.PerkTreeDynamic = {
//			Weapon = [
//				this.Const.Perks.PolearmTree,
//				this.Const.Perks.SwordTree,
//				this.Const.Perks.ShieldTree,
//				this.Const.Perks.DaggerTree,
//				this.Const.Perks.CleaverTree,
//				this.Const.Perks.SpearTree,
//				this.Const.Perks.ThrowingTree
//			],
//			Defense = [
//				this.Const.Perks.LightArmorTree,
//				this.Const.Perks.MediumArmorTree
//			],
//			Traits = [
//				this.Const.Perks.ViciousTree,
//				this.Const.Perks.IndestructibleTree,
//				this.Const.Perks.AgileTree,
//				this.Const.Perks.LargeTree,
//				this.Const.Perks.FitTree,
//				this.Const.Perks.MartyrTree
//			],
//			Enemy = [
//				this.Const.Perks.SwordmastersTree
//			],
//			Class = [
//				this.Const.Perks.BeastClassTree
//			],
//			Profession = [],
//			Magic = [
//				this.Const.Perks.ImmortalMagicTree,
//				this.Const.Perks.RetiredGladiatorTree
//			]
//		}
	}

	function getTooltip()
	{
		local ret = this.character_background.getTooltip()
		ret.push(
			{
				id = 13,
				type = "text",
				icon = "ui/icons/health.png",
				text = "При потере ОЗ проверка боевого духа не проводится"
			}
		)
		return ret
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
//			this.m.HairColors = this.Const.HairColors.Old;
//			this.m.Bodies = this.Const.Bodies.SouthernFemaleMuscular;
//		}
//		else
//		{
//			this.m.Faces = this.Const.Faces.AfricanFemale;
//			this.m.Hairs = this.Const.Hair.SouthernFemale;
//			this.m.HairColors = this.Const.HairColors.Old;
//			this.m.Bodies = this.Const.Bodies.AfricanFemaleMuscular;
//		}
//
//		this.m.Beards = null;
//		this.m.Names = this.Const.Strings.SouthernFemaleNames;
//		this.m.BeardChance = 0;
//		this.addBackgroundType(this.Const.BackgroundType.Female);
//	}

	function onBuildDescription()
	{
//		if (this.isBackgroundType(this.Const.BackgroundType.Female))
//		{
			return "{Приятно снова оказаться под открытым небом - пусть вы уже не тот первоклассный боец, каким были раньше, но вы всё ещё можете поставить на место любого меченосца, будь то в канаве, в пустыне или на виду у беснующейся толпы.}";
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
				5,
				8
			],
			Bravery = [ //will get +10 from avatar
				7,
				9
			],
			Stamina = [
				0,
				4
			],
			MeleeSkill = [
				12,
				15
			],
			RangedSkill = [
				7,
				12
			],
			MeleeDefense = [
				10,
				14
			],
			RangedDefense = [
				4,
				6
			],
			Initiative = [
				10,
				15
			]
		};
		return c;
	}

	function onAdded()
	{
//		if (this.m.IsNew)
//            ::Legends.Traits.grant(this, ::Legends.Trait.Old);
//            ::Legends.Actives.grant(this, ::Legends.Active.ThrowDirt);
		this.character_background.onAdded();
		local actor = this.getContainer().getActor();
        if (!actor.getSkills().hasSkill("actives.throw_dirt"))
        {
            actor.getSkills().add(this.new("scripts/skills/actives/throw_dirt_skill"));
        }
        if (!actor.getSkills().hasSkill("trait.old"))
        {
            actor.getSkills().add(this.new("scripts/skills/traits/old_trait"));
        }
	}

	function onAddEquipment()
	{
//		local talents = this.getContainer().getActor().getTalents();
//		talents.resize(this.Const.Attributes.COUNT, 0);
//		talents[this.Const.Attributes.Bravery] = 2;
//		talents[this.Const.Attributes.MeleeSkill] = 3;
//		this.getContainer().getActor().fillTalentValues(2, true);
		local items = this.getContainer().getActor().getItems();
		local r;

		if (items.hasEmptySlot(this.Const.ItemSlot.Mainhand))
		{
			local weapons = [
				"weapons/oriental/saif",
//				"weapons/legend_reinforced_flail",
				"weapons/ancient/warscythe",
				"weapons/oriental/nomad_mace",
//				"weapons/legend_swordstaff",
				"weapons/oriental/polemace",
				"weapons/fighting_axe",
				"weapons/fighting_spear",
				"weapons/two_handed_flail",
				"weapons/two_handed_flanged_mace",
				"weapons/bardiche"
			];

			items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		}

		if (items.hasEmptySlot(this.Const.ItemSlot.Offhand))
		{
			local offhand = [
				"tools/throwing_net",
				"shields/oriental/metal_round_shield"
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

//		local a = this.Const.World.Common.pickArmor([
//			[1, "oriental/gladiator_harness"]
//		]);
//
//		r = this.Math.rand(1, 2);
//
//		if (r == 1)
//		{
//			a.setUpgrade(this.new("scripts/items/legend_armor/armor_upgrades/legend_light_gladiator_upgrade"));
//		}
//		else if (r == 2)
//		{
//			a.setUpgrade(this.new("scripts/items/legend_armor/armor_upgrades/legend_heavy_gladiator_upgrade"));
//		}
//		items.equip(a);
//
//		items.equip(this.Const.World.Common.pickHelmet([
//			[1, ""]
//		]));

	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.IsAffectedByLosingHitpoints = false;
	}

});

