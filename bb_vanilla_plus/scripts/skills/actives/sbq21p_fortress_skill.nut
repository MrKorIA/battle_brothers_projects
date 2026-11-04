this.sbq21p_fortress_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbq21p_fortress_skill";
		this.m.Name = "128. Living Fortress (passive)";
		this.m.Icon = "ui/xxp39.png";
		this.m.Description = "Bonus Melee and Ranged Defense per specific perk: \n+4 Bonus: #Resilient, #Anticipation \n+3 Bonus: #Fortified mind, #Steel brow \n+2 Bonus: #Shield expert, #Underdog, #Indomitable";
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
		local aa = 4;
		local bb = 3;
		local cc = 2;
		local actor = this.getContainer().getActor();
		local tss = actor.getSkills();
		if (tss.hasSkill("perk.hold_out")) rr += aa;
		if (tss.hasSkill("perk.anticipation")) rr += aa;
		if (tss.hasSkill("perk.fortified_mind")) rr += bb;
		if (tss.hasSkill("perk.steel_brow")) rr += bb;		
		if (tss.hasSkill("perk.shield_expert")) rr += cc;
		if (tss.hasSkill("perk.underdog")) rr += cc;
		if (tss.hasSkill("perk.indomitable")) rr += cc;
		_properties.MeleeDefense += rr;
		_properties.RangedDefense += rr;
	}

});

