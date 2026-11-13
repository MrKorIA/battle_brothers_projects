this.xxi_female_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.female_villager";
		this.m.Name = "Селянка";
		this.m.Icon = "ui/backgrounds/backgrounds_housemaid.png";
		this.m.HiringCost = 50;
		this.m.DailyCost = 5;
		this.m.Excluded = [];
		this.m.Titles = [];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = null;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 0;
		this.m.Names = this.Const.Strings.CharacterNamesFemale;
		this.m.IsLowborn = true;
		this.m.GoodEnding = "%name% ушла на пенсию из %companyname%. A после выхода она поселилась в маленьком городке. Говорят, что там она вернулась к жизни обычной женщины и жила счастливо.";
		this.m.BadEnding = "%name% ушла на пенсию из %companyname%. С тех пор никто не слышал никаких новостей о %name%";
	}

    function getTooltip()
    {
        return [
            {
                id = 1,
                type = "title",
                text = this.getName()
            }
            {
                id = 2,
                type = "description",
                text = this.getDescription()
            }
            {
                id = 10,
                type = "text",
                icon = "ui/icons/morale.png",
                text = "Селянка не рвется в бой и не получает штрафа от прибывания в резерве."
            }
        ];
    }

    function onUpdate( _properties )
    {
    	this.character_background.onUpdate(_properties);

		_properties.IsContentWithBeingInReserve = true;
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
				15,
				10
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
		local xbody = actor.getSprite("body");
		local xhead = actor.getSprite("head");
		local xhair = actor.getSprite("hair");
		local xtattoo_head = actor.getSprite("tattoo_head");
		xbody.setBrush("bust_naked_body_78" + this.Math.rand(69, 70));
		xhead.setBrush("bust_head_787" + this.Math.rand(0, 1));
		xhair.setBrush("hair_black_787" + this.Math.rand(0, 6));
		if (this.Math.rand(0, 3) == 0)
		{
			if (this.Math.rand(0, 1) == 0)
			{
				xtattoo_head.setBrush("bust_head_pox_01");
			}
			else
			{
				xtattoo_head.setBrush("bust_head_darkeyes_01");
			}
		}
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

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		items.equip(this.new("scripts/items/armor/vp_dress"));
	}

});

