this.sbq4_dragonkick_skill <- this.inherit("scripts/skills/skill", {
	m = {
		SoundOnAttack = [
			"sounds/combat/hand_01.wav",
			"sounds/combat/hand_02.wav",
			"sounds/combat/hand_03.wav"
		],
		Sklevel = 1
	},
	function create()
	{
		this.m.ID = "actives.sbq4_dragonkick_skill";
		this.m.Name = "111. Удар ногой Зуб Дракона";
		this.m.Description = "Прыгает к цели, находящейся на расстоянии 2 клеток, и наносит мощный удар ногой в прыжке. При попадании цель отбрасывается назад.";
		this.m.Icon = "ui/xx78.png";
		this.m.IconDisabled = "ui/xx78_sw.png";
		this.m.Overlay = "active_06";
		this.m.SoundOnUse = [
			"sounds/combat/overhead_strike_01.wav",
			"sounds/combat/overhead_strike_02.wav",
			"sounds/combat/overhead_strike_03.wav"
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
		this.m.IsIgnoredAsAOO = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 15;
		this.m.MinRange = 2;
		this.m.MaxRange = 2;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Когда у вас есть навык Удар ногой (37): этот навык будет усилен."
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Перемещает пользователя рядом с целью, игнорируя зону контроля."
		});
		if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Не может использоваться при рутировании[/color]"
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

	function onUpdate( _properties )
	{
		if (this.getContainer().getActor().getSkills().hasSkill("actives.sb_kick_skill"))
		{
			this.m.Name = "111. 화룡각";
			this.m.Sklevel = 2;
		}
		else
		{
			this.m.Name = "111. 용아각";
			this.m.Sklevel = 1;
		}
	}

	function onUse( _user, _targetTile )
	{
		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();
		local destTile;
		if (this.m.Sklevel >= 2)
		{
			this.Sound.play("sounds/combat/poison_applied_0" + this.Math.rand(1, 2) + ".wav", this.Const.Sound.Volume.Skill * 1.6, myTile);
			for( local i = 0; i < this.Const.Tactical.MortarImpactParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarImpactParticles[i].Brushes, actor.getTile(), this.Const.Tactical.MortarImpactParticles[i].Delay, this.Const.Tactical.MortarImpactParticles[i].Quantity * 0.5, this.Const.Tactical.MortarImpactParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.MortarImpactParticles[i].SpawnRate, this.Const.Tactical.MortarImpactParticles[i].Stages, this.createVec(0, -30));
			}
			actor.fadeTo(this.createColor("fa6400ff"), 0);
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
		return true;
	}

	function onTeleportDone( _entity, _tag )
	{
		if (_tag.Skill.m.Sklevel >= 2)
		{
			this.Sound.play("sounds/combat/poison_applied_0" + this.Math.rand(1, 2) + ".wav", this.Const.Sound.Volume.Skill * 1.6, _tag.User.getTile());
			for( local i = 0; i < this.Const.Tactical.MortarImpactParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarImpactParticles[i].Brushes, _tag.TargetTile, this.Const.Tactical.MortarImpactParticles[i].Delay, this.Const.Tactical.MortarImpactParticles[i].Quantity * 0.5, this.Const.Tactical.MortarImpactParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.MortarImpactParticles[i].SpawnRate, this.Const.Tactical.MortarImpactParticles[i].Stages, this.createVec(0, -30));
			}
			_tag.User.fadeToStoredColors(1000);
		}
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
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_entity) + " lunges and is repelled");
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
		this.spawnAttackEffect(_tag.TargetTile, this.Const.Tactical.AttackEffectSplit);
		local s = this.m.SoundOnUse;
		this.m.SoundOnUse = this.m.SoundOnAttack;
		local t = _tag.TargetTile;
		local target = t.getEntity();		
		local rr = 0;
		local dir = _entity.getTile().getDirectionTo(_tag.TargetTile);
		local success = this.attackEntity(_entity, target);
		if (success && target.isAlive() && !target.isDying())
		{
			if (t.hasNextTile(dir))
			{
				local knockToTile = t.getNextTile(dir);
				if (knockToTile.IsEmpty && knockToTile.Level - t.Level <= 1 && rr == 0)
				{
					rr = 1;
					this.Tactical.getNavigator().teleport(target, knockToTile, null, null, false, 1.5);
				}
			}
			local altdir = dir - 1 >= 0 ? dir - 1 : 5;
			if (t.hasNextTile(altdir))
			{
				local knockToTile = t.getNextTile(altdir);
				if (knockToTile.IsEmpty && knockToTile.Level - t.Level <= 1 && rr == 0)
				{
					rr = 1;
					this.Tactical.getNavigator().teleport(target, knockToTile, null, null, false, 1.5);
				}
			}
			altdir = dir + 1 <= 5 ? dir + 1 : 0;
			if (t.hasNextTile(altdir))
			{
				local knockToTile = t.getNextTile(altdir);
				if (knockToTile.IsEmpty && knockToTile.Level - t.Level <= 1 && rr == 0)
				{
					rr = 1;
					this.Tactical.getNavigator().teleport(target, knockToTile, null, null, false, 1.5);
				}
			}
		}
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
			_properties.DamageDirectAdd = 0;
			_properties.DamageDirectMeleeAdd = 0;
			_properties.DamageDirectRangedAdd = 0;
			_properties.DamageDirectMult = 1;
			_properties.DamageRegularMin = this.m.Sklevel >= 2 ? 100 : 50;
			_properties.DamageRegularMax = this.m.Sklevel >= 2 ? 370 : 350;
			_properties.DamageArmorMult = 1.0;
			local actor = this.getContainer().getActor();
			local mainh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			local offh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
			if (mainh != null && offh == null && mainh.isDoubleGrippable())
			{
				_properties.DamageTotalMult /= 1.25;
			}
		}
	}

});

