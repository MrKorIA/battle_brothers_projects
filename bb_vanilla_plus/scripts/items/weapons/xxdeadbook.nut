this.xxdeadbook <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xxdeadbook";
		this.m.Name = "Книга мертвых";
		this.m.Description = "Книга, содержащая все знания о смерти.";
		this.m.IconLarge = "xx_weapon_09.png";
		this.m.Icon = "xx_weapon_09_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Tool;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_xx_weapon_09";
		this.m.Value = 5000;
		this.m.StaminaModifier = 0;
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
				text = "Максимум усталости [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.StaminaModifier + "[/color]"
			});
		}
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "При использовании кинжала: +40% к урону в ближнем бою, +40 к навыку ближнего боя. \n\nЕсли кинжал является обсидиановым кинжалом: +10 к защите в ближнем и дальнем бою."
		});
		return ret;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/xxitem_deadbookaa_skill"));
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
		this.getContainer().getActor().setSpriteOffset("arms_icon", this.createVec(0, 0));
		this.getContainer().updateAppearance();
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
		local a = this.getContainer().getActor();
		local as = this.getContainer().getActor().getSkills();
		if (as.hasSkill("actives.stab") || as.hasSkill("actives.puncture") || as.hasSkill("actives.deathblow"))
		{
			_properties.MeleeDamageMult *= 1.4;
			_properties.MeleeSkill += 40;
		}
		local mainh = a.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local offh = a.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		if (mainh != null && mainh.getID() == "weapon.obsidian_dagger")
		{
			_properties.MeleeDefense += 10;
			_properties.RangedDefense += 10;
		}
	}

});

