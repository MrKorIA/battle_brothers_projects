this.xxlimitpotion <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.xxlimitpotion";
		this.m.Name = "Зелье преодоления пределов";
		this.m.Description = "Максимальное количество навыков, которые можно изучить с помощью книг навыков, становится 3.";
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
		local chk = _actor.getSkills();
		foreach ( s in this.FantasyChampList )
		{
			if (chk.hasSkill(s))
			{
				return false;
			}
		}
		local ax = _actor.getFlags().getAsInt("xxSkillBookTraining");
		if (ax < 9999989)
		{
		}
		else
		{
			return false;
		}
		if (chk.hasSkill("effects.xxzzlimitpotion_skill"))
		{
			return false;
		}
		this.Sound.play("sounds/combat/drink_03.wav", this.Const.Sound.Volume.Inventory);
		chk.add(this.new("scripts/skills/actives/xxzzlimitpotion_skill"));
		return true;
	}

});

