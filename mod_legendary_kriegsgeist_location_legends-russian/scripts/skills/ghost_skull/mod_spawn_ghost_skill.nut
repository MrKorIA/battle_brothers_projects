this.mod_spawn_ghost_skill <- ::inherit("scripts/skills/mod_ghost_skull_magic_skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.spawn_ghost";
		this.m.Name = "Вызвать духа";
		this.m.Description = "Запускает [b]духа[/b] прямо на целевую клетку, который наносит урон всем, кто находится на его пути. Для расчета шанса попадания используется навык ближнего боя.";
		this.m.Icon = "skills/active_spawn_ghost.png";
		this.m.IconDisabled = "skills/active_spawn_ghost_sw.png";
		this.m.Overlay = "active_mod_spawn_ghost";
		this.m.SoundOnUse = [
			"sounds/enemies/ghost_death_01.wav",
			"sounds/enemies/ghost_death_02.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 4;
		this.m.IsSerialized = false;
		this.m.Delay = 500;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsIgnoringRiposte = true;
		this.m.IsSpearwallRelevant = false;
		this.m.IsUsingHitchance = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 6;
		this.m.XPCost = 250;
		this.m.XPLevel = 6;
		this.m.MinRange = 2;
		this.m.MaxRange = 4;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();

		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Имеет дальность действия в [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMinRange() + "[/color] - [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] клеток"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Полностью игнорирует броню"
			},
			{
				id = 7,
				type = "hint",
				icon = "ui/tooltips/negative.png",
				text = "Жертва, убитая этим умением, не дает очков души"
			},
			{
				id = 1,
				type = "hint",
				icon = "ui/icons/skills.png",
				text = "Уровень [b]3[/b] умения, для разблокировки требуется [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.XPLevel * 500 + "[/color] очков души"
			}
		]);

		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		return _targetTile.IsEmpty;
	}

	function onUse( _user, _targetTile )
	{
		local originTile;
		local myTile = _user.getTile();

		/*local dir = _targetTile.getDirectionTo(myTile);

		if (myTile.hasNextTile(dir))
		{
			originTile = myTile.getNextTile(dir);
		}
		else
		{
			originTile = myTile;
		}*/

		local targets = [];
		local myPos = _user.getPos();
		local targetPos = _targetTile.Pos;
		local distance = myTile.getDistanceTo(_targetTile);
		local Dx = (targetPos.X - myPos.X) / distance;
		local Dy = (targetPos.Y - myPos.Y) / distance;

		for( local i = 1; i < distance; i = ++i )
		{
			local x = myPos.X + Dx * i;
			local y = myPos.Y + Dy * i;
			local tileCoords = ::Tactical.worldToTile(::createVec(x, y));
			local tile = ::Tactical.getTile(tileCoords);

			if (tile != null && tile.IsOccupiedByActor)
			{
				targets.push(tile.getEntity());
			}
		}

		local flip = _user.isAlliedWithPlayer() ? _targetTile.X <= _user.getPos().X : _targetTile.X > _user.getPos().X;
		local time = ::Tactical.spawnProjectileEffect("bust_ghost_01", /*originTile*/ myTile, _targetTile, 1.0, 1.0, false, flip);
		::Time.scheduleEvent(::TimeUnit.Virtual, time, this.onSpawnGhost.bindenv(this), {
			User = _user,
			Targets = targets,
			TargetTile = _targetTile
		});
		return true;
	}

	function onSpawnGhost( _tag )
	{
		local _user = _tag.User;
		local _faction = _user.getFaction() == ::Const.Faction.Player ? ::Const.Faction.PlayerAnimals : _user.getFaction();

		foreach (e in _tag.Targets)
		{
			this.attackEntity(_user, e);
			e.checkMorale(-1, 0, ::Const.MoraleCheckType.MentalAttack);
		}

		local ghost = ::Tactical.spawnEntity("scripts/entity/tactical/enemies/ghost", _tag.TargetTile.Coords);
		ghost.spawnGhostEffect(_tag.TargetTile);
		ghost.setFaction(_faction);
		ghost.getSprite("socket").setBrush(_user.getSprite("socket").getBrush().Name);
		ghost.getSkills().add(::new("scripts/skills/perks/perk_fearsome"));
		ghost.getSkills().add(::new("scripts/skills/perks/perk_footwork"));
		ghost.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		ghost.getSkills().add(::new("scripts/skills/perks/perk_anticipation"));
		ghost.getSkills().add(::new("scripts/skills/perks/perk_dodge"));
	}

	function onTargetSelected( _targetTile )
	{
		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();
		local myPos = actor.getPos();
		local targetPos = _targetTile.Pos;
		local distance = myTile.getDistanceTo(_targetTile);
		local Dx = (targetPos.X - myPos.X) / distance;
		local Dy = (targetPos.Y - myPos.Y) / distance;

		for( local i = 1; i < distance; i = ++i )
		{
			local x = myPos.X + Dx * i;
			local y = myPos.Y + Dy * i;
			local tileCoords = ::Tactical.worldToTile(::createVec(x, y));
			local tile = ::Tactical.getTile(tileCoords);

			if (tile != null)
			{
				::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
			}
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 5;
			_properties.DamageRegularMax += 10;
			_properties.DamageArmorMult *= 0.0;
			_properties.IsIgnoringArmorOnAttack = true;
		}
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (_skill == this)
		{
			_targetEntity.getFlags().add("give_no_xp");
		}
	}

});

