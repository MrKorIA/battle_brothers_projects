this.pit_fighter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create(); //—
		this.m.ID = "background.pit_fighter";
		this.m.Name = "Новобранец арены";
		this.m.Icon = "ui/backgrounds/background_pitfighter.png";
		this.m.BackgroundDescription = "Особенно жестокими бойцами часто становятся невезучие рабы, которых отбирают вручную, чтобы они могли стать гладиаторами и, соответственно, оплатить свой путь к свободе.";
		this.m.GoodEnding = "%name% потерял цель в жизни после вашего ухода, когда вы перестали вести его за собой, ему потребовалось несколько месяцев, чтобы пережить случившееся. В конце концов он основал легальную школу гладиаторов, в которую принимали рабов и угнетённых, желающих бороться за лучшую жизнь. Школа эта стала знаменитой во всех краях земли, и брали в неё как как высокородных, так и простолюдинов.";
		this.m.BadEnding = "%name% знал, что умрёт не в своей постели. Однако то, как он умер, стало для многих неожиданностью. После вашего ухода, гордый гладиатор наконец отпустил все ужасы этого мира, решив покончить с собой. %name% привык гнуться, а не ломаться, но даже у самой крепкой стали есть пределы прочности.";
		this.m.HiringCost = 10000000000;
		this.m.DailyCost = 28;
		this.m.Excluded = [
			"trait.gluttonous",
			"trait.lucky",
			"trait.cocky",
			"trait.fat",
			"trait.fearless",
			"trait.drunkard",
			"trait.determined",
			"trait.greedy",
			"trait.hate_undead",
			"trait.hate_greenskins",
			"trait.light",
			"trait.slack"
		];
		this.m.Titles = [
			"Порабощённый",
			"Пленник",
			"Неудачник",
			"Непрощённый",
			"Порабощённый",
			"Преступник",
			"Покорный",
			"Скованный",
			"Связанный"
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
		this.m.Level = 3;

		this.m.IsCombatBackground = true;
//		this.m.BackgroundType = this.Const.BackgroundType.Combat;
//		this.m.Modifiers.ArmorParts = this.Const.LegendMod.ResourceModifiers.ArmorParts[1];
//		this.m.Modifiers.Salvage = this.Const.LegendMod.ResourceModifiers.Salvage[1];
//		this.m.Modifiers.Training = this.Const.LegendMod.ResourceModifiers.Training[3];
//		this.m.Modifiers.Stash = this.Const.LegendMod.ResourceModifiers.Stash[2];
//		this.m.Modifiers.Hunting = this.Const.LegendMod.ResourceModifiers.Hunting[1];
//		this.m.Modifiers.Terrain =  [
//				0.0, // ?
//				0.0, //ocean
//				0.0, //plains
//				0.0, //swamp
//				0.01, //hills
//				0.01, //forest
//				0.01, //forest
//				0.0, //forest_leaves
//				0.0, //autumn_forest
//				0.01, //mountains
//				0.0, // ?
//				0.01, //farmland
//				0.0, // snow
//				0.0, // badlands
//				0.0, //highlands
//				0.0, //stepps
//				0.0, //ocean
//				0.01, //desert
//				0.01 //oasis
//			];
//		this.m.PerkTreeDynamic = {
//			Weapon = [
//				this.Const.Perks.PolearmTree,
//				this.Const.Perks.SwordTree,
//				this.Const.Perks.MaceTree,
//				this.Const.Perks.CleaverTree,
//				this.Const.Perks.ThrowingTree,
//				this.Const.Perks.DaggerTree,
//				this.Const.Perks.ShieldTree,
//				this.Const.Perks.FistsTree
//			],
//			Defense = [
//				this.Const.Perks.HeavyArmorTree,
//				this.Const.Perks.MediumArmorTree
//			],
//			Traits = [
//				this.Const.Perks.ViciousTree,
//				this.Const.Perks.SturdyTree,
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
//			Magic = []
//		}
	}
