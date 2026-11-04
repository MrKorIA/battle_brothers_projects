this.huge_quiver_of_bolts <- this.inherit("scripts/items/ammo/ammo", {
	m = {},
	function create()
	{
		this.m.ID = "ammo.bolts";
		this.m.Name = "Улучшенный большой колчан с болтами";
		this.m.Description = "Большой колчан с болтами, улучшенный мастерством стрельника отряда. Необходим для использования арбалетов. Автоматически пополняется после каждого боя, если у вас достаточно боеприпасов.";
		this.m.Icon = "ammo/quiver_04.png";
		this.m.IconEmpty = "ammo/quiver_04_empty.png";
		this.m.SlotType = this.Const.ItemSlot.Ammo;
		this.m.ItemType = this.Const.Items.ItemType.Ammo;
		this.m.AmmoType = this.Const.Items.AmmoType.Bolts;
		this.m.ShowOnCharacter = true;
		this.m.ShowQuiver = true;
		this.m.Sprite = "bust_quiver_01";
		this.m.Value = 1000;
		this.m.Ammo = 20;
		this.m.AmmoMax = 20;
		this.m.IsDroppedAsLoot = true;
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

		if (this.m.Ammo != 0)
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "Содержит [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Ammo + "[/color] болтов"
			});
		}
		else
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Пуст и бесполезен[/color]"
			});
		}

		return result;
	}

});

