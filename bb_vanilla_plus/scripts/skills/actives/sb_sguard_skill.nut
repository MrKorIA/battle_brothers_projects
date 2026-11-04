this.sb_sguard_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 4,
		Skillcool = 4
	},
	function create()
	{
		this.m.ID = "actives.sb_sguard_skill";
		this.m.Name = "56. Щитовой страж";
		this.m.Description = "Потратьте все ОД в этом ходу, чтобы уменьшить получаемый урон заклинателем и целью на 99% до следующего хода. Заклинатель теряет 40% прочности щита. Этот навык также можно использовать на себя. \n[color=#8f1e1e]Требования:[/color] Щит";
		this.m.Icon = "ui/xx67.png";
		this.m.IconDisabled = "ui/xx67_sw.png";
		this.m.SoundOnUse = [
			"sounds/combat/shieldwall_01.wav",
			"sounds/combat/shieldwall_02.wav",
			"sounds/combat/shieldwall_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 25;
		this.m.MinRange = 0;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Cannot be used if the shield\'s durability is 5 or less"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Cooldown: 4 turn \nCooldown left: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] turn"
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		local offh = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		local qq = offh.m.Condition - (offh.m.ConditionMax * 0.25);
		if (qq <= 1)
		{
			offh.m.Condition = 1;
		}
		else
		{
			offh.m.Condition = qq;
		}
		_targetTile.getEntity().getSkills().add(this.new("scripts/skills/effects/sb_sguard_effect"));
		return true;
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
		if (_targetTile.getEntity().getSkills().hasSkill("sb_sguard_effect"))
		{
			return false;
		}
		return true;
	}

	function isHidden()
	{
		if (this.m.Container.getActor().isPlacedOnMap())
		{
			local actor = this.getContainer().getActor();
			local offh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
			if (offh == null)
			{
				return true;
			}
			else if (!offh.isItemType(this.Const.Items.ItemType.Shield))
			{
				return true;
			}
			else if (!this.getContainer().hasSkill("actives.knock_back"))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else if (this.m.Skillcool < this.m.Cooldown)
		{
			return false;
		}

		local actor = this.getContainer().getActor();
		local offh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		if (offh == null)
		{
			return false;
		}
		else if (!offh.isItemType(this.Const.Items.ItemType.Shield))
		{
			return false;
		}
		else if (offh.m.Condition <= 5)
		{
			return false;
		}
		else if (this.getContainer().hasSkill("actives.knock_back"))
		{
			return true;
		}

		return false;
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

