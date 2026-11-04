this.legend_prepare_bullet_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.legend_prepare_bullet";
		this.m.Name = "Готовность к выстрелу";
//		::Legends.Effects.onCreate(this, ::Legends.Effect.LegendPrepareBullet);
		this.m.Description = "Этот персонаж готовит выстрел из пращи, увеличивая скорость и урон снаряда.";
		this.m.Icon = "ui/perks/perk_slinger_spins.png";
		this.m.IconMini = "slinger_spins_mini";
		this.m.Overlay = "slinger_spins_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsHidden = false;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.getBonus() + "[/color] к урону в дальнем бою"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + this.getBonus() + "%[/color] к пробитию брони"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+1[/color] к дальности броска"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "Смена оружия или получение урона снимут этот эффект."
			}
		];
		return ret;
	}

	function getBonus()
	{
		return this.getContainer().getActor().getCurrentProperties().Initiative * 0.1;
	}

	function onUpdate( _properties )
	{
		local weapon = this.getContainer().getActor().getMainhandItem();
		if (weapon == null)
			this.removeSelf();
			return;
		if (!(weapon.isWeaponType(this.Const.Items.WeaponType.Sling) && weapon.isItemType(this.Const.Items.ItemType.OneHanded)))
			this.removeSelf();
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.removeSelf();
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		this.removeSelf();
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		this.removeSelf();
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
//		if (_skill.isGarbage() || _skill.getID() != ::Legends.Actives.getID(::Legends.Active.SlingStone))
		if (_skill.isGarbage() || _skill.getID() != this.m.ID)
			return;
		local bonus = this.getBonus();
		_properties.DamageRegularMin += bonus;
		_properties.DamageRegularMax += bonus;
		_properties.DamageDirectAdd += bonus * 0.01;
	}
});
