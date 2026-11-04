this.sbp_selfcare_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_selfcare_skill";
		this.m.Name = "103. Забота о себе (пассивная)";
		this.m.Icon = "ui/xxp1.png";
		this.m.Description = "В конце битвы: Полностью восстановить броню, шлем, ОЗ";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast + 100;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
		this.m.IsHidden = false;
	}

	function getTooltip()
	{
		local ret = [
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
		return ret;
	}

	function onCombatFinished()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap())
		{
			return false;
		}
		actor.setHitpoints(actor.getHitpointsMax());
		local items = actor.getItems().getAllItems();
		foreach( item in items )
		{
			item.setCondition(item.getConditionMax());
			local slotType = item.getSlotType();
			if (slotType == this.Const.ItemSlot.Head || slotType == this.Const.ItemSlot.Body)
			{
				item.setArmor(item.getArmorMax());
			}
		}
	}

});

