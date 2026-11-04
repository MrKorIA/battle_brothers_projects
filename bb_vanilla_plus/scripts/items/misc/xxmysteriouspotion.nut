this.xxmysteriouspotion <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.xxmysteriouspotion";
		this.m.Name = "Таинственное зелье";
		this.m.Description = "Постоянно получайте +5 ко всем характеристикам.";
		this.m.Icon = "xx_item_03_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.Value = 2500;
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
			id = 65,
			type = "text",
			text = "Используйте, щелкнув правой кнопкой мыши или перетащив на слот головы выбранного персонажа. Этот предмет будет израсходован в процессе."
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		this.Sound.play("sounds/combat/drink_03.wav", this.Const.Sound.Volume.Inventory);
		_actor.getBaseProperties().Hitpoints += 5;
		_actor.getBaseProperties().Bravery += 5;
		_actor.getBaseProperties().Stamina += 5;
		_actor.getBaseProperties().MeleeSkill += 5;
		_actor.getBaseProperties().RangedSkill += 5;
		_actor.getBaseProperties().MeleeDefense += 5;
		_actor.getBaseProperties().RangedDefense += 5;
		_actor.getBaseProperties().Initiative += 5;
		return true;
	}

});

