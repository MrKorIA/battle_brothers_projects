this.xxtransmog_helmet <- this.inherit("scripts/items/item", {
	m = {
		IsUsed = false,
		StoredName = "Nude Hood",
		StoredShowOnCharacter = true,
		StoredHideCharacterHead = false,
		StoredHideHair = false,
		StoredHideBeard = false,
		StoredReplaceSprite = false,
		StoredVision = 0,
		StoredSprite = "",
		StoredSpriteDamaged = "",
		StoredSpriteCorpse = "",
		StoredIcon = "helmets/inventory_xxinvihat.png"
	},

	function create()
	{
		this.item.create();
		this.m.ID = "misc.xxtransmog_helmet";
		this.m.Name = "Transmog Kit (Helmet)";
		this.m.Description = "Used to save the appearance of the equipped helmet. Saves a transparent appearance if the helmet slot is empty.";
		this.m.Icon = "transmog_head_a_70x70.png";
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
		this.m.Icon = this.m.IsUsed ? "transmog_head_b_70x70.png" : "transmog_head_a_70x70.png";
	}

	function getDescription()
	{
		if (this.m.IsUsed)
		{
			local desc = "Saved Appearance: [color=#116a2c]" + this.m.StoredName + "[/color]\n";
			desc += "Using this on any helmet will consume it to forge a new piece with the saved look.\n\n";
			desc += "[color=#1e8a1e]Special abilities maintained for:[/color] Fangshire, Davakul, Emperor, Ijirok, and Lindwurm Helmet";
			return desc;
		}
		return this.m.Description;
	}

	function getTooltip()
	{
		local result = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() }
		];
		result.push({ id = 66, type = "text", text = this.getValueString() });
		result.push({
			id = 65,
			type = "text",
			text = "Use by Right-clicking or Dragging on the helmet slot of the currently selected character. This item will be consumed in the process."
		});
		return result;
	}

	function onUse( _actor, _item = null )
	{
		local helm = _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);

		if (!this.m.IsUsed)
		{
			if (helm != null)
			{
				this.m.StoredName = helm.getName();
				this.m.StoredShowOnCharacter = helm.m.ShowOnCharacter;
				this.m.StoredHideCharacterHead = helm.m.HideCharacterHead;
				this.m.StoredHideHair = helm.m.HideHair;
				this.m.StoredHideBeard = helm.m.HideBeard;
				this.m.StoredReplaceSprite = helm.m.ReplaceSprite;
				this.m.StoredVision = helm.m.Vision;
				this.m.StoredSprite = helm.m.Sprite;
				this.m.StoredSpriteDamaged = helm.m.SpriteDamaged;
				this.m.StoredSpriteCorpse = helm.m.SpriteCorpse;
				this.m.StoredIcon = helm.m.Icon;
			}
			this.m.IsUsed = true;
			this.updateIcon();
			this.World.Assets.getStash().add(this);
			return true;
		}
		else
		{
			if (helm == null)
			{
				::Sound.play("sounds/combat/lute_break_01.wav", 1.0);
				return false;
			}

			local citem;
			switch(helm.m.ID)
			{
				case "armor.head.fangshire":
					citem = ::new("scripts/items/helmets/xxtransmog_helmet_out_fangshire");
					break;
				case "armor.head.mask_of_davkul":
					citem = ::new("scripts/items/helmets/xxtransmog_helmet_out_davkul");
					break;
				case "armor.head.emperors_countenance":
					citem = ::new("scripts/items/helmets/xxtransmog_helmet_out_emperor");
					break;
				case "armor.head.ijirok_helmet":
					citem = ::new("scripts/items/helmets/xxtransmog_helmet_out_ijirok");
					break;
				case "armor.head.lindwurm_helmet":
					citem = ::new("scripts/items/helmets/xxtransmog_helmet_out_lindwurm");
					break;
				default:
					citem = ::new("scripts/items/helmets/xxtransmog_helmet_out");
					break;
			}

			citem.m.Sprite = this.m.StoredSprite;
			citem.m.SpriteDamaged = this.m.StoredSpriteDamaged;
			citem.m.SpriteCorpse = this.m.StoredSpriteCorpse;
			citem.m.Icon = this.m.StoredIcon;			
			citem.m.ShowOnCharacter = this.m.StoredShowOnCharacter;
			citem.m.HideCharacterHead = this.m.StoredHideCharacterHead;
			citem.m.HideHair = this.m.StoredHideHair;
			citem.m.HideBeard = this.m.StoredHideBeard;
			citem.m.ReplaceSprite = this.m.StoredReplaceSprite;
			citem.m.Vision = helm.m.Vision;
			citem.m.Name = helm.m.Name;
			citem.m.Description = helm.m.Description;
			citem.m.Value = helm.m.Value;
			citem.m.ConditionMax = this.Math.floor(helm.m.ConditionMax);
			citem.m.Condition = helm.m.Condition;
			citem.m.StaminaModifier = helm.m.StaminaModifier;
			citem.m.ItemType = helm.m.ItemType;
			_actor.getItems().unequip(helm);
			this.World.Assets.getStash().remove(helm);
			_actor.getItems().equip(citem);
			return true;
		}
	}

	function onSerialize( _out )
	{
		this.item.onSerialize(_out);
		_out.writeBool(this.m.IsUsed);
		_out.writeString(this.m.StoredName);
		_out.writeString(this.m.StoredSprite);
		_out.writeString(this.m.StoredSpriteDamaged);
		_out.writeString(this.m.StoredSpriteCorpse);
		_out.writeString(this.m.StoredIcon);		
		_out.writeBool(this.m.StoredShowOnCharacter);
		_out.writeBool(this.m.StoredHideCharacterHead);
		_out.writeBool(this.m.StoredHideHair);
		_out.writeBool(this.m.StoredHideBeard);
		_out.writeBool(this.m.StoredReplaceSprite);
		_out.writeI32(this.m.StoredVision);

	}

	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);
		this.m.IsUsed = _in.readBool();
		this.m.StoredName = _in.readString();
		this.m.StoredSprite = _in.readString();
		this.m.StoredSpriteDamaged = _in.readString();
		this.m.StoredSpriteCorpse = _in.readString();
		this.m.StoredIcon = _in.readString();
		this.m.StoredShowOnCharacter = _in.readBool();
		this.m.StoredHideCharacterHead = _in.readBool();
		this.m.StoredHideHair = _in.readBool();
		this.m.StoredHideBeard = _in.readBool();
		this.m.StoredReplaceSprite = _in.readBool();
		this.m.StoredVision = _in.readI32();
		this.updateIcon();
	}
});