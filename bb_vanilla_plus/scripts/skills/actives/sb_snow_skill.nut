this.sb_snow_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sb_snow_skill";
		this.m.Name = "62. Двойной лезвие";
		this.m.Description = "Атаковать цель (25% шанс), атаковать себя (25% шанс) или и то, и другое (50% шанс). 100% шанс поразить цель. \n[color=#8f1e1e]Требования:[/color] Оружие ближнего боя";
		this.m.Icon = "ui/xx76.png";
		this.m.IconDisabled = "ui/xx76_sw.png";
		this.m.Overlay = "active_07";
		this.m.SoundOnUse = [
			"sounds/combat/overhead_strike_01.wav",
			"sounds/combat/overhead_strike_02.wav",
			"sounds/combat/overhead_strike_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/overhead_strike_hit_01.wav",
			"sounds/combat/overhead_strike_hit_02.wav",
			"sounds/combat/overhead_strike_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.IsUsingHitchance = false;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 100;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 0;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Устойчивость (перк): Это умение уменьшает урон на 70% при попадании по себе."
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Двуручное оружие ближнего боя: [color=" + this.Const.UI.Color.PositiveValue + "]90%[/color] Ущерб,\nОдноручное оружие ближнего боя: [color=" + this.Const.UI.Color.PositiveValue + "]140%[/color] Ущерб"
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (this.Math.rand(1, 100) <= 50)
		{
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSlash);
			this.attackEntity(_user, target, false);
			this.spawnAttackEffect(_user.getTile(), this.Const.Tactical.AttackEffectSlash);
			return this.attackEntity(_user, _user, false);
		}
		else
		{
			if (this.Math.rand(1, 100) <= 50)
			{
				this.spawnAttackEffect(_user.getTile(), this.Const.Tactical.AttackEffectSlash);
				return this.attackEntity(_user, _user, false);
			}
			else
			{
				this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSlash);
				return this.attackEntity(_user, target, false);
			}
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local mainh = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (mainh != null && mainh.isItemType(this.Const.Items.ItemType.MeleeWeapon))
			{
				this.m.DirectDamageMult = mainh.m.DirectDamageMult;
				if (mainh.isItemType(this.Const.Items.ItemType.TwoHanded))
				{
					_properties.MeleeDamageMult *= 0.9;
				}
				else
				if (mainh.isItemType(this.Const.Items.ItemType.OneHanded))
				{
					_properties.MeleeDamageMult *= 1.4;
				}
			}
			if (_targetEntity != null && this.getContainer().getActor().isPlacedOnMap())
			{
				if (this.getContainer().getActor().getID() == _targetEntity.getID() && this.getContainer().getActor().getSkills().hasSkill("perk.hold_out"))
				{
					_properties.DamageTotalMult *= 0.3;
				}
			}
		}
	}

	function isHidden()
	{
		if (this.m.Container.getActor().isPlacedOnMap())
		{
			local actor = this.getContainer().getActor();
			local mainh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (mainh != null && mainh.isItemType(this.Const.Items.ItemType.MeleeWeapon))
			{
				return false;
			}
			return true;
		}
		return false;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		local actor = this.getContainer().getActor();
		local mainh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (mainh != null && mainh.isItemType(this.Const.Items.ItemType.MeleeWeapon))
		{
			return true;
		}
		return false;
	}

});

