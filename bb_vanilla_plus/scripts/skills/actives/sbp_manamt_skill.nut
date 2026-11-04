this.sbp_manamt_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_manamt_skill";
		this.m.Name = "84. Mana Mastery (passive)";
		this.m.Icon = "ui/xxp26.png";
		this.m.Description = "+20% Damage when both hands are empty or when wearing a Cestus. The effect is enhanced if Resolve is 90 or higher.";
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
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Max number of skills that can be learned through skill books becomes 3."
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local mainh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local offh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		if ((mainh == null && offh == null) || this.getContainer().hasSkill("actives.xxitem_cestusaa_skill"))
		{
			if (actor.getCurrentProperties().getBravery() >= 90)
			{
				_properties.DamageTotalMult += 0.35;
			}
			else
			{
				_properties.DamageTotalMult += 0.2;
			}
		}
	}

});

