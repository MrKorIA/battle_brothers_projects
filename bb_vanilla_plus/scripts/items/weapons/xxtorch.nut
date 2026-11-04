this.xxtorch <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xxtorch";
		this.m.Name = "Факел";
		this.m.Description = "Эффективен в ночное время. Может быть брошен, чтобы поджечь целевую область.";
		this.m.IconLarge = "xx_weapon_25.png";
		this.m.Icon = "xx_weapon_25_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Tool;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_xx_weapon_25";
		this.m.Value = 100;
		this.m.RangeMax = 2;
		this.m.StaminaModifier = 0;
		this.m.IsDroppedAsLoot = false;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});
		result.push({
			id = 64,
			type = "text",
			text = "Для второй руки"
		});
		result.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Активный: Бросает факел, чтобы поджечь целевую область. (Шанс успеха: 71%, дальность: 2 клетки, расходуется при использовании.)"
		});
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Пассивный (только ночью): Навыки ближнего и дальнего боя +10. Защита в ближнем и дальнем бою -15. Штрафы за ночное время сняты."
		});
		return result;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/xxitem_torch_skill");
		skill.setItem(this);
		this.addSkill(skill);
	}

});

