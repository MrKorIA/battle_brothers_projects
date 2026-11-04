this.rally_rat_troops_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.rally_rat_troops";
		this.m.Name = "Собрать крыс";
		this.m.Description = "";
		this.m.Icon = "skills/rat_active_06.png";
		this.m.IconDisabled = "";
		this.m.Overlay = "rat_active_06";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/whip_slave_01.wav",
			"sounds/combat/dlc6/whip_slave_02.wav",
			"sounds/combat/dlc6/whip_slave_03.wav"
		];
		this.m.SoundVolume = 1.5;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function onUse( _user, _targetTile )
	{
		local myTile = _user.getTile();
		local actors = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());

		foreach( a in actors )
		{
			if (a.getID() == _user.getID())
			{
				continue;
			}

			if (a.getMoraleState() > this.Const.MoraleState.Steady)
			{
				continue;
			}

			if (a.getFaction() == _user.getFaction() && !a.getSkills().hasSkill("effects.rally_rat"))
			{
				a.getSkills().add(this.new("scripts/skills/effects/rally_rat_effect"));
			}
		}

		this.getContainer().add(this.new("scripts/skills/effects/rally_rat_effect"));
		return true;
	}

});

