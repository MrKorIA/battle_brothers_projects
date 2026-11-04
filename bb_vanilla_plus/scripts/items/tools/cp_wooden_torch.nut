// We inherit from weapon for a few of its useful function implementations, like updateAppearance()
this.cp_wooden_torch <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		SpritesBase = {
			Description = "Простой деревянный факел с головкой из легковоспламеняющегося материала, готовый к использованию.",
			IconLarge = "tools/cp_wooden_torch.png",
			Icon = "tools/cp_wooden_torch_70x70.png",
			ArmamentIcon = "icon_cp_wooden_torch",
		},
		SpritesLit = {
			Description = "Деревянный факел, горящий открытым пламенем.",
			IconLarge = "tools/cp_wooden_torch_lit.png",
			Icon = "tools/cp_wooden_torch_lit_70x70.png",
			ArmamentIcon = "icon_cp_wooden_torch_lit",
		},

	// Private
		IsLit = false,
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.cp_wooden_torch";
		this.m.Name = "Деревянный факел";
		this.m.SlotType = ::Const.ItemSlot.Offhand;
		this.m.ItemType = ::Const.Items.ItemType.Tool;
		this.m.EquipSound = ::Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.IsDroppedAsLoot = true;

		this.m.Value = 80;
		this.m.StaminaModifier = -6;
		this.m.Condition = 80.0;
		this.m.ConditionMax = 80.0;

		this.m.CP_CanBeRepaired = false;

		this.setLit(false);
	}

	function getTooltip()
	{
		local ret = this.item.CP_getEquippableTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Тушится при снятии",
		});

		return ret;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::new("scripts/skills/actives/cp_ignite_torch_skill"));
		this.addSkill(::new("scripts/skills/actives/cp_set_fire_skill"));
	}

	function onUnequip()
	{
		this.setLit(false);
		this.weapon.onUnequip();
	}

	function onCombatFinished()
	{
		this.setLit(false);
	}

	// Overwrite, because we want to guarantee to ignore changes done by overhaul mods to ensure balanced pricing
	function getValue()
	{
		// Same as vanilla weapon::getValue()
		return ::Math.floor(this.m.Value * (this.getCondition() / (this.getConditionMax() * 1.0)));
	}

// New Functions
	function setLit( _bool )
	{
		if (_bool)
		{
			this.m.IsLit = true;
			this.m.Description = this.m.SpritesLit.Description;
			this.m.IconLarge = this.m.SpritesLit.IconLarge;
			this.m.Icon = this.m.SpritesLit.Icon;
			this.m.ArmamentIcon = this.m.SpritesLit.ArmamentIcon;
		}
		else
		{
			this.m.IsLit = false;
			this.m.Description = this.m.SpritesBase.Description;
			this.m.IconLarge = this.m.SpritesBase.IconLarge;
			this.m.Icon = this.m.SpritesBase.Icon;
			this.m.ArmamentIcon = this.m.SpritesBase.ArmamentIcon;
		}

		if (this.isEquipped())
		{
			this.updateAppearance();
		}
	}

	// Similar to the vanilla weapon::lowerCondition function
	function CP_lowerCondition( _value )
	{
		this.m.Condition = ::Math.maxf(0.0, this.m.Condition - _value);

		local actor = this.getContainer().getActor();
		if (this.m.Condition <= 0)
		{
			if (!actor.isHiddenToPlayer())
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " " + this.getName() + " сломан!");
				::Sound.play(this.m.BreakingSound, 1.0, actor.getPos());
			}

			this.unequip();
		}
	}
});
