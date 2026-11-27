this.location_map_legendary_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.location_map_legendary";
		this.m.Name = "Карта легендарной локации";
		this.m.Icon = "misc/map_legendary.png";
		this.m.Description = "Выцветшая карта с пометками о далёком, легендарном месте. Картограф неизвестен, а путь обозначен тщательно — словно кто-то искал его сам и нашёл.\nЩёлкните правой кнопкой мыши, чтобы изучить её.";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsUsable = true;
		this.m.Value = 1000;
	}

	function onUse( _actor, _item = null )
	{
		local location = ::LocationMaps.rollLocation(::LocationMaps.getLegendaryCandidates());

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
