this.xxmagicstaff <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xxmagicstaff";
		this.m.Name = "Магический посох";
		this.m.Description = "Деревянный посох, наделенный таинственной силой. Он становится еще более мощным, если его используют люди, обладающие магическими способностями.";
		this.m.Categories = "Булава, двуручное";
		this.m.IconLarge = "xx_weapon_14.png";
		this.m.Icon = "xx_weapon_14_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_xx_weapon_14";
		this.m.Value = 3000;
		this.m.ShieldDamage = 0;
		this.m.Condition = 50;
		this.m.ConditionMax = 50;
		this.m.StaminaModifier = -5;
		this.m.RegularDamage = 70;
		this.m.RegularDamageMax = 90;
		this.m.ArmorDamageMult = 1.5;
		this.m.DirectDamageMult = 0.6;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local sk = this.new("scripts/skills/actives/xxitem_magicstaffaa_skill");
		sk.m.DirectDamageMult = 0.6;
		sk.m.ActionPointCost = 6;
		this.addSkill(sk);
		sk = this.new("scripts/skills/actives/knock_out");
		sk.m.DirectDamageMult = 0.6;
		sk.m.ActionPointCost = 6;
		this.addSkill(sk);
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
		local gg = this.getContainer().getActor().getCurrentProperties().getBravery();
		if (gg >= 80)
		{
			_properties.DamageRegularMax += this.Math.min(gg * 0.5, 100);
		}
		_properties.MeleeSkill += 10;
	}

	function getTooltip()
	{
		local ret = this.weapon.getTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Текущая решимость составляет 80 или более: максимальный урон увеличивается на 50% от текущей решимости ( макс.: +100)"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Навык ближнего боя"
		});
		return ret;
	}

});

