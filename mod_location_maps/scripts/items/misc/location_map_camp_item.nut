this.location_map_camp_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.location_map_camp";
		this.m.Name = "Карта большого лагеря";
		this.m.Icon = "misc/map_camp.png";
		this.m.Description = "Карта с примечаниями следопыта. На ней отмечено логово врага — большое, сильно укреплённое и, судя по всему, богатое добычей.\nЩёлкните правой кнопкой мыши, чтобы изучить её.";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsUsable = true;
		this.m.Value = 500;
	}

	function onUse( _actor, _item = null )
	{
		local location = ::LocationMaps.rollLocation(::LocationMaps.getCampCandidates());

		if (location == null)
		{
			::World.State.getMenuStack().popAll(true);
			::World.Events.fire("event.location_map_fake");
			return true;
		}

		::LocationMaps.revealLocation(location);
		this.Sound.play("sounds/scribble.wav", this.Const.Sound.Volume.Inventory);
		return true;
	}
});
