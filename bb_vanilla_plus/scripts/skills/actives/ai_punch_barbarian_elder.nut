this.ai_punch_barbarian_elder <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.horrific_scream";
		this.m.Name = "Barbarian Savage Magic";
		this.m.Description = "";
		this.m.Overlay = "active_176";
		this.m.SoundOnUse = [
			"sounds/combat/rage_01.wav",
			"sounds/combat/rage_02.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 2;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 4;
	}

	function isUsable()
	{
		return !this.Tactical.isActive() || this.skill.isUsable() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}

	function onUse( _user, _targetTile )
	{
		local targets = this.Tactical.Entities.getInstancesOfFaction(_targetTile.getEntity().getFaction());
		local aa = [];
		local r = 10;
		foreach( a in targets )
		{
			if (a.isAlive() && !a.isAlliedWith(_user))
			{
				if (a.getCurrentProperties().MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] >= 1000.0)
				{
					continue;
				}
				aa.push(a);
			}
		}
		aa = aa[this.Math.rand(0, aa.len() - 1)];
		local t = aa.getTile();
		this.Tactical.spawnSpriteEffect("effect_skull_03", this.createColor("#ffffff"), t, 0, 40, 1.0, 0.25, 0, 400, 300);
		aa.checkMorale(-1, -15, this.Const.MoraleCheckType.MentalAttack);
		if (!aa.checkMorale(0, -5, this.Const.MoraleCheckType.MentalAttack) && !aa.getCurrentProperties().IsStunned && !aa.getCurrentProperties().IsImmuneToStun)
		{
			aa.getSkills().add(this.new("scripts/skills/effects/horrified_effect"));
			r = 20;
		}
		if (!aa.getCurrentProperties().IsImmuneToBleeding)
		{
			local e = this.new("scripts/skills/effects/bleeding_effect");
			e.setDamage(r);
			aa.getSkills().add(e);
			this.Sound.play("sounds/combat/cleave_hit_hitpoints_01.wav", 1.0, aa.getPos());
			this.spawnAttackEffect(t, this.Const.Tactical.AttackEffectClaws);
			this.spawnAttackEffect(t, this.Const.Tactical.AttackEffectClaws);
			this.spawnAttackEffect(t, this.Const.Tactical.AttackEffectSlash);
			this.spawnAttackEffect(t, this.Const.Tactical.AttackEffectBash);
			this.spawnAttackEffect(t, this.Const.Tactical.AttackEffectChop);
		}
		if (!aa.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(aa) + " is hexed by savage magic");
		}
		local xsk = this.new("scripts/skills/effects/ai_weak_effect");
		xsk.m.TurnsBase = 2;
		for( local i = 0; i < r; i = ++i )
		{
			aa.getSkills().add(xsk);
		}
		xsk = this.new("scripts/skills/actives/ai_fakebuff");
		xsk.m.Overlay = "";
		aa.getSkills().add(xsk);
	}

});

