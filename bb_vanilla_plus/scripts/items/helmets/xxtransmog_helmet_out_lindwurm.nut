this.xxtransmog_helmet_out_lindwurm <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.lindwurm_helmet";
		this.m.Name = "Lindwurm Mask";
		this.m.Description = "This helmet must have once belonged to a daring and skilled hunter for it is covered in the scales of a dreaded Lindwurm. Not only do the scales deflect blows and hits, but they also remain unscathed by the acidic Lindwurm blood.";
		this.m.ShowOnCharacter = true;
		this.m.HideCharacterHead = false;
		this.m.HideHair = false;
		this.m.HideBeard = false;
		this.m.ReplaceSprite = false;
		this.m.VariantString = "helmet";
		this.m.Variant = 35;
		this.m.Sprite = "bust_helmet_35";
		this.m.SpriteDamaged = "bust_helmet_35_damaged";
		this.m.SpriteCorpse = "bust_helmet_35_dead";
		this.m.Icon = "helmets/inventory_helmet_35.png";
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Value = 1;
		this.m.Condition = 280;
		this.m.ConditionMax = 280;
		this.m.StaminaModifier = -20;
		this.m.Vision = -2;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Named;
	}

	function getTooltip()
	{
		local result = this.helmet.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Unaffected by acidic Lindwurm blood"
		});
		return result;
	}

	function onEquip()
	{
		this.helmet.onEquip();
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			this.m.Container.getActor().getFlags().add("head_immune_to_acid");
		}
	}

	function onUnequip()
	{
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			this.m.Container.getActor().getFlags().remove("head_immune_to_acid");
		}

		this.helmet.onUnequip();
	}

	function updateVariant()
	{
	}

	function onSerialize( _out )
	{
		this.item.onSerialize(_out);
		_out.writeF32(this.m.Condition);
		_out.writeF32(this.m.ConditionMax);
		_out.writeI32(this.m.StaminaModifier);
		_out.writeString(this.m.Sprite);
		_out.writeString(this.m.SpriteDamaged);
		_out.writeString(this.m.SpriteCorpse);
		_out.writeString(this.m.Icon);
	}

	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);
		this.m.Condition = _in.readF32();
		this.m.ConditionMax = _in.readF32();
		this.m.StaminaModifier = _in.readI32();
		this.m.Sprite = _in.readString();
		this.m.SpriteDamaged = _in.readString();
		this.m.SpriteCorpse = _in.readString();
		this.m.Icon = _in.readString();
	}

});

