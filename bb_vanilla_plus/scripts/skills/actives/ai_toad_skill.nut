this.ai_toad_skill <- this.inherit("scripts/skills/skill", {
	m = {
		SwallowedEntity = null,
		SoundOnLightning = [
			"sounds/enemies/swallow_whole_01.wav",
			"sounds/enemies/swallow_whole_02.wav",
			"sounds/enemies/swallow_whole_03.wav"
		]
	},
	function getSwallowedEntity()
	{
		return this.m.SwallowedEntity;
	}

	function create()
	{
		this.m.ID = "actives.ai_punch";
		this.m.Name = "Атака жабы";
		this.m.Description = "";
		this.m.Overlay = "active_103";
		this.m.SoundOnUse = [
			"sounds/combat/whip_01.wav",
			"sounds/combat/whip_02.wav",
			"sounds/combat/whip_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/whip_hit_01.wav",
			"sounds/combat/whip_hit_02.wav",
			"sounds/combat/whip_hit_03.wav",
			"sounds/combat/whip_hit_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.DirectDamageMult = 0.2;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
	}

	function addResources()
	{
		foreach( r in this.m.SoundOnLightning )
		{
			this.Tactical.addResource(r);
		}
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (this.m.SwallowedEntity == null && target.getFlags().has("human") && target.isPlayerControlled() && this.Math.rand(1, 100) <= 15)
		{
			if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || this.knockToTile.IsVisibleForPlayer))
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " devours " + this.Const.UI.getColorizedEntityName(target));
			}
			local skills = target.getSkills();
			skills.removeByID("effects.shieldwall");
			skills.removeByID("effects.spearwall");
			skills.removeByID("effects.riposte");
			if (target.getMoraleState() != this.Const.MoraleState.Ignore)
			{
				target.setMoraleState(this.Const.MoraleState.Breaking);
			}
			this.m.SwallowedEntity = target;
			this.m.SwallowedEntity.getFlags().set("Devoured", true);
			this.m.SwallowedEntity.setHitpoints(this.Math.max(5, this.m.SwallowedEntity.getHitpoints() - this.Math.rand(10, 20)));
			target.removeFromMap();
			local effect = this.new("scripts/skills/effects/swallowed_whole_effect");
			effect.setName(target.getName());
			_user.getSkills().add(effect);
			_user.getSprite("head").setBrush("bust_toad_eat");
			if (this.m.SoundOnLightning.len() != 0)
			{
				this.Sound.play(this.m.SoundOnLightning[this.Math.rand(0, this.m.SoundOnLightning.len() - 1)], this.Const.Sound.Volume.Skill * 2.0, _user.getPos());
			}
			return true;
		}
		else
		{
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSlash);
			return this.attackEntity(_user, _targetTile.getEntity());
		}
	}

});

