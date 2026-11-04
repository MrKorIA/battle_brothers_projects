this.xxlefts <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xxlefts";
		this.m.Name = "Меч для левой руки";
		this.m.Description = "Леворучное дополнительное оружие для двойного оружия. Для атаки необходимо иметь основное оружие.";
		this.m.IconLarge = "xx_weapon_03.png";
		this.m.Icon = "xx_weapon_03_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Tool;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_xx_weapon_03";
		this.m.Value = 1000;
		this.m.StaminaModifier = -4;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		if (this.getIconLarge() != null)
		{
			ret.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			ret.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}
		ret.push({
			id = 9,
			type = "text",
			text = this.getValueString()
		});
		if (this.m.StaminaModifier < 0)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Максимальная усталость [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.StaminaModifier + "[/color]"
			});
		}
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] Урон в ближнем бою"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Защита в ближнем бою"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Специальный навык, добавляемый при оснащении одной рукой оружием ближнего боя (за некоторыми исключениями)"
		});
		return ret;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/xxitem_leftsaa_skill"));
		if (this.getContainer().getActor().isAlliedWithPlayer())
		{
			this.getContainer().getActor().setSpriteOffset("arms_icon", this.createVec(-15, 0));
		}
		else
		{
			this.getContainer().getActor().setSpriteOffset("arms_icon", this.createVec(15, 0));
		}
		this.getContainer().getActor().setAlwaysApplySpriteOffset(true);
		this.updateAppearance();
	}

	function onUnequip()
	{
		this.m.IsBloodied = false;
		this.weapon.onUnequip();
		if (this.m.ShowArmamentIcon)
		{
			if (this.m.SlotType == this.Const.ItemSlot.Offhand)
			{
				this.getContainer().getAppearance().Shield = "";
			}
			else
			{
				this.getContainer().getAppearance().Weapon = "";
				this.getContainer().getAppearance().TwoHanded = false;
			}
		}
		this.getContainer().getActor().setSpriteOffset("arms_icon", this.createVec(0, 0));
		this.getContainer().updateAppearance();
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
		_properties.MeleeDefense += 5;
		_properties.MeleeDamageMult += 0.15;
	}

});

