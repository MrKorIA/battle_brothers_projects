this.wolfrat_bite <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.wolfrat_bite";
		this.m.Name = "Укус волкокрыса";
		this.m.Description = "";
		this.m.KilledString = "Разорван в клочья";
		this.m.Icon = "skills/rat_active_02.png";
		this.m.Overlay = "rat_active_02";
		this.m.SoundOnUse = [
			"sounds/enemies/rat_attack.wav"
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/enemies/werewolf_claw_hit_01.wav",
			"sounds/enemies/werewolf_claw_hit_02.wav",
			"sounds/enemies/werewolf_claw_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingAndPiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingAndPiercingHead;
		this.m.DirectDamageMult = 0.2;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 6;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 33;
		this.m.ChanceSmash = 0;
	}

	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 20;
		_properties.DamageRegularMax += 40;
		_properties.DamageArmorMult *= 0.7;
	}

	function onUse( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}

});

