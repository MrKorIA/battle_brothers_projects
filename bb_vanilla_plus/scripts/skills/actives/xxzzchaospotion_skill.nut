this.xxzzchaospotion_skill <- this.inherit("scripts/skills/skill", {
	m = {	},
	function create()
	{
		this.m.ID = "effects.xxzzchaospotion_skill";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Icon = "ui/perks/perk_56.png";
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
	}

	function getTooltip()
	{
		local a = this.getContainer().getActor();
		local ax = a.getFlags();
		local s0 = "+" + ax.getAsInt("qzhp") + " ОЗ\n";
		local s1 = "+" + ax.getAsInt("qzst") + " Выносливость\n";
		local s2 = "+" + ax.getAsInt("qzbr") + " Bravery\n";
		local s3 = "+" + ax.getAsInt("qzin") + " Initiative\n";
		local s4 = "+" + ax.getAsInt("qzms") + " Melee Skill\n";
		local s5 = "+" + ax.getAsInt("qzrs") + " Ranged Skill\n";
		local s6 = "+" + ax.getAsInt("qzmd") + " Melee Defense\n";
		local s7 = "+" + ax.getAsInt("qzrd") + " Ranged Defense\n";
		local s8 = "+" + ax.getAsInt("xxcp8") + "% Melee Damage\n";
		local s9 = "+" + ax.getAsInt("xxcp9") + "% Ranged Damage\n";
		local s10 = "+" + ax.getAsInt("xxcp10") + "% Damage\n";
		local s11 = "+" + ax.getAsInt("xxcp11") + "% Armor Damage\n";
		local s12 = "+" + ax.getAsInt("xxcp12") + "% Armor Ignoring Damage\n";
		local s13 = "+" + ax.getAsInt("xxcp13") * 2 + "% Damage on a hit to the head\n";
		local s14 = "+" + ax.getAsInt("xxcp14") + "% Chance to hit the head\n";
		local s15 = "+" + ax.getAsInt("xxcp15") * 2 + "% Experience Gain\n";
		local s16 = "+" + ax.getAsInt("xxcp16") + "% Chance of two defense rolls\n";
		local s17 = "+" + ax.getAsInt("xxcp17") + " HP recovery per turn\n";
		local s18 = "+" + ax.getAsInt("xxcp18") + " Fatigue Recovery per turn\n";
		local s19 = "-" + ax.getAsInt("qzwage") + " Daily Wage\n";
		return [
			{
				id = 1,
				type = "title",
				text = "Stat Bonus"
			},
			{
				id = 2,
				type = "description",
				text = s0 + s1 + s2 + s3 + s4 + s5 + s6 + s7 + s8 + s9 + s10 + s11 + s12 + s13 + s14 + s15 + s16 + s17 + s18 + s19
			}
		];
	}

	function onUpdate( _properties )
	{
		local a = this.getContainer().getActor();
		local ax = a.getFlags();
		local az = ax.getAsInt("xxcp8");
		if (az > 0)
		{
			_properties.MeleeDamageMult += az * 0.01;
		}
		az = ax.getAsInt("xxcp9")
		if (az > 0)
		{
			_properties.RangedDamageMult += az * 0.01;
		}
		az = ax.getAsInt("xxcp10")
		if (az > 0)
		{
			_properties.DamageTotalMult += az * 0.01;
		}
		az = ax.getAsInt("xxcp11")
		if (az > 0)
		{
			_properties.DamageArmorMult += az * 0.01;
		}
		az = ax.getAsInt("xxcp12")
		if (az > 0)
		{
			_properties.DamageDirectAdd += az * 0.01;
		}
		az = ax.getAsInt("xxcp13")
		if (az > 0)
		{
			_properties.DamageAgainstMult[this.Const.BodyPart.Head] += az * 0.02;
		}
		az = ax.getAsInt("xxcp14")
		if (az > 0)
		{
			_properties.HitChance[this.Const.BodyPart.Head] += az * 1;
		}
		az = ax.getAsInt("xxcp15")
		if (az > 0)
		{
			_properties.XPGainMult *= az * 0.02 + 1;
		}
		az = ax.getAsInt("xxcp16")
		if (az > 0)
		{
			_properties.RerollDefenseChance +=  az * 1;
		}
		az = ax.getAsInt("xxcp17")
		if (az > 0)
		{
			_properties.HitpointsRecoveryRate += az * 1;
		}
		az = ax.getAsInt("xxcp18")
		if (az > 0)
		{
			_properties.FatigueRecoveryRate += az * 1;
		}
	}

});

