// Utility skill for the wooden torch, which toggles its state on and off
this.cp_ignite_torch_skill <- this.inherit("scripts/skills/skill", {
	m = {
	},
	function create()
	{
		this.m.ID = "actives.cp_ignite_torch_skill";
		this.m.Name = "Зажечь факел";
		this.m.Description = "Зажгите факел.";
		this.m.Icon = "skills/cp_ignite_torch_skill.png";
		this.m.IconDisabled = "skills/cp_ignite_torch_skill_sw.png";
		this.m.Overlay = "cp_ignite_torch_skill";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/fire_hit_01.wav",
			"sounds/combat/dlc6/fire_hit_02.wav",
			"sounds/combat/dlc6/fire_hit_03.wav",
			"sounds/combat/dlc6/fire_hit_04.wav",
			"sounds/combat/dlc6/fire_hit_05.wav",
			"sounds/combat/dlc6/fire_hit_06.wav",
		];

		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.NonTargeted;
		this.m.IsActive = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsSerialized = false;

		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 10;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Даёт бонус к решимости, а так же защите ближнего боя против зверей",
		});

		if (this.getItem().m.IsLit)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "Не может быть использовано, так как ваш факел уже зажжён",
			});
		}

		if (this.getItem().getCondition() <= 0)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "Не может быть использовано, так как ваш факел сломан",
			});
		}

		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getItem().m.IsLit && this.getItem().getCondition() > 0;
	}

	function onUse( _user, _targetTile )
	{
		this.getItem().setLit(true);
		this.getItem().addSkill(::new("scripts/skills/effects/cp_burning_torch_effect"));
		return true;
	}
});

