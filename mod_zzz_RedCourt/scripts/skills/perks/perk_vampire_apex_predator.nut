this.perk_vampire_apex_predator <- this.inherit("scripts/skills/skill", {
	m = {
		IsBattleStart = false
	},
	function create()
	{
		this.m.ID = "perk.vampire_apex_predator";
		this.m.Name = this.Const.Strings.PerkName.VampireApexPredator;
		this.m.Description = this.Const.Strings.PerkDescription.VampireApexPredator;
		this.m.Icon = "ui/perks/vampire_apex_predator.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function getTooltip()
	{
		local tooltip = this.skill.getTooltip();
		tooltip.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+2[/color] к обзору в ночное время"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] к навыку ближнего боя в ночное время"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] к навыку дальнего в ночное время"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] к защите в ближнем бою в ночное время"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] к восстановлению выносливости за ход в ночное время"
			}
		]);

		return tooltip;
	}

	function onAdded() // make this perk work when added to non-player
	{
		if (!this.getContainer().getActor().isPlayerControlled())
		{
			this.onCombatStarted();
		}
	}

	function isHidden()
	{
		return !this.m.IsBattleStart || this.World.getTime().IsDaytime;
	}
	
	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();

		if (!this.isHidden())
		{
			_properties.Vision += 2;
			_properties.MeleeSkillMult *= 1.10; // 10%
			_properties.RangedSkillMult *= 1.10;
			_properties.MeleeDefenseMult *= 1.15; //15%
			_properties.FatigueRecoveryRate += 5;

			local sprite = actor.getSprite("dirt");

			if (sprite != null)
			{
				sprite.setBrush("zombie_rage_eyes");
				sprite.Visible = true;
				actor.setDirty(true);
			}
		}
		// _properties.DamageReceivedRegularMult *= 0.95; //5% reduction
	}

	function onCombatStarted()
	{
		this.m.IsBattleStart = true;
	}

	function onCombatFinished()
	{
		this.m.IsBattleStart = false;
		this.getContainer().getActor().getSprite("dirt").Visible = false;
		this.getContainer().getActor().setDirty(true);
	}

});
