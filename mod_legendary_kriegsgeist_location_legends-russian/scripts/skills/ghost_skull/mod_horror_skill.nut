this.mod_horror_skill <- ::inherit("scripts/skills/mod_ghost_skull_magic_skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.horror";
		this.m.Name = "Ужас";
		this.m.Description = "Проецирует ужасающие образы в сознание тех, кто находится в зоне его действия. Убивает желание бороться практически у любого живого существа, лишает их надежды, позволяет страху поглотить их.";
		this.m.Icon = "skills/active_102.png";
		this.m.IconDisabled = "skills/active_102_sw.png";
		this.m.Overlay = "active_102";
		this.m.SoundOnUse = [
			"sounds/enemies/horror_spell_01.wav",
			"sounds/enemies/horror_spell_02.wav",
			"sounds/enemies/horror_spell_03.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 5;
		this.m.Delay = 0;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.NotGoodInMelee = true;
		this.m.ActionPointCost = 6;
		this.m.XPCost = 100;
		this.m.XPLevel = 8;
		this.m.MinRange = 1;
		this.m.MaxRange = 7;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local ret = this.mod_ghost_skull_magic_skill.getTooltip();

		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Имеет дальность действия в [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] клеток на ровной местности, при использовании с возвышенности дальность увеличивается."
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Может поразить до 7-ми целей."
			},
			{
				id = 1,
				type = "hint",
				icon = "ui/icons/skills.png",
				text = "Уровень [b]4[/b] умения, для разблокировки требуется [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.XPLevel * 500 + "[/color] очков души"
			}
		]);

		return ret;
	}

	function isViableTarget( _user, _target )
	{
		if (_user.getID() == _target.getID())
		{
			return false;
		}

		if (_target.getMoraleState() == ::Const.MoraleState.Ignore)
		{
			return false;
		}

		if (_target.getCurrentProperties().MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] >= 1000.0)
		{
			return false;
		}
		
		if (_target.getCurrentProperties().IsStunned)
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local targets = [];

		if (_targetTile.IsOccupiedByActor)
		{
			local entity = _targetTile.getEntity();

			if (this.isViableTarget(_user, entity))
			{
				targets.push(entity);
			}
		}

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local adjacent = _targetTile.getNextTile(i);

				if (adjacent.IsOccupiedByActor)
				{
					local entity = adjacent.getEntity();

					if (this.isViableTarget(_user, entity))
					{
						targets.push(entity);
					}
				}
			}
		}

		foreach( target in targets )
		{
			local effect = ::Tactical.spawnSpriteEffect("effect_skull_03", ::createColor("#ffffff"), target.getTile(), 0, 40, 1.0, 0.25, 0, 400, 300);
			target.checkMorale(-1, -15, ::Const.MoraleCheckType.MentalAttack);

			if (target.getMoraleState() == ::Const.MoraleState.Fleeing || !target.checkMorale(0, -5, ::Const.MoraleCheckType.MentalAttack))
			{
				target.getSkills().add(::new("scripts/skills/effects/horrified_effect"));

				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					::Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " объят ужасом");
				}
			}
		}

		return true;
	}

	function onTargetSelected( _targetTile )
	{
		::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);

		for( local i = 0; i != 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);
				::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
			}
		}
	}

});

