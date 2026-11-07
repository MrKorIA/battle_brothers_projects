this.named_mgl10_armor_01 <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_mgl10_armor_01";
		this.m.Description = "Этот доспех когда-то покоился на плечах степного владыки, чьё имя до сих пор произносят шёпотом. Дух его гвардии ещё хранит присягу — и может явиться на зов, если владелец окажется в беде.";
		this.m.Name = "Доспех Хана Великой Орды.";
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 20000;
		this.m.Condition = 280;
		this.m.ConditionMax = 280;
		this.m.StaminaModifier = -26;
		this.randomizeValues();
	}
    
	function onEquip()
	{
		this.named_armor.onEquip();
		local actor = this.getContainer().getActor();
		if (actor != null && !actor.getSkills().hasSkill("effects.mgl_khan_armor"))
		{
			actor.getSkills().add(this.new("scripts/skills/effects/mgl_khan_armor_effect"));
		}
	}

	function onUnequip()
	{
		this.named_armor.onUnequip();
		local actor = this.getContainer().getActor();
		if (actor != null)
		{
			actor.getSkills().removeByID("effects.mgl_khan_armor");
		}
	}

	function getTooltip()
	{
		local result = this.armor.getTooltip();
		result.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] к решимости"
			},
            {
                id = 15,
                type = "text",
                icon = "ui/icons/special.png",
                text = "При получении урона из любых источников появляется призрачный страж, который будет сражаться на стороне владельца доспехов"
            }]);
		return result;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_body_mgl10_" + variant;
		this.m.SpriteDamaged = "bust_body_mgl10_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_body_mgl10_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_bust_body_mgl10_" + variant + ".png";
		this.m.Icon = "armor/icon_bust_body_mgl10_" + variant + ".png";
	}
	
});

