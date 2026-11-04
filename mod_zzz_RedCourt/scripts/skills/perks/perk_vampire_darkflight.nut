this.perk_vampire_darkflight <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.vampire_darkflight";
		this.m.Name = this.Const.Strings.PerkName.VampireDarkflight;
		this.m.Description = this.Const.Strings.PerkDescription.VampireDarkflight;
		this.m.Icon = "ui/perks/vampire_darkflight.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		this.m.Container.add(this.new("scripts/skills/actives/vampire_darkflight_skill"));
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.vampire_darkflight");
	}

	function onUpdate( _properties )
	{
		// _properties.DamageReceivedRegularMult *= 0.95; //5% reduction
	}
});
