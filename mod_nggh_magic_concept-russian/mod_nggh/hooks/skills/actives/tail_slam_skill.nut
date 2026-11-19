::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/tail_slam_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Name = "Взмах хвостом";
		m.Description = "Взмахнуть хвостом по широкой дуге, чтобы атаковать три соседние клетки против часовой стрелки. Не наносит урон себе.";
		m.KilledString = "Сокрушён";
		m.Icon = "skills/active_108.png";
		m.IconDisabled = "skills/active_108_sw.png";
		m.Order = ::Const.SkillOrder.OffensiveTargeted + 1;
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]" + m.HitChanceBonus + "%[/color] к шансу на попадание"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Имеет шанс [color=" + ::Const.UI.Color.NegativeValue + "]выбить дух[/color], [color=" + ::Const.UI.Color.NegativeValue + "]оглушить[/color] или [color=" + ::Const.UI.Color.NegativeValue + "]оттолкнуть[/color] при попадании"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Никогда не наносит урон [color=" + ::Const.UI.Color.NegativeValue + "]себе[/color] или [color=" + ::Const.UI.Color.NegativeValue + "]себе подобным[/color]"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Может поразить до трёх целей"
			}
		]);

		return ret;
	}

	q.onAfterUpdate <- function( _properties )
	{
		m.FatigueCostMult = _properties.IsSpecializedInAxes ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	q.onUse = @() function( _user, _targetTile )
	{
		m.TilesUsed = [];
		spawnAttackEffect(_targetTile, ::Const.Tactical.AttackEffectSwing);
		local ret = false;
		local ownTile = _user.getTile();
		local dir = ownTile.getDirectionTo(_targetTile);
		ret = attackEntity(_user, _targetTile.getEntity());

		if (!_user.isAlive() || _user.isDying())
			return ret;

		if (ret && _targetTile.IsOccupiedByActor && _targetTile.getEntity().isAlive() && !_targetTile.getEntity().isDying())
			applyEffectToTarget(_user, _targetTile.getEntity(), _targetTile);

		local nextDir = dir - 1 >= 0 ? dir - 1 : ::Const.Direction.COUNT - 1;

		if (ownTile.hasNextTile(nextDir)) {
			local nextTile = ownTile.getNextTile(nextDir);
			local success = false;
			local canBeHit = nextTile.IsOccupiedByActor && canBeHit(_user, nextTile.getEntity());

			if (nextTile.IsOccupiedByActor && nextTile.getEntity().isAttackable() && ::Math.abs(nextTile.Level - ownTile.Level) <= 1 && canBeHit)
				success = attackEntity(_user, nextTile.getEntity());
			
			if (!_user.isAlive() || _user.isDying())
				return success;

			if (success && nextTile.IsOccupiedByActor && nextTile.getEntity().isAlive() && !nextTile.getEntity().isDying() && canBeHit)
				applyEffectToTarget(_user, nextTile.getEntity(), nextTile);

			ret = success || ret;
		}

		nextDir = nextDir - 1 >= 0 ? nextDir - 1 : ::Const.Direction.COUNT - 1;

		if (ownTile.hasNextTile(nextDir)) {
			local nextTile = ownTile.getNextTile(nextDir);
			local success = false;
			local canBeHit = nextTile.IsOccupiedByActor && canBeHit(_user, nextTile.getEntity());

			if (nextTile.IsOccupiedByActor && nextTile.getEntity().isAttackable() && ::Math.abs(nextTile.Level - ownTile.Level) <= 1 && canBeHit)
				success = attackEntity(_user, nextTile.getEntity());

			if (!_user.isAlive() || _user.isDying())
				return success;

			if (success && nextTile.IsOccupiedByActor && nextTile.getEntity().isAlive() && !nextTile.getEntity().isDying() && canBeHit)
				applyEffectToTarget(_user, nextTile.getEntity(), nextTile);

			ret = success || ret;
		}

		m.TilesUsed = [];
		return ret;
	}

	q.onTargetSelected <- function( _targetTile )
	{
		local ownTile = getContainer().getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);
		::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		local nextDir = dir - 1 >= 0 ? dir - 1 : ::Const.Direction.COUNT - 1;

		if (ownTile.hasNextTile(nextDir)) {
			local nextTile = ownTile.getNextTile(nextDir);

			if (::Math.abs(nextTile.Level - ownTile.Level) <= 1)
				::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, nextTile, nextTile.Pos.X, nextTile.Pos.Y);
		}

		nextDir = nextDir - 1 >= 0 ? nextDir - 1 : ::Const.Direction.COUNT - 1;

		if (ownTile.hasNextTile(nextDir)) {
			local nextTile = ownTile.getNextTile(nextDir);

			if (::Math.abs(nextTile.Level - ownTile.Level) <= 1)
				::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, nextTile, nextTile.Pos.X, nextTile.Pos.Y);
		}
	}

	q.canBeHit <- function( _user, _target )
	{
		if (!_target.getFlags().has("lindwurm")) return true;
		else if (!_target.isAlliedWith(_user)) return true;
		else return false;
	}
	
});
