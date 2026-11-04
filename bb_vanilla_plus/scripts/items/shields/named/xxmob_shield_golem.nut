this.xxmob_shield_golem <- this.inherit("scripts/items/shields/named/named_shield", {
	m = {},
	function create()
	{
		this.named_shield.create();
		this.updateVariant();
		this.m.ID = "shield.xxmob_shield_golem";
		this.m.Name = "Щит Голема";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = false;
		this.m.Value = 0;
		this.m.MeleeDefense = 1;
		this.m.RangedDefense = 1;
		this.m.StaminaModifier = 0;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.SoundOnHit = this.Const.Sound.ShieldHitMetal;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_golem_02";
		this.m.SpriteDamaged = "bust_golem_02";
		this.m.ShieldDecal = "";
		this.m.IconLarge = "shields/inventory_legendary_shield_01.png";
		this.m.Icon = "shields/icon_legendary_shield_01.png";
	}

	function onUpdateProperties( _properties )
	{
		this.named_shield.onUpdateProperties(_properties);
		_properties.DamageReceivedTotalMult *= 0.5;
		if (this.getContainer().getActor().getHitpoints() <= this.getContainer().getActor().getHitpointsMax() * 0.5)
		{
			if (this.m.SoundOnDestroyed.len() != 0)
			{
				this.Sound.play(this.m.SoundOnDestroyed[this.Math.rand(0, this.m.SoundOnDestroyed.len() - 1)], this.Const.Sound.Volume.Skill, this.getContainer().getActor().getPos());
			}
			this.m.Container.unequip(this);
		}
	}

});

