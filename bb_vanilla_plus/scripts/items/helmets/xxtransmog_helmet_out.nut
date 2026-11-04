this.xxtransmog_helmet_out <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.xxtransmog_helmet_out";
		this.m.Name = "Trasmog Helmet";
		this.m.Description = "Shape change has been applied.";
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
		this.m.Condition = 10;
		this.m.ConditionMax = 10;
		this.m.StaminaModifier = -20;
		this.m.Vision = -3;
	}

	function updateVariant()
	{
	}

	function onSerialize( _out )
	{
		this.item.onSerialize(_out);
		_out.writeString(this.m.Name);
		_out.writeString(this.m.Description);
		_out.writeU32(this.m.ItemType);
		_out.writeF32(this.m.Condition);
		_out.writeF32(this.m.ConditionMax);
		_out.writeI32(this.m.StaminaModifier);
		_out.writeI32(this.m.Vision);
		_out.writeBool(this.m.HideHair);
		_out.writeBool(this.m.HideBeard);
		_out.writeString(this.m.Sprite);
		_out.writeString(this.m.SpriteDamaged);
		_out.writeString(this.m.SpriteCorpse);
		_out.writeString(this.m.Icon);
	}

	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);
		this.m.Name = _in.readString();
		this.m.Description = _in.readString();
		this.m.ItemType = _in.readU32();
		this.m.Condition = _in.readF32();
		this.m.ConditionMax = _in.readF32();
		this.m.StaminaModifier = _in.readI32();
		this.m.Vision = _in.readI32();
		this.m.HideHair = _in.readBool();
		this.m.HideBeard = _in.readBool();
		this.m.Sprite = _in.readString();
		this.m.SpriteDamaged = _in.readString();
		this.m.SpriteCorpse = _in.readString();
		this.m.Icon = _in.readString();
	}

});

