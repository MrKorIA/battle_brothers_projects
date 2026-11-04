this.xxherocrimson_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.xxherosp";
		this.m.Name = "Бархатный рыцарь";
		this.m.Icon = "ui/xxherocrimson_icon.png";
		this.m.BackgroundDescription = "О его прошлом мало что известно, но его боевые навыки, без сомнения, выдающиеся. [color=" + this.Const.UI.Color.NegativeValue + "](Предупреждение: этот персонаж не может использовать книги навыков.)[/color]";
		this.m.GoodEnding = "%name% ушел на пенсию из %companyname%. После ухода на пенсию он продолжил свою жизнь наемника и авантюриста, прославившись своими многочисленными подвигами, а его истории стали легендарными и передавались из поколения в поколение.";
		this.m.BadEnding = "%name% ушел на пенсию из %companyname%. С тех пор никто не слышал никаких новостей о %name%";
		this.m.HiringCost = 100000;
		this.m.DailyCost = 35;
		this.m.Excluded = [
			"trait.dumb",
			"trait.greedy",
			"trait.night_blind",
			"trait.short_sighted",
			"trait.superstitious",
			"trait.paranoid",
			"trait.disloyal",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.ailing",
			"trait.clubfooted",
			"trait.irrational",
			"trait.hesitant",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure",
			"trait.asthmatic"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.BeardChance = 50;
		this.m.Names = this.Const.Strings.KnightNames;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+1[/color] Очков действий"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] Урона"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] к Шансу попадания по голове"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] Урона сквозь броню"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] Урона Броне"
			}
		];
	}

	function onBuildDescription()
	{
		return "%name% Это сдержанный человек, который не любит много говорить о себе. Его прошлое неизвестно, но его боевые навыки заслуживают доверия. [color=" + this.Const.UI.Color.NegativeValue + "](Предупреждение: этот персонаж не может использовать книги навыков.)[/color]";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				10,
				10
			],
			Bravery = [
				10,
				10
			],
			Stamina = [
				10,
				10
			],
			MeleeSkill = [
				10,
				10
			],
			RangedSkill = [
				20,
				20
			],
			MeleeDefense = [
				5,
				5
			],
			RangedDefense = [
				5,
				5
			],
			Initiative = [
				10,
				10
			]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		actor.getSprite("accessory_special").setBrush("bust_militia_band_01");
		actor.getSprite("surcoat").setBrush("surcoat_04");
		actor.getSprite("surcoat").Saturation = 1.2;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		items.equip(this.new("scripts/items/helmets/named/xxdragonhat"));
		items.equip(this.new("scripts/items/armor/coat_of_scales"));
		items.equip(this.new("scripts/items/weapons/greatsword"));
		local sks = [
			"sb_flamewave_skill",
			"sb_firebomb_skill",
			"sb_heal_skill",
			"sb_command_skill",
			"sb_concent_skill",
			"sb_great_skill",
			"sb_march_skill",
			"sb_mark_skill"
		];
		sks = this.new("scripts/skills/actives/" + sks[this.Math.rand(0, sks.len() - 1)]);
		this.m.Container.add(sks);
		sks = [
			"perk_bags_and_belts",
			"perk_fortified_mind",
			"perk_steel_brow",
			"perk_hold_out",
			"perk_lone_wolf",
			"perk_underdog",
			"perk_fast_adaption",
			"perk_adrenalin",
			"perk_recover",
			"perk_rotation",
			"perk_footwork"
		];
		sks = this.new("scripts/skills/perks/" + sks[this.Math.rand(0, sks.len() - 1)]);
		this.m.Container.add(sks);
		this.m.Container.add(this.new("scripts/skills/perks/perk_nine_lives"));
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.ActionPoints += 1
		_properties.DamageTotalMult += 0.1;
		_properties.HitChance[this.Const.BodyPart.Head] += 10;
		_properties.DamageDirectAdd += 0.1;
		_properties.DamageArmorMult += 0.1;
	}

	function onDeath( _fatalityType )
	{
		this.getContainer().getActor().getSprite("surcoat").setBrush("");
		this.skill.onDeath( _fatalityType )
	}

});

