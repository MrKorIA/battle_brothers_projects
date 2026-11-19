this.nggh707_skull_of_the_dead <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "accessory.skull_of_undead";
		this.m.Name = "Череп мертвеца";
		this.m.Description = "Жуткий череп, вырезанный из цельного кристалла. На его поверхности не видно царапин или других следов. Он убивает огонь надежды всякого человека, что узрит его, ломает волю и порождает сомнения.";
		this.m.IconLarge = "";
		this.m.Icon = "accessory/skull_of_death.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Musical | this.Const.Items.WeaponType.Mace;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Accessory | this.Const.Items.ItemType.Tool | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_skull_of_death_enrage";
		this.m.Value = 5000;
		this.m.StaminaModifier = 0;
		this.m.IsDroppedAsLoot = false;
		this.m.IsDoubleGrippable = true;
		this.m.IsBloodied = false;
	}

	function getTooltip()
	{
		local result = [
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
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}
		
		result.push({
			id = 64,
			type = "text",
			text = "Берётся в левую руку"
		});

		if (this.m.StaminaModifier < 0)
		{
			result.push({
				id = 8,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Выносливость [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.StaminaModifier + "[/color]"
			});
		}
		
		return result;
	}
	
	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/perfect_focus_01.wav", this.Const.Sound.Volume.Inventory);
	}

});

