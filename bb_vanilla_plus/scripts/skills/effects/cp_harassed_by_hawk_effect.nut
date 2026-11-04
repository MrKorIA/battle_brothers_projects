this.cp_harassed_by_hawk_effect <- ::inherit("scripts/skills/skill", {
	m = {

		// Config
		MovementAPCostAdditional = 2,

		// Const
		StartingTurnsLeft = 1,

		// Private
		TurnsLeft = null,
	},
	function create()
	{
		this.m.ID = "effects.cp_harassed_by_hawk";
		this.m.Name = "Преследуемый ястребом";
		this.m.Description = "Этого персонажа преследует ястреб, препятствующий его передвижению.";
		this.m.Icon = "skills/rf_arrow_to_the_knee_debuff_effect.png";	// Placeholder
		this.m.IconMini = "rf_arrow_to_the_knee_debuff_effect_mini";	// Placeholder
		this.m.Overlay = "rf_arrow_to_the_knee_debuff_effect";	// Placeholder
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onAdded()
	{
		this.getContainer().getActor().getFlags().set("CP_WasHarassedByHawk", true);

		this.setTurnsLeft(this.m.StartingTurnsLeft);
	}

	function getTooltip()
	{
		local tooltip = this.skill.getTooltip();

		if (this.m.MovementAPCostAdditional != 0)
		{
			tooltip.extend([
				{
					id = 10,
					type = "text",
					icon = "ui/icons/action_points.png",
					text = ::MSU.Text.colorRed(this.m.MovementAPCostAdditional) + " дополнительных ОД при перемещении за каждую клетку"
				}
			]);
		}

		if (this.m.TurnsLeft != null)
		{
			tooltip.extend([
				{
					id = 20,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Длится на " + ::MSU.Text.colorRed(this.m.TurnsLeft) + " больше хода(ов)"
				}
			]);
		}

		return tooltip;
	}

	function onRefresh()
	{
		this.setTurnsLeft(this.m.StartingTurnsLeft);
	}

	function onUpdate( _properties )
	{
		_properties.MovementAPCostAdditional += this.m.MovementAPCostAdditional;
	}

	function onTurnEnd()
	{
		--this.m.TurnsLeft;
		if (this.m.TurnsLeft == 0)
		{
			this.removeSelf();
		}
	}

// New Function
	function setTurnsLeft( _turnsLeft )
	{
		this.m.TurnsLeft = ::Math.max(1, _turnsLeft + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
	}
});
