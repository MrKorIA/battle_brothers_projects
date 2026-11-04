this.sb_gale_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sb_gale_skill";
		this.m.Name = "Штормовая сила";
		this.m.Description = "Сильный ветер отбрасывает цель назад на 1–3 клетки и наносит урон, игнорирующий броню. При попадании ошеломляет цель и снимает защиту от стены щитов / стены копий / ответного удара.";
		this.m.Icon = "ui/xx56.png";
		this.m.IconDisabled = "ui/xx56_sw.png";
		this.m.Overlay = "active_rand";
		this.m.SoundOnUse = [
			"sounds/combat/indomitable_01.wav",
			"sounds/combat/indomitable_02.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/hand_hit_01.wav",
			"sounds/combat/hand_hit_02.wav",
			"sounds/combat/hand_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.HitChanceBonus = 15;
		this.m.DirectDamageMult = 1;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.MaxLevelDifference = 4;
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
			icon = "ui/icons/hitchance.png",
			text = "+11% к шансу попадания. Игнорирует препятствия и атакует только выбранную цель."
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Навыки \'В яблочко\', \'Предвидение\', \'Длина имеет значение\' дают +10 к наносимому урону, получаемый бонус с каждого навыка суммируется."
		});
		return ret;
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		local dir = _userTile.getDirectionTo(_targetTile);
		local left = dir - 1 < 0 ? 5 : dir - 1;
		local right = dir + 1 > 5 ? 0 : dir + 1;
		local ret = [];
		local tlvl = this.m.MaxLevelDifference;
		if (_targetTile.hasNextTile(dir))
		{
			local knockToTile = _targetTile.getNextTile(dir);
			local nextToTile;
			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= tlvl)
			{
				ret.push(knockToTile);
			}
			if (knockToTile.hasNextTile(left))
			{
				nextToTile = knockToTile.getNextTile(left);
				if (nextToTile.IsEmpty && nextToTile.Level - _targetTile.Level <= tlvl)
				{
					ret.push(nextToTile);
					ret.push(nextToTile);
				}
			}
			if (knockToTile.hasNextTile(right))
			{
				nextToTile = knockToTile.getNextTile(right);
				if (nextToTile.IsEmpty && nextToTile.Level - _targetTile.Level <= tlvl)
				{
					ret.push(nextToTile);
					ret.push(nextToTile);
				}
			}

			knockToTile = knockToTile.getNextTile(dir);
			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= tlvl)
			{
				ret.push(knockToTile);
				ret.push(knockToTile);
				ret.push(knockToTile);
			}
			if (knockToTile.hasNextTile(left))
			{
				nextToTile = knockToTile.getNextTile(left);
				if (nextToTile.IsEmpty && nextToTile.Level - _targetTile.Level <= tlvl)
				{
					ret.push(nextToTile);
					ret.push(nextToTile);
				}
			}
			if (knockToTile.hasNextTile(right))
			{
				nextToTile = knockToTile.getNextTile(right);
				if (nextToTile.IsEmpty && nextToTile.Level - _targetTile.Level <= tlvl)
				{
					ret.push(nextToTile);
					ret.push(nextToTile);
				}
			}

			knockToTile = knockToTile.getNextTile(dir);
			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= tlvl)
			{
				ret.push(knockToTile);
				ret.push(knockToTile);
				ret.push(knockToTile);
			}
		}

		if (ret.len() > 0)
		{
			local effectT = ret[this.Math.rand(0, ret.len() - 1)];
			return effectT;
		}

		return null;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local knockToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);
		local flip = !this.m.IsProjectileRotated && target.getPos().X > _user.getPos().X;
		local xfire = this.Tactical.spawnProjectileEffect("effect_thresh", _user.getTile(), _targetTile, 0.1, 2, true, flip);
		this.Tactical.spawnProjectileEffect("effect_thresh", _user.getTile(), _targetTile, 0.9, 1, true, flip);
		this.Tactical.spawnProjectileEffect("effect_thresh", _user.getTile(), _targetTile, 0.9, 1, true, flip);
		this.Tactical.spawnProjectileEffect("effect_thresh", _user.getTile(), _targetTile, 0.9, 2, true, flip);
		this.Tactical.spawnProjectileEffect("effect_thresh", _user.getTile(), _targetTile, 0.9, 2, true, flip);
		this.Tactical.spawnProjectileEffect("effect_thresh", _user.getTile(), _targetTile, 0.8, 3, true, flip);
		this.Tactical.spawnProjectileEffect("effect_thresh", _user.getTile(), _targetTile, 0.8, 3, true, flip);
		this.Tactical.spawnProjectileEffect("effect_thresh", _user.getTile(), _targetTile, 0.8, 4, true, flip);
		this.Tactical.spawnProjectileEffect("effect_thresh", _user.getTile(), _targetTile, 0.8, 4, true, flip);
		this.Tactical.spawnProjectileEffect("effect_thresh", _user.getTile(), _targetTile, 0.7, 5, true, flip);
		this.Tactical.spawnProjectileEffect("effect_thresh", _user.getTile(), _targetTile, 0.7, 6, true, flip);
		this.Tactical.spawnProjectileEffect("effect_thresh", _user.getTile(), _targetTile, 0.6, 7, true, flip);
		this.Tactical.spawnProjectileEffect("effect_thresh", _user.getTile(), _targetTile, 0.5, 8, true, flip);
		this.Tactical.spawnProjectileEffect("effect_thresh", _user.getTile(), _targetTile, 0.4, 9, true, flip);
		this.Tactical.spawnProjectileEffect("effect_thresh", _user.getTile(), _targetTile, 0.3, 10, true, flip);
		this.Sound.play("sounds/enemies/vampire_takeoff_0" + this.Math.rand(1, 3) + ".wav", this.Const.Sound.Volume.Skill * 1.5, _user.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Virtual, xfire, function ( _skill )
		{
			this.attackEntity(_user, target, false)
		}.bindenv(this), this);
		return true;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == this && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			if (_targetEntity.getCurrentProperties().IsImmuneToKnockBackAndGrab || _targetEntity.getCurrentProperties().IsRooted)
			{
				return false;
			}

			local knockToTile = this.findTileToKnockBackTo(this.getContainer().getActor().getTile(), _targetEntity.getTile());

			if (knockToTile == null)
			{
				return;
			}

			if (!_targetEntity.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_targetEntity) + " был отброшен назад");
			}

			local skills = _targetEntity.getSkills();
			skills.removeByID("effects.shieldwall");
			skills.removeByID("effects.spearwall");
			skills.removeByID("effects.riposte");
			_targetEntity.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
			this.Tactical.getNavigator().teleport(_targetEntity, knockToTile, null, null, false, 1.5);
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local actor = this.getContainer().getActor();
			local tss = actor.getSkills();
			local rr = 10;
			local bb = 10;
			if (tss.hasSkill("perk.bullseye"))
			{
				rr = rr + bb;
			}
			if (tss.hasSkill("perk.anticipation"))
			{
				rr = rr + bb;
			}
			if (tss.hasSkill("perk.taunt"))
			{
				rr = rr + bb;
			}
			if (tss.hasSkill("perk.reach_advantage"))
			{
				rr = rr + bb;
			}
			_properties.DamageRegularMin = rr;
			_properties.DamageRegularMax = rr;
			_properties.RangedSkill += 11;
			_properties.IsIgnoringArmorOnAttack = true;
			_properties.DamageArmorMult *= 0;
			_properties.RangedAttackBlockedChanceMult *= 0;
			_properties.HitChanceMult[this.Const.BodyPart.Head] = 0;
			_properties.HitChanceMult[this.Const.BodyPart.Body] = 1;
		}
	}

});

