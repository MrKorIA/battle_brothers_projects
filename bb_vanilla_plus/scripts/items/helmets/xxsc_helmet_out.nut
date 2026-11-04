this.xxsc_helmet_out <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.xxsc_helmet_out";
		this.m.NameList = [
			"Paragon",
			"Avenger",
			"Ancestor",
			"Immortal",
			"Giant",
			"Yeti",
			"Buddy",
			"Bastion",
			"Defender",
			"Keeper",
			"Conqueror",
			"Dominator",
			"Warden",
			"Guardian",
			"Protector",
			"Overseer",
			"Overlord",
			"Sage",
			"Tyrant",
			"Elder",
			"Invincible",
			"Unbeatable",
			"Preserver",
			"Saver"
		];
		this.m.Description = "The outward appearance of this item is but a magically woven illusion. its true value is decided only by the whims of fate.";
		this.m.ShowOnCharacter = false;
		this.m.ReplaceSprite = false;
		this.m.HideCharacterHead = false;
		this.m.HideHair = false;
		this.m.HideBeard = false;
		this.m.VariantString = "helmet";
		this.m.Variant = 32;
		this.m.Sprite = "";
		this.m.SpriteDamaged = "";
		this.m.SpriteCorpse = "";
		this.m.Icon = "helmets/inventory_xxinvihat.png";
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

	function updateVariant()
	{
	}

	function onSerialize( _out )
	{
		this.item.onSerialize(_out);
		_out.writeString(this.m.Name);
		_out.writeF32(this.m.Condition);
		_out.writeF32(this.m.ConditionMax);
		_out.writeI32(this.m.StaminaModifier);
		_out.writeI32(this.m.Vision);
		_out.writeBool(this.m.ShowOnCharacter);
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
		this.m.Condition = _in.readF32();
		this.m.ConditionMax = _in.readF32();
		this.m.StaminaModifier = _in.readI32();
		this.m.Vision = _in.readI32();
		this.m.ShowOnCharacter = _in.readBool();
		this.m.HideHair = _in.readBool();
		this.m.HideBeard = _in.readBool();
		this.m.Sprite = _in.readString();
		this.m.SpriteDamaged = _in.readString();
		this.m.SpriteCorpse = _in.readString();
		this.m.Icon = _in.readString();
	}

});

