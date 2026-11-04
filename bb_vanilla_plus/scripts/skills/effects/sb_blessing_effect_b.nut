this.sb_blessing_effect_b <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.sb_blessing_effect_b";
		this.m.Name = "Благословение";
		this.m.Description = "В следующий раз получите на [color=" + this.Const.UI.Color.PositiveValue + "]30%[/color] меньше урона.";
		this.m.Icon = "skills/status_effect_73.png";
		this.m.IconMini = "status_effect_73_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onUpdate( _properties )
	{
		_properties.DamageReceivedTotalMult *= 0.7;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		this.removeSelf();
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		this.Tactical.spawnSpriteEffect("bust_frozen", this.createColor("#ffff00"), this.getContainer().getActor().getTile(), 0, 0, 1.2, 1.2, 0, 400, 300);
	}

});

