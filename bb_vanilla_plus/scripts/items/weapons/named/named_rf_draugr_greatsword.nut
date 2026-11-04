this.named_rf_draugr_greatsword <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {
		StunChance = 0
	},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_rf_draugr_greatsword";
		this.m.NameList = ::Const.Strings.GreatswordNames;
		this.m.Description = "Двуручный меч, покрытый древними рунами, несмотря на свой возраст, сохраняет острую кромку. Его костяная рукоять предназначена не столько для боевого применения, сколько для красоты.";
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.WeaponType = ::Const.Items.WeaponType.Sword;
		this.m.ItemType = ::Const.Items.ItemType.Named | ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.Value = 3200;
		this.m.ShieldDamage = 24;
		this.m.Condition = 70.0;
		this.m.ConditionMax = 70.0;
		this.m.StaminaModifier = -16;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.1;
		this.m.DirectDamageMult = 0.25;
		this.m.DirectDamageAdd = 0.05;
		this.m.ChanceToHitHead = 10;
		this.randomizeValues();
	}

	function updateVariant()
	{
		local variant = this.m.Variant < 10 ? "0" + this.m.Variant : this.m.Variant;
		this.m.IconLarge = "weapons/melee/rf_draugr_greatsword_named_" + variant + ".png";
		this.m.Icon = "weapons/melee/rf_draugr_greatsword_named_" + variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_draugr_greatsword_named_" + variant ;
	}

	function onEquip()
	{
		this.__setNameBasedOnChampion();

		this.named_weapon.onEquip();

		local skill = ::new("scripts/skills/actives/overhead_strike");
		skill.m.ActionPointCost -= 1;
        skill.m.FatigueCost -= 3;
		this.addSkill(skill);

        skill = ::new("scripts/skills/actives/split");
        skill.m.FatigueCost -= 5;

        skill = ::new("scripts/skills/actives/swing");
        skill.m.FatigueCost -= 5;
		this.addSkill(skill);

        skill = ::new("scripts/skills/actives/split_shield");
        skill.m.ActionPointCost += 1;
        skill.m.FatigueCost += 5;
		this.addSkill(skill);
	}

	function onPutIntoBag()
	{
		this.__setNameBasedOnChampion();
		this.named_weapon.onPutIntoBag();
	}

	function __setNameBasedOnChampion()
	{
		if (this.m.Name.len() == 0 && this.getContainer().getActor().getSkills().hasSkill("racial.champion"))
		{
			this.setName(this.getContainer().getActor().getName() + " " + ::MSU.Array.rand(this.m.NameList));
		}
	}
});
