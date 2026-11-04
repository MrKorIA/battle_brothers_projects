this.ai_mob_scythe_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.ai_punch";
		this.m.Name = "Специальная атака";
		this.m.Description = "aa";
		this.m.Overlay = "active_100";
		this.m.SoundOnUse = [
			"sounds/combat/reap_01.wav",
			"sounds/combat/reap_02.wav",
			"sounds/combat/reap_03.wav"
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/combat/reap_hit_01.wav",
			"sounds/combat/reap_hit_02.wav",
			"sounds/combat/reap_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsTooCloseShown = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.2;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.ChanceDecapitate = 100;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			if (this.Math.rand(1, 100) <= 11)
			{
				_properties.MeleeSkill += 500;
			}
		}
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSwing);
		local ret = false;
		local myTile = _user.getTile();
		local myTile = this.m.Container.getActor().getTile();
		local d = myTile.getDistanceTo(_targetTile);
		local result = {
			Tiles = [],
			MyTile = myTile,
			TargetTile = _targetTile,
			Num = 0
		};
		this.Tactical.queryTilesInRange(myTile, d, d, false, [], this.onQueryTilesHit, result);
		local tiles = [];

		for( local i = 0; i != result.Tiles.len(); i = ++i )
		{
			if (result.Tiles[i].ID == _targetTile.ID)
			{
				tiles.push(result.Tiles[i]);
				local idx = i - 1;

				if (idx < 0)
				{
					idx = idx + result.Tiles.len();
				}

				tiles.push(result.Tiles[idx]);
				idx = i - 2;

				if (idx < 0)
				{
					idx = idx + result.Tiles.len();
				}

				tiles.push(result.Tiles[idx]);
				break;
			}
		}

		foreach( t in tiles )
		{
			if (!t.IsVisibleForEntity)
			{
				continue;
			}

			if (this.Math.abs(t.Level - myTile.Level) > 1 || this.Math.abs(t.Level - _targetTile.Level) > 1)
			{
				continue;
			}

			if (!t.IsEmpty && t.getEntity().isAttackable() && !t.getEntity().isAlliedWith(_user))
			{
				ret = this.attackEntity(_user, t.getEntity()) || ret;
			}

			if (!_user.isAlive() || _user.isDying())
			{
				break;
			}
		}

		return ret;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == this && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			if (this.Math.rand(1, 2) == 1 && !_targetEntity.getSkills().hasSkill("effects.insect_swarm"))
			{
				local sounds = [
					"sounds/status/insect_swarm_effect_01.wav",
					"sounds/status/insect_swarm_effect_02.wav",
					"sounds/status/insect_swarm_effect_03.wav"
				];
				this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], 1.0, _targetEntity.getTile().Pos);
				_targetEntity.getSkills().add(this.new("scripts/skills/effects/insect_swarm_effect"));
			}
			else 
			if (this.Math.rand(1, 2) == 1 && !_targetEntity.getCurrentProperties().IsRooted && !_targetEntity.getCurrentProperties().IsImmuneToRoot && !_targetEntity.getSkills().hasSkill("effects.rooted"))
			{
				local sounds = [
					"sounds/combat/break_free_roots_00.wav",
					"sounds/combat/break_free_roots_01.wav",
					"sounds/combat/break_free_roots_02.wav",
					"sounds/combat/break_free_roots_03.wav"
				];
				this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], 1.0, _targetEntity.getTile().Pos);
				_targetEntity.getSkills().add(this.new("scripts/skills/effects/rooted_effect"));
				local breakFree = this.new("scripts/skills/actives/break_free_skill");
				breakFree.setDecal("roots_destroyed");
				breakFree.m.Icon = "skills/active_75.png";
				breakFree.m.IconDisabled = "skills/active_75_sw.png";
				breakFree.m.Overlay = "active_75";
				breakFree.m.SoundOnUse = sounds;
				_targetEntity.getSkills().add(breakFree);
				_targetEntity.raiseRootsFromGround("bust_roots", "bust_roots_back");
			}
		}
	}

	function onQueryTilesHit( _tile, _result )
	{
		_result.Tiles.push(_tile);
	}

	function onTargetSelected( _targetTile )
	{
		local myTile = this.m.Container.getActor().getTile();
		local d = myTile.getDistanceTo(_targetTile);
		local result = {
			Tiles = [],
			MyTile = myTile,
			TargetTile = _targetTile,
			Num = 0
		};
		this.Tactical.queryTilesInRange(myTile, d, d, false, [], this.onQueryTilesHit, result);
		local tiles = [];

		for( local i = 0; i != result.Tiles.len(); i = ++i )
		{
			if (result.Tiles[i].ID == _targetTile.ID)
			{
				tiles.push(result.Tiles[i]);
				local idx = i - 1;

				if (idx < 0)
				{
					idx = idx + result.Tiles.len();
				}

				tiles.push(result.Tiles[idx]);
				idx = i - 2;

				if (idx < 0)
				{
					idx = idx + result.Tiles.len();
				}

				tiles.push(result.Tiles[idx]);
				break;
			}
		}

		foreach( t in tiles )
		{
			if (!t.IsVisibleForEntity)
			{
				continue;
			}

			if (this.Math.abs(t.Level - myTile.Level) > 1 || this.Math.abs(t.Level - _targetTile.Level) > 1)
			{
				continue;
			}

			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, t, t.Pos.X, t.Pos.Y);
		}
	}

});

