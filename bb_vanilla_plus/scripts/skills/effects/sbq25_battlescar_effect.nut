this.sbq25_battlescar_effect <- this.inherit("scripts/skills/skill", {
	m = {	},
	function create()
	{
		this.m.ID = "effects.sbq25_battlescar_effect";
		this.m.Name = "Battle Scar";
		this.m.Description = "Gains a bonus of +8% Damage per Temporary Injury and +25% Damage per Permanent Injury until the end of this combat.";
		this.m.Icon = "ui/perks/perk_36.png";
		this.m.IconMini = "perk_36_mini";
		this.m.Overlay = "perk_36";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getInjuryCount( _injuryType )
	{
		local ss = this.getContainer().m.Skills;
		local c = 0;
		foreach( s in ss )
		{
			if (s != null && s.isType(_injuryType))
			{
				c++;
			}
		}
		return c;
	}

	function onAfterUpdate( _properties )
	{
		local t = this.getInjuryCount(this.Const.SkillType.TemporaryInjury);
		local p = this.getInjuryCount(this.Const.SkillType.PermanentInjury);
		local b = (t * 0.08) + (p * 0.25);
		if (b > 0)
		{
			_properties.DamageTotalMult += b;
		}
	}

});

