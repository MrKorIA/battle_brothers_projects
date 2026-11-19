this.nggh_mod_blessed_effect <- ::inherit("scripts/skills/skill", {
	m = {
		DayLefts = 3,
	},
	function create()
	{
		this.m.ID = "effects.blessed_effect";
		this.m.Name = "Благословение";
		this.m.Description = "В награду за проделанную работу вы чувствуете себя лучше, чем когда-либо.";
		this.m.Icon = "skills/status_effect_73.png";
		this.m.IconMini = "status_effect_73_mini";
		this.m.Type = ::Const.SkillType.Trait;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
	}

	function isTreated()
	{
		return true;
	}
	
	function getDescription()
	{
		return this.m.Description + "Эффект проходит в течение " + this.m.DayLefts + " дней.";
	}

	function getTooltip()
	{
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
				id = 13,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+5%[/color] к решимости"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+5%[/color] к инициативе"
			},
		];
		
		return ret;
	}

	function onNewDay()
	{
		if (--this.m.DayLefts <= 0)
		{
			this.removeSelf();
		}
	}

	function onUpdate( _properties )
	{
		_properties.BraveryMult *= 1.05;
		_properties.InitiativeMult *= 1.05;
	}
	
	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU16(this.m.DayLefts);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.DayLefts = _in.readU16();
	}

});

