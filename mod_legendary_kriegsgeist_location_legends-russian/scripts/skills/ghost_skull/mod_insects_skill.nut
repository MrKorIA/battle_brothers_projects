this.mod_insects_skill <- ::inherit("scripts/skills/mod_ghost_skull_magic_skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.insects";
		this.m.Name = "Рой мошкары";
		this.m.Description = "Окутывает цель густым облаком жуков, резко снижая ее боеспособность на три хода.";
		this.m.Icon = "skills/active_69.png";
		this.m.IconDisabled = "skills/active_69_sw.png";
		this.m.Overlay = "active_69";
		this.m.SoundOnUse = [
			"sounds/enemies/geist_idle_01.wav",
			"sounds/enemies/geist_idle_02.wav",
			"sounds/enemies/geist_idle_03.wav",
			"sounds/enemies/geist_idle_04.wav",
			"sounds/enemies/geist_idle_05.wav"
		];
		this.m.SoundOnHit = [
			"sounds/status/insect_swarm_effect_01.wav",
			"sounds/status/insect_swarm_effect_02.wav",
			"sounds/status/insect_swarm_effect_03.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 3;
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
		this.m.NotGoodInMelee = true;
		this.m.ActionPointCost = 6;
		this.m.XPCost = 50;
		this.m.XPLevel = 4;
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
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Применяет умение 'Рой мошкары' со следующими эффектами: "
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-50%[/color] к навыку ближнего боя"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-50%[/color] к навыку дальнего боя"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-50%[/color] к защите в ближнем бою"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-50%[/color] к защите в дальнем бою"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-50%[/color] к инициативе"
			},
			{
				id = 1,
				type = "hint",
				icon = "ui/icons/skills.png",
				text = "Уровень [b]2[/b] умения, для разблокировки требуется [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.XPLevel * 500 + "[/color] очков души"
			}
		]);

		return ret;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local effect = target.getSkills().getSkillByID("effects.insect_swarm");

		if (effect != null)
		{
			effect.resetTime();
		}
		else
		{
			target.getSkills().add(::new("scripts/skills/effects/insect_swarm_effect"));
		}

		return true;
	}

	function onTargetSelected( _targetTile )
	{
	}

});

