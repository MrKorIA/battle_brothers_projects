this.sb_acciattack_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sb_acciattack_skill";
		this.m.Name = "1. Неожиданное Нападение";
		this.m.Description = "Атакуйте цель оружием ближнего боя. Вероятность попадания обратна, поэтому атака должна промахнуться, чтобы нанести урон. (Melee Skill)\n[color=#8f1e1e]Требования:[/color] Оружие ближнего боя";
		this.m.Icon = "ui/xx69.png";
		this.m.IconDisabled = "ui/xx69_sw.png";
		this.m.Overlay = "active_rand";
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
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Two-Handed Melee Weapon: [color=" + this.Const.UI.Color.PositiveValue + "]130%[/color] Damage,\nOne-Handed Melee Weapon: [color=" + this.Const.UI.Color.PositiveValue + "]190%[/color] Damage"
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectChop);
		if (this.Math.rand(1, 100) <= this.getHitchance(target))
		{
			_user.getCurrentProperties().DamageTotalMult = 0;
			_user.getCurrentProperties().MeleeSkill += -500;
			this.attackEntity(_user, target, false);
			return false;
		}
		_user.getCurrentProperties().MeleeSkill += 500;
		return this.attackEntity(_user, target, false);
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
					_properties.MeleeDamageMult *= 1.3;
				}
				else
				if (mainh.isItemType(this.Const.Items.ItemType.OneHanded))
				{
					_properties.MeleeDamageMult *= 1.9;
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

