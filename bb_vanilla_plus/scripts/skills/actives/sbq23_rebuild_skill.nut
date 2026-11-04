this.sbq23_rebuild_skill <- this.inherit("scripts/skills/skill", {
	m = {	},
	function create()
	{
		this.m.ID = "actives.sbq23_rebuild_skill";
		this.m.Name = "130. Rebuild";
		this.m.Description = "Becoming highly vulnerable and unable to act for 3 turns. After this, restores hitpoints, helmet and armor durability to 50% of their maximum.";
		this.m.Icon = "ui/xx88.png";
		this.m.IconDisabled = "ui/xx88_sw.png";
		this.m.SoundOnUse = [
			"sounds/vomit_01.wav"
		];
		this.m.SoundVolume = 1.1;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 5;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Container.add(this.new("scripts/skills/effects/sbq23_rebuild_effect"));
		return true;
	}

});

