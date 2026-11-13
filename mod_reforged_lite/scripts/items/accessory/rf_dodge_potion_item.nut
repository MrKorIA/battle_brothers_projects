this.rf_dodge_potion_item <- ::inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "accessory.rf_dodge_potion";
		this.m.Name = "Призрачное зелье";
		this.m.Description = "Это снадобье из эссенции потустороннего духа облегчает быстрые движения, даруя персонажу исключительные рефлексы и затрудняя попадание по нему врагам. Действует в течение следующего боя.";
		this.m.SlotType = ::Const.ItemSlot.None;
		this.m.ItemType = ::Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.IconLarge = "";
		this.m.Icon = "consumables/rf_dodge_potion.png";
		this.m.Value = 550;
	}

	function getTooltip()
	{
		local ret = this.item.getTooltip();

		local effect = ::new("scripts/skills/effects/rf_dodge_potion_effect");
		ret.extend(effect.getTooltip().slice(2)) // slice 2 to remove name and description

		ret.push({
			id = 65,
			type = "text",
			text = "Нажмите ПКМ или перетащите на выбранного персонажа, чтобы выпить. Исчезает после использования."
		});
		ret.push({
			id = 65,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "Передозировка может вызвать болезнь"
		});
		return ret;
	}

	function playInventorySound( _eventType )
	{
		::Sound.play("sounds/bottle_01.wav", ::Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		::Sound.play("sounds/combat/drink_0" + ::Math.rand(1, 3) + ".wav", ::Const.Sound.Volume.Inventory);
		_actor.getSkills().add(::new("scripts/skills/effects/rf_dodge_potion_effect"));
		::Const.Tactical.Common.checkDrugEffect(_actor);
		return true;
	}
});
