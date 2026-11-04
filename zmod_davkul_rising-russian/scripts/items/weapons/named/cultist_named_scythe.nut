this.cultist_named_scythe <- this.inherit("scripts/items/weapons/named/cultist_named_twohander", {
	m = {},
	function create()
	{
		this.cultist_named_twohander.create();
		this.m.ID = "weapon.cultist_named_scythe";
		this.m.Description = "Ужасная коса, используемая для нанесения глубоких размашистых ударов на расстоянии.";
		this.m.Categories = "Древковое, двуручное";
		this.m.NameList = ["Кровавая жатва", "Вопль вдовы"]
		this.m.Name = this.Math.randArray(this.m.NameList)
		this.m.Variants <- [5, 6]
		this.m.Value = 4000;
		this.m.ShieldDamage = 0;
		this.m.Condition = 62.0;
		this.m.ConditionMax = 62.0;
		this.m.StaminaModifier = -20;
		this.m.RegularDamage = 70;
		this.m.RegularDamageMax = 90;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.3;
		this.m.FatigueOnSkillUse = 3;

		this.setArmament()
		this.randomizeValues()
		this.m.IsAoE = true;
	}
	function onEquip()
	{
		this.weapon.onEquip();
		local strike = this.new("scripts/skills/actives/strike_skill");
		strike.m.Icon = "skills/active_93.png";
		strike.m.IconDisabled = "skills/active_93_sw.png";
		strike.m.Overlay = "active_93";
		this.addSkill(strike);
		this.addSkill(this.new("scripts/skills/actives/reap_skill"));
	}
});

