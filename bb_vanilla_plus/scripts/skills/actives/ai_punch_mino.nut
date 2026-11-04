this.ai_punch_mino <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.ai_punch";
		this.m.Name = "Атака";
		this.m.Overlay = "active_06";
		this.m.SoundOnUse = [
			"sounds/combat/overhead_strike_01.wav",
			"sounds/combat/overhead_strike_02.wav",
			"sounds/combat/overhead_strike_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/overhead_strike_hit_01.wav",
			"sounds/combat/overhead_strike_hit_02.wav",
			"sounds/combat/overhead_strike_hit_03.wav"
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
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceSmash = 50;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (!_user.isAlive() || _user.isDying())
		{
			return;
		}
		if (this.Tactical.TurnSequenceBar.getActiveEntity().getID() != _user.getID())
		{
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSwing);
			return this.attackEntity(_user, _targetTile.getEntity());
		}
		local success = this.attackEntity(_user, _targetTile.getEntity());
		if (success && target.isAlive() && !target.isDying() && this.Math.rand(1, 100) <= this.m.ChanceSmash)
		{
			local tiles = {
				User = _user,
				Tiles = []
			};
			this.Tactical.queryTilesInRange(_user.getTile(), 1, 3, false, [], this.onQueryTargetTile, tiles);
			if (tiles.len() > 0)
			{
				this.Tactical.getNavigator().teleport(target, tiles.Tiles[this.Math.rand(0, tiles.Tiles.len() - 1)], null, null, false, 1.5);
			}
			this.m.ChanceSmash = 50;
			this.spawnAttackEffect(_user.getTile(), this.Const.Tactical.AttackEffectThresh);
		}
		else
		{
			this.m.ChanceSmash = this.m.ChanceSmash + 10;
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSwing);
		}


		return success;
	}

	function onQueryTargetTile(_tile, _tag)
	{
		if (_tile == null)
		{
			return;
		}
		if (!this.Tactical.isValidTileSquare(_tile.Coords.X, _tile.Coords.Y))
		{
			return;
		}
		if (_tile.Type == this.Const.Tactical.TerrainType.Impassable)
		{
			return;
		}
		if (!_tile.IsEmpty)
		{
			return;
		}
		if (this.Math.abs(_tag.User.getTile().Level - _tile.Level) > 1)
		{
			return;
		}
		_tag.Tiles.push(_tile);
	}

});

