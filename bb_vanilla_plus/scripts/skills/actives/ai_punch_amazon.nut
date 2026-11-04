this.ai_punch_amazon <- this.inherit("scripts/skills/skill", {
	m = {
		hasShield = true
	},
	function create()
	{
		this.m.ID = "actives.ai_punch";
		this.m.Name = "Shield Bash";
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
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.4;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function isUsable()
	{
		if (!this.Tactical.isActive())
		{
			return true;
		}
		if (!this.skill.isUsable())
		{
			return false;
		}
		local actor = this.getContainer().getActor();
		local isMyTurn = (this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == actor.getID());
		if (!isMyTurn)
		{
			return true;
		}
		return actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions());
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		local dir = _userTile.getDirectionTo(_targetTile);
		if (_targetTile.hasNextTile(dir))
		{
			local knockToTile = _targetTile.getNextTile(dir);
			if (knockToTile.IsEmpty && knockToTile.Type != this.Const.Tactical.TerrainType.Impassable && knockToTile.Level - _targetTile.Level <= 1)
			{
				return knockToTile;
			}
		}
		local altdir = dir - 1 >= 0 ? dir - 1 : 5;
		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);
			if (knockToTile.IsEmpty && knockToTile.Type != this.Const.Tactical.TerrainType.Impassable && knockToTile.Level - _targetTile.Level <= 1)
			{
				return knockToTile;
			}
		}
		altdir = dir + 1 <= 5 ? dir + 1 : 0;
		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);
			if (knockToTile.IsEmpty && knockToTile.Type != this.Const.Tactical.TerrainType.Impassable && knockToTile.Level - _targetTile.Level <= 1)
			{
				return knockToTile;
			}
		}
		return null;
	}

	function checkShield( _user )
	{
		local offhandItem = _user.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		this.m.hasShield = (offhandItem != null && offhandItem.isItemType(this.Const.Items.ItemType.Shield));
		return this.m.hasShield;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local offhandItem = _user.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		local hasShield = this.checkShield(_user);

		if (hasShield)
		{
			this.m.Name = "Shield Bash";
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
			this.m.DirectDamageMult = 0.4;
			this.Tactical.spawnSpriteEffect("active_10", this.createColor("#ffffff"), _user.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, this.Const.Tactical.Settings.SkillOverlayOffsetY, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration + this.m.Delay, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
		}
		else
		{
			this.m.Name = "Thrust";
			this.m.SoundOnUse = [
				"sounds/combat/thrust_01.wav",
				"sounds/combat/thrust_02.wav",
				"sounds/combat/thrust_03.wav"
			];
			this.m.SoundOnHit = [
				"sounds/combat/thrust_hit_01.wav",
				"sounds/combat/thrust_hit_02.wav",
				"sounds/combat/thrust_hit_03.wav"
			];
			this.m.DirectDamageMult = 0.2;
			this.Tactical.spawnSpriteEffect("active_04", this.createColor("#ffffff"), _user.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, this.Const.Tactical.Settings.SkillOverlayOffsetY, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration + this.m.Delay, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectThrust);
			return this.attackEntity(_user, target);
		}

		local success = this.attackEntity(_user, target);
		if (!_user.isAlive() || _user.isDying())
		{
			return;
		}

		local isUserTurn = (this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == _user.getID());
		if (isUserTurn && success && target.isAlive() && !target.isDying() && !target.getCurrentProperties().IsImmuneToKnockBackAndGrab && !target.getCurrentProperties().IsRooted)
		{
			local pushDistance = this.Math.rand(1, 2);
			local currentOriginTile = _user.getTile();
			local currentTargetTile = target.getTile();
			local finalDestTile = null;
			for (local i = 0; i < pushDistance; i = ++i)
			{
				local nextTile = this.findTileToKnockBackTo(currentOriginTile, currentTargetTile);
				if (nextTile != null)
				{
					finalDestTile = nextTile;
					currentOriginTile = currentTargetTile;
					currentTargetTile = nextTile;
				}
				else
				{
					break;
				}
			}
			if (finalDestTile != null)
			{
				target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
				this.Tactical.getNavigator().teleport(target, finalDestTile, null, null, false, 1.5);
			}
		}
		return success;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local hasShield = this.checkShield(this.getContainer().getActor());
			if (hasShield)
			{
				_properties.DamageRegularMin = 30;
				_properties.DamageRegularMax = 50;
				_properties.DamageArmorMult = 1.0;
			}
			else
			{
				_properties.DamageRegularMin = 30;
				_properties.DamageRegularMax = 40;
				_properties.DamageArmorMult = 0.8;
			}
		}
	}

	function onUpdate( _properties )
	{
		local hasShield = this.checkShield(this.getContainer().getActor());
		if (hasShield)
		{
			_properties.DamageReceivedTotalMult *= 0.5;
		}
	}

});
