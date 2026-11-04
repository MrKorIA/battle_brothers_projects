this.sbp_orc_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_orc_skill";
		this.m.Name = "Оружейное искусство орков";
		this.m.Icon = "ui/xxp29.png";
		this.m.Description = "При использовании оружия или щита орков: +8 к восстановлению усталости за ход";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast + 100;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
		this.m.IsHidden = true;
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
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			this.m.IsHidden = true;
			return;
		}
		this.m.IsHidden = false;

		local actor = this.getContainer().getActor();
		local r = 0;
		local item = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null)
		{
			if (item.getID().find("orc_") != null)
			{
				r = 1;
			}
		}
		item = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		if (item != null)
		{
			if (item.getID().find("orc_") != null)
			{
				r = 1;
			}
		}
		if (r == 1)
		{
			_properties.FatigueRecoveryRate += 8;
		}
	}

});

