this.xxtransmog_helmet_out_fangshire <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.fangshire";
		this.m.Name = "The Fangshire";
		this.m.Description = "The Fangshire is a northern tiger\'s skull that nestles the faces of men deeply and darkly behind two ferocious fangs. Originally worn by Bjarund the Beastman, a fierce northern raider, it instilled fear into the hearts of his enemies as he went on bloody raids and burned down many a village along the coastline. When Bjarund was finally slain, Fangshire was taken as a trophy and went further south. Rumors proclaim that its wearer\'s eyes glow a sharpened yellow, allowing them to see through the very night.";
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
		this.m.Value = 300;
		this.m.Condition = 60;
		this.m.ConditionMax = 60;
		this.m.StaminaModifier = -5;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
	}

	function getTooltip()
	{
		local result = this.helmet.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Allows the wearer to see at night and negates any penalties due to nighttime."
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.helmet.onUpdateProperties(_properties);
		_properties.IsAffectedByNight = false;
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

