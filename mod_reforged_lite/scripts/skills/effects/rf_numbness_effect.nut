this.rf_numbness_effect <- ::inherit("scripts/skills/skill", {
	m = {
		DamageTotalMult = 0.75,
		TurnsLeft = 1
	},
	function create()
	{
		this.m.ID = "effects.rf_numbness";
		this.m.Name = "Онемение";
		this.m.Description = "Этот персонаж чувствует онемение в конечностях.";
		this.m.Icon = "skills/rf_numbness_effect.png";
		this.m.IconMini = "rf_numbness_effect_mini";
		this.m.Overlay = "rf_numbness_effect";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/regular_damage.png",
			text = "Наносит на " + ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.DamageTotalMult) + " урона")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Истекает через " + this.m.TurnsLeft + " [ход(а,ов)|Concept.Turn]")
		});
		return ret;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		// TODO: Better to do this via a skill_container.onAnySkillAdded event
		local warmth = actor.getSkills().getSkillByID("effects.rf_warmth_potion");
		if (warmth != null)
		{
			this.removeSelf();
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " сопротивляется онемению благодаря " + warmth.getName());
			return;
		}

		if (actor.getCurrentProperties().IsResistantToAnyStatuses && ::Math.rand(1, 100) <= 50)
		{
			if (!actor.isHiddenToPlayer())
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " сопротивляется онемению благодаря своей неестественной физиологии");
			}

			this.removeSelf();
			return;
		}

		// Add 1 so that it expires at the end of the next turn
		// otherwise the effect expires when you end your turn after an attack.
		if (actor.isTurnStarted())
		{
			this.m.TurnsLeft++;
		}

		this.m.TurnsLeft = ::Math.max(1, this.m.TurnsLeft + actor.getCurrentProperties().NegativeStatusEffectDuration);
	}

	function onUpdate( _properties )
	{
		_properties.DamageTotalMult *= this.m.DamageTotalMult;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft == 0)
			this.removeSelf();
	}
});
