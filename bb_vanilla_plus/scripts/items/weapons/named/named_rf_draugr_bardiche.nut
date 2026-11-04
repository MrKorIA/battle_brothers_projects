this.named_rf_draugr_bardiche <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_rf_draugr_bardiche";
		this.m.NameList = ::Const.Strings.AxeNames;
		this.m.Description = "Этот древний топор с большим, украшенным гравировкой лезвием, создан для войны и наносит могучие удары, способные быстро убить противника. По виду и применению напоминает современный бердыш.";
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.WeaponType = ::Const.Items.WeaponType.Axe;
		this.m.ItemType = ::Const.Items.ItemType.Named | ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.Value = 3200;
		this.m.ShieldDamage = 32;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -16;
		this.m.RegularDamage = 70;
		this.m.RegularDamageMax = 90;
		this.m.ArmorDamageMult = 1.5;
		this.m.DirectDamageMult = 0.4;
		this.m.DirectDamageAdd = 0.05;
		this.randomizeValues();
	}

	function updateVariant()
	{
		local variant = this.m.Variant >= 10 ? this.m.Variant : "0" + this.m.Variant;
		this.m.IconLarge = "weapons/melee/rf_draugr_bardiche_named_" + variant + ".png";
		this.m.Icon = "weapons/melee/rf_draugr_bardiche_named_" + variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_draugr_bardiche_named_" + variant;
	}

	function onEquip()
	{
		this.__setNameBasedOnChampion();

		this.named_weapon.onEquip();

		local skill = ::new("scripts/skills/actives/split_man");
		skill.m.Icon = "skills/active_168.png";
		skill.m.IconDisabled = "skills/active_168_sw.png";
		skill.m.Overlay = "active_168";
		this.addSkill(skill);

		this.addSkill(this.new("scripts/skills/actives/split_axe"));

        skill = ::new("scripts/skills/actives/split_shield");
        skill.m.ActionPointCost += 2;
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
