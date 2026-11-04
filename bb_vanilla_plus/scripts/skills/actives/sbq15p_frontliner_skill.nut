this.sbq15p_frontliner_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbq15p_frontliner_skill";
		this.m.Name = "122. Frontliner (passive)";
		this.m.Icon = "ui/xxp35.png";
		this.m.Description = "+15% Damage when engaged in melee (in ZOC)";
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
		if (actor.isPlacedOnMap() && actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions()))
		{
			_properties.DamageTotalMult += 0.15;
		}
	}

});

