this.xxdefring <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.xxdefring";
		this.m.Name = "Кольцо защиты";
		this.m.Description = "Кольцо с магической защитой. Обнаруживает враждебное поведение и предупреждает владельца, чтобы тот мог его избежать.";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = false;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/xxdefring.png";
		this.m.Sprite = "xxsilvertrophy";
		this.m.Value = 4000;
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
			text = "Общая прочность доспехов и шлема составляет 350 или менее: +15 к защите в ближнем бою, 20% уменьшение урона, получаемого доспехами."
		});
		result.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Общая прочность доспехов и шлема превышает 350: +9 к защите в ближнем бою, 10% снижение урона, получаемого доспехами."
		});
		result.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]ВНИМАНИЕ:[/color] Если вы изучили навык «Ловкость» или «Закаленный в боях», это не сработает."
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		local actor = this.getContainer().getActor();
		if (actor.getSkills().hasSkill("perk.battle_forged") || actor.getSkills().hasSkill("perk.nimble") || !this.getContainer().getActor().isPlacedOnMap())
		{
		}
		else
		{
			local helm = actor.getArmorMax(this.Const.BodyPart.Head);
			local armor = actor.getArmorMax(this.Const.BodyPart.Body);
			local total = helm + armor;
			if (total <= 350)
			{
				_properties.MeleeDefense += 15;
				_properties.DamageReceivedArmorMult *= 0.8;
			}
			else
			{
				_properties.MeleeDefense += 9;
				_properties.DamageReceivedArmorMult *= 0.9;
			}
		}
	}

});

