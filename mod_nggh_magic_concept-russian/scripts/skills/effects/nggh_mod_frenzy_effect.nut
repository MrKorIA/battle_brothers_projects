this.nggh_mod_frenzy_effect <- ::inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2,
		SkillCount = 0,
		LastTargetID = 0,
		IsCombatOver = false,
	},
	function create()
	{
		this.m.ID = "effects.frenzy";
		this.m.Name = "Боевое безумие";
		this.m.Icon = "ui/perks/perk_madden.png";
		this.m.IconMini = "perk_madden_mini";
		this.m.Overlay = "perk_madden";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "РААААРРРР! Этот персонаж находится в состоянии бешенства еще [color=" + ::Const.UI.Color.PositiveValue + "]" + this.m.TurnsLeft + "[/color] ход(ов). Становится слишком безрассудным, но в то же время демонстрирует невообразимую силу.";
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+15%[/color] к наносимому урону"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+15%[/color] к навыку ближнего боя"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+50%[/color] к инициативе"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-50%[/color] к защите в ближнем бою"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Все умения тратят на [color=" + ::Const.UI.Color.PositiveValue + "]1[/color] меньше ОД"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Может наложить эффект [color=" + ::Const.UI.Color.PositiveValue + "]подавлен[/color] на цель"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Получает невосприимчивость к эффектам 'оглушён' или 'выбит дух'"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Получает невосприимчивость к отталкиванию и захвату"
			},
		];
	}

	function onUpdate( _properties )
	{
		_properties.AdditionalActionPointCost -= 1;
		_properties.FatalityChanceMult *= 10000.0;
		_properties.MeleeDamageMult *= 1.15;
		_properties.MeleeSkillMult *= 1.15;
		_properties.InitiativeMult *= 1.5;
		_properties.MeleeDefenseMult *= 0.5;
		_properties.TargetAttractionMult *= 1.15;
		_properties.IsImmuneToKnockBackAndGrab = true;
		_properties.IsImmuneToStun = true;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.applyOverwhelmed(_targetEntity);
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		this.applyOverwhelmed(_targetEntity);
	}

	function applyOverwhelmed( _targetEntity )
	{
		if (::Tactical.TurnSequenceBar.getActiveEntity() == null || ::Tactical.TurnSequenceBar.getActiveEntity().getID() != this.getContainer().getActor().getID())
		{
			return;
		}

		if (!_targetEntity.isAlive() || _targetEntity.isDying() || _targetEntity.isAlliedWith(this.getContainer().getActor()))
		{
			return;
		}
		
		if (_targetEntity.getCurrentProperties().IsImmuneToOverwhelm)
		{
			return;
		}
	
		if (!_targetEntity.isTurnStarted() && !_targetEntity.isTurnDone())
		{
			if (this.m.SkillCount == ::Const.SkillCounter && this.m.LastTargetID == _targetEntity.getID())
			{
				return;
			}

			this.m.SkillCount = ::Const.SkillCounter;
			this.m.LastTargetID = _targetEntity.getID();
			_targetEntity.getSkills().add(::new("scripts/skills/effects/overwhelmed_effect"));
		}
	}

	function onRemoved()
	{
		if (this.m.IsCombatOver)
		{
			return;
		}

		if (!this.getContainer().hasSkill("effects.nacho_eat") && !this.getContainer().getActor().getCurrentProperties().IsImmuneToDaze)
		{
			this.getContainer().add(::new("scripts/skills/effects/dazed_effect"));
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " выбит дух на 2 хода");
		}
	}

	function onCombatFinished()
	{
		this.m.IsCombatOver = true;
		this.skill.onCombatFinished();
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});

