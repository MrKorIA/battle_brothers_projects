this.rattle_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.rattle";
		this.m.Name = "Ошеломление";
		this.m.Description = "Оглушает пойманного врага, нанося ему урон и выбивая из него дух.";
		this.m.KilledString = "Забит до смерти";
		this.m.Icon = "skills/manchatcher_rattle.png";
		this.m.IconDisabled = "skills/manchatcher_rattle_bw.png";
		this.m.Overlay = "active_02";
		this.m.SoundOnUse = [
			"sounds/combat/bash_01.wav",
			"sounds/combat/bash_02.wav",
			"sounds/combat/bash_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/bash_hit_01.wav",
			"sounds/combat/bash_hit_02.wav",
			"sounds/combat/bash_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.4;
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 15;
		this.m.MinRange = 2;
		this.m.MaxRange = 2;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 0;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] к шансу на попадание"
			}
		]);
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Цель получит эффект 'Выбит дух'"
		});
		return ret;
	}
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.MeleeSkill += 10;
		}
	}

	function isUsable()
	{
		if (!this.Tactical.isActive())
		{
			return false;
		}
		local catch_skill = this.getContainer().getActor().getSkills().getSkillByID("effects.catching_enemy")
		if (catch_skill == null || catch_skill.m.TargetEntity == null || !catch_skill.m.TargetEntity.isAlive()) return false;

		local tile = this.getContainer().getActor().getTile();
		return this.skill.isUsable() && !tile.hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
		local success = this.attackEntity(_user, target);

		if (!_user.isAlive() || _user.isDying())
		{
			return success;
		}

		if (success && target.isAlive())
		{
			target.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));

			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " оглушает противника " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()) + " выбивая из него дух");
			}
		}

		return success;
	}
	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}
		local catch_skill = this.getContainer().getActor().getSkills().getSkillByID("effects.catching_enemy")
		local entity = _targetTile.getEntity();
		if (entity == null) return false
		if (catch_skill == null || catch_skill.m.TargetEntity == null || !catch_skill.m.TargetEntity.isAlive() || entity.getID() != catch_skill.m.TargetEntity.getID()) return false

		return true;
	}

});

