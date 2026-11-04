this.ai_roc_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 11,
		Skillcool = 11
	},
	function create()
	{
		this.m.ID = "actives.ai_roc_skill";
		this.m.Name = "Полет";
		this.m.Description = "В этом ходу движение стоит на 1 ОД меньше, не вызывает усталости от движения и игнорирует зоны контроля..";
		this.m.Icon = "skills/active_104.png";
		this.m.IconDisabled = "skills/active_104_sw.png";
		this.m.Overlay = "active_104";
		this.m.SoundOnUse = [
			"sounds/inventory/hawk_inventory_01.wav",
			"sounds/inventory/hawk_inventory_02.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 230;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsWeaponSkill = false;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 1;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}


	function getTooltip()
	{
		local ret = [
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
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Cooldown: 11 turn \nCooldown left: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] turn"
			}
		];
		if (this.m.Container.hasSkill("effects.ai_roc_effect"))
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Already in flight.[/color]"
			});
		}
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		return this.m.Container.add(this.new("scripts/skills/effects/ai_roc_effect"));
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}

		if (this.m.Skillcool < this.m.Cooldown)
		{
			return false;
		}

		return true;
	}

	function onNewRound()
	{
		this.m.Skillcool = this.m.Skillcool + 1;
	}

	function onCombatFinished()
	{
		this.m.Skillcool = this.m.Cooldown;
	}

});

