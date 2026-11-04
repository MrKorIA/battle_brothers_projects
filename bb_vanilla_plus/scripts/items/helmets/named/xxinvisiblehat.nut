this.xxinvisiblehat <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.xxinvisiblehat";
		this.m.Name = "Невидимый капюшон";
		this.m.Description = "Это прозрачный капюшон, созданный с помощью древней магии.";
		this.m.ShowOnCharacter = false;
		this.m.HideHair = false;
		this.m.HideBeard = false;
		this.m.VariantString = "helmet_southern_named";
		this.m.Variant = 301;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.JesterImpact;
		this.m.Value = 5000;
		this.m.Condition = 150;
		this.m.ConditionMax = 150;
		this.m.StaminaModifier = 0;
		this.m.UseRandomName = false;
		this.xxnameditem();
	}

	function xxnameditem()
	{
		this.m.Condition = this.Math.rand(150, 300);
		this.m.ConditionMax = this.m.Condition;
	}

	function onSerialize( _out )
	{
		_out.writeString(this.m.Name);
		_out.writeF32(this.m.Condition);
		_out.writeF32(this.m.ConditionMax);
		_out.writeI8(this.m.StaminaModifier);
		_out.writeI8(this.m.Vision);
		_out.writeBool(this.m.HideHair);
		_out.writeBool(this.m.HideBeard);
		_out.writeString(this.m.Sprite);
		_out.writeString(this.m.SpriteDamaged);
		_out.writeString(this.m.SpriteCorpse);
		_out.writeString(this.m.IconLarge);
		_out.writeString(this.m.Icon);
		_out.writeString(this.m.VariantString);
		_out.writeI8(this.m.Variant);
		this.helmet.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.m.Name = _in.readString();
		this.m.Condition = _in.readF32();
		this.m.ConditionMax = _in.readF32();
		this.m.StaminaModifier = _in.readI8();
		this.m.Vision = _in.readI8();
		this.m.HideHair = _in.readBool();
		this.m.HideBeard = _in.readBool();
		this.m.Sprite = _in.readString();
		this.m.SpriteDamaged = _in.readString();
		this.m.SpriteCorpse = _in.readString();
		this.m.IconLarge = _in.readString();
		this.m.Icon = _in.readString();
		this.m.VariantString = _in.readString();
		this.m.Variant = _in.readI8();
		this.helmet.onDeserialize(_in);
		this.updateVariant();
	}

});

