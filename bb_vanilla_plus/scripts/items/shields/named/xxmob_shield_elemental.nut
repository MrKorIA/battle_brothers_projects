this.xxmob_shield_elemental <- this.inherit("scripts/items/shields/named/named_shield", {
	m = {},
	function create()
	{
		this.named_shield.create();
		this.updateVariant();
		this.m.ID = "shield.xxmob_shield_elemental";
		this.m.Name = "Щит Дуллахана";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = false;
		this.m.Value = 0;
		this.m.MeleeDefense = 25;
		this.m.RangedDefense = 15;
		this.m.StaminaModifier = 0;
		this.m.Condition = 70;
		this.m.ConditionMax = 70;
		this.m.SoundOnHit = this.Const.Sound.ShieldHitMetal;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.Sprite = "xxshield_1";
		this.m.SpriteDamaged = "xxshield_1_damaged";
		this.m.ShieldDecal = "";
		this.m.IconLarge = "shields/inventory_legendary_shield_01.png";
		this.m.Icon = "shields/icon_legendary_shield_01.png";
	}

	function onUpdateProperties( _properties )
	{
		this.named_shield.onUpdateProperties(_properties);
		_properties.MeleeSkill += 5;
		_properties.DamageTotalMult += 0.2;
		_properties.DamageReceivedTotalMult *= 0.5;
	}

	function onEquip()
	{
		this.named_shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
		this.addSkill(this.new("scripts/skills/perks/perk_head_hunter"));
		this.addSkill(this.new("scripts/skills/perks/perk_underdog"));
		this.addSkill(this.new("scripts/skills/perks/perk_nine_lives"));
	}

	function onShieldHit( _attacker, _skill )
	{
		if (_attacker != null && _attacker.isAlive() && !_attacker.isDying())
		{
			_attacker.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
		}
	}

});