//
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
//		if(this.isBackgroundType(this.Const.BackgroundType.Female)) //—
//		{
//
//		return "{%name% любила своего отца, он был известным художником и инженером. А ещё он ни дня не мог прожить без выпивки. | Её происхождение остается загадкой: одни говорят, что %name% была разбойницей и любовницей местного принца, иные утверждают, что она была обычной воровкой. | У неё было тяжёлое детство, и в конце концов отец продал её мужчине много старше себя. Судя по шрамам и характеру, всё прошло как нельзя лучше. | Говорят, что когда-то она была принцессой, однако связь с женщиной привела к тому, что %name% оказалась в самой глубокой и тёмной дыре, какую только смогла найти её семья.} {С тех пор она сражается и выживает в этих краях, иногда в полной броне, а иногда и вовсе без неё. Она остается рабыней хозяина, которого никогда не встречала и не слышала его имени. | В какой-то момент она стала частью преступного мира, и с тех пор прекрасно знает нужные места и людей, способных продать вам недорогие оружие и доспехи, которые 'просто выпали из телеги'. | Шрамы и рубцы покрывают её руки, лицо и ноги, но, похоже, ни один из них не был настолько болезненным, чтобы она сдалась и отпустила свою жизнь. | %name% обрела великое мастерство в искусстве ожидания и ничегонеделания. Когда она бездействует, то часто считает камни в стене или каждый булыжник на дороге. Работа наёмника ей очень подходит.} {В то время как годы пренебрежения и случайных пыток ослабляют дух и телосложение обычного раба, таких бойцов как %name% всегда кормят лучшей едой и поддерживают в боевой форме, чтобы не разочаровать толпу. | Для неё неважно, какому хозяину она служит - все они одинаковы. Но %name% ясно дала понять, что если кто-то прикоснётся к ней, то лишиться глаз. Что вполне объяснимо. | Она не против сразиться со зверем или человеком, но открытые пространства за пределами арены заставляют её заметно нервничать.}";
//		}
//		else
//		{

		return "{%name% увяз в долгах, и в конце концов ему пришлось продавать свой труд тем, кому он задолжал. Поначалу работа была простой: «отнеси это, иди сюда» и так далее. Однако задания усложнялись, и со временем он дошёл до того, что мог ограбить арсенал ополчения или убить путников на дороге. | Мать родила его в бараке среди других рабов, и за пределами боевых ям он не знал ничего. С детства его учили убивать и быть убитым на арене. | По какой-то причине, известной лишь ему самому, %name% добровольно стал рабом. Он нарочно ввязывался в неприятности и выставлял напоказ боевые навыки, чтобы хозяин заметил его, повысил и позволил сражаться от своего имени.} {С тех пор, как он впервые вышел на арену, прошли годы, и из обычного человека он превратился в прирождённого бойца — благодаря тревожному пренебрежению к собственной безопасности. | Он уже некоторое время дрался в ямах, однажды задушив гиену ногой и проломив другому рабу череп камнем. | В прошлом сезоне арена, где он дрался, чуть не сгорела из-за восстания рабов. Когда новобранцы подавили бунт и потушили огонь, они обнаружили, что %name% преспокойно лежит на своей койке и предаётся мечтам. Возможно, он был слишком глуп, чтобы уйти, или достаточно умён, чтобы понимать, что далеко не уйдёт.} {Ему нравилась арена, но идея свободы и собственного кусочка богатства вывела его из привычной жизни в бескрайний мир. | Хотя на арене у него всё шло хорошо, он смутно представлял себе конечную цель и не ожидал, что всё зайдёт так далеко. | Мир за пределами арены оказался не таким, как он ожидал, но, как и все, он научится справляться. В конце концов, здесь меньше правил.}";
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
				9
			],
			Bravery = [
				-5,
				0
			],
			Stamina = [
				10,
				15
			],
			MeleeSkill = [
				3,
				5
			],
			RangedSkill = [
				3,
				6
			],
			MeleeDefense = [
				-2,
				-4
			],
			RangedDefense = [
				-3,
				-5
			],
			Initiative = [
				5,
				5
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
		local actor = this.getContainer().getActor();
        if (!actor.getSkills().hasSkill("actives.throw_dirt"))
        {
            actor.getSkills().add(this.new("scripts/skills/actives/throw_dirt_skill"));
        }
//		actor.getSkills().add(this.new("scripts/skills/actives/throw_dirt_skill"));
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
					"weapons/two_handed_flail",
					"weapons/two_handed_flanged_mace",
					"weapons/bardiche"
				]);
			}

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

