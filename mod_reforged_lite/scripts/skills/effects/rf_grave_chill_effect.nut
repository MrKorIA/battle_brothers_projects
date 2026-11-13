this.rf_grave_chill_effect <- ::inherit("scripts/skills/skill", {
	m = {
		MaxTurns = 2,
		TurnsLeft = 2
	},
	function create()
	{
		this.m.ID = "effects.rf_grave_chill";
		this.m.Name = "Могильный холод";
		this.m.Description = "Этого персонажа терзает холод, приходится тратить много сил, дабы пошевелить окоченевшими конечностями.";
		this.m.Icon = "skills/rf_grave_chill_effect.png";
		this.m.IconMini = "rf_grave_chill_effect_mini";
		this.m.Overlay = "rf_grave_chill_effect";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		local mult = this.getMalusMult();
		if (mult != 1.0)
		{
			ret.extend([
				{
					id = 10,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(mult) + " к [навыку ближнего боя|Concept.MeleeSkill]")
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(mult) + " к [защите в ближнем бою|Concept.MeleeDefense]")
				},
				{
					id = 12,
					type = "text",
					icon = "ui/icons/ranged_skill.png",
					text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(mult) + " к [навыку дальнего боя|Concept.RangeSkill]")
				},
				{
					id = 13,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(mult) + " к [защите в дальнем бою|Concept.RangeDefense]")
				}
			]);
		}

		local moveAP = this.getMovementAPCostAdditional();
		if (moveAP != 0)
		{
			ret.push({
				id = 14,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(moveAP, {AddSign = true, InvertColor = true}) + " к [ОД|Concept.ActionPoints] за каждую пройденную клетку")
			});
		}

		ret.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Эффект ослабевает с каждым прошедшим [ходом|Concept.Turn]. [Ходов|Concept.Turn] осталось:" + this.m.TurnsLeft)
		});

		return ret;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		local statusResisted = actor.getCurrentProperties().IsResistantToAnyStatuses ? ::Math.rand(1, 100) <= 50 : false;
		statusResisted = statusResisted || actor.getCurrentProperties().IsResistantToPhysicalStatuses ? ::Math.rand(1, 100) <= 33 : false;

		if (statusResisted)
		{
			if (!actor.isHiddenToPlayer())
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " сопротивляется охлаждению благодаря своей неестественной физиологии");
			}

			this.removeSelf();
		}
		else
		{
			this.m.TurnsLeft = ::Math.max(1, this.m.MaxTurns + actor.getCurrentProperties().NegativeStatusEffectDuration);
		}
	}

	function onRefresh()
	{
		this.m.TurnsLeft = ::Math.max(this.m.TurnsLeft, this.m.MaxTurns + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
	}

	function onUpdate( _properties )
	{
		local mult = this.getMalusMult();
		_properties.MeleeSkill *= mult;
		_properties.MeleeDefense *= mult;
		_properties.RangedSkill *= mult;
		_properties.RangedDefense *= mult;
		_properties.MovementAPCostAdditional += this.getMovementAPCostAdditional();
	}

	function onTurnStart()
	{
		if (--this.m.TurnsLeft)
		{
			this.removeSelf();
		}
	}

	function getMalusMult()
	{
		return 1.0 - this.m.TurnsLeft * 0.15;
	}

	function getMovementAPCostAdditional()
	{
		return this.m.TurnsLeft;
	}
});
