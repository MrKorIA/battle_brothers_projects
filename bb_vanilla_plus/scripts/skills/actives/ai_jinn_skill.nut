this.ai_jinn_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.ai_punch";
		this.m.Name = "Элементальная атака";
		this.m.Overlay = "active_21";
		this.m.SoundOnUse = [
			"sounds/enemies/ghoul_claws_01.wav",
			"sounds/enemies/ghoul_claws_02.wav",
			"sounds/enemies/ghoul_claws_03.wav",
			"sounds/enemies/ghoul_claws_04.wav",
			"sounds/enemies/ghoul_claws_05.wav",
			"sounds/enemies/ghoul_claws_06.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.Delay = 1250;
		this.m.InjuriesOnBody = this.Const.Injury.BurningBody;
		this.m.InjuriesOnHead = this.Const.Injury.BurningHead;
		this.m.DirectDamageMult = 0.2;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
	}

	function applyEffect( _data, _delay )
	{
		this.Time.scheduleEvent(this.TimeUnit.Virtual, _delay, function ( _data )
		{
			if (_data.User.getFlags().has("firejinn"))
			{
				for( local i = 0; i < this.Const.Tactical.MortarFireRightParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarFireRightParticles[i].Brushes, _data.TargetTile, this.Const.Tactical.MortarFireRightParticles[i].Delay, this.Const.Tactical.MortarFireRightParticles[i].Quantity * 0.5, this.Const.Tactical.MortarFireRightParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.MortarFireRightParticles[i].SpawnRate, this.Const.Tactical.MortarFireRightParticles[i].Stages, this.createVec(0, -30));
				}
				for( local i = 0; i < this.Const.Tactical.BurnParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, _data.TargetTile, this.Const.Tactical.BurnParticles[i].Delay, this.Const.Tactical.BurnParticles[i].Quantity * 0.5, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, this.createVec(0, -30));
				}
			}
			else
			{
				for( local i = 0; i < this.Const.Tactical.LightningParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.LightningParticles[i].Brushes, _data.TargetTile, this.Const.Tactical.LightningParticles[i].Delay, this.Const.Tactical.LightningParticles[i].Quantity, this.Const.Tactical.LightningParticles[i].LifeTimeQuantity, this.Const.Tactical.LightningParticles[i].SpawnRate, this.Const.Tactical.LightningParticles[i].Stages);
				}
			}
		}, _data);

		if (_data.Target == null)
		{
			return;
		}

		this.Time.scheduleEvent(this.TimeUnit.Virtual, _delay + 200, function ( _data )
		{
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = this.Math.rand(10, 20);
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			_data.Target.onDamageReceived(_data.User, _data.Skill, hitInfo);
		}, _data);
	}

	function onUse( _user, _targetTile )
	{
		if (_user.getFlags().has("firejinn"))
		{
			for( local i = 0; i < this.Const.Tactical.MortarFireRightParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarFireRightParticles[i].Brushes, _targetTile, this.Const.Tactical.MortarFireRightParticles[i].Delay, this.Const.Tactical.MortarFireRightParticles[i].Quantity * 0.5, this.Const.Tactical.MortarFireRightParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.MortarFireRightParticles[i].SpawnRate, this.Const.Tactical.MortarFireRightParticles[i].Stages, this.createVec(0, -30));
			}
			for( local i = 0; i < this.Const.Tactical.BurnParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, _targetTile, this.Const.Tactical.BurnParticles[i].Delay, this.Const.Tactical.BurnParticles[i].Quantity * 0.5, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, this.createVec(0, -30));
			}
		}
		else
		{
			for( local i = 0; i < this.Const.Tactical.LightningParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.LightningParticles[i].Brushes, _targetTile, this.Const.Tactical.LightningParticles[i].Delay, this.Const.Tactical.LightningParticles[i].Quantity, this.Const.Tactical.LightningParticles[i].LifeTimeQuantity, this.Const.Tactical.LightningParticles[i].SpawnRate, this.Const.Tactical.LightningParticles[i].Stages);
			}
		}
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectClaws);
		local success = this.attackEntity(_user, _targetTile.getEntity());
		local myTile = _user.getTile();

		if (success && _user.isAlive() && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == _user.getID())
		{
			local selectedTargets = [];
			local potentialTargets = [];
			local potentialTiles = [];
			local target;
			local targetTile = _targetTile;

			if (!targetTile.IsEmpty && targetTile.getEntity().isAlive())
			{
				target = targetTile.getEntity();
				selectedTargets.push(target.getID());
			}

			local data = {
				Skill = this,
				User = _user,
				TargetTile = targetTile,
				Target = target
			};
			this.applyEffect(data, 100);
			potentialTargets = [];
			potentialTiles = [];

			for( local i = 0; i < 6; i = ++i )
			{
				if (!targetTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = targetTile.getNextTile(i);

					if (tile.ID != myTile.ID)
					{
						potentialTiles.push(tile);
					}

					if (!tile.IsOccupiedByActor || !tile.getEntity().isAttackable() || tile.getEntity().isAlliedWith(_user) || selectedTargets.find(tile.getEntity().getID()) != null)
					{
					}
					else
					{
						potentialTargets.push(tile);
					}
				}
			}

			if (potentialTargets.len() != 0)
			{
				target = potentialTargets[this.Math.rand(0, potentialTargets.len() - 1)].getEntity();
				selectedTargets.push(target.getID());
				targetTile = target.getTile();
			}
			else
			{
				target = null;
				targetTile = potentialTiles[this.Math.rand(0, potentialTiles.len() - 1)];
			}

			local data = {
				Skill = this,
				User = _user,
				TargetTile = targetTile,
				Target = target
			};
			this.applyEffect(data, 350);
			potentialTargets = [];
			potentialTiles = [];

			for( local i = 0; i < 6; i = ++i )
			{
				if (!targetTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = targetTile.getNextTile(i);

					if (tile.ID != myTile.ID)
					{
						potentialTiles.push(tile);
					}

					if (!tile.IsOccupiedByActor || !tile.getEntity().isAttackable() || tile.getEntity().isAlliedWith(_user) || selectedTargets.find(tile.getEntity().getID()) != null)
					{
					}
					else
					{
						potentialTargets.push(tile);
					}
				}
			}

			if (potentialTargets.len() != 0)
			{
				target = potentialTargets[this.Math.rand(0, potentialTargets.len() - 1)].getEntity();
				selectedTargets.push(target.getID());
				targetTile = target.getTile();
			}
			else
			{
				target = null;
				targetTile = potentialTiles[this.Math.rand(0, potentialTiles.len() - 1)];
			}

			local data = {
				Skill = this,
				User = _user,
				TargetTile = targetTile,
				Target = target
			};
			this.applyEffect(data, 550);
		}

		return success;
	}

});

