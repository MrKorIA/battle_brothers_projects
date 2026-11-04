this.xxheavyhorse_shield <- this.inherit("scripts/items/shields/shield", {
	m = {},
	function create()
	{
		this.shield.create();
		this.m.ID = "shield.xxheavyhorse_shield";
		this.m.Name = "Бронированная боевая лошадь";
		this.m.Description = "Боевой конь в тяжелых доспехах. Обеспечивает высокую мобильность и боевую мощь, а также отличается прочностью. \n\n+10 к навыку ближнего боя, движение стоит на 1 AP меньше, не вызывает усталости от движения, -10 к защите от дальних атак, этот предмет классифицируется как щит.";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = false;
		this.m.Variant = this.Math.rand(1, 1);
		this.updateVariant();
		this.m.Value = 10000;
		this.m.MeleeDefense = 10;
		this.m.RangedDefense = -10;
		this.m.StaminaModifier = 0;
		this.m.Condition = 55;
		this.m.ConditionMax = 55;
		this.m.SoundOnHit = [
			"sounds/fantasyhorse/fantasyarmorhorse_hurt_01.wav",
			"sounds/fantasyhorse/fantasyarmorhorse_hurt_02.wav",
			"sounds/fantasyhorse/fantasyarmorhorse_hurt_03.wav",
			"sounds/fantasyhorse/fantasyarmorhorse_hurt_04.wav"
		];
		this.m.SoundOnDestroyed = [
			"sounds/fantasyhorse/fantasyhorse_death_01.wav",
			"sounds/fantasyhorse/fantasyhorse_death_02.wav"
		];
	}

	function updateVariant()
	{
		this.m.Sprite = "xxheavyhorse_" + this.m.Variant;
		this.m.SpriteDamaged = "xxheavyhorse_" + this.m.Variant + "_damaged";
		this.m.ShieldDecal = "";
		this.m.IconLarge = "shields/inventory_xxheavyhorse_shield_" + this.m.Variant + ".png";
		this.m.Icon = "shields/icon_xxheavyhorse_shield_" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/xxitem_horse_skill"));
		this.addSkill(this.new("scripts/skills/actives/xxitem_horseaa_skill"));
		local actor = this.getContainer().getActor();
		if (actor.getSkills().hasSkill("effects.sb_wolfride_effect"))
		{
			actor.getSkills().removeByID("effects.sb_wolfride_effect");
		}
		if (this.getContainer().getActor().isAlliedWithPlayer())
		{
			this.getContainer().getActor().setSpriteOffset("arms_icon", this.createVec(-15, 0));
		}
		else
		{
			this.getContainer().getActor().setSpriteOffset("arms_icon", this.createVec(15, 0));
		}
		this.getContainer().getActor().setAlwaysApplySpriteOffset(true);
	}

	function onUnequip()
	{
		this.item.onUnequip();
		if (this.m.ShowOnCharacter)
		{
			local app = this.getContainer().getAppearance();
			app.Shield = "";
			app.RaiseShield = false;
			this.getContainer().updateAppearance();
		}
		this.getContainer().getActor().setSpriteOffset("arms_icon", this.createVec(0, 0));
		this.getContainer().getActor().setAlwaysApplySpriteOffset(false);
	}

	function onUpdateProperties( _properties )
	{
		this.shield.onUpdateProperties(_properties);
		_properties.MeleeSkill += 10;
		_properties.MovementAPCostAdditional -= 1;
		_properties.MovementFatigueCostMult *= 0;
	}

});

