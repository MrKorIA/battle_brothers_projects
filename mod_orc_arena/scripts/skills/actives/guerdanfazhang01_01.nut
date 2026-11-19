this.guerdanfazhang01_01 <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.guerdanfazhang01_01";
		this.m.Name = "Жатва душ";
		this.m.Description = "";
		this.m.KilledString = "Насмерть перепуган";
		this.m.Icon = "skills/active_101.png";
		this.m.IconDisabled = "skills/active_101_sw.png";
		this.m.Overlay = "active_101";
		this.m.SoundOnUse = [
			"sounds/enemies/zombie_rise_01.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
	}

	function onUpdate( _properties )
	{
		_properties.IsIgnoringArmorOnAttack = true;
	}

	function onUse( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}

});

