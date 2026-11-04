this.sbp_goblin_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 0
	},
	function create()
	{
		this.m.ID = "actives.sbp_goblin_skill";
		this.m.Name = "Оружейное дело гоблинов";
		this.m.Icon = "ui/xxp2.png";
		this.m.Description = "При использовании оружия гоблинов: +50% к пробитию брони и +5 к защите в ближнем бою в начале хода";
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

	function onNewRound()
	{
		if (this.getContainer().getActor().isPlacedOnMap() && this.m.Skillcharge != 1)
		{
			this.m.Skillcharge = 1;
			this.spawnIcon("status_effect_34", this.getContainer().getActor().getTile());
		}
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
		local item = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null && this.m.Skillcharge == 1)
		{
			if (item.getID().find("goblin") != null)
			{
				_properties.DamageDirectAdd += 0.5;
				_properties.MeleeDefense += 5;
			}
		}
	}

});

