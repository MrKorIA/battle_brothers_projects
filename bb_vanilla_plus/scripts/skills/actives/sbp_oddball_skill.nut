this.sbp_oddball_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_oddball_skill";
		this.m.Name = "97. Чудак (пассивный)";
		this.m.Icon = "ui/xxp10.png";
		this.m.Description = "+10% урона за каждый из следующих перков: \n#Устойчивость, #Стальные брови, #Удар в спину, #Предвидение, #Неумолимость, #Дразнить, #Преимущество в дальности, #Подавлять, #Одинокий волк, #Охотник за головами";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast + 100;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
		this.m.IsHidden = false;
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
			}
		];
		return ret;
	}

	function onUpdate( _properties )
	{
		local rr = 0;
		local bb = 0.1;
		local actor = this.getContainer().getActor();
		local tss = actor.getSkills();
		if (tss.hasSkill("perk.hold_out"))
		{
			rr = rr + bb;
		}
		if (tss.hasSkill("perk.steel_brow"))
		{
			rr = rr + bb;
		}
		if (tss.hasSkill("perk.backstabber"))
		{
			rr = rr + bb;
		}
		if (tss.hasSkill("perk.anticipation"))
		{
			rr = rr + bb;
		}
		if (tss.hasSkill("perk.relentless"))
		{
			rr = rr + bb;
		}
		if (tss.hasSkill("perk.taunt"))
		{
			rr = rr + bb;
		}
		if (tss.hasSkill("perk.reach_advantage"))
		{
			rr = rr + bb;
		}
		if (tss.hasSkill("perk.overwhelm"))
		{
			rr = rr + bb;
		}
		if (tss.hasSkill("perk.lone_wolf"))
		{
			rr = rr + bb;
		}
		if (tss.hasSkill("perk.head_hunter"))
		{
			rr = rr + bb;
		}
		_properties.DamageTotalMult += rr;
	}

});

