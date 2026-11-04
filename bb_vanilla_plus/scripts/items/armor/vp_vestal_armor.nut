this.vp_vestal_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.vp_vestal_armor";
		this.m.Name = "Броня защитницы света";
		this.m.Description = "Тяжёлая броня идеально подогнанная на женское тело. Мужчине облачиться в неё невозможно.";
		this.m.Variant = 00;
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
		local variant = this.m.Variant
		this.m.Sprite = "vestal_body_armor";
		this.m.SpriteDamaged = "vestal_body_armor_damaged";
		this.m.SpriteCorpse = "vestal_body_armor_dead";
		this.m.IconLarge = "armor/vestal_body_armor_L.png";
		this.m.Icon = "armor/vestal_body_armor.png";
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

	function onEquip()
	{
//		local actor = this.getContainer().getActor();
        this.armor.onEquip();
        local actor = this.getContainer().getActor();
        if (!actor.getSkills().hasSkill("vp.vestal.background"))
        {
            local body_brush = actor.getSprite("body").getBrush().Name
            if (body_brush != "bust_naked_body_7869" && body_brush != "bust_naked_body_7870" && body_brush.find("bust_female_") == null)
            {
                this.armor.onUnequip();
                this.World.Assets.getStash().makeEmptySlots(1);
                this.World.Assets.getStash().add(this);
            }

        }
	}

});

