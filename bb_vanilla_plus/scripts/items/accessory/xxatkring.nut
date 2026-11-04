this.xxatkring <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.xxatkring";
		this.m.Name = "Кольцо Берсерка";
		this.m.Description = "Носитель этого кольца теряет свою человечность, его чувства милосердия и сострадания исчезают, и он становится жестоким, как берсерк.";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = false;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/xxatkring.png";
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
			id = 9,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Владелец участвует в ближнем бою (в зоне действия): +25% к урону"
		});
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "-10 к защите в ближнем бою, -10 к защите в дальнем бою, на 10% больше получаемого урона"
		});
		return result;
	}

	function onEquip()
	{
		this.accessory.onEquip();
		this.addSkill(this.new("scripts/skills/actives/xxitem_atkringaa_skill"));
	}

});

