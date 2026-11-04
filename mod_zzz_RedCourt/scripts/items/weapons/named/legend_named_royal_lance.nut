this.legend_named_royal_lance <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.ID = "weapon.legend_named_royal_lance";
		this.m.NameList = this.Const.Strings.SpetumNames;
		this.m.PrefixList = this.Const.Strings.SouthernPrefix;
		this.m.SuffixList = this.Const.Strings.SouthernSuffix;
		this.m.Description = "Это копьё отличается исключительным мастерством исполнения - оно пережило века, а его наконечник достоин даже знатного вельможи. Предназначено для нанесения колющих ударов с дистанции и сдерживания врага.";
		this.m.WeaponType = this.Const.Items.WeaponType.Spear;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.Value = 4800;
		this.m.ShieldDamage = 0;
		this.m.Condition = 65.0;
		this.m.ConditionMax = 65.0;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 65;
		this.m.RegularDamageMax = 85;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.25;
		this.m.ChanceToHitHead = 5;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/legend_mummy_lance_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/legend_mummy_lance_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_mummy_lance_named_0" + this.m.Variant;
	}

	function createRandomName()
	{
		if (!this.m.UseRandomName || this.Math.rand(1, 100) <= 60)
		{
			if (this.m.SuffixList.len() == 0 || this.Math.rand(1, 100) <= 70)
			{
				return this.m.PrefixList[this.Math.rand(0, this.m.PrefixList.len() - 1)] + " " + this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)];
			}
			else
			{
				return this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)] + " " + this.m.SuffixList[this.Math.rand(0, this.m.SuffixList.len() - 1)];
			}
		}
		else if (this.Math.rand(1, 2) == 1)
		{
			return this.getRandomCharacterName(this.Const.Strings.SouthernNamesLast) + " " + this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)];
		}
		else
		{
			return this.getRandomCharacterName(this.Const.Strings.NomadChampionStandalone) + " " + this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)];
		}
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local skill = this.new("scripts/skills/actives/prong_skill");
        skill.m.Icon = "skills/active_54.png";
        skill.m.IconDisabled = "skills/active_54_sw.png";
        skill.m.Overlay = "active_54";
		this.addSkill(skill);

		skill = this.new("scripts/skills/actives/legend_heartseeker_skill");
		skill.m.IsTwoHanded = true;
		this.addSkill(skill);

		skill = this.new("scripts/skills/actives/legend_skewer_skill");
        skill.m.Icon = "skills/skewer_spetum.png";
        skill.m.IconDisabled = "skills/skewer_spetum_bw.png";
        skill.m.Overlay = "skewer_spetum";
        this.addSkill(skill);

		skill = this.new("scripts/skills/actives/spearwall");
        skill.m.Icon = "skills/active_54.png";
        skill.m.IconDisabled = "skills/active_54_sw.png";
        skill.m.Overlay = "active_54";
        skill.m.BaseAttackName = "Prong";
        skill.setFatigueCost(skill.getFatigueCostRaw() + 5);
        skill.m.ActionPointCost = 6;
	}

});
