this.xxreforged <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.xxreforged";
		this.m.Name = "Reforged Stone";
		this.m.Description = "If a standard weapon you currently have equipped is on the following list, this stone upgrades it to a Named Item and enhances its stats.\n\n[color=" + this.Const.UI.Color.PositiveValue + "]Upgradable Weapon List : [/color]Goedendag, Fire Lance, Throwing Spear, Staff Sling, Nomad Sling, Spiked Bolas, Spiked Impaler, Notched Blade, Obsidian Dagger, Reproach of the Old Gods, Censer of the Diviner, Main Weapons of Fantasy Town";
		this.m.Icon = "xx_item_10_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.Value = 2500;
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
			id = 65,
			type = "text",
			text = "Use by Right-clicking or Dragging on the weapon slot of the currently selected character. This item will be consumed in the process."
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
		local mm = _item == null ? _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) : _item;
		if (mm != null && !mm.isItemType(this.Const.Items.ItemType.Named) && mm.isItemType(this.Const.Items.ItemType.Weapon))
		{

			if (mm.m.ID == "weapon.firelance")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_firelance"));
			}
			else if (mm.m.ID == "weapon.goblin_crossbow")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_goblin_crossbow"));
			}
			else if (mm.m.ID == "weapon.goblin_notched_blade")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_goblin_notched_blade"));
			}
			else if (mm.m.ID == "weapon.goblin_spiked_balls")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_goblin_spiked_balls"));
			}
			else if (mm.m.ID == "weapon.goedendag")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_goedendag"));
			}
			else if (mm.m.ID == "weapon.lightbringer_sword")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_lightbringer_sword"));
			}
			else if (mm.m.ID == "weapon.miasma_flail")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_miasma_flail"));
			}
			else if (mm.m.ID == "weapon.nomad_sling")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_nomad_sling"));
			}
			else if (mm.m.ID == "weapon.obsidian_dagger")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_obsidian_dagger"));
			}
			else if (mm.m.ID == "weapon.staff_sling")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_staff_sling"));
			}
			else if (mm.m.ID == "weapon.throwing_spear")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_throwing_spear"));
			}
			else if (mm.m.ID == "weapon.xxarcanespear")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_xxarcanespear"));
			}
			else if (mm.m.ID == "weapon.xxbamboospear")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_xxbamboospear"));
			}
			else if (mm.m.ID == "weapon.xxcestus")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_xxcestus"));
			}
			else if (mm.m.ID == "weapon.xxcestusb")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_xxcestusb"));
			}
			else if (mm.m.ID == "weapon.xxdragonsw")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_xxdragonsw"));
			}
			else if (mm.m.ID == "weapon.xxheavylance")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_xxheavylance"));
			}
			else if (mm.m.ID == "weapon.xxkatar")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_xxkatar"));
			}
			else if (mm.m.ID == "weapon.xxkusarigama")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_xxkusarigama"));
			}
			else if (mm.m.ID == "weapon.xxmagicstaff")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_xxmagicstaff"));
			}
			else if (mm.m.ID == "weapon.xxmeteor")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_xxmeteor"));
			}
			else if (mm.m.ID == "weapon.xxmstaff")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_xxmstaff"));
			}
			else if (mm.m.ID == "weapon.xxnodachi")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_xxnodachi"));
			}
			else if (mm.m.ID == "weapon.xxrifle")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_xxrifle"));
			}
			else if (mm.m.ID == "weapon.xxringblade")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_xxringblade"));
			}
			else if (mm.m.ID == "weapon.xxruneblade")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_xxruneblade"));
			}
			else if (mm.m.ID == "weapon.xxshuriken")
			{
				 _actor.getItems().unequip(mm);
				this.World.Assets.getStash().remove(mm);
				 _actor.getItems().equip(::new("scripts/items/weapons/named/uq_xxshuriken"));
			}
			else
			{
				::Sound.play("sounds/combat/lute_break_01.wav", 1.0);
				return false;
			}
		}
		else
		{
			::Sound.play("sounds/combat/lute_break_01.wav", 1.0);
			return false;
		}
		return true;
	}

});

