this.nggh_mod_blind_effect <- ::inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2,
	},
	function create()
	{
		this.m.ID = "effects.blind";
		this.m.Name = "Ослеплён кислотой";
		this.m.Icon = "skills/status_effect_117.png";
		this.m.IconMini = "status_effect_117_mini";
		this.m.Overlay = "status_effect_117";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onRefresh()
	{
		this.m.TurnsLeft = 2;
	}

	function onAdded()
	{
		// instantly panic
		::Tactical.TurnSequenceBar.pushEntityBack(this.getContainer().getActor().getID());
		this.getContainer().getActor().checkMorale(-1, -1000);
	}

	function getDescription()
	{
		return "Лицо этого персонажа было забрызгано кислотной кровью Линдвурма, поэтому он временно ослеп и впал в состояние полной паники. Боль и темнота - идеальный рецепт для катастрофы. Эффект спадёт через [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] ход(ов).";
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
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (this.m.TurnsLeft * 25) + "%[/color] к навыку ближнего боя"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (this.m.TurnsLeft * 45) + "%[/color] к навыку дальнего боя"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (this.m.TurnsLeft * 25) + "%[/color] к защите в ближнем бою"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (this.m.TurnsLeft * 45) + "%[/color] к защите в дальнем бою"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (this.m.TurnsLeft * 15) + "%[/color] к инициативе"
			}
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (this.m.TurnsLeft * 25) + "%[/color] к решимости"
			}
			{
				id = 10,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (this.m.TurnsLeft * 45) + "%[/color] к обзору"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.VisionMult *= 1.0 - (this.m.TurnsLeft * 0.45);
		_properties.BraveryMult *= 1.0 - (this.m.TurnsLeft * 0.25);
		_properties.InitiativeMult *= 1.0 - (this.m.TurnsLeft * 0.15);
		_properties.MeleeSkillMult *= 1.0 - (this.m.TurnsLeft * 0.25);
		_properties.MeleeDefenseMult *= 1.0 - (this.m.TurnsLeft * 0.25);
		_properties.RangedSkillMult *= 1.0 - (this.m.TurnsLeft * 0.45);
		_properties.RangedDefenseMult *= 1.0 - (this.m.TurnsLeft * 0.45);
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});

