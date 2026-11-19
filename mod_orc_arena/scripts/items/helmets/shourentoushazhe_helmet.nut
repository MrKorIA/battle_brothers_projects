this.shourentoushazhe_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.shourentoushazhe_helmet";
		this.m.Name = "Шлем мастера окров";
		this.m.Description = "Шлем, который носит хозяин орской арены и наставник орков. Вы сможете получить это сокровище, только одолев его в бою. Увеличивает наносимый оркам урон на 10% в сражениях против них.";
		this.m.ShowOnCharacter = true;
		this.m.HideCharacterHead = false;
		this.m.HideCorpseHead = false;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.IsDroppedAsLoot = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 2000;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -18;
		this.m.Vision = -2;
	}


	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_jingjichang_helmet_" + variant;
		this.m.SpriteDamaged = "bust_jingjichang_helmet_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_jingjichang_helmet_" + variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/icon_bust_jingjichang_helmet_" + variant + ".png";
	}
	
	function onUpdateProperties( _properties )
	{   
	   
	    this.helmet.onUpdateProperties(_properties);
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			return;
		}

		if (this.Tactical.Entities.getInstancesNum(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID()) != 0 || this.Tactical.Entities.getInstancesNum(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getID()) != 0)
		{
			_properties.DamageTotalMult *= 1.1;
			_properties.TargetAttractionMult *= 1.1;
		}
	}
	
});

