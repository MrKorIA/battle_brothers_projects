this.mod_wither_skill <- ::inherit("scripts/skills/mod_ghost_skull_magic_skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.wither";
		this.m.Name = "Иссушение";
		this.m.Description = "Ослабляет цель на три хода, снижая ее урон, выносливость и инициативу на [color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color]. Эффект уменьшается на 10% каждый ход.";
		this.m.Icon = "skills/active_217.png";
		this.m.IconDisabled = "skills/active_217_sw.png";
		this.m.Overlay = "active_217";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/wither_01.wav",
			"sounds/enemies/dlc6/wither_02.wav",
			"sounds/enemies/dlc6/wither_03.wav"
		];
		this.m.SoundVolume = 1.2;
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 2;
		this.m.Delay = 0;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.NotGoodInMelee = true;
		this.m.ActionPointCost = 5;
		this.m.XPCost = 50;
		this.m.XPLevel = 2;
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
				id = 1,
				type = "hint",
				icon = "ui/icons/skills.png",
				text = "Уровень [b]1[/b] умения, для разблокировки требуется [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.XPLevel * 500 + "[/color] очков души"
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

		if (_targetTile.getEntity().getFlags().get("undead"))
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		target.getSkills().add(this.new("scripts/skills/effects/withered_effect"));

		if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + " иссушен");
		}

		return true;
	}
	
	function onTargetSelected( _targetTile )
	{
	}

});

