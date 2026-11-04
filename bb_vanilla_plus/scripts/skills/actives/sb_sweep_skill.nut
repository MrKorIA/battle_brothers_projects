this.sb_sweep_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sb_sweep_skill";
		this.m.Name = "69. Борьба";
		this.m.Description = "71% шанс нанести 25 единиц усталости и обезоружить цель.";
		this.m.Icon = "ui/xx55.png";
		this.m.IconDisabled = "ui/xx55_sw.png";
		this.m.Overlay = "active_06";
		this.m.SoundOnHit = [
			"sounds/combat/repel_hit_01.wav",
			"sounds/combat/repel_hit_02.wav",
			"sounds/combat/repel_hit_03.wav"
		];
		this.m.SoundOnMiss = [
			"sounds/combat/impale_01.wav",
			"sounds/combat/impale_02.wav",
			"sounds/combat/impale_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.MaxLevelDifference = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Fatigue inflicted on the target increases with the number of Takedown skills. (Base 25)"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Backstabber (perk) : This skill always succeeds."
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local rr = this.getContainer().getActor().getSkills().hasSkill("perk.backstabber") ? 100 : 71;
		if (this.Math.rand(1, 99) <= rr)
		{
			if (!target.getCurrentProperties().IsStunned && !target.getCurrentProperties().IsImmuneToDisarm)
			{
				target.getSkills().add(this.new("scripts/skills/effects/disarmed_effect"));
				if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has disarmed " + this.Const.UI.getColorizedEntityName(target) + " for one turn");
				}
			}
			rr = this.TakedownNum(_user);
			this.applyFatigueDamage(target, (rr * 10) + 15);
			this.Tactical.getShaker().shake(target, _targetTile, 7);
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
		}
		else
		{
			this.Tactical.getShaker().shake(target, _user.getTile(), 4);
			this.Sound.play(this.m.SoundOnMiss[this.Math.rand(0, this.m.SoundOnMiss.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
		}
		return true;
	}

});

