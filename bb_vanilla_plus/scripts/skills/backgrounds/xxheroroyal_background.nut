this.xxheroroyal_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.xxheroroyal";
		this.m.Name = "Королевская кровь";
		this.m.Icon = "ui/traits/trait_icon_37.png";
		this.m.BackgroundDescription = "Люди с королевской кровью обычно имеют высокий статус и большой авторитет. Некоторые члены королевской семьи иногда становятся наемниками из-за собственных амбиций или удовольствия.";
		this.m.GoodEnding = "%name% начал войну за престолонаследие, собрав своих солдат на основе опыта и наемнических навыков, приобретенных в %companyname%. В конце концов он достиг своей цели занять трон, сражаясь и убеждая великих вельмож.";
		this.m.BadEnding = "%name% ушел на пенсию из %companyname%. После ухода на пенсию он был убит наемным убийцей, посланным другой королевской семьей.";
		this.m.HiringCost = 10000;
		this.m.DailyCost = 35;
		this.m.Excluded = [
			"trait.survivor",
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
		this.m.ExcludedTalents = [
			this.Const.Attributes.RangedSkill
		];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Thick;
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
				id = 3,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт [color=" + this.Const.UI.Color.PositiveValue + "]300[/color] крон за победу в битве"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт [color=" + this.Const.UI.Color.PositiveValue + "]20[/color] крон за убийство людей."
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=#8f1e1e]Помеха:[/color] Дальнобойные навыки всегда равны 0. Атака цели на расстоянии 2 и более плиток всегда приводит к промаху"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=#8f1e1e]Когда умирает:[/color] Отряд теряет 10.000 крон, получает вражду с случайным благородным домом."
			}
		];
	}

	function onBuildDescription()
	{
		return "%name% является членом королевской семьи, происходит из знатной родословной. [color=" + this.Const.UI.Color.NegativeValue + "][/color]";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				0,
				0
			]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local coat_type = [
			"01",
			"02",
			"03",
			"06",
			"07",
			"08",
			"09",
			"10"
		];
		actor.getSprite("surcoat").setBrush("bust_body_noble_" + coat_type[this.Math.rand(0, coat_type.len() - 1)]);
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		items.equip(this.new("scripts/items/helmets/greatsword_hat"));
		items.equip(this.new("scripts/items/armor/noble_tunic"));
		items.equip(this.new("scripts/items/weapons/arming_sword"));
		this.m.Container.add(this.new("scripts/skills/actives/sb_bribe_skill"));
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.SurviveWithInjuryChanceMult *= 0;
		_properties.TargetAttractionMult *= 1.5;
		_properties.RangedSkill *= 0;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null)
		{
			return;
		}
		if (_skill.isAttack())
		{
			local d = this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile());
			if (d != 1)
			{
				_properties.MeleeSkill *= 0;
			}
		}
	}

	function onCombatFinished()
	{
		if (!this.getContainer().getActor().isPlacedOnMap() || !this.getContainer().getActor().isAlive())
		{
			return false;
		}
		local actor = this.getContainer().getActor();
		local gg = 0;
		local actors = this.Tactical.Entities.getAllInstances();
		foreach( i in actors )
		{
			foreach( a in i )
			{
				if (!a.isAlliedWith(actor))
				{
					gg = 1;
					break;
				}
			}
		}
		if (gg == 0)
		{
			this.World.Assets.addMoney(300 / 2);
		}
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (_targetEntity.getFlags().has("human"))
		{
			this.World.Assets.addMoney(20);
		}
	}

	function onDeath( _fatalityType )
	{
		this.getContainer().getActor().setFaction(this.Const.Faction.Player);
		this.getContainer().getActor().getSprite("surcoat").setBrush("");
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local noblehouse = nobles[this.Math.rand(0, nobles.len() - 1)];
		if (noblehouse != null)
		{
			noblehouse.addPlayerRelation(-100.0, "Вас считают предателями");
		}
		if (this.World.Assets.getMoney() >= 10000)
		{
			this.World.Assets.addMoney(-10000);
		}
		else
		{
			this.World.Assets.addMoney(-this.World.Assets.getMoney());
		}
		this.skill.onDeath( _fatalityType );
	}

});

