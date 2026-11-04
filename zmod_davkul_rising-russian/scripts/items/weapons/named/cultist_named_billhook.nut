this.cultist_named_billhook <- this.inherit("scripts/items/weapons/named/cultist_named_twohander", {
	m = {},
	function create()
	{
		this.cultist_named_twohander.create();
		this.m.ID = "weapon.cultist_named_billhook";
		this.m.Description = "Тяжёлое, грубое оружие с лезвием для нанесения ударов на расстоянии.";
		this.m.Categories = "Древковое, двуручное";
		this.m.NameList = ["Гнев Давкула"]
		this.m.Name = this.Math.randArray(this.m.NameList)
		this.m.Variants <- [1, 2]
		this.m.Value = 4000;
		this.m.ShieldDamage = 0;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -20;
		this.m.RegularDamage = 65;
		this.m.RegularDamageMax = 95;
		this.m.ArmorDamageMult = 1.4;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 10;
		this.m.FatigueOnSkillUse = 3;
		
		this.setArmament()
		this.randomizeValues()
	}
	function onEquip()
	{
		this.weapon.onEquip();
		local strike = this.new("scripts/skills/actives/strike_skill");
		strike.m.Icon = "skills/active_93.png";
		strike.m.IconDisabled = "skills/active_93_sw.png";
		strike.m.Overlay = "active_93";
		this.addSkill(strike);
		this.addSkill(this.new("scripts/skills/actives/hook"));
	}
});

