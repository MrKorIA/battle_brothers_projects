this.xxuquiver <- this.inherit("scripts/items/ammo/ammo", {
	m = {	},
	function create()
	{
		this.ammo.create();
		this.m.ID = "ammo.arrows";
		this.m.Name = "Колчан из ночных теней";
		this.m.Description = "Этот загадочный колчан для снарядов пропитан эльфийской магией. Он действует как стрелы, болты и порох в зависимости от вида дальнобойного оружия.";
		this.m.Icon = "xx_weapon_22.png";
		this.m.IconEmpty = "xx_weapon_22_empty.png";
		this.m.SlotType = this.Const.ItemSlot.Ammo;
		this.m.ItemType = this.Const.Items.ItemType.Ammo | this.Const.Items.ItemType.Legendary;
		this.m.AmmoType = this.Const.Items.AmmoType.Arrows;
		this.m.ShowOnCharacter = true;
		this.m.ShowQuiver = true;
		this.m.Sprite = "bust_quiver_01";
		this.m.Value = 1000;
		this.m.Ammo = 12;
		this.m.AmmoMax = 12;
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
				text = "Содержит [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Ammo + "[/color] снарядов"
			});
		}
		else
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Пустой и бесполезный[/color]"
			});
		}

		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+7[/color] Навык дальнего боя"
		});
		result.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Наносит 10 единиц урона от боли, когда эти снаряды используются против нежити. (Наносит урон, который игнорирует броню, но не убивает)"
		});
		return result;
	}

	function onEquip()
	{
		this.ammo.onEquip();
		this.addSkill(this.new("scripts/skills/actives/xxitem_xxuquiveraa_skill"));
	}

});

