this.lingmu01_01 <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.lingmu01_01";
		this.m.Name = "Жуткое прикосновение";
		this.m.Description = "";
		this.m.KilledString = "Умер от испуга";
		this.m.Icon = "skills/active_30.png";
		this.m.IconDisabled = "skills/active_30.png";
		this.m.Overlay = "active_30";
		this.m.SoundOnUse = [
			"sounds/combat/impale_01.wav",
			"sounds/combat/impale_02.wav",
			"sounds/combat/impale_03.wav"
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
		this.m.FatigueCost = 1;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
	}

	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 30;
		_properties.DamageRegularMax += 40;
		_properties.IsIgnoringArmorOnAttack = true;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectImpale);
		return this.attackEntity(_user, _targetTile.getEntity());
	}
	

});

