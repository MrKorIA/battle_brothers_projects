::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/tail_slam_split_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Name = "Выпад хвостом";
		m.Description = "Широко размашистая атака сверху хвостом, выполняемая для максимального охвата, а не силы, которая может поразить две клетки по прямой.";
		m.KilledString = "Сокрушён";
		m.Icon = "skills/active_108.png";
		m.IconDisabled = "skills/active_108_sw.png";
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultTooltip();
		ret.extend([
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
				text = "Может поразить до двух целей"
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
		spawnAttackEffect(_targetTile, ::Const.Tactical.AttackEffectSplit);
		local ret = attackEntity(_user, _targetTile.getEntity());

		if (!_user.isAlive() || _user.isDying())
			return ret;

		if (ret && _targetTile.IsOccupiedByActor && _targetTile.getEntity().isAlive() && !_targetTile.getEntity().isDying())
			applyEffectToTarget(_user, _targetTile.getEntity(), _targetTile);

		local ownTile = _user.getTile();
		local dir = ownTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir)) {
			local forwardTile = _targetTile.getNextTile(dir);
			local canbeHit = forwardTile.IsOccupiedByActor && canBeHit(_user, forwardTile.getEntity());

			if (forwardTile.IsOccupiedByActor && forwardTile.getEntity().isAttackable() && ::Math.abs(forwardTile.Level - ownTile.Level) <= 1 && canbeHit)
				ret = attackEntity(_user, forwardTile.getEntity()) || ret;

			if (ret && forwardTile.IsOccupiedByActor && forwardTile.getEntity().isAlive() && !forwardTile.getEntity().isDying() && canbeHit)
				applyEffectToTarget(_user, forwardTile.getEntity(), forwardTile);
		}

		return ret;
	}

	q.onTargetSelected <- function( _targetTile )
	{
		::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		local ownTile = getContainer().getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir)) {
			local forwardTile = _targetTile.getNextTile(dir);

			if (::Math.abs(forwardTile.Level - ownTile.Level) <= 1)
				::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, forwardTile, forwardTile.Pos.X, forwardTile.Pos.Y);
		}
	}

	q.canBeHit <- function( _user, _target )
	{
		if (!_target.getFlags().has("lindwurm")) return true;
		else if (!_target.isAlliedWith(_user)) return true;
		else return false;
	}

});
