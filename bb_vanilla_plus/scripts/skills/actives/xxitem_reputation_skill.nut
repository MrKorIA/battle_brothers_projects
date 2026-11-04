this.xxitem_reputation_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.xxitem_reputation_skill";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Name = "Зелье репутации";
		this.m.Icon = "skills/status_effect_94.png";
		this.m.IsSerialized = true;
	}

	function getDescription()
	{
		if (this.World.Assets.getMoralReputation() <= 9.0)
		{
			return "When your reputation was \'Dreaded\' : All stats +15 in night battles";
		}
		else if (this.World.Assets.getMoralReputation() >= 90.0)
		{
			return "When your reputation was \'Saintly\' : All stats +7 in day battles";
		}
		else
		{
			return "When your reputation was \'Dreaded\' : All stats +15 in night battles \n\nWhen your reputation was \'Saintly\' : All stats +7 in day battles";
		}
	}

	function onUpdate( _properties )
	{
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			return;
		}
		if (this.getContainer().hasSkill("special.night") && this.World.Assets.getMoralReputation() <= 9.0)
		{
			local r = 15;
			_properties.Hitpoints += r;
			_properties.Bravery += r;
			_properties.Stamina += r;
			_properties.MeleeSkill += r;
			_properties.RangedSkill += r;
			_properties.MeleeDefense += r;
			_properties.RangedDefense += r;
			_properties.Initiative += r;
		}
		else if (!this.getContainer().hasSkill("special.night") && this.World.Assets.getMoralReputation() >= 90.0)
		{
			local r = 7;
			_properties.Hitpoints += r;
			_properties.Bravery += r;
			_properties.Stamina += r;
			_properties.MeleeSkill += r;
			_properties.RangedSkill += r;
			_properties.MeleeDefense += r;
			_properties.RangedDefense += r;
			_properties.Initiative += r;
		}
	}

});

