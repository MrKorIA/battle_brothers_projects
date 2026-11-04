this.cultist_named_crowbeak <- this.inherit("scripts/items/weapons/named/cultist_named_twohander", {
	m = {},
	function create()
	{
		this.cultist_named_twohander.create();
		this.m.ID = "weapon.cultist_named_crowbeak";
		this.m.Description = "Тяжёлый шип на длинном древке, используемый для раскалывания брони и сокрушения того, кто находится под ней..";
		this.m.Categories = "Молот, двуручное";
		this.m.NameList = ["Свирепый клюв", "Печаль орла", "Разрушитель"]
		this.m.Name = this.Math.randArray(this.m.NameList)
		this.m.Variants <- [3, 4]
		this.m.Value = 4000;
		this.m.ShieldDamage = 0;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -20;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 90;
		this.m.ArmorDamageMult = 1.85;
		this.m.DirectDamageMult = 0.5;

		this.m.FatigueOnSkillUse = 5;
		this.setArmament()
		this.randomizeValues()
	}
	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/batter_skill");
		this.addSkill(skill);
		local skill = this.new("scripts/skills/actives/demolish_armor_skill");
		this.addSkill(skill);
	}
});

