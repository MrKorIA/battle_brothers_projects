this.paladin_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.hackflows_paladin_helmet";
		this.m.Name = "Полный шлем паладина";
		this.m.Description = "";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.HideCharacterHead = true;
		this.m.HideCorpseHead = true;
		this.m.IsIndestructible = true;
		this.m.Variant = 1001;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 15000;
		this.m.Condition = 350.0;
		this.m.ConditionMax = 350.0;
		this.m.StaminaModifier = -18;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
	}

	function getTooltip()
	{
		local result = this.helmet.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Утраивает Решимость при защите от способностей, вызывающих страх и контроль сознания"
		});
		return result;
	}

	function updateVariant()
	{
		this.m.Sprite = "paladin_helmet";
		this.m.SpriteDamaged = "paladin_helmet_damaged";
		this.m.SpriteCorpse = "paladin_helmet_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/paladin_helmet_stash.png";
	}

	function onUpdateProperties( _properties )
	{
		this.helmet.onUpdateProperties(_properties);
		_properties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] *= 3.0;
	}

});

