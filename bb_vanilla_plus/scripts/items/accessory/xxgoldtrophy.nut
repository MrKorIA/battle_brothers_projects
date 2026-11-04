this.xxgoldtrophy <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.xxgoldtrophy";
		this.m.Name = "Пояс завоевателя";
		this.m.Description = "Пояс, который носил великий человек.";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/xxgoldtrophy.png";
		this.m.Sprite = "xxgoldtrophy";
		this.m.Value = 500;
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
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

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
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+50%[/color] Получение опыта"
		});
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+7[/color] Все Статы"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		_properties.XPGainMult *= 1.5;
		_properties.Hitpoints += 7;
		_properties.Stamina += 7;
		_properties.Bravery += 7;
		_properties.Initiative += 7;
		_properties.MeleeSkill += 7;
		_properties.RangedSkill += 7;
		_properties.MeleeDefense += 7;
		_properties.RangedDefense += 7;
	}

});

