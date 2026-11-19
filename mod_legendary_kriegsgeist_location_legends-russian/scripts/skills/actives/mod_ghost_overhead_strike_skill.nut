this.mod_ghost_overhead_strike_skill <- ::inherit("scripts/skills/skill", {
	m = {
		StunChance = 0,
		GhostSound = []
	},
	function setStunChance( _c )
	{
		this.m.StunChance = _c;
	}

	function setGhostSound( _s )
	{
		this.m.GhostSound = _s;
	}

	function create()
	{
		this.m.ID = "actives.overhead_strike";
		this.m.Name = "Удар с размаха";
		this.m.Description = "Диагональный удар с размаха, использующий всю силу для нанесения наибольшего ущерба.";
		this.m.Icon = "skills/active_152.png";
		this.m.IconDisabled = "skills/active_20_sw.png";
		this.m.Overlay = "active_152";
		this.m.SoundOnUse = [
			"sounds/combat/overhead_strike_01.wav",
			"sounds/combat/overhead_strike_02.wav",
			"sounds/combat/overhead_strike_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc6/skull_death_01.wav",
			"sounds/enemies/dlc6/skull_death_02.wav",
			"sounds/enemies/dlc6/skull_death_03.wav",
			"sounds/enemies/dlc6/skull_death_04.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = false;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = ::Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = ::Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 99;
		this.m.ChanceDisembowel = 50;
		this.m.ChanceSmash = 0;
	}

	function addResources()
	{
		this.skill.addResources();

		foreach( r in this.m.GhostSound )
		{
			::Tactical.addResource(r);
		}
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();

		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = this.getContainer().getActor().getSkills().hasSkill("perk.mastery.sword") ? "[color=" + ::Const.UI.Color.PositiveValue  + "]+10%[/color] к шансу на попадание, благодаря специализации на мечах" : "[color=" + ::Const.UI.Color.PositiveValue  + "]+5%[/color] к шансу на попадание"
		});

		if (this.m.StunChance != 0)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Шанс [color=" + ::Const.UI.Color.PositiveValue + "]" + this.m.StunChance + "%[/color] оглушить цель при попадании"
			});
		}

		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Полностью игнорирует броню"
		});

		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInSwords ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function targetIsGhost( _target )
	{
		if (_target.getFlags().has("ghost_boss")) return false;

		if (_target.getSkills().hasSkill("racial.ghost")) return true;

//		if (_target.getType() == ::Const.EntityType.LegendDemonHound) return true;

		return false;
	}

	function killGhost( _user, _target )
	{
		::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " побеждает противника " + ::Const.UI.getColorizedEntityName(_target));

		if (typeof _user == "instance")
		{
			_user = _user.get();
		}

		if (this.m.SoundOnHit.len() != 0)
		{
			::Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], ::Const.Sound.Volume.Skill * this.m.SoundVolume, _target.getPos());
		}

		_target.kill(_user, this);
		return true;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, ::Const.Tactical.AttackEffectBash);
		local target = _targetTile.getEntity();

		if (this.targetIsGhost(target))
		{
			return this.killGhost(_user, target);
		}

		local success = this.attackEntity(_user, target);

		if (!_user.isAlive() || _user.isDying())
		{
			return success;
		}

		if (success && _targetTile.IsOccupiedByActor && ::Math.rand(1, 100) <= this.m.StunChance && !target.getCurrentProperties().IsImmuneToStun && !target.getSkills().hasSkill("effects.stunned"))
		{
			target.getSkills().add(::new("scripts/skills/effects/stunned_effect"));

			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " оглушает противника " + ::Const.UI.getColorizedEntityName(target) + " на один ход");
			}
		}

		return success;
	}

	function getHitchance( _targetEntity )
	{
		if (!_targetEntity.isAttackable() && !_targetEntity.isRock() && !_targetEntity.isTree() && !_targetEntity.isBush() && !_targetEntity.isSupplies())
		{
			return 0;
		}

		if (this.targetIsGhost(_targetEntity))
		{
			return 100;
		}

		return this.skill.getHitchance(_targetEntity);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.MeleeSkill += 5;
			_properties.DamageRegularMin += 10;
			_properties.DamageRegularMax += 20;
			_properties.DamageArmorMult *= 0.0;
			_properties.IsIgnoringArmorOnAttack = true;

			if (this.getContainer().getActor().getSkills().hasSkill("perk.mastery.sword"))
			{
				_properties.MeleeSkill += 5;
			}
		}
	}

});

