this.sb_taichi_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 3,
		Skillcool = 3
	},
	function create()
	{
		this.m.ID = "actives.sb_taichi_skill";
		this.m.Name = "70. Форма оружия тайцзи";
		this.m.Description = "Получаете эффекты Контратака и Стена копий. Подвержен влиянию мастерства Меч и Копье. \n[color=#8f1e1e]Требование:[/color] Оружие ближнего боя"
		this.m.Icon = "ui/xx53.png";
		this.m.IconDisabled = "ui/xx53_sw.png";
		this.m.SoundOnUse = [
			"sounds/combat/inspire_01.wav",
			"sounds/combat/inspire_02.wav"
		];
		this.m.SoundVolume = 1.2;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 25;
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
			text = "Ожидание (перк): Этот навык уменьшает AP на -2."
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Перезарядка: 3 хода \nПерезарядка: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] ход"
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.ActionPointCost = 5 - (this.getContainer().getActor().getSkills().hasSkill("perk.anticipation") ? 2 : 0);
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		local mainh = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (mainh != null)
		{
			if (mainh.isItemType(this.Const.Items.ItemType.MeleeWeapon))
			{
				this.m.Container.removeByID("effects.spearwall");
				this.m.Container.removeByID("effects.riposte");
				if (!_user.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " uses Riposte");
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " uses Spearwall");
				}
				this.m.Container.add(this.new("scripts/skills/effects/riposte_effect"));
				this.m.Container.add(this.new("scripts/skills/effects/ai_spearwall_effect"));
			}
		}
		return true;
	}

	function isUsable()
	{
		local mainh = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (mainh == null || !mainh.isItemType(this.Const.Items.ItemType.MeleeWeapon))
		{
			return false;
		}
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

