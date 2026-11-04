this.sb_revel_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 1,
		SkillchargeMax = 1
	},
	function create()
	{
		this.m.ID = "actives.sb_revel_skill";
		this.m.Name = "52. Усиление храбрости";
		this.m.Description = "Повышает боевой дух цели до максимального уровня и уменьшает усталость на 30. Может быть использовано на союзников.";
		this.m.Icon = "ui/xx59.png";
		this.m.IconDisabled = "ui/xx59_sw.png";
		this.m.Overlay = "status_effect_56";
		this.m.SoundOnUse = [
			"sounds/tavern_round_01.wav"
		];
		this.m.SoundVolume = 2.1;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 1;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Дальность " + this.getMaxRange() + " плиток"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Дразнить, Укрепленный разум, Собрать войска (перк): каждый перк увеличивает лимит использования и дальность действия этого навыка на +1."
		});
		if (this.Tactical.isActive())
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Может использоваться [color=#8f1e1e]" + this.m.Skillcharge + "[/color] еще несколько раз в этой битве."
			});
		}
		else
		{
			local rr = 1;
			if (this.getContainer().getActor().getSkills().hasSkill("perk.taunt"))
			{
				rr = rr + 1;
			}
			if (this.getContainer().getActor().getSkills().hasSkill("perk.fortified_mind"))
			{
				rr = rr + 1;
			}
			if (this.getContainer().getActor().getSkills().hasSkill("perk.rally_the_troops"))
			{
				rr = rr + 1;
			}
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Может использоваться [color=#8f1e1e]" + rr + "[/color] еще несколько раз в этой битве."
			});
		}
		return ret;
	}

	function getCursorForTile( _tile )
	{
		return this.Const.UI.Cursor.Drink;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}
		if (!this.m.Container.getActor().isAlliedWith(_targetTile.getEntity()))
		{
			return false;
		}
		return true;
	}

	function onUpdate( _properties )
	{
		local rr = 1;
		if (this.getContainer().getActor().getSkills().hasSkill("perk.taunt"))
		{
			rr = rr + 1;
		}
		if (this.getContainer().getActor().getSkills().hasSkill("perk.fortified_mind"))
		{
			rr = rr + 1;
		}
		if (this.getContainer().getActor().getSkills().hasSkill("perk.rally_the_troops"))
		{
			rr = rr + 1;
		}
		this.m.MaxRange = rr;
		this.m.SkillchargeMax = rr;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcharge = this.m.Skillcharge - 1
		local target = _targetTile.getEntity();
		target.setFatigue(this.Math.max(0, target.getFatigue() - 30));
		target.setMoraleState(this.Const.MoraleState.Confident);
		this.spawnIcon("morale_up", _targetTile);
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

