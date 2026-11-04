this.ai_horsejump <- this.inherit("scripts/skills/skill", {
	m = {	},
	function create()
	{
		this.m.ID = "actives.horrific_scream";
		this.m.Name = "Charge";
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
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.HitChanceBonus = 0;
		this.m.DirectDamageMult = 0.4;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 2;
		this.m.MaxRange = 5;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 55;
		this.m.ChanceSmash = 0;
	}

	function isUsable()
	{
		local actor = this.getContainer().getActor();
		return actor.isAlive() && actor.getSkills().hasSkill("effects.xxitem_horse_skill") && this.skill.isUsable() && !actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions()) && !this.getContainer().getActor().getCurrentProperties().IsRooted;
	}

	function getMoveTile( _targetTile )
	{
		local myTile = this.getContainer().getActor().getTile();
		local tiles = [];
		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
				continue;
			}
			local tile = _targetTile.getNextTile(i);
			if (tile.IsEmpty && this.Math.abs(myTile.Level - tile.Level) <= 1 && this.Math.abs(_targetTile.Level - tile.Level) <= 1)
			{
				tiles.push(tile);
			}
		}
		if (tiles.len() > 0)
		{
			tiles.sort(function( _t1, _t2 )
			{
				local d1 = _t1.getDistanceTo(myTile);
				local d2 = _t2.getDistanceTo(myTile);
				if (d1 < d2) return -1;
				if (d1 > d2) return 1;
				return 0;
			}.bindenv(this));
			for( local i = tiles.len() - 1; i > 0; --i )
			{
				local d1 = tiles[i].getDistanceTo(myTile);
				local d_prev = tiles[i - 1].getDistanceTo(myTile);				
				if (d1 == d_prev && this.Math.rand(0, 1) == 1)
				{
					local temp = tiles[i];
					tiles[i] = tiles[i - 1];
					tiles[i - 1] = temp;
				}
			}
		}
		return tiles;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}
		local tiles = this.getMoveTile(_targetTile);
		return tiles.len() > 0;
	}

	function onUse( _user, _targetTile )
	{
		local tiles = this.getMoveTile(_targetTile);
		if (tiles.len() == 0)
		{
			return false;
		}
		local destTile = tiles[0];
		if (destTile == null)
		{
			return false;
		}
		this.getContainer().setBusy(true);
		local myTile = _user.getTile();
		local tag = {
			Skill = this,
			User = _user,
			OldTile = myTile,
			TargetTile = _targetTile,
			OnRepelled = this.onRepelled
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
				if (this.Tactical.isValidTile(tile.X, tile.Y) && this.Const.Tactical.RaiseFromGroundParticles.len() != 0)
				{
					for( local i = 0; i < this.Const.Tactical.RaiseFromGroundParticles.len(); i = ++i )
					{
						this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseFromGroundParticles[i].Brushes, this.Tactical.getTile(tile), this.Const.Tactical.RaiseFromGroundParticles[i].Delay, this.Const.Tactical.RaiseFromGroundParticles[i].Quantity, this.Const.Tactical.RaiseFromGroundParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseFromGroundParticles[i].SpawnRate, this.Const.Tactical.RaiseFromGroundParticles[i].Stages);
					}
				}
			}
		}
		_user.spawnTerrainDropdownEffect(myTile);
		this.Sound.play("sounds/combat/rage_0" + this.Math.rand(1, 2) + ".wav", this.Const.Sound.Volume.Skill * 1.0, myTile);
		this.Tactical.getNavigator().teleport(_user, destTile, this.onTeleportDone.bindenv(this), tag, false, 3.0);
		return true;
	}

	function onTeleportDone( _entity, _tag )
	{
		local myTile = _entity.getTile();
		if (_tag.OldTile.IsVisibleForPlayer || myTile.IsVisibleForPlayer)
		{
			local myPos = _tag.OldTile.Pos;
			local targetPos = myTile.Pos;
			local distance = _tag.OldTile.getDistanceTo(myTile);
			if (distance > 0)
			{
				local Dx = (targetPos.X - myPos.X) / distance;
				local Dy = (targetPos.Y - myPos.Y) / distance;
				for( local i = 0; i < distance; i = ++i )
				{
					local x = myPos.X + Dx * i;
					local y = myPos.Y + Dy * i;
					local tile = this.Tactical.worldToTile(this.createVec(x, y));
					if (this.Tactical.isValidTile(tile.X, tile.Y) && this.Const.Tactical.DustParticles.len() != 0)
					{
						for( local j = 0; j < this.Const.Tactical.DustParticles.len(); j = ++j )
						{
							this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[j].Brushes, this.Tactical.getTile(tile), this.Const.Tactical.DustParticles[j].Delay, this.Const.Tactical.DustParticles[j].Quantity * 0.3, this.Const.Tactical.DustParticles[j].LifeTimeQuantity * 0.3, this.Const.Tactical.DustParticles[j].SpawnRate, this.Const.Tactical.DustParticles[j].Stages);
						}
					}
				}
			}
		}
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
			}
		}
		this.Sound.play("sounds/combat/impale_0" + this.Math.rand(1, 3) + ".wav", this.Const.Sound.Volume.Skill * 1.0, myTile);
		this.spawnAttackEffect(_tag.TargetTile, this.Const.Tactical.AttackEffectSplit);
		this.attackEntity(_entity, _tag.TargetTile.getEntity());
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
				dmg = this.Math.rand(90, 100);
			}
			_properties.DamageRegularMin = dmg;
			_properties.DamageRegularMax = dmg;
			_properties.MeleeDefense += 10;
		}
	}

});
