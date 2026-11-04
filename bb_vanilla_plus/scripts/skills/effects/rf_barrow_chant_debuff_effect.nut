this.rf_barrow_chant_debuff_effect <- ::inherit("scripts/skills/skill", {
	m = {
		DamageMultPerMoraleStateAdd = -0.15
	},
	function create()
	{
		this.m.ID = "effects.rf_barrow_chant_debuff";
		this.m.Name = "Под воздействием курганного пения";
		// TODO: Placeholder icons
		this.m.Icon = "ui/perks/perk_32.png";
		// this.m.IconMini = "TODO";
		// this.m.Overlay = "TODO";
		this.m.Description = "В ушах этого персонажа звенит песнопение, вызывая ужас.";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function isHidden()
	{
		return this.getContainer().getActor().getMoraleState() == ::Const.MoraleState.Ignore;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Не может иметь уверенный боевой дух"
		});

//		if (this.m.DamageMultPerMoraleStateAdd != 0.0)
//		{
//			if (::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()))
//			{
//				ret.push({
//					id = 11,
//					type = "text",
//					icon = "ui/icons/regular_damage.png",
//					text = "Наносит на " + ::MSU.Text.colorizeMultWithText(1.0 + this.m.DamageMultPerMoraleStateAdd) + " урона за каждое состояние боевого духа ниже уверенного"
//				});
//			}
//			else
//			{
//				local damageMult = this.getDamageMult();
//				if (damageMult != 1.0)
//				{
//					ret.push({
//						id = 11,
//						type = "text",
//						icon = "ui/icons/regular_damage.png",
//						text = "Наносит на " + ::MSU.Text.colorizeMultWithText(damageMult) + " урона"
//					});
//				}
//			}
//		}

		return ret;
	}

	function onAdded()
	{
		// `mood_check` can set players at Confident during onCombatStart.
		// This happens before this skill can push Confident as a forbidden morale state (as this skill
		// is added via onActorSpawned).
		// So we manually remove Confident after this effect has been added to the actor.
		local actor = this.getContainer().getActor();
		if (actor.getMoraleState() == ::Const.MoraleState.Confident)
		{
//			// Set the actor to the first non-forbidden morale state below Confident.
//			local newState = ::Const.MoraleState.Confident - 1;
//			while (actor.getCurrentProperties().MV_ForbiddenMoraleStates.find(newState) != null)
//			{
//				// We don't want to make the character Flee, so the
//				// maximum we go down is to 1 state above Fleeing.
//				if (--newState == ::Const.MoraleState.Fleeing + 1)
//				{
//					break;
//				}
//			}
//
//			actor.setMoraleState(newState);
			actor.setMoraleState(::Const.Const.MoraleState.Steady);
		}
	}

//	function onUpdate( _properties )
//	{
//		if (this.getContainer().getActor().getMoraleState() != ::Const.MoraleState.Ignore)
//		{
//			_properties.MV_ForbiddenMoraleStates.push(::Const.MoraleState.Confident);
//		}
//	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		_properties.DamageTotalMult *= this.getDamageMult();
	}

	function getDamageMult()
	{
		return ::Math.maxf(0.0, 1.0 + this.m.DamageMultPerMoraleStateAdd * (::Const.MoraleState.Confident - this.getContainer().getActor().getMoraleState()));
	}
});
