this.sbq26p_rodelero_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbq26p_rodelero_skill";
		this.m.Name = "133. Rodelero (passive)";
		this.m.Icon = "ui/xxp40.png";
		this.m.Description = "While a shield is equipped, grants +10% Damage. Also enables the Duelist perk (if learned).";
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

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local items = actor.getItems();
		local off = items.getItemAtSlot(this.Const.ItemSlot.Offhand);
		if (off != null && off.isItemType(this.Const.Items.ItemType.Shield))
		{
			_properties.DamageTotalMult += 0.1;
			if (actor.getSkills().hasSkill("perk.duelist"))
			{
				if (off.getID() != "shield.buckler" && off.getID() != "shield.named_buckler")
				{
					_properties.DamageDirectAdd += 0.25;
				}
			}
		}
	}

});

