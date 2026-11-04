this.xxsc_armor_out <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.xxsc_armor_out";
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
		this.m.ShowOnCharacter = true;
		this.m.VariantString = "body";
		this.m.Variant = 32;
		this.m.Sprite = "";
		this.m.SpriteDamaged = "";
		this.m.SpriteCorpse = "";
		this.m.IconLarge = "armor/inventory_xxinviarmor_L.png";
		this.m.Icon = "armor/inventory_xxinviarmor.png";
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.JesterImpact;
		this.m.Value = 100;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.StaminaModifier = -20;
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
			this.m.StaminaModifier = this.Math.rand(-40, -10);
			this.m.Condition = this.Math.rand(100, 400);
		}
		else
		{
			this.m.StaminaModifier = this.Math.rand(-40, -20);
			this.m.Condition = this.Math.rand(100, 350);
		}
		this.m.ConditionMax = this.m.Condition;
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
		_out.writeF32(this.m.Condition);
		_out.writeF32(this.m.ConditionMax);
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

