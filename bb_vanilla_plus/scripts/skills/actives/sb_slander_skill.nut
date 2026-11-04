this.sb_slander_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 2,
		SkillchargeMax = 2
	},
	function create()
	{
		this.m.ID = "actives.sb_slander_skill";
		this.m.Name = "Проклятье";
		this.m.Description = "Снижает боевой дух одной цели.";
		this.m.Icon = "ui/xx66.png";
		this.m.IconDisabled = "ui/xx66_sw.png";
		this.m.Overlay = "active_117";
		if (this.Const.DLC.Unhold)
		{
			this.m.SoundOnUse = [
			"sounds/enemies/dlc2/alp_nightmare_02.wav"
			];
		}
		else
		{
			this.m.SoundOnUse = [
			"sounds/enemies/swarm_of_insects_02.wav"
			];
		}
		this.m.SoundVolume = 2;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Дальность " + this.getMaxRange() + " клетки"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Навык \'Насмешка\' увеличивает лимит использования на 2."
		});
		if (this.Tactical.isActive())
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Может использоваться ещё [color=#8f1e1e]" + this.m.Skillcharge + "[/color] раз в этой битве."
			});
		}
		else
		{
			local rr = 2;
			if (this.getContainer().getActor().getSkills().hasSkill("perk.taunt"))
			{
				rr = rr + 2;
			}
			if (this.getContainer().getActor().getSkills().hasSkill("perk.fortified_mind"))
			{
				rr = rr + 2;
			}
			if (this.getContainer().getActor().getSkills().hasSkill("perk.rally_the_troops"))
			{
				rr = rr + 2;
			}
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Может использоваться [color=#8f1e1e]" + rr + "[/color] раз в одной битве."
			});
		}
		return ret;
	}

	function onUpdate( _properties )
	{
		local rr = 2;
		if (this.getContainer().getActor().getSkills().hasSkill("perk.taunt"))
		{
			rr = rr + 2;
		}
		if (this.getContainer().getActor().getSkills().hasSkill("perk.fortified_mind"))
		{
			rr = rr + 2;
		}
		if (this.getContainer().getActor().getSkills().hasSkill("perk.rally_the_troops"))
		{
			rr = rr + 2;
		}
		this.m.SkillchargeMax = rr;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcharge = this.m.Skillcharge - 1
		local target = _targetTile.getEntity();
		if (this.Math.rand(3, 6) == 6)
		{
			target.checkMorale(-1, -15, this.Const.MoraleCheckType.MentalAttack);
		}
		if (this.Math.rand(7, 9) == 8)
		{
			target.checkMorale(-1, 0, this.Const.MoraleCheckType.MentalAttack);
		}
		target.checkMorale(-1, 0, this.Const.MoraleCheckType.MentalAttack);
		this.spawnIcon("status_effect_52", _targetTile);
		return true;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else if (this.m.Skillcharge <= 0)
		{
			return false;
		}
		return true;
	}

	function isHidden()
	{
		if (this.m.Skillcharge > 0)
		{
			return false;
		}

		return true;
	}

	function onCombatStarted()
	{
		this.m.Skillcharge = this.m.SkillchargeMax;
	}

	function onCombatFinished()
	{
		this.m.Skillcharge = this.m.SkillchargeMax;
	}

});

