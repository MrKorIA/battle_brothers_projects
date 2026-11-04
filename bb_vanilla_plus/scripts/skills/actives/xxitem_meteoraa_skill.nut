this.xxitem_meteoraa_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.xx_a";
		this.m.Name = "Метеоритный хлыст";
		this.m.Description = "Ударяет врага железным шаром, прикрепленным к веревке. Удар по голове имеет дополнительный эффект.";
		this.m.KilledString = "Размозжён";
		this.m.Icon = "skills/active_39.png";
		this.m.IconDisabled = "skills/active_39_sw.png";
		this.m.Overlay = "active_39";
		this.m.SoundOnUse = [
			"sounds/combat/pound_01.wav",
			"sounds/combat/pound_02.wav",
			"sounds/combat/pound_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/pound_hit_01.wav",
			"sounds/combat/pound_hit_02.wav",
			"sounds/combat/pound_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.2;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 55;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Дальность " + this.getMaxRange() + " клеток"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "При ударе по голове наносит дополнительные 30 пробивающего урона и накладывает оглушение"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Эффект мастерства оружия Цеп/Булава/Молот: +30 к пробивающему урону при попадании в голову"
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		local a = 0;
		a += _properties.IsSpecializedInFlails ? 1 : 0;
		a += _properties.IsSpecializedInHammers ? 1 : 0;
		if (_properties.IsSpecializedInMaces)
		{
			a++;
		}
		this.m.FatigueCost = 15 - (a * 2);
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectChop);
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == this && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			if (_bodyPart == this.Const.BodyPart.Head)
			{
				local user = this.getContainer().getActor();
				local rr = 30;
				local rrbonus = 30;
				if (!_targetEntity.getCurrentProperties().IsImmuneToDaze)
				{
					_targetEntity.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
					if (!user.isHiddenToPlayer() && _targetEntity.getTile().IsVisibleForPlayer)
					{
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " удар наложил " + this.Const.UI.getColorizedEntityName(_targetEntity) + " оглушение");
					}
				}
				if (user.getCurrentProperties().IsSpecializedInFlails)
				{
					rr = rr + rrbonus;
				}
				if (user.getCurrentProperties().IsSpecializedInHammers)
				{
					rr = rr + rrbonus;
				}
				if (user.getCurrentProperties().IsSpecializedInMaces)
				{
					rr = rr + rrbonus;
				}
				local hitInfo = clone this.Const.Tactical.HitInfo;
				hitInfo.DamageRegular = rr;
				hitInfo.DamageDirect = 1;
				hitInfo.BodyPart = this.Const.BodyPart.Body;
				hitInfo.BodyDamageMult = 1;
				_targetEntity.onDamageReceived(this.getContainer().getActor(), this, hitInfo);
				return true;
			}
		}
	}

});

