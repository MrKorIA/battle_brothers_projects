this.vp_vestal_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.vp_vestal_armor";
		this.m.Name = "Броня защитницы света";
		this.m.Description = "Тяжёлая броня идеально подогнанная на женское тело. Мужчине облачиться в неё невозможно.";
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 1000;
		this.m.Condition = 280;
		this.m.ConditionMax = 280;
		this.m.StaminaModifier = -28;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "vestal_body_armor_" + variant;
		this.m.SpriteDamaged = "vestal_body_armor_" + variant + "_damaged";
		this.m.SpriteCorpse = "vestal_body_armor_" + variant + "_dead";
		this.m.IconLarge = "armor/vestal_body_armor_" + variant + "_L.png";
		this.m.Icon = "armor/vestal_body_armor_" + variant + ".png";
	}

	function getTooltip()
	{
		local result = this.armor.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]Эта броня недоступна мужским персонажам[/color]"
		});
		return result;
	}

	// Women only: the sprites are fitted to a female body. The vestal background herself is
	// always allowed. The actual refusal happens in the item_container equip hook
	// (mod_vanilla_plus/hooks/items/item_container.nut), so the ban is enforced everywhere -
	// inventory screen, tactical swaps and AI alike.
	function isForbiddenFor( _actor )
	{
		if (_actor.getSkills().hasSkill("vp.vestal.background"))
		{
			return false;
		}
		local body_brush = _actor.getSprite("body").getBrush().Name;
		return body_brush != "bust_naked_body_7869" && body_brush != "bust_naked_body_7870" && body_brush.find("bust_female_") == null;
	}

});

