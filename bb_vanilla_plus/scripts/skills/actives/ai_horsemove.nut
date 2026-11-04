this.ai_horsemove <- this.inherit("scripts/skills/skill", {
	m = {
		SoundOnCharge = [
			"sounds/fantasyhorse/fantasyhorse_rage_01.wav",
			"sounds/fantasyhorse/fantasyhorse_rage_02.wav"
		],
		TilesUsed = []
	},
	function create()
	{
		this.m.ID = "actives.darkflight";
		this.m.Name = "Наскок";
		this.m.Description = "";
		this.m.Overlay = "active_07";
		this.m.SoundOnUse = [
			"sounds/enemies/vampire_takeoff_01.wav",
			"sounds/enemies/vampire_takeoff_02.wav",
			"sounds/enemies/vampire_takeoff_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/split_hit_01.wav",
			"sounds/combat/split_hit_02.wav",
			"sounds/combat/split_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.IsUsingActorPitch = true;
		this.m.IsSpearwallRelevant = false;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.4;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 5;
		this.m.MaxLevelDifference = 3;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 77;
		this.m.ChanceSmash = 0;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()) && !this.getContainer().getActor().getCurrentProperties().IsRooted && this.getContainer().getActor().getSkills().hasSkill("effects.xxitem_horse_skill");
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!_targetTile.IsEmpty)
		{
			return false;
		}
		return true;
	}

	function onUse( _user, _targetTile )
	{
		this.m.TilesUsed = [];
		local tag = {
			Skill = this,
			User = _user,
			OldTile = _user.getTile(),
			TargetTile = _targetTile
		};
		if (tag.OldTile.IsVisibleForPlayer || _targetTile.IsVisibleForPlayer)
		{
			local myPos = _user.getPos();
			local targetPos = _targetTile.Pos;
			local distance = tag.OldTile.getDistanceTo(_targetTile);
			local Dx = (targetPos.X - myPos.X) / distance;
			local Dy = (targetPos.Y - myPos.Y) / distance;

			for( local i = 0; i < distance; i = ++i )
			{
				local x = myPos.X + Dx * i;
				local y = myPos.Y + Dy * i;
				local tile = this.Tactical.worldToTile(this.createVec(x, y));

				if (this.Tactical.isValidTile(tile.X, tile.Y) && this.Const.Tactical.DustParticles.len() != 0)
				{
					for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
					{
						this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, this.Tactical.getTile(tile), this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
					}
				}
			}
		}
		this.Tactical.getNavigator().teleport(_user, _targetTile, this.onTeleportDone.bindenv(this), tag, false, 3.0);
		return true;
	}

	function onTeleportDone( _entity, _tag )
	{
		local myTile = _entity.getTile();
		local potentialVictims = [];
		local betterThanNothing;
		local dirToTarget = _tag.OldTile.getDirectionTo(myTile);
		local ZOC = [];
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
					if (actor.isAlliedWith(_entity))
					{
					}
					else
					{
						ZOC.push(actor);
						if (betterThanNothing == null)
						{
							betterThanNothing = actor;
						}
						potentialVictims.push(actor);
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
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_entity) + " charges and is repelled");
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
				for( local i = 0; i != 6; i = ++i )
				{
					if (!myTile.hasNextTile(i))
					{
					}
					else
					{
						local tile = myTile.getNextTile(i);

						if (tile.IsEmpty && this.Math.abs(tile.Level - myTile.Level) <= 1)
						{
							if (tile.getZoneOfControlCountOtherThan(_entity.getAlliedFactions()) != 0)
							{
							}
							else
							{
								_tag.TargetTile = tile;
								this.Time.scheduleEvent(this.TimeUnit.Virtual, 50, _tag.OnRepelled, _tag);
								return;
							}
						}
					}
				}
				_tag.TargetTile = _tag.OldTile;
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 50, _tag.OnRepelled, _tag);
				return;
			}
		}
		if (potentialVictims.len() == 0 && betterThanNothing != null)
		{
			potentialVictims.push(betterThanNothing);
		}
		if (potentialVictims.len() != 0)
		{
			local victim = potentialVictims[this.Math.rand(0, potentialVictims.len() - 1)];
			if (_tag.Skill.m.SoundOnHit.len() != 0)
			{
				this.Sound.play(_tag.Skill.m.SoundOnHit[this.Math.rand(0, _tag.Skill.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, victim.getPos());
			}
			if (this.m.SoundOnCharge.len() != 0)
			{
				this.Sound.play(this.m.SoundOnCharge[this.Math.rand(0, this.m.SoundOnCharge.len() - 1)], this.Const.Sound.Volume.Skill * 0.5, victim.getPos());
			}
			this.spawnAttackEffect(victim.getTile(), this.Const.Tactical.AttackEffectSplit);
			this.attackEntity(_entity, victim);
		}
	}

	function onRepelled( _tag )
	{
		this.Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, null, null, false);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local actor = this.getContainer().getActor();
			local item = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			local dmg = this.Math.rand(70, 90);
			if (item != null && item.getID() == "weapon.xxheavylance")
			{
				dmg = this.Math.rand(100, 110);
			}
			_properties.DamageRegularMin = dmg;
			_properties.DamageRegularMax = dmg;
			_properties.MeleeDefense += 10;
		}
	}

	function addResources()
	{
		foreach( r in this.m.SoundOnCharge )
		{
			this.Tactical.addResource(r);
		}
	}

});

