::VanillaPlus.HooksMod.hook("scripts/items/item_container", function(q) {

	// Vestal armor is tailored to a female body: refuse the equip at the container level
	// (same approach as the druid's beastform gear ban) so it is enforced everywhere -
	// inventory screen, tactical swaps and AI alike. The female check itself lives on
	// the item (see scripts/items/armor/vp_vestal_armor.nut, isForbiddenFor).
	// During save deserialization m.Actor is not set yet, so the refusal is skipped
	// there and legacy items load untouched.
	q.equip = @(__original) function (_item) {
		if (_item != null && _item.getID() == "armor.body.vp_vestal_armor")
		{
			local actor = this.m.Actor;
			if (!::MSU.isNull(actor) && _item.isForbiddenFor(actor))
			{
				return false;
			}
		}
		return __original(_item);
	}

});
