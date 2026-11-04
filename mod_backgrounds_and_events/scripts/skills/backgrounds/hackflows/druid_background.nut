this.druid_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
		Tattoo = 0
	},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_druid";
		this.m.Name = "Друид";
		this.m.Icon = "ui/backgrounds/background_druid.png";
		this.m.BackgroundDescription = "Друиды - это люди, более чуткие к мистическим силам, чем обычные смертные.";
		this.m.GoodEnding = "Устав от постоянных сражений, %name%, бывший нищий, ушел из %companyname%. Вы знаете, что человек неплохо заработал за время службы в наемной роте, но на днях вы снова увидели его попрошайничающим. Вы спросили, не потратил ли он все свои деньги, и он рассмеялся. Он сказал, что купил землю и у него все отлично. Затем он протянул свою жестянку и попросил монетку. Вы дали ему две.";
		this.m.BadEnding = "Жизнь наемника сурова, и %name%, бывший нищий, счел за благо уйти из нее, пока она не стала смертельной. К сожалению, он вернулся к попрошайничеству. Говорят, какой-то дворянин очистил город от отбросов и отправил их на север, несмотря на зиму. Замерзший и голодный, %name% умер на обочине дороги, с примерзшей к пальцу жестяной кружкой.";
		this.m.HiringCost = 330;
		this.m.DailyCost = 14;
		this.m.Excluded = [
			"trait.ailing",
			"trait.asthmatic",
			"trait.bleeder",
			"trait.brute",
			"trait.cocky",
			"trait.craven",
			"trait.dumb",
			"trait.fat",
			"trait.fear_beasts",
			"trait.gluttonous",
			"trait.greedy",
			"trait.hate_beasts",
			"trait.night_blind",
			"trait.short_sighted",
			"trait.teamplayer",
			"trait.impatient"
		];
		this.m.Titles = [
			"Друид",
			"Мистик",
			"Таинственный",
			"Дух природы",
			"Каналья",
			"Таинственный"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.WildMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Wild;
		this.m.BeardChance = 100;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(1, 2);
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
			}
		];
	}

	function onBuildDescription()
	{
		return "{Татуировки и руны, покрывающие тело друида %name%, делают его весьма примечательным в городе. Выросший в диких землях, но не чуждый манерам цивилизованного человека, %name% хранит своё прошлое в тайне. Он рассказывает, что ищет работу наёмника, поскольку друидическое пророчество предрекло, что однажды братство воинов встретится с полчищами невиданных ужасов. Вы не уверены, стоит ли его нанимать; в любом случае, его слова глубоко тревожат.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [5, 5]
			Bravery = [6, 6]
			Stamina = [0, 5]
			MeleeSkill = [0, 0]
			RangedSkill = [0, 0]
			MeleeDefense = [0, 0]
			RangedDefense = [0, 0]
			Initiative = [0, 0]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local dirt = actor.getSprite("dirt");
		dirt.Visible = true;
		this.m.Tattoo = this.Math.rand(0, 1);
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");
		local body = actor.getSprite("body");
		tattoo_body.setBrush((this.m.Tattoo == 0 ? "warpaint_01_" : "scar_02_") + body.getBrush().Name);
		tattoo_body.Visible = true;
		tattoo_head.setBrush(this.m.Tattoo == 0 ? "warpaint_01_head" : "scar_02_head");
		tattoo_head.Visible = true;
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush((this.m.Tattoo == 0 ? "warpaint_01_" : "scar_02_") + body.getBrush().Name);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/greenskins/goblin_staff"));
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
	}

	function onSerialize( _out )
	{
		this.character_background.onSerialize(_out);
		_out.writeU8(this.m.Tattoo);
	}

	function onDeserialize( _in )
	{
		this.character_background.onDeserialize(_in);
		this.m.Tattoo = _in.readU8();
	}

});

