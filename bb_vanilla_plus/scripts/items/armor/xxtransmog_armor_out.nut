this.xxtransmog_armor_out <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.xxtransmog_armor_out";
		this.m.Name = "Trasmog Armor";
		this.m.Description = "Shape change has been applied.";
		this.m.ShowOnCharacter = true;
		this.m.VariantString = "body";
		this.m.Variant = 12;
		this.m.Sprite = "bust_body_12";
		this.m.SpriteDamaged = "bust_body_12_damaged";
		this.m.SpriteCorpse = "bust_body_12_dead";
		this.m.IconLarge = "armor/inventory_body_armor_12.png";
		this.m.Icon = "armor/icon_body_armor_12.png";
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Value = 1;
		this.m.Condition = 10;
		this.m.ConditionMax = 10;
		this.m.StaminaModifier = -20;
	}

	function updateVariant()
	{
	}

	function onSerialize( _out )
	{
		if (this.m.Upgrade != null)
		{
			_out.writeI32(this.m.Upgrade.ClassNameHash);
			this.m.Upgrade.onSerialize(_out);
		}
		else
		{
			_out.writeI32(0);
		}
		this.item.onSerialize(_out);
		_out.writeString(this.m.Name);
		_out.writeString(this.m.Description);
		_out.writeU32(this.m.ItemType);
		_out.writeBool(this.m.ShowOnCharacter);
		_out.writeF32(this.m.ConditionMax);
		_out.writeF32(this.m.Condition);
		_out.writeI32(this.m.StaminaModifier);
		_out.writeString(this.m.Sprite);
		_out.writeString(this.m.SpriteDamaged);
		_out.writeString(this.m.SpriteCorpse);
		_out.writeString(this.m.IconLarge);
		_out.writeString(this.m.Icon);
	}

	function onDeserialize( _in )
	{
		local upgrade = _in.readI32();
		if (upgrade != 0)
		{
			this.m.Upgrade = this.new(this.IO.scriptFilenameByHash(upgrade));
			this.m.Upgrade.setArmor(this);
			this.m.Upgrade.onDeserialize(_in);
		}
		this.item.onDeserialize(_in);
		this.m.Name = _in.readString();
		this.m.Description = _in.readString();
		this.m.ItemType = _in.readU32();
		this.m.ShowOnCharacter = _in.readBool();
		this.m.Condition = _in.readF32();
		this.m.ConditionMax = _in.readF32();
		this.m.StaminaModifier = _in.readI32();
		this.m.Sprite = _in.readString();
		this.m.SpriteDamaged = _in.readString();
		this.m.SpriteCorpse = _in.readString();
		this.m.IconLarge = _in.readString();
		this.m.Icon = _in.readString();
	}

});

