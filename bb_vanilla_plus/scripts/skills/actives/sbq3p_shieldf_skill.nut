this.sbq3p_shieldf_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbq3p_shieldf_skill";
		this.m.Name = "110. Щит веры (пассивный)";
		this.m.Icon = "ui/xxp31.png";
		this.m.Description = "При оснащении щитом: +25 к максимальной усталости +10 к храбрости (этот эффект удваивается, если это щит с именем или легендарный щит)";
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
		local item = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		if (item != null && item.isItemType(this.Const.Items.ItemType.Shield))
		{
			if (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary) || item.getID() == "shield.gilders_embrace")
			{
				_properties.Stamina += 50;
				_properties.Bravery += 20;
			}
			else
			{
				_properties.Stamina += 25;
				_properties.Bravery += 10;
			}
		}
	}

});

