this.ai_psv_spiderdemon <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.ai_psv_spiderdemon";
		this.m.Name = "Spider Attack";
		this.m.Description = "TODO";
		this.m.Icon = "";
		this.m.SoundOnUse = [
			"sounds/combat/throw_net_01.wav",
			"sounds/combat/throw_net_02.wav"
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/combat/break_free_net_01.wav",
			"sounds/combat/break_free_net_02.wav",
			"sounds/combat/break_free_net_03.wav"
		];
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (!_targetEntity.isAlive() || _targetEntity.isDying() || _targetEntity.isAlliedWith(this.getContainer().getActor()) || this.Tactical.TurnSequenceBar.getActiveEntity().getID() != this.getContainer().getActor().getID())
		{
			return;
		}

		if (this.getContainer().getActor().getSkills().hasSkill("perk.brawny"))
		{
			if (!_targetEntity.getFlags().has("body_immune_to_acid") && !_targetEntity.getFlags().has("head_immune_to_acid"))
			{
				local xacid = _targetEntity.getSkills().getSkillByID("effects.lindwurm_acid");
				if (xacid == null)
				{
					_targetEntity.getSkills().add(this.new("scripts/skills/effects/lindwurm_acid_effect"));
				}
				else
				{
					xacid.resetTime();
				}
				this.spawnIcon("status_effect_78", _targetEntity.getTile());
			}
		}

		if (!_targetEntity.getCurrentProperties().IsImmuneToRoot && !_targetEntity.getCurrentProperties().IsRooted && this.Math.rand(0, 100) < 44)
		{
			if (this.m.SoundOnUse.len() != 0)
			{
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill, _targetEntity.getPos());
			}
			_targetEntity.getSkills().add(this.new("scripts/skills/effects/web_effect"));
			local breakFree = this.new("scripts/skills/actives/break_free_skill");
			breakFree.setDecal("web_destroyed");
			breakFree.m.Icon = "skills/active_113.png";
			breakFree.m.IconDisabled = "skills/active_113_sw.png";
			breakFree.m.Overlay = "active_113";
			breakFree.m.SoundOnUse = this.m.SoundOnHitHitpoints;
			_targetEntity.getSkills().add(breakFree);
			local effect = this.Tactical.spawnSpriteEffect("bust_web2", this.createColor("#ffffff"), _targetEntity.getTile(), 0, 4, 1.0, _targetEntity.getSprite("status_rooted").Scale, 100, 100, 0);
			local flip = !_targetEntity.isAlliedWithPlayer();
			effect.setHorizontalFlipping(flip);
			this.Time.scheduleEvent(this.TimeUnit.Real, 200, this.onNetSpawn.bindenv(this), _targetEntity);

		}
	}

	function onNetSpawn( _targetEntity )
	{
		local rooted = _targetEntity.getSprite("status_rooted");
		rooted.setBrush("bust_web2");
		rooted.Visible = true;
		local rooted_back = _targetEntity.getSprite("status_rooted_back");
		rooted_back.setBrush("bust_web2_back");
		rooted_back.Visible = true;
		_targetEntity.setDirty(true);
	}

});

