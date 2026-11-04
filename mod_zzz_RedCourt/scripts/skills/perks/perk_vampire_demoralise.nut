this.perk_vampire_demoralise <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.vampire_demoralise";
		this.m.Name = this.Const.Strings.PerkName.VampireDemoralise;
		this.m.Description = this.Const.Strings.PerkDescription.VampireDemoralise;
		this.m.Icon = "ui/perks/vampire_demoralise.png";
		this.m.IconDisabled = "ui/perks/vampire_demoralise_bw.png"
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		// _properties.DamageReceivedRegularMult *= 0.95; //5% reduction
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.vampire_demoralise"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/vampire_demoralise_skill"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.vampire_demoralise");
	}

});
