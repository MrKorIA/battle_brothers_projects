this.hellpit_gorge_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.hellpit_gorge";
		this.m.Name = "Адское пожирание";
		this.m.Description = "";
		this.m.Icon = "skills/rat_active_03.png";
		this.m.IconDisabled = "skills/rat_active_03.png";
		this.m.Overlay = "rat_active_03";
		this.m.SoundOnUse = [
			"sounds/enemies/hellpit_attack.wav",
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/enemies/lindwurm_gorge_hit_01.wav",
			"sounds/enemies/lindwurm_gorge_hit_02.wav",
			"sounds/enemies/lindwurm_gorge_hit_03.wav"
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
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.DirectDamageMult = 0.35;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 50;
		this.m.ChanceSmash = 0;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 60;
			_properties.DamageRegularMax += 120;
			_properties.DamageArmorMult *= 1.5;
		}
	}

	function onUse( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}

});

