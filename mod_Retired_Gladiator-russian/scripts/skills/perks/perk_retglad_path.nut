this.perk_retglad_path <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.retglad_path";
        local perk = ::Const.Perks.LookupMap[this.m.ID];
        this.m.Name = perk.Name;
        this.m.Description = perk.Tooltip;
        this.m.Icon = perk.Icon;
        this.m.IconDisabled = perk.IconDisabled;
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties ) //backend
	{

		local item = this.getContainer().getActor().getMainhandItem(); //southern weapons only (no shields, ranged or offhands)
		if (item != null)
		{	//Normal rules
			if (item.getID() == "weapon.firelance" || item.getID() == "weapon.heavy_southern_mace" || item.getID() == "weapon.battle_whip" || item.getID() == "weapon.light_southern_mace" || item.getID() == "weapon.nomad_mace" || item.getID() == "weapon.polemace" || item.getID() == "weapon.qatal_dagger" || item.getID() == "weapon.saif" || item.getID() == "weapon.swordlance" || item.getID() == "weapon.two_handed_saif" || item.getID() == "weapon.two_handed_scimitar" || item.getID() == "weapon.legend_katar" || item.getID() == "weapon.scimitar" || item.getID() == "weapon.shamshir" || item.getID() == "weapon.crypt_cleaver" || item.getID() == "weapon.khopesh" || item.getID() == "weapon.legend_great_khopesh" || item.getID() == "weapon.legend_khopesh" || item.getID() == "weapon.legend_kopis" || item.getID() == "weapon.Warscythe" || item.getID() == "weapon.spetum" || item.getID() == "weapon.cp_reinforced_wooden_staff")
			{
				_properties.MeleeDamageMult *= 1.05;
				_properties.DamageArmorMult *= 1.1; //effectiveness vs armour
				_properties.XPGainMult *= 1.1; //10%
			}
			//Named rules
			else if (item.getID() == "weapon.named_battle_whip" || item.getID() == "weapon.named_mace" || item.getID() == "weapon.named_polemace" || item.getID() == "weapon.named_qatal_dagger" || item.getID() == "weapon.named_royal_lance" || item.getID() == "weapon.named_shamshir" || item.getID() == "weapon.named_swordlance" || item.getID() == "weapon.named_two_handed_scimitar" || item.getID() == "weapon.legend_mage_swordstaff" || item.getID() == "weapon.lightbringer_sword" || item.getID() == "weapon.obsidian_dagger" || item.getID() == "weapon.named_crypt_cleaver" || item.getID() == "weapon.named_khopesh" || item.getID() == "weapon.named_legend_great_khopesh" || item.getID() == "weapon.named_warscythe" || item.getID() == "weapon.named_spetum" || item.getID() == "weapon.player_banner")
			{
				_properties.MeleeDamageMult *= 1.1;
				_properties.DamageArmorMult *= 1.2; //effectiveness vs armour
				_properties.FatigueOnSkillUse -= 5;
				_properties.XPGainMult *= 1.15; //15%
			}
			//Normal rules
			else if (item.getID() == "weapon.staff_sling" || item.getID() == "weapon.composite_bow" || item.getID() == "weapon.handgonne" || item.getID() == "weapon.nomad_sling" || item.getID() == "weapon.legend_sling")
			{
				_properties.MeleeDamageMult *= 1.05;
				_properties.DamageArmorMult *= 1.1; //effectiveness vs armour
				_properties.XPGainMult *= 1.1; //10%
			}
			//Named rules 
			else if (item.getID() == "weapon.named_handgonne" || item.getID() == "weapon.legend_named_nomad_sling" || item.getID() == "weapon.legend_named_northern_sling")
			{
				_properties.MeleeDamageMult *= 1.1;
				_properties.DamageArmorMult *= 1.2; //effectiveness vs armour
				_properties.FatigueOnSkillUse -= 5;
				_properties.XPGainMult *= 1.15; //15%
			}
			//Everything else
			else
			{
				return
			}
		}
	}

	function getDescription()
	{
		return "[color=" + this.Const.UI.Color.PositiveValue + "]К 'южному оружию ближнего боя' относятся:[/color] огненное копьё, тяжёлая и лёгкая южная булава, булава кочевников, кнут, буздыхан, джамбия, саиф, глефа, двуручный саиф, двуручный ятаган, катар, ятаган, рунка и шамшир.\n[color=" + this.Const.UI.Color.PositiveValue + "]К 'именному оружию' относятся:[/color] кнут, одноручная булава (все типы), буздыхан, джамбия, кинжал, шамшир, глефа, рунка и двуручный ятаган.\n\nРаспространяется на: ритуальный тесак, хопеш, большой хопеш, бронзовый хопеш, копис и боевая коса.\n\nТакже к ним относятся обсидиановый кинжал, заточенный магический посох, королевское копьё и порицатель древних богов.\n\n[color=" + this.Const.UI.Color.PositiveValue + "]К 'южному оружию дальнего боя' относятся:[/color] все виды пращей, составной лук, и ручница.\n [color=" + this.Const.UI.Color.PositiveValue + "]К 'южному именному оружию' относится:[/color] ручница, праща кочевников и северная праща.";
	}

	function getTooltip() //frontend
	{
		local tooltip = this.skill.getTooltip();
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		
		//no need to continue if no item
		if (item == null) return tooltip;

		local normalMeleeWeapons = [
			"weapon.firelance",
			"weapon.heavy_southern_mace",
			"weapon.battle_whip",
			"weapon.light_southern_mace",
			"weapon.nomad_mace",
			"weapon.polemace",
			"weapon.qatal_dagger",
			"weapon.saif",
			"weapon.swordlance",
			"weapon.two_handed_saif",
			"weapon.two_handed_scimitar",
			"weapon.legend_katar",
			"weapon.scimitar",
			"weapon.shamshir",
			"weapon.crypt_cleaver",
			"weapon.khopesh",
			"weapon.legend_great_khopesh",
			"weapon.legend_khopesh",
			"weapon.legend_kopis",
			"weapon.warscythe",
			"weapon.spetum",
			"weapon.cp_reinforced_wooden_staff"
		];
		local namedMeleeWeapons = [
			"weapon.named_battle_whip",
			"weapon.named_mace",
			"weapon.named_polemace",
			"weapon.named_qatal_dagger",
			"weapon.named_royal_lance",
			"weapon.named_shamshir",
			"weapon.named_swordlance",
			"weapon.named_two_handed_scimitar",
			"weapon.legend_mage_swordstaff",
			"weapon.lightbringer_sword",
			"weapon.obsidian_dagger",
			"weapon.named_crypt_cleaver",
			"weapon.named_khopesh",
			"weapon.named_legend_great_khopesh",
			"weapon.named_warscythe",
			"weapon.named_spetum",
			"weapon.player_banner"
		];
		local normalRangedWeapons = [
			"weapon.staff_sling", 
			"weapon.composite_bow", 
			"weapon.handgonne", 
			"weapon.nomad_sling",
			"weapon.legend_sling"
		];
		local namedRangedWeapons = [
			"weapon.named_handgonne",
			"weapon.legend_named_nomad_sling",
			"weapon.legend_named_northern_sling"
		];

		if (normalMeleeWeapons.find(item.getID()) != null)
		{
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/icons/mentor_normal.png",
				text = "Получает [color=" + this.Const.UI.Color.PositiveValue + "]+5% к урону, +10% к урону по броне и на 10% больше опыта, получаемого при использовании южного оружия ближнего боя[/color]."
			});
		}
		else if (namedMeleeWeapons.find(item.getID()) != null)
		{
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/icons/mentor_special.png",
				text = "Получает [color=" + this.Const.UI.Color.PositiveValue + "]+10% к урону, +20% к урону по броне, -5 к затратам выносливости при использовании этого оружия и на 15% больше опыта, полученного при использовании именного или уникального южного оружия ближнего боя[/color]."
			});
		}
		else if (normalRangedWeapons.find(item.getID()) != null)
		{
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/icons/mentor_normal.png",
				text = "Получает [color=" + this.Const.UI.Color.PositiveValue + "]+5% к урону, +10% к урону по броне и на 10% больше опыта, получаемого при использовании южного оружия дальнего боя[/color]."
			});
		}
		else if (namedRangedWeapons.find(item.getID()) != null)
		{
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/icons/mentor_special.png",
				text = "Получает [color=" + this.Const.UI.Color.PositiveValue + "]+10% к урону, +20% к урону по броне, -5 к затратам выносливости при использовании этого оружия и на 15% больше опыта, полученного при использовании именного южного оружия дальнего боя[/color]."
			});
		}
		else
		{
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Этот персонаж не использует южное оружие, поэтому не получает никаких бонусов от навыка 'Путь Златоликого'[/color]."
			});
		}

		return tooltip;
	}

});
