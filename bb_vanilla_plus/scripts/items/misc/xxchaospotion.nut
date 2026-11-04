this.xxchaospotion <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.xxchaospotion";
		this.m.Name = "Зелье хаоса";
		this.m.Description = "Любой, кто выпьет эту жидкость, навсегда получает одно из двух улучшений характеристик.";
		this.m.Icon = "xx_item_06_70x70.png";
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
		local chk = _actor.getSkills();
		chk.add(this.new("scripts/skills/actives/xxzzcheck_skill"));
	        ::World.State.getMenuStack().popAll(true);
		::World.Events.fire("event.xxzzchaospotion_event");
		return true;
	}

	function getBuyPrice()
	{
		return this.Math.ceil(this.getValue());
	}

	function getSellPrice()
	{
		return 1;
	}

});

