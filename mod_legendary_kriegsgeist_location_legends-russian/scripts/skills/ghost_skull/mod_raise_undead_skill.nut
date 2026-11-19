this.mod_raise_undead_skill <- ::inherit("scripts/skills/mod_ghost_skull_magic_skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.raise_undead";
		this.m.Name = "Поднятие нежити";
		this.m.Description = "Воскрешает человеческий труп к жизни, который сражается за вас. Не может быть использовано, если персонаж вовлечен в ближний бой.";
		this.m.Icon = "skills/active_26.png";
		this.m.IconDisabled = "skills/raisedead2_bw.png";
		this.m.Overlay = "active_26";
		this.m.SoundOnHit = [
			"sounds/enemies/dlc2/alp_idle_01.wav",
			"sounds/enemies/dlc2/alp_idle_02.wav",
			"sounds/enemies/dlc2/alp_idle_03.wav",
			"sounds/enemies/dlc2/alp_idle_04.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 1;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 4;
		this.m.XPCost = 25;
		this.m.XPLevel = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 7;
		this.m.MaxLevelDifference = 4;
	}

	function isUsable()
	{
		return this.mod_ghost_skull_magic_skill.isUsable() && !this.getContainer().getActor().isEngagedInMelee();
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
				id = 1,
				type = "hint",
				icon = "ui/icons/skills.png",
				text = "Уровень [b]0[/b] умения, для разблокировки требуется [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.XPLevel * 500 + "[/color] очков души"
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

		if (!::MSU.Tile.canResurrectOnTile(_targetTile))
		{
			return false;
		}

		if (!_targetTile.IsEmpty)
		{
			return false;
		}

		return true;
	}

	function spawnUndead( _user, _tile )
	{
		local p = _tile.Properties.get("Corpse");
		p.Faction = _user.getFaction();
		if (p.Faction == ::Const.Faction.Player)
		{
			p.Faction = ::Const.Faction.PlayerAnimals;
		}
		local e = ::Tactical.Entities.onResurrect(p, true);

		if (e != null)
		{
			e.getSprite("socket").setBrush(_user.getSprite("socket").getBrush().Name);
		}
	}

	function onUse( _user, _targetTile )
	{
		if (_targetTile.IsVisibleForPlayer)
		{
			for( local i = 0; i < ::Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
			{
				::Tactical.spawnParticleEffect(true, ::Const.Tactical.RaiseUndeadParticles[i].Brushes, _targetTile, ::Const.Tactical.RaiseUndeadParticles[i].Delay, ::Const.Tactical.RaiseUndeadParticles[i].Quantity, ::Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, ::Const.Tactical.RaiseUndeadParticles[i].SpawnRate, ::Const.Tactical.RaiseUndeadParticles[i].Stages);
			}
			
			if (_user.isDiscovered() && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " поднимает нежить");

				if (this.m.SoundOnHit.len() != 0)
				{
					::Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], ::Const.Sound.Volume.Skill * 1.2, _user.getPos());
				}
			}
		}

		this.spawnUndead(_user, _targetTile);
		return true;
	}

	function onTargetSelected( _targetTile )
	{
	}

});

