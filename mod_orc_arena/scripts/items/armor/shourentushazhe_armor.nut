this.shourentushazhe_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.shourentushazhe_armor";
		this.m.Name = "Доспехи мясника орков";
		this.m.Description = "После истребления множества орков их головы повешены на пояс, а плечи прикрыты орскими наплечниками. Эта броня особенно эффективна в боях с орками. Увеличивает наносимый оркам урон на 10% в сражениях против них.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 3000;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -24;
	}


	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_body_jingjichang_" + variant;
		this.m.SpriteDamaged = "bust_body_jingjichang_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_body_jingjichang_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_bust_body_jingjichang_" + variant + ".png";
		this.m.Icon = "armor/icon_bust_body_jingjichang_" + variant + ".png";
	}
	
	function onUpdateProperties( _properties )
	{
	    this.armor.onUpdateProperties(_properties);
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