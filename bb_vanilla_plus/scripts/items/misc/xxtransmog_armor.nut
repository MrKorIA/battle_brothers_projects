this.xxtransmog_armor <- this.inherit("scripts/items/item", {
	m = {
		IsUsed = false,
		IsNude = true,
		StoredName = "Nude Robe",
		StoredShowOnCharacter = false,
		StoredSprite = "",
		StoredSpriteDamaged = "",
		StoredSpriteCorpse = "",
		StoredIconLarge = "armor/inventory_xxinviarmor_L.png",
		StoredIcon = "armor/inventory_xxinviarmor.png"
	},

	function create()
	{
		this.item.create();
		this.m.ID = "misc.xxtransmog_armor";
		this.m.Name = "Transmog Kit (Armor)";
		this.m.Description = "Used to save the appearance of the equipped armor. Saves a transparent appearance if the armor slot is empty.";
		this.m.Icon = "transmog_body_a_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsUsable = true;
		this.m.Value = 2;
	}

	function getName()
	{
		return this.m.Name + (this.m.IsUsed ? " (Saved)" : "");
	}

	function updateIcon()
	{
		this.m.Icon = this.m.IsUsed ? "transmog_body_b_70x70.png" : "transmog_body_a_70x70.png";
	}

	function getDescription()
	{
		if (this.m.IsUsed)
		{
			local desc = "Saved Appearance: [color=#116a2c]" + this.m.StoredName + "[/color]\n";
			desc += "Using this on any armor will consume it to forge a new piece with the saved look.\n\n";
			desc += "[color=#1e8a1e]Special abilities maintained for:[/color] Davkul, Emperor, Ijirok, and Lindwurm Armor";
			return desc;
		}
		return this.m.Description;
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
		result.push({
			id = 65,
			type = "text",
			text = "Use by Right-clicking or Dragging on the armor slot of the currently selected character. This item will be consumed in the process."
		});
		return result;
	}

	function onUse( _actor, _item = null )
	{
		local armor = _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);

		if (!this.m.IsUsed)
		{
			if (armor != null)
			{
				this.m.IsNude = false;
				this.m.StoredName = armor.getName();
				this.m.StoredShowOnCharacter = armor.m.ShowOnCharacter;
				this.m.StoredSprite = armor.m.Sprite;
				this.m.StoredSpriteDamaged = armor.m.SpriteDamaged;
				this.m.StoredSpriteCorpse = armor.m.SpriteCorpse;
				this.m.StoredIcon = armor.m.Icon;
				this.m.StoredIconLarge = armor.m.IconLarge;
			}
			this.m.IsUsed = true;
			this.updateIcon();
			this.World.Assets.getStash().add(this);
			return true;
		}
		else
		{
			if (armor == null)
			{
				::Sound.play("sounds/combat/lute_break_01.wav", 1.0);
				return false;
			}
			if (armor.getUpgrade() != null)
			{
				local upg = armor.getUpgrade();
			        armor.setUpgrade(null);
				upg.m.Armor = null;
				this.World.Assets.getStash().add(upg);
			}
			local citem;
			switch(armor.m.ID)
			{
				case "armor.body.armor_of_davkul":
					citem = ::new("scripts/items/armor/xxtransmog_armor_out_davkul");
					break;
				case "armor.body.emperors_armor":
					citem = ::new("scripts/items/armor/xxtransmog_armor_out_emperors");
					break;
				case "armor.body.ijirok_armor":
					citem = ::new("scripts/items/armor/xxtransmog_armor_out_ijirok");
					break;
				case "armor.body.lindwurm_armor":
					citem = ::new("scripts/items/armor/xxtransmog_armor_out_lindwurm");
					break;
				 default:
				        citem = ::new("scripts/items/armor/xxtransmog_armor_out");
				        break;
			}
			citem.m.Sprite = this.m.StoredSprite;
			citem.m.SpriteDamaged = this.m.StoredSpriteDamaged;
			citem.m.SpriteCorpse = this.m.StoredSpriteCorpse;
			citem.m.Icon = this.m.StoredIcon;
			citem.m.IconLarge = this.m.StoredIconLarge;
			citem.m.ShowOnCharacter = this.m.StoredShowOnCharacter;
			citem.m.Value = armor.m.Value;
			citem.m.ConditionMax = this.Math.floor(armor.m.ConditionMax);
			citem.m.Condition = armor.m.Condition;
			citem.m.StaminaModifier = armor.m.StaminaModifier;
			citem.m.Name = armor.m.Name;
			citem.m.Description = armor.m.Description;
			citem.m.ItemType = armor.m.ItemType;
			 _actor.getItems().unequip(armor);
			this.World.Assets.getStash().remove(armor);
			 _actor.getItems().equip(citem);
			this.updateIcon();
			return true;
		}
	}

	function onSerialize( _out )
	{
		this.item.onSerialize(_out);
		_out.writeBool(this.m.IsUsed);
		_out.writeBool(this.m.IsNude);
		_out.writeString(this.m.StoredName);
		_out.writeBool(this.m.StoredShowOnCharacter);
		_out.writeString(this.m.StoredSprite);
		_out.writeString(this.m.StoredSpriteDamaged);
		_out.writeString(this.m.StoredSpriteCorpse);
		_out.writeString(this.m.StoredIcon);
		_out.writeString(this.m.StoredIconLarge);
	}

	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);
		this.m.IsUsed = _in.readBool();
		this.m.IsNude = _in.readBool();
		this.m.StoredName = _in.readString();
		this.m.StoredShowOnCharacter = _in.readBool();
		this.m.StoredSprite = _in.readString();
		this.m.StoredSpriteDamaged = _in.readString();
		this.m.StoredSpriteCorpse = _in.readString();
		this.m.StoredIcon = _in.readString();
		this.m.StoredIconLarge = _in.readString();
		this.updateIcon();
	}
});