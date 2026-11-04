this.xxsc_helmet_outz <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.xxsc_helmet_outz";
		this.m.NameList = [
			"Avenger",
			"Ancestor",
			"Basilisk",
			"Cockatrice",
			"Gorgon",
			"Griffin",
			"Phoenix",
			"Pegasus",
			"Sasquatch",
			"Yeti",
			"Best Friend",
			"Buddy",
			"Bastion",
			"Defender",
			"Doppelganger",
			"Keeper",
			"Tutelary",
			"Dominator",
			"Warden",
			"Guardian",
			"Protector",
			"Safeguard",
			"Spirit",
			"Shapechanger",
			"Legacy",
			"Peacekeeper",
			"Overseer",
			"Overlord",
			"Sage",
			"Tyrant",
			"Great One",
			"Old One",
			"Elderguard",
			"Invincible",
			"Unbeatable",
			"Preserver",
			"Savior",
			"Familiar",
			"Eternal Life",
			"Saver",
			"Redeemer",
			"Supreme Guard",
			"Unique Guard"
		];
		this.m.Description = "Shape change has been applied.";
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.VariantString = "";
		this.m.Variant = 35;
		this.m.Sprite = "bust_helmet_35";
		this.m.SpriteDamaged = "bust_helmet_35_damaged";
		this.m.SpriteCorpse = "bust_helmet_35_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/inventory_helmet_35.png";
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.JesterImpact;
		this.m.Value = 100;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.StaminaModifier = -20;
		this.m.Vision = -3;
		this.m.UseRandomName = true;
		this.xxnameditem();
	}

	function updateVariant()
	{
	}

	function xxnameditem()
	{
		if (this.Math.rand(0, 2) == 2)
		{
			this.m.Vision = this.Math.rand(-3, 0);
			this.m.StaminaModifier = this.Math.rand(-20, -5);
			this.m.Condition = this.Math.rand(100, 400);
		}
		else
		{
			this.m.Vision = -3;
			this.m.StaminaModifier = this.Math.rand(-20, -10);
			this.m.Condition = this.Math.rand(100, 350);
		}
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

