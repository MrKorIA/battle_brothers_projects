this.ratswarm_bite <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.ratswarm_bite";
		this.m.Name = "Укус крысиной стаи";
		this.m.Description = "";
		this.m.KilledString = "Искалечен";
		this.m.Icon = "skills/rat_active_01.png";
		this.m.Overlay = "rat_active_01";
		this.m.SoundOnUse = [
			"sounds/enemies/rat_attack.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsUsingActorPitch = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.HitChanceBonus = -15;
		this.m.DirectDamageMult = 1;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 5;
		_properties.DamageRegularMax += 15;
	}

	function onUse( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}

});

