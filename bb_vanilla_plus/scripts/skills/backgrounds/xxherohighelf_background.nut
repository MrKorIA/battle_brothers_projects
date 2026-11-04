this.xxherohighelf_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.xxherosp";
		this.m.Name = "Высший эльф";
		this.m.Icon = "ui/xxherohighelf_icon.png";
		this.m.BackgroundDescription = "Высшие эльфы — самая древняя и чистая линия древних эльфийских рас. [color=" + this.Const.UI.Color.NegativeValue + "][/color]";
		this.m.GoodEnding = "%name% ушел на пенсию из %companyname%. После ухода на пенсию она продолжила свою жизнь в качестве наемника и авантюриста, прославившись своими многочисленными подвигами, а ее история стала легендарной и передается из поколения в поколение.";
		this.m.BadEnding = "%name% ушел на пенсию из %companyname%. С тех пор никто не слышал никаких новостей о %name%";
		this.m.HiringCost = 10000;
		this.m.DailyCost = 35;
		this.m.Excluded = [
			"trait.dumb",
			"trait.greedy",
			"trait.night_blind",
			"trait.short_sighted",
			"trait.superstitious",
			"trait.paranoid",
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
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = null;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 0;
		this.m.Names = this.Const.Strings.AncientDeadNames;
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
				id = 3,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=#135213]+20%[/color] к Урону в дальнем бою"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=#135213]+2[/color] к Обзору"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=#135213]+5[/color] к регенерации выносливости каждый ход"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Когда убивает врага: [color=#135213]+2[/color] ОД, [color=#135213]-10[/color] выносливости (не более 9 ОД)"
			}
		];
	}

	function onBuildDescription()
	{
		return "%name% является высоким эльфом, принадлежащим к самой древней и чистой линии древних эльфийских рас. [color=" + this.Const.UI.Color.NegativeValue + "][/color]";
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
				25,
				25
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
				15,
				15
			]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local xbody = actor.getSprite("body");
		local xhead = actor.getSprite("head");
		local xhair = actor.getSprite("hair");
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");
		xbody.setBrush("bust_naked_body_78" + this.Math.rand(69, 70));
		xhead.setBrush("bust_head_787" + this.Math.rand(0, 1));
		xhair.setBrush("hair_elf_0" + this.Math.rand(1, 6));
		local pp = this.Math.rand(0, 3)
		if (pp == 1)
		{
			tattoo_body.setBrush("warpaint_01_" + actor.getSprite("body").getBrush().Name);
			tattoo_body.Visible = true;
			tattoo_head.setBrush("warpaint_01_head");
			tattoo_head.Visible = true;
		}
		else
		if (pp == 2)
		{
			tattoo_body.setBrush("tattoo_02_" + actor.getSprite("body").getBrush().Name);
			tattoo_body.Visible = true;
			tattoo_head.setBrush("tattoo_02_head");
			tattoo_head.Visible = true;
		}
		tattoo_body.Scale = 0.8;
		actor.getSprite("permanent_injury_4").setBrush("zombie_rage_eyes");
		actor.getSprite("permanent_injury_4").Visible = true;
		actor.getSprite("permanent_injury_4").Color = this.createColor("#ffffff");
		actor.getSprite("permanent_injury_4").Saturation = 0.3;
		actor.setSpriteOffset("permanent_injury_4", this.createVec(0, -0.9));
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		items.equip(this.new("scripts/items/armor/named/named_sellswords_armor"));
		items.equip(this.new("scripts/items/weapons/war_bow"));
		items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		items.addToBag(this.new("scripts/items/weapons/dagger"));
		local sks = [
			"sb_fonature_skill",
			"sb_electric_skill",
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

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();
		actor.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/fantasyfemale/fantasyfemale_light_01.wav",
			"sounds/fantasyfemale/fantasyfemale_light_02.wav",
			"sounds/fantasyfemale/fantasyfemale_light_03.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/fantasyfemale/fantasyfemale_injury_01.wav",
			"sounds/fantasyfemale/fantasyfemale_injury_02.wav",
			"sounds/fantasyfemale/fantasyfemale_injury_03.wav",
			"sounds/fantasyfemale/fantasyfemale_injury_04.wav",
			"sounds/fantasyfemale/fantasyfemale_injury_05.wav",
			"sounds/fantasyfemale/fantasyfemale_injury_06.wav",
			"sounds/fantasyfemale/fantasyfemale_injury_07.wav",
			"sounds/fantasyfemale/fantasyfemale_injury_08.wav",
			"sounds/fantasyfemale/fantasyfemale_injury_09.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/fantasyfemale/fantasyfemale_death_01.wav",
			"sounds/fantasyfemale/fantasyfemale_death_02.wav",
			"sounds/fantasyfemale/fantasyfemale_death_03.wav",
			"sounds/fantasyfemale/fantasyfemale_death_04.wav",
			"sounds/fantasyfemale/fantasyfemale_death_05.wav",
			"sounds/fantasyfemale/fantasyfemale_death_06.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/fantasyfemale/fantasyfemale_fatigue_01.wav",
			"sounds/fantasyfemale/fantasyfemale_fatigue_02.wav",
			"sounds/fantasyfemale/fantasyfemale_fatigue_03.wav",
			"sounds/fantasyfemale/fantasyfemale_fatigue_04.wav",
			"sounds/fantasyfemale/fantasyfemale_fatigue_05.wav",
			"sounds/fantasyfemale/fantasyfemale_fatigue_06.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/fantasyfemale/fantasyfemale_flee_01.wav",
			"sounds/fantasyfemale/fantasyfemale_flee_02.wav",
			"sounds/fantasyfemale/fantasyfemale_flee_03.wav",
			"sounds/fantasyfemale/fantasyfemale_flee_04.wav"
		];
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 1.0;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.NoDamageReceived] = 1.0;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 1.0;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Fatigue] = 1.0;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Flee] = 1.0;
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.RangedDamageMult += 0.2;
		_properties.FatigueRecoveryRate += 5;
		_properties.HitpointsRecoveryRate += 4;
		_properties.Vision += 2;
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
//		actor.setHitpoints(this.Math.min(actor.getHitpointsMax(), actor.getHitpoints() + 1));
		actor.setDirty(true);
		actor.onUpdateInjuryLayer();
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		local actor = this.getContainer().getActor();
		if (actor.isAlliedWith(_targetEntity))
		{
			return;
		}
		if (this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == actor.getID())
		{
			actor.setActionPoints(this.Math.min(actor.getActionPointsMax(), actor.getActionPoints() + 2));
			actor.setFatigue(this.Math.max(0, actor.getFatigue() - 10));
			this.spawnIcon("status_effect_29", this.m.Container.getActor().getTile());
			actor.setDirty(true);
		}
	}

});

