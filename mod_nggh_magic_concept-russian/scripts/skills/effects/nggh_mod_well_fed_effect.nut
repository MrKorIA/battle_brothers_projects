this.nggh_mod_well_fed_effect <- ::inherit("scripts/skills/skill", {
	m = {
		BonusType = 0,
	},
	function create()
	{
		this.m.ID = "effects.well_fed";
		this.m.Name = "Сытый";
		this.m.Icon = "skills/status_effect_well_fed.png";
		this.m.IconMini = "status_effect_well_fed_mini";
		this.m.Overlay = "status_effect_well_fed";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = true;
		this.m.IsStacking = true;
		this.m.IsActive = false;

		// get random bonus
		this.m.BonusType = ::Math.rand(0, this.getAvailableBonus().len() - 1);
	}

	function getDescription()
	{
		return "Съев столько трупов, этот персонаж доволен своей жизнью, но всё ещё готов к любой битве, а также ест меньше 'обычной еды'. Эффект длится до следующей битвы.";
	}

	function getTooltip()
	{
		local data = this.getAvailableBonus()[this.m.BonusType];
		local value = (data[3] - 1.0) * 100;
		local ret = [
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
				icon = "ui/icons/asset_daily_food.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]-25%[/color] от ежедневного потребления пищи"
			}
		];

		if (value > 0)
		{
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/icons/" + data[2] + ".png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + value + "%[/color]" + data[1]
			})
		}
		else
		{
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/icons/" + data[2] + ".png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]" + value + "%[/color]" + data[1]
			})
		}

		return ret;
	}

	function getAvailableBonus()
	{
		return [
			["ActionPointsMult",          "к максимальным ОД", "action_points", 1.25],
			["StaminaMult",               "к максимальной выносливости",      "fatigue"      , 1.25],
			["BraveryMult",               "к решимости",          "bravery"      , 1.25],
			["InitiativeMult",            "к инициативе",       "initiative"   , 1.25],
			["MeleeSkillMult",            "к навыку ближнего боя",      "melee_skill"  , 1.25],
			["MeleeDefenseMult",          "к защите в ближнем бою",    "melee_defense", 1.25],
			["MeleeDamageMult",           "к урону в ближнем бою",     "damage_dealt" , 1.25],
			["DamageReceivedRegularMult", "к получаемому урону",     "sturdiness"   , 0.75],
			["XPGainMult",                "к получаемому опыту",  "xp_received"  , 1.25],
		];
	}

	function onUpdate( _properties )
	{
		local data = this.getAvailableBonus()[this.m.BonusType];
		_properties[data[0]] *= data[3];
	}

	function onAfterUpdate( _properties )
	{
		// eat less on world map
		_properties.DailyFood = ::Math.max(1, _properties.DailyFood * 0.75);
	}

	function onSerialize( _out )
	{
		_out.writeU8(this.m.BonusType);
	}

	function onDeserialize( _in )
	{
		this.m.BonusType = _in.readU8();
	}

});

