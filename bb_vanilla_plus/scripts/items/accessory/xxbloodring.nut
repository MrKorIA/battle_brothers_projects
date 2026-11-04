this.xxbloodring <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.xxbloodring";
		this.m.Name = "Кровавое кольцо";
		this.m.Description = "Наполненное силой Некросаванта, это кольцо пробуждает в его владельце жажду крови.";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = false;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/xxbloodring.png";
		this.m.Sprite = "xxsilvertrophy";
		this.m.Value = 3000;
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
			text = "При атаке кровоточащей цели: +10% к урону, +5 к навыку ближнего боя, +5 к навыку дальнего боя, 30% к похищению жизни при попадании."
		});
		return result;
	}

	function onEquip()
	{
		this.accessory.onEquip();
		this.addSkill(this.new("scripts/skills/actives/xxitem_bloodringaa_skill"));
	}

});

