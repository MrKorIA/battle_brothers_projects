this.xx11_lvlpotion <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.xx11_lvlpotion";
		this.m.Name = "Зелье превосходства";
		this.m.Description = "Повышает уровень пользователя до 11. Если уровень уже 11 или выше, повышает на 1 уровень.";
		this.m.Icon = "xx_item_05_70x70.png";
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
		local targetlevel = 11 - _actor.getLevel();
		if (targetlevel <= 0)
		{
			targetlevel = 1;
		}
		for( local i = 0; i != targetlevel; i = ++i )
		{
			local nextlevelXP = _actor.getXPForNextLevel() - _actor.m.XP;
			_actor.m.XP += nextlevelXP;
			_actor.m.CombatStats.XPGained += nextlevelXP;
			_actor.updateLevel();
			_actor.getSkills().update();
		}
		return true;
	}

});

