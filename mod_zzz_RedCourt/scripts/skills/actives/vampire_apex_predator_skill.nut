this.vampire_apex_predator_skill <- this.inherit("scripts/skills/skill", {
	m = {
		IsBattleStart = false
	},
	function create()
	{
		this.m.ID = "perk.vampire_apex_predator";
		this.m.Name = this.Const.Strings.PerkName.VampireApexPredator; // I'd suggest writing separate Name and Description strings for active skills
		this.m.Description = this.Const.Strings.PerkDescription.VampireApexPredator;
		this.m.Icon = "ui/perks/apex_predator.png";
		this.m.IconDisabled = "ui/perks/apex_predator_bw.png"
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]+2[/color] к обзору в ночное время"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]+5[/color] к навыку ближнего боя в ночное время"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]+10[/color] к защите в ближнем бою в ночное время"
			}
		]);

		return tooltip;
	}

	function onAdded() // make this perk works when added to non-player
	{
		if (!this.getContainer().getActor().isPlayerControlled())
		{
			this.onCombatStarted();
		}
	}

	function isHidden()
	{
		return !this.m.IsBattleStart || this.Time.getTime().IsDaytime;
	}
	
	function onUpdate( _properties )
	{
		/*if (this.getContainer().hasSkill("special.night") && _properties.IsAffectedByNight == false) //must be false due to hemovore trait
		{
			_properties.Vision += 2;
			_properties.MeleeSkill += 5;
			_properties.MeleeDefense += 10;

			///---
			this.getSprite("dirt").setBrush("bust_glowing_eyes");
			this.getSprite("dirt").Visible = true;
			///---
		}*/

		local actor = this.getContainer().getActor();

		if (!this.isHidden())
		{
			_properties.Vision += 2;
			_properties.MeleeSkill += 5;
			_properties.MeleeDefense += 10;

			local sprite = actor.getSprite("dirt");

			if (sprite != null)
			{
				sprite.setBrush("zombie_rage_eyes");
				sprite.Visible = true;
				actor.setDirty(true);
			}
		}
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
