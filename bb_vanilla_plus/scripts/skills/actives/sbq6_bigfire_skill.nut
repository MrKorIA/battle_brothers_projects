this.sbq6_bigfire_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 1
	},
	function create()
	{
		this.m.ID = "actives.sbq6_bigfire_skill";
		this.m.Name = "Армагеддон";
		this.m.Description = "Наносит урон всем союзникам и врагам, включая читателя заклинания. После применения этого навыка заклинатель не сможете действовать 4 хода. Этот навык можно использовать только во время ближнего боя.";
		this.m.Icon = "ui/xx80.png";
		this.m.IconDisabled = "ui/xx80_sw.png";
		this.m.Overlay = "status_effect_116";
		this.m.SoundOnUse = [
			"sounds/enemies/lindwurm_tail_slam_hit_01.wav",
			"sounds/enemies/lindwurm_tail_slam_hit_02.wav",
			"sounds/enemies/lindwurm_tail_slam_hit_03.wav",
			"sounds/enemies/lindwurm_tail_slam_hit_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsAttack = true;
		this.m.ActionPointCost = 9;
		this.m.FatigueCost = 35;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Урон: [color=" + this.Const.UI.Color.PositiveValue + "]20 ~ 50[/color] (150% Урон броне)"
		});
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Цель с навыком \'Держи себя в руках!\': имеет 70% шанс не получить урон от этого навыка"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Может быть использованно [color=#8f1e1e]" + this.m.Skillcharge + "[/color] раз в этой битве"
		});
		if (this.Tactical.isActive() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Этот навык можно использовать только во время ближнего боя.[/color]"
			});
		}
		return ret;
	}

	function applyDamage( _attacker, _target, _hitInfo, _hitchance )
	{
		if (!_target.isAlive())
		{
			return;
		}
		if (this.Math.rand(1, 100) <= _hitchance)
		{
			_target.onDamageReceived(_attacker, this, _hitInfo);
		}
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcharge = this.m.Skillcharge - 1;
		local actor = this.getContainer().getActor();
		local hitchance = 66;
		local atile = actor.getTile();
		local tiles = this.fakeAffectedTiles();
		local rantile;
		local dmg = this.Math.rand(20, 50) * (actor.getSkills().hasSkill("perk.hold_out") ? 1.5 : 1.0);
		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = dmg;
		hitInfo.DamageArmor = dmg * 1.5;
		hitInfo.DamageFatigue = 5;
		hitInfo.DamageDirect = 0.5;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		this.Sound.play("sounds/combat/poison_applied_0" + this.Math.rand(1, 2) + ".wav", this.Const.Sound.Volume.Skill * 1.2, atile.Pos);
		this.Tactical.getCamera().quake(this.createVec(0, -1.0), 6.0, 0.16, 0.35);
		foreach( t in tiles )
		{
			for( local i = 0; i < this.Const.Tactical.MortarImpactParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarImpactParticles[i].Brushes, t, this.Const.Tactical.MortarImpactParticles[i].Delay, this.Const.Tactical.MortarImpactParticles[i].Quantity * 0.3, this.Const.Tactical.MortarImpactParticles[i].LifeTimeQuantity * 0.3, this.Const.Tactical.MortarImpactParticles[i].SpawnRate * 0.3, this.Const.Tactical.MortarImpactParticles[i].Stages, this.createVec(0, -30));
			}
		}
		for( local z = 0; z < tiles.len(); z = ++z )
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 0 + (z * this.Math.rand(10, 30)), function ( _skill )
			{
				rantile = tiles.remove(this.Math.rand(0, tiles.len() - 1));
				for( local i = 0; i < this.Const.Tactical.BurnParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarImpactParticles[i].Brushes, rantile, this.Const.Tactical.BurnParticles[i].Delay, this.Const.Tactical.BurnParticles[i].Quantity * 0.8, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity * 0.8, this.Const.Tactical.BurnParticles[i].SpawnRate * 0.8, this.Const.Tactical.BurnParticles[i].Stages, this.createVec(0, -10));
				}
			}.bindenv(this), this);
		}
		local targets = this.Tactical.Entities.getAllInstancesAsArray();
		foreach( target in targets )
		{
			if (actor.isAlive() && target.isAlive() && actor.getID() != target.getID())
			{
				this.applyDamage(actor, target, hitInfo, hitchance);
			}
		}
		local stun = this.new("scripts/skills/effects/ai_stun_effect");
		actor.getSkills().add(stun);
		stun.setTurns(2);
		if (actor.isAlive() && !actor.getSkills().hasSkill("perk.hold_out"))
		{
			this.applyDamage(actor, actor, hitInfo, hitchance);
		}
		return true;
	}

	function fakeAffectedTiles()
	{
		local atile = this.getContainer().getActor().getTile();
		local ret = [
			atile
		];
		local size = this.Tactical.getMapSize();
		for( local x = 0; x < size.X; x = ++x )
		{
			for( local y = 0; y < size.Y; y = ++y )
			{
				if (atile.getDistanceTo(this.Tactical.getTileSquare(x, y)) <= 14 && this.Tactical.getTileSquare(x, y) != atile && this.Math.rand(1, 7) == 1)
				{
					if (atile.getDistanceTo(this.Tactical.getTileSquare(x, y)) >= 7)
					{
						if (this.Math.rand(1, 3) == 1)
						{
							ret.push(this.Tactical.getTileSquare(x, y));
						}
					}
					else
					{
						ret.push(this.Tactical.getTileSquare(x, y));
					}
				}
			}
		}
		return ret;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else if (this.m.Skillcharge <= 0)
		{
			return false;
		}
		else if (!this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			return false;
		}
		return true;
	}

	function isHidden()
	{
		if (this.m.Skillcharge > 0)
		{
			return false;
		}
		return true;
	}

	function onCombatFinished()
	{
		this.m.Skillcharge = 1;
	}

});

