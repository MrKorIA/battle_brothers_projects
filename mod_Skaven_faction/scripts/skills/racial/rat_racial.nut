this.rat_racial <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "racial.rat";
		this.m.Name = "Крысиная кровь";
		this.m.Description = "Крысиная кровь";
		this.m.Icon = "";
		this.m.SoundOnUse = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav"
		];
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_attacker == null || !_attacker.isAlive())
		{
			return;
		}

		if (_attacker.getTile().getDistanceTo(this.getContainer().getActor().getTile()) > 1)
		{
			return;
		}

        local isArmor = _attacker.getArmor(this.Const.BodyPart.Body) > 10
        if (isArmor) isArmor = _attacker.getArmor(this.Const.BodyPart.Head) > 10
		if (_attacker.getFlags().has("rat") || isArmor)
		{
			return;
		}

		if (_attacker.getCurrentProperties().IsImmuneToPlague )
		{
			return;
		}

		this.spawnIcon("rat_status_effect_01", _attacker.getTile());
		_attacker.getSkills().add(this.new("scripts/skills/effects/rat_plague_effect"));

	}
});

