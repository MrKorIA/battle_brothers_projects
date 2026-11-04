this.ai_monsterbite <- this.inherit("scripts/skills/skill", {
	//tentacle9 bat9 bloodsucker9 spiderdemon9
	m = {},
	function create()
	{
		this.m.ID = "actives.ai_punch";
		this.m.Name = "Атака";
		this.m.Overlay = "active_150";
		this.m.SoundOnUse = [
			"sounds/enemies/lindwurm_gorge_01.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/lindwurm_gorge_hit_01.wav"
		];
		this.m.SoundVolume = 1.2;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.ChanceDecapitate = 33;
		this.m.ChanceSmash = 33;
		this.m.ChanceDisembowel = 15;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local hp = target.getHitpoints();
		local success = this.attackEntity(_user, _targetTile.getEntity());
		if (!_user.isAlive() || _user.isDying())
		{
			return;
		}
		if (this.m.Name == "Rend")
		{
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectClaws);
		}
		if (success && target.isAlive() && !target.isDying())
		{
			if (!target.getCurrentProperties().IsImmuneToBleeding && hp - target.getHitpoints() >= this.Const.Combat.MinDamageToApplyBleeding)
			{
				local effect = this.new("scripts/skills/effects/bleeding_effect");
				effect.setDamage(this.getContainer().getActor().getCurrentProperties().IsSpecializedInCleavers ? this.m.ChanceDisembowel : 5);
				target.getSkills().add(effect);
			}
		}
		return success;
	}

});

