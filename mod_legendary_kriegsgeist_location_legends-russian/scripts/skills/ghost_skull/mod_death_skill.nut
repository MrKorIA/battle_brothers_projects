this.mod_death_skill <- ::inherit("scripts/skills/mod_ghost_skull_magic_skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.death";
		this.m.Name = "Смерть";
		this.m.Description = "Цель всех жизней - смерть, от смерти никуда не деться. Однако существует короткий путь к ней.";
		this.m.Icon = "skills/active_mod_death.png";
		this.m.IconDisabled = "skills/active_mod_death_sw.png";
		this.m.Overlay = "active_mod_death";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/lich_death_01.wav",
			"sounds/enemies/dlc4/madman_death_01.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 6;
		this.m.Delay = 1000;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 6;
		this.m.XPCost = 5000;
		this.m.XPLevel = 10;
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
				text = "Мгновенно убивает все, что угодно"
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
				text = "Уровень [b]5[/b] умения, для разблокировки требуется [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.XPLevel * 500 + "[/color] очков души"
			}
		]);

		return ret;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();

		if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
		{
			::Tactical.EventLog.log("[b]Смерть[/b] пришла за персонажем " + this.Const.UI.getColorizedEntityName(target));
		}

		local effect = ::Tactical.spawnSpriteEffect("effect_skull_02", ::createColor("#ffffff"), _targetTile, 0, 40, 1.0, 0.25, 0, 400, 300);
		::Time.scheduleEvent(::TimeUnit.Virtual, effect, this.onInstantKill.bindenv(this), {
			User = _user,
			Target = target,
			TargetTile = _targetTile
		});
		return true;
	}

	function onInstantKill( _tag )
	{
		_tag.Target.getFlags().add("give_no_xp");
		_tag.Target.kill(_tag.User, this);
	}

	function onTargetSelected( _targetTile )
	{
	}

	function onAfterUpdate( _properties )
	{
	}

});

