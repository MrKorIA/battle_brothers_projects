this.perk_vampire_maintenance <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.vampire_maintenance";
		this.m.Name = this.Const.Strings.PerkName.VampireMaintenance;
		this.m.Description = this.Const.Strings.PerkDescription.VampireMaintenance;
		this.m.Icon = "ui/perks/vampire_maintenance.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		local item = this.getContainer().getActor().getMainhandItem(); //ancient and embalmed weapons only (no shields or offhands)
		if (item != null)
		{	//Normal rules
			if (item.getID() == "weapon.legend_great_khopesh" || item.getID() == "weapon.crypt_cleaver" || item.getID() == "weapon.broken_ancient_sword" || item.getID() == "weapon.falx" || item.getID() == "weapon.ancient_spear" || item.getID() == "weapon.ancient_sword" || item.getID() == "weapon.bladed_pike" || item.getID() == "weapon.broken_bladed_pike" || item.getID() == "weapon.khopesh" || item.getID() == "weapon.legend_fan_axe" || item.getID() == "weapon.legend_gladius" || item.getID() == "weapon.legend_khopesh" || item.getID() == "weapon.legend_kopis" || item.getID() == "weapon.rhomphaia" || item.getID() == "weapon.warscythe" || item.getID() == "weapon.legend_broad_warscythe" || item.getID() == "weapon.legend_broadhead_spear" || item.getID() == "weapon.legend_broken_spatha" || item.getID() == "weapon.legend_spatha" || item.getID() == "weapon.legend_military_crypt_cleaver" || item.getID() == "weapon.legend_military_rhomphaia" || item.getID() == "weapon.legend_oxtongue_spear" || item.getID() == "weapon.legend_sica" || item.getID() == "weapon.legend_honed_warscythe")
			{
				_properties.MeleeDamageMult *= 1.1;
			}
			//Named/decorated rules
			else if (item.getID() == "weapon.named_legend_great_khopesh" || item.getID() == "weapon.named_crypt_cleaver" || item.getID() == "weapon.named_bladed_pike" || item.getID() == "weapon.named_khopesh" || item.getID() == "weapon.named_legend_gladius" || item.getID() == "weapon.named_warscythe" || item.getID() == "weapon.legend_broken_decorated_sword" || item.getID() == "weapon.legend_decorated_crypt_cleaver" || item.getID() == "weapon.legend_decorated_rhomphaia" || item.getID() == "weapon.legend_decorated_sword" || item.getID() == "weapon.legend_named_military_warscythe")
			{
				_properties.MeleeDamageMult *= 1.1;
				_properties.FatigueOnSkillUse -= 5;
			}
		}
		// _properties.DamageReceivedRegularMult *= 0.95; //5% reduction
	}

	function getDescription()
	{
		return "[color=" + this.Const.UI.Color.PositiveValue + "]\'Древнее оружие\' включает:[/color] все виды Хопешей, Древний меч, Фальката, Ритуальный тесак, Древнее копьё, Древняя клинковая пика, Веерный древний топор, Древний гладиус, Копис, Ромфея, Бронзовый хопеш, Боевая коса и прочее.\n[color=" + this.Const.UI.Color.NegativeValue + "]А также все сломанные и именные разновидности перечисленного оружия.[/color]";
	}

	function getTooltip() //frontend
	{
		local tooltip = this.skill.getTooltip();
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		
		//no need to continue if no item
		if (item == null) return tooltip;

		local normalWeapons = [
			"weapon.legend_great_khopesh",
			"weapon.crypt_cleaver",
			"weapon.broken_ancient_sword",
			"weapon.falx",
			"weapon.ancient_spear",
			"weapon.ancient_sword",
			"weapon.bladed_pike",
			"weapon.broken_bladed_pike",
			"weapon.khopesh",
			"weapon.legend_fan_axe",
			"weapon.legend_gladius",
			"weapon.legend_khopesh",
			"weapon.legend_kopis",
			"weapon.rhomphaia",
			"weapon.warscythe",
			"weapon.legend_broad_warscythe",
			"weapon.legend_broadhead_spear",
			"weapon.legend_broken_spatha",
			"weapon.legend_spatha",
			"weapon.legend_military_crypt_cleaver",
			"weapon.legend_military_rhomphaia",
			"weapon.legend_oxtongue_spear",
			"weapon.legend_sica",
			"weapon.legend_honed_warscythe",

		];
		local namedWeapons = [
			"weapon.legend_named_gladius",
			"weapon.named_crypt_cleaver",
			"weapon.named_khopesh",
			"weapon.named_legend_great_khopesh",
			"weapon.named_pike",
			"weapon.named_warscythe",
			"weapon.legend_broken_decorated_sword",
			"weapon.legend_decorated_crypt_cleaver",
			"weapon.legend_decorated_rhomphaia",
			"weapon.legend_decorated_sword",
			"weapon.legend_named_military_warscythe",

		];
		if (normalWeapons.find(item.getID()) != null)
		{
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Повышает урон на [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] при использовании древнего оружия. Восстановливает [color=" + this.Const.UI.Color.PositiveValue + "]3–5[/color] единиц прочности за каждый смертельный удар."
			});
		}
		else if (namedWeapons.find(item.getID()) != null)
		{
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Повышает урон на [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] и затрачивает на [color=" + this.Const.UI.Color.PositiveValue + "]-5[/color] выносливости меньше при использование умений оружия, если экипировано именное или декоративное древнее оружие."
			});
		}
		else
		{
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Этот персонаж испытывает трудности при обращении этим странным оружием и не получает преимуществ от навыка \'Уход за оружием\'.[/color]"
			});
		}

		return tooltip;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		local item = this.getContainer().getActor().getMainhandItem();
		local condition = item.getCondition();
		local conditionMax = item.getConditionMax();
		local bonusMin = 3;
		local bonusMax = 5;
		local repair = this.Math.rand(bonusMin, bonusMax);

		if ((conditionMax - condition) > repair )
		{
		    item.setCondition(condition + repair)
		}
		else
		{
		    item.setCondition(conditionMax);
		}
	}
});
