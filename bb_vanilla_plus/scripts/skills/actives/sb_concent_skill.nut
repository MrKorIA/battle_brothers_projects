this.sb_concent_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 4,
		Skillcool = 4
	},
	function create()
	{
		this.m.ID = "actives.sb_concent_skill";
		this.m.Name = "14. Концентрация";
		this.m.Description = "Используйте все ОД в этом ходу. Получите полезные бонусы до следующего хода.";
		this.m.Icon = "ui/xx58.png";
		this.m.IconDisabled = "ui/xx58_sw.png";
		this.m.SoundOnUse = [
			"sounds/combat/perfect_focus_01.wav"
		];
		this.m.SoundVolume = 0.7;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "+50% урона. +20 к навыку ближнего боя. +20 к навыку дальнего боя. -50% к стоимости усталости навыков. Убран штраф к усталости от вражеских атак."
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Перезарядка: 4 хода \nПерезарядки осталось: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] turn"
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		this.m.Container.add(this.new("scripts/skills/effects/sb_concent_effect"));
		this.getContainer().getActor().setActionPoints(0);
		return true;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else
		if (this.m.Skillcool < this.m.Cooldown)
		{
			return false;
		}

		return true;
	}

	function onTurnStart()
	{
		this.m.Skillcool = this.m.Skillcool + 1;
	}

	function onCombatFinished()
	{
		this.m.Skillcool = this.m.Cooldown;
	}

});

