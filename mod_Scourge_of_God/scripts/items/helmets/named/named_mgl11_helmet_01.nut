this.named_mgl11_helmet_01 <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_mgl11_helmet_01";
		this.m.Description = "Через прорези этого шлема мир видится яснее и смелее, словно сам владыка смотрит сквозь них вместе с вами. Экипированный вместе с его доспехом наделяет полной силой наследия.";
		this.m.Name = "Шлем Хана Великой Орды";
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 7000;
		this.m.Condition = 285;
		this.m.ConditionMax = 285;
		this.m.StaminaModifier = -20;
		this.m.Vision = -1;
		this.randomizeValues();
	}

    function onEquip()
    {
       this.named_helmet.onEquip();
       local actor = this.getContainer().getActor();
       if (actor != null && !actor.getSkills().hasSkill("effects.mgl_khan_helmet"))
       {
           actor.getSkills().add(this.new("scripts/skills/effects/mgl_khan_helmet_effect"));
       }
    }

    function onUnequip()
    {
       this.named_helmet.onUnequip();
       local actor = this.getContainer().getActor();
       if (actor != null)
       {
           actor.getSkills().removeByID("effects.mgl_khan_helmet");
       }
    }

    function getTooltip()
    {
        local result = this.helmet.getTooltip();
        result.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] к инициативе"
			},
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
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]+1[/color] к стражам охраняющим благополучие владельца доспехов"
            }
        ]);
        return result;
    }

    function updateVariant()
    {
        local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
        this.m.Sprite = "bust_helmet_mgl11_" + variant;
        this.m.SpriteDamaged = "bust_helmet_mgl11_" + variant + "_damaged";
        this.m.SpriteCorpse = "bust_helmet_mgl11_" + variant + "_dead";
        this.m.IconLarge = "";
        this.m.Icon = "helmets/icon_bust_helmet_mgl11_" + variant + ".png";
    }
	
});

