this.mod_ghost_skull_magic_skill <- ::inherit("scripts/skills/skill", {
	m = {
		XPLevel = 0,
		XPCost = 0,
		XPCostMult = 1.0,
		NotGoodInMelee = false
	},
	function getXPCost()
	{
		return ::Math.round(this.m.XPCost * this.m.XPCostMult);
	}

	function getCurrentXP()
	{
		return this.m.Item.getXP();
	}

	function getCostString()
	{
		return "[i]Затрачивает " + (this.isAffordableBasedOnAPPreview() ? "[b][color=" + ::Const.UI.Color.PositiveValue + "]" + this.getActionPointCost() : "[b][color=" + ::Const.UI.Color.NegativeValue + "]" + this.getActionPointCost()) + " ОД[/color][/b] и " + (this.isAffordableBasedOnXPPreview() ? "[b][color=" + ::Const.UI.Color.PositiveValue + "]" + this.getXPCost() : "[b][color=" + ::Const.UI.Color.NegativeValue + "]" + this.getXPCost()) + " очков души[/color][/b] при использовании[/i]\n";
	}

	function getDescription()
	{
		if (this.m.NotGoodInMelee)
		{
			return this.m.Description + " Затрачивает на [color=" + ::Const.UI.Color.NegativeValue + "]25%[/color] больше очков души при использовании в ближнем бою."
		}

		return this.m.Description;
	}

	function getFatigueCost()
	{
		return 0;
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
		];
		ret.push(this.m.Item.getXP_Tooltip());
		return ret;
	}

	function getDefaultTooltip()
	{
		local ret = this.skill.getDefaultTooltip();
		ret.insert(3, this.m.Item.getXP_Tooltip());
		return ret;	
	}

	function getDefaultUtilityTooltip()
	{
		return this.getTooltip();
	}

	function isAffordableBasedOnXPPreview()
	{
		if (this.getContainer().getActor().getPreviewSkillID() == this.getID())
		{
			return true;
		}

		return this.getXPCost() <= this.getCurrentXP();
	}

	function isAffordable()
	{
		return this.skill.isAffordable() && this.getXPCost() <= this.getCurrentXP();
	}

	function isHidden()
	{
		return this.skill.isHidden() || this.m.XPLevel > this.m.Item.getXPLevel();
	}

	function use( _targetTile, _forFree = false )
	{
		local ret = this.skill.use(_targetTile, _forFree);

		if (!_forFree)
		{
			this.m.Item.useXP(this.getXPCost());
		}

		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.XPCostMult = _properties.IsSpecializedInGhostSkull ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;

		if (this.m.NotGoodInMelee && this.getContainer().getActor().isEngagedInMelee())
		{
			this.m.XPCostMult *= 1.25;
		}
	}

});

