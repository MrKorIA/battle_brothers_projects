this.catch_enemy_skill <- this.inherit("scripts/skills/skill", {
	m = {
	},
	function create()
	{
		this.m.ID = "actives.catch_enemy";
		this.m.Name = "Поймать врага";
		this.m.Description = "Использовать людолов, чтобы поймать цель и удержать её на месте, тем самым помешав ей двигаться или эффективно защищаться.";
		this.m.Icon = "skills/manchatcher_active_skill.png";
		this.m.IconDisabled = "skills/manchatcher_active_skill_bw.png";
		this.m.Overlay = "active_73";
		this.m.SoundOnUse = [
			"sounds/combat/throw_net_01.wav",
			"sounds/combat/throw_net_02.wav"
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/combat/break_free_net_01.wav",
			"sounds/combat/break_free_net_02.wav",
			"sounds/combat/break_free_net_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.Delay = 0;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = true;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 25;
		this.m.MinRange = 2;
		this.m.MaxRange = 2;
		this.m.MaxLevelDifference = 1;
	}

	function isUsable()
	{
		local caught = this.getContainer().getSkillByID("effects.catching_enemy")
		if (caught != null && caught.m.TargetEntity != null) return false
		if (this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions())) return false;
		
		return this.skill.isUsable()
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Имеет дальность в [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] клеток"
			}
		]);
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (_targetTile.getEntity().getCurrentProperties().IsRooted)
		{
			return false;
		}
		if (_targetTile.getEntity().getCurrentProperties().IsImmuneToRoot)
		{
			return false;
		}

		return true;
	}

	function onAfterUpdate( _properties )
	{

		this.m.ActionPointCost = _properties.IsSpecializedInPolearms ? 5 : 6;
	}

	function onUse( _user, _targetTile )
	{
		local targetEntity = _targetTile.getEntity();


		if (!targetEntity.getCurrentProperties().IsImmuneToRoot)
		{
			if (this.m.SoundOnHit.len() != 0)
			{
				this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, targetEntity.getPos());
			}

			targetEntity.getSkills().add(this.new("scripts/skills/effects/caught_effect"));
			targetEntity.getSkills().getSkillByID("effects.serpent_ensnare").m.TargetEntity = _user

			_user.getSkills().add(this.new("scripts/skills/effects/catching_enemy_effect"));
			_user.getSkills().getSkillByID("effects.catching_enemy").m.TargetEntity = targetEntity


			local effect = this.Tactical.spawnSpriteEffect("bust_net", this.createColor("#ffffff"), _targetTile, 0, 10, 1.0, targetEntity.getSprite("status_rooted").Scale, 100, 100, 0);
			local flip = !targetEntity.isAlliedWithPlayer();
			effect.setHorizontalFlipping(flip);
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
			local rooted = targetEntity.getSprite("status_rooted");
			rooted.setBrush("bust_net");
			rooted.Visible = true;
			local rooted_back = targetEntity.getSprite("status_rooted_back");
			rooted_back.setBrush("bust_net_back");
			rooted_back.Visible = true;
			targetEntity.setDirty(true);

		}
		else
		{
			if (this.m.SoundOnMiss.len() != 0)
			{
				this.Sound.play(this.m.SoundOnMiss[this.Math.rand(0, this.m.SoundOnMiss.len() - 1)], this.Const.Sound.Volume.Skill, targetEntity.getPos());
			}
			return false;
		}
	}
});

