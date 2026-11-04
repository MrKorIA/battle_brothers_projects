this.paladin_chestplate <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.hackflows_paladin_chestplate";
		this.m.Name = "Нагрудник паладина";
		this.m.Description = "Величественный нагрудник с прикреплённым тёмно-синим плащом. Владелец чувствует тёплое благословение старых богов, закаляющее его дух и дарующее ему стойкость даже в самые трудные времена.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 10000;
		this.m.Condition = 380;
		this.m.ConditionMax = 380;
		this.m.StaminaModifier = -28;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
	}

	function getTooltip()
	{
		local result = this.armor.getTooltip();
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Боевой дух владельца всегда будет \'уверенный\' в начале его хода."
		});
		return result;
	}

	function updateVariant()
	{
		this.m.Sprite = "paladin_chestplate";
		this.m.SpriteDamaged = "paladin_chestplate_damaged";
		this.m.SpriteCorpse = "paladin_chestplate_dead";
		this.m.IconLarge = "armor/paladin_chestplate.png";
		this.m.Icon = "armor/paladin_chestplate_stash.png";
	}

	function onMovementFinished()
	{
		local actor = this.getContainer().getActor();
		local allies = this.Tactical.Entities.getInstancesOfFaction(actor.getFaction());

		foreach( ally in allies )
		{
			if (ally.getID() != actor.getID())
			{
				ally.getSkills().update();
			}
		}
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		actor.setMoraleState(this.Const.MoraleState.Confident);
	}

});

