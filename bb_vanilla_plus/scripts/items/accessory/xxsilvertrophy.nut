this.xxsilvertrophy <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.xxsilvertrophy";
		this.m.Name = "Ожерелье-оберег";
		this.m.Description = "Говорят, что это ожерелье носили стражи древних времен, и оно символизирует сильную волю защищать свой народ.";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/xxsilvertrophy.png";
		this.m.Sprite = "xxsilvertrophy";
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
			text = "Мои атаки не наносят урона союзникам. При атаке на расстоянии препятствия игнорируются, если вокруг цели находятся союзники. (некоторые навыки не применяются)"
		});
		return result;
	}

	function onEquip()
	{
		this.accessory.onEquip();
		this.addSkill(this.new("scripts/skills/actives/ai_noteamkill"));
	}

});

