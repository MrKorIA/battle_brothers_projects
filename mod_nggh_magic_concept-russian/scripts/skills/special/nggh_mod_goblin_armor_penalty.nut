this.nggh_mod_goblin_armor_penalty <- ::inherit("scripts/skills/skill", {
	m = {
		Limit = ::Const.Goblin.ArmorFatigueThreshold,
		IsDisableFleetfooted = false,
	},
	function create()
	{
		this.m.ID = "special.sluggish";
		this.m.Name = "Перегрузка";
		this.m.Icon = "skills/status_effect_53.png";
		this.m.IconMini = "status_effect_53_mini";
		this.m.Overlay = "status_effect_111";
		this.m.Type = ::Const.SkillType.StatusEffect | ::Const.SkillType.Special;
		this.m.IsActive = false;
		this.m.IsSerialized = false;
	}

	function getDescription()
	{
		return "Ух! Слишком тяжело, этот персонаж еле шевелиться в своих неприподъёмных доспехах.";
	}
	
	function getTooltip()
	{
		local fat = this.getModifier();
		local tooltip = [
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
		];

		if (fat > 0)
		{
			local fm = ::Math.floor((::Math.maxf(1.0, 1.05 + ::Math.pow(fat, 1.23) * 0.01) * 100) - 100);
			local mm = ::Math.floor(fat / 8);
			
			tooltip.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/icons/initiative.png",
					text = "Снижение выносливости на [color=" + ::Const.UI.Color.NegativeValue + "]+" + fm + "%[/color] снижает инициативу"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/fatigue.png",
					text = "Затрачивает на [color=" + ::Const.UI.Color.NegativeValue + "]" + fm + "%[/color] больше выносливости для прохождения каждой клетки"
				},
			]);
			
			if (fat >= 8)
			{
				tooltip.extend([
					{
						id = 6,
						type = "text",
						icon = "ui/icons/tracking_disabled.png",
						text = "Затрачивает на [color=" + ::Const.UI.Color.NegativeValue + "]" + mm + "[/color] больше ОД для прохождения каждой клетки"
					},
				]);
			}
			
			if (fat >= 12)
			{
				tooltip.push({
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Не может быть целью умения [color=" + ::Const.UI.Color.NegativeValue + "]Рокировка[/color]."
				});
			}
			
			if (fat >= 16)
			{
				tooltip.push({
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Затрачивает [color=" + ::Const.UI.Color.NegativeValue + "]на 1[/color] больше ОД при использовании умения"
				});
			}
		}

		return tooltip;
	}
	
	function isHidden()
	{
		return this.getModifier() == 0;
	}
	
	function onUpdate( _properties )
	{
		local fat = this.getModifier();
		
		if (fat == 0)
		{
			return;
		}
		
		_properties.FatigueToInitiativeRate *= ::Math.maxf(1.0, 1.05 + ::Math.pow(fat, 1.23) * 0.01);
		_properties.MovementFatigueCostMult *= ::Math.maxf(1.0, 1.05 + ::Math.pow(fat, 1.23) * 0.01);
		this.m.IsDisableFleetfooted = fat >= 8;

		if (fat >= 8)
		{
			_properties.MovementAPCostAdditional += ::Math.floor(fat / 8);
		}
		
		if (fat >= 12)
		{
			_properties.IsImmuneToRotation = true;
		}
		
		if (fat >= 16)
		{
			_properties.AdditionalActionPointCost += 1;
		}
	}

	function onAfterUpdate( _properties )
	{
		if (this.m.IsDisableFleetfooted)
		{
			_properties.IsFleetfooted = false;
		}
	}
	
	function getModifier()
	{
		local fat = 0;
		local body = this.getContainer().getActor().getItems().getItemAtSlot(::Const.ItemSlot.Body);
		local head = this.getContainer().getActor().getItems().getItemAtSlot(::Const.ItemSlot.Head);

		if (body != null)
		{
			fat += body.getStaminaModifier();
		}

		if (head != null)
		{
			fat += head.getStaminaModifier();
		}

		fat = ::Math.min(0, fat + this.m.Limit);

		if (fat > 0)
		{
			return 0;
		}
		
		return ::Math.abs(fat);
	}

});

