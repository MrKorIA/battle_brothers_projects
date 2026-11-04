this.jinweapon99_03 <- this.inherit("scripts/skills/skill", {
	m = {
		SoundOnAttack = [
			"sounds/combat/dlc2/lunge_attack_01.wav",
			"sounds/combat/dlc2/lunge_attack_02.wav",
			"sounds/combat/dlc2/lunge_attack_03.wav",
			"sounds/combat/dlc2/lunge_attack_04.wav"
		],
        TilesUsed = [],
        hasSpare = 9999
	},
	function create()
	{
		this.m.ID = "actives.jinweapon99_03";
		this.m.Name = "Выпад";
		this.m.Description = "Стремительный выпад до цели на расстояние в 2 клетки, завершающийся точным колющим ударом по захваченному врасплох противнику. Чем выше инициатива, тем больше урона наносится.";
		this.m.KilledString = "Искромсан";
		this.m.Icon = "skills/jinweapon99_02.png";
		this.m.IconDisabled = "skills/jinweapon99_02_sw.png";
		this.m.Overlay = "jinweapon99_02";
		this.m.SoundOnUse = [
			"sounds/combat/dlc2/lunge_move_01.wav",
			"sounds/combat/dlc2/lunge_move_02.wav",
			"sounds/combat/dlc2/lunge_move_03.wav",
			"sounds/combat/dlc2/lunge_move_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/knockback_hit_01.wav",
			"sounds/combat/knockback_hit_02.wav",
			"sounds/combat/knockback_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.HitChanceBonus = 0;
		this.m.DirectDamageMult = 0.25;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 30;
		this.m.MinRange = 2;
		this.m.MaxRange = 2;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 33;
		this.m.ChanceSmash = 0;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Позволяет перемещаться мимо противников, игнорируя зону контроля."
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит дополнительный урон, зависящий от уровня текущей инициативы персонажа."
			}
            {
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт бонус к шансу попадания, зависящий от уровня текущей инициативы персонажа."
			}
		]);

		if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Нельзя использовать, пока персонаж обездвижен[/color]"
			});
		}

		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().getActor().getCurrentProperties().IsRooted;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local myTile = this.getContainer().getActor().getTile();
		local hasTile = false;

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);

				if (tile.IsEmpty && tile.getDistanceTo(myTile) == 1 && this.Math.abs(myTile.Level - tile.Level) <= 1 && this.Math.abs(_targetTile.Level - tile.Level) <= 1)
				{
					hasTile = true;
					break;
				}
			}
		}

		return hasTile;
	}

	function addResources()
	{
		this.skill.addResources();

		foreach( r in this.m.SoundOnAttack )
		{
			this.Tactical.addResource(r);
		}
	}
                              function findTileToKnockBackTo( _userTile, _targetTile )
	{
		local dir = _userTile.getDirectionTo(_targetTile);
                                local knock = null;
		if (_targetTile.hasNextTile(dir))
		{
			local knockToTile = _targetTile.getNextTile(dir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1 && this.m.TilesUsed.find(knockToTile.ID) == null)
			{
				knock = knockToTile;
			}
		}

		local altdir = dir - 1 >= 0 ? dir - 1 : 5;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1 && this.m.TilesUsed.find(knockToTile.ID) == null)
			{
				knock = knockToTile;
			}
		}

		altdir = dir + 1 <= 5 ? dir + 1 : 0;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1 && this.m.TilesUsed.find(knockToTile.ID) == null)
			{
				knock = knockToTile;
			}
		}
        if(knock != null)
        {
           this.m.hasSpare = 0;
        }
		return knock;
	    }
            function applyEffectToTarget( _user, _target, _targetTile )
	    {
		
        if (_target.getCurrentProperties().IsImmuneToKnockBackAndGrab || _target.getCurrentProperties().IsRooted)
        {
            return;
        }

        local knockToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);

        if (knockToTile == null)
        {
            return;
        }

        this.m.TilesUsed.push(knockToTile.ID);

        if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || knockToTile.IsVisibleForPlayer))
        {
            this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " отбрасывает " + this.Const.UI.getColorizedEntityName(_target));
        }

        local skills = _target.getSkills();
        skills.removeByID("effects.shieldwall");
        skills.removeByID("effects.spearwall");
        skills.removeByID("effects.riposte");
        _target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
        local damage = this.Math.max(0, this.Math.abs(knockToTile.Level - _targetTile.Level) - 1) * this.Const.Combat.FallingDamage;

        if (damage == 0)
        {
            this.Tactical.getNavigator().teleport(_target, knockToTile, null, null, true);
        }
        else
        {
            local p = this.getContainer().getActor().getCurrentProperties();
            local tag = {
                Attacker = _user,
                Skill = this,
                HitInfo = clone this.Const.Tactical.HitInfo
            };
            tag.HitInfo.DamageRegular = damage;
            tag.HitInfo.DamageDirect = 1.0;
            tag.HitInfo.BodyPart = this.Const.BodyPart.Body;
            tag.HitInfo.BodyDamageMult = 1.0;
            tag.HitInfo.FatalityChanceMult = 1.0;
            this.Tactical.getNavigator().teleport(_target, knockToTile, this.onKnockedDown, tag, true);
        }
        if (_target.isNonCombatant())
        {
            return;
        }

        _target.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));

        if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
        {
            this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " дезориентирует " + this.Const.UI.getColorizedEntityName(_target) + " на один ход");
        }
		
	}

	function onKnockedDown( _entity, _tag )
	{
		if (_tag.HitInfo.DamageRegular != 0)
		{
			_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfo);
		}
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInPolearms ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		this.m.TilesUsed = [];
                                local actor = this.getContainer().getActor();
		local myTile = actor.getTile();
                                local ret = false;
		local destTile;
        if(this.m.hasSpare ==1)
        {
            ret = this.attackEntity(_user, _targetTile.getEntity());
        }

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);

				if (tile.IsEmpty && tile.getDistanceTo(myTile) == 1 && this.Math.abs(myTile.Level - tile.Level) <= 1 && this.Math.abs(_targetTile.Level - tile.Level) <= 1)
				{
					destTile = tile;
					break;
				}
			}
		}

		if (destTile == null)
		{
			return false;
		}

		this.getContainer().setBusy(true);
		local tag = {
			Skill = this,
			User = _user,
			OldTile = _user.getTile(),
			TargetTile = _targetTile,
			OnRepelled = this.onRepelled
		};
		_user.spawnTerrainDropdownEffect(myTile);
		this.Tactical.getNavigator().teleport(_user, destTile, this.onTeleportDone.bindenv(this), tag, false, 3.0);
                                if (ret && _targetTile.IsOccupiedByActor && _targetTile.getEntity().isAlive() && !_targetTile.getEntity().isDying())
		{
			this.applyEffectToTarget(_user, _targetTile.getEntity(), _targetTile);
		}

		return true;
	}

	function onTeleportDone( _entity, _tag )
	{
		local myTile = _entity.getTile();
		local ZOC = [];
		this.getContainer().setBusy(false);

		for( local i = 0; i != 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = myTile.getNextTile(i);

				if (!tile.IsOccupiedByActor)
				{
				}
				else
				{
					local actor = tile.getEntity();

					if (actor.isAlliedWith(_entity) || actor.getCurrentProperties().IsStunned)
					{
					}
					else
					{
						ZOC.push(actor);
					}
				}
			}
		}

		foreach( actor in ZOC )
		{
			if (!actor.onMovementInZoneOfControl(_entity, true))
			{
				continue;
			}

			if (actor.onAttackOfOpportunity(_entity, true))
			{
				if (_tag.OldTile.IsVisibleForPlayer || myTile.IsVisibleForPlayer)
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_entity) + " совершает рывок и отбрасывает");
				}

				if (!_entity.isAlive() || _entity.isDying())
				{
					return;
				}

				local dir = myTile.getDirectionTo(_tag.OldTile);

				if (myTile.hasNextTile(dir))
				{
					local tile = myTile.getNextTile(dir);

					if (tile.IsEmpty && this.Math.abs(tile.Level - myTile.Level) <= 1 && tile.getDistanceTo(actor.getTile()) > 1)
					{
						_tag.TargetTile = tile;
						this.Time.scheduleEvent(this.TimeUnit.Virtual, 50, _tag.OnRepelled, _tag);
						return;
					}
				}
			}
		}

		this.spawnAttackEffect(_tag.TargetTile, this.Const.Tactical.AttackEffectThrust);
		local s = this.m.SoundOnUse;
		this.m.SoundOnUse = this.m.SoundOnAttack;
		this.attackEntity(_entity, _tag.TargetTile.getEntity());
		this.m.SoundOnUse = s;
	}

	function onRepelled( _tag )
	{
		this.Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, null, null, false);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local a = this.getContainer().getActor();
			local s = this.Math.minf(2.0, 2.0 * (this.Math.max(0, a.getInitiative() + (_targetEntity != null ? this.getFatigueCost() * a.getCurrentProperties().FatigueToInitiativeRate : 0)) / 175.0));
                                                local m = this.Math.minf(10, 1* (this.Math.max(0, a.getInitiative() ) / 15));
			_properties.DamageTotalMult *= 1.5;
            _properties. MeleeSkill += m;
		}
	}

});

