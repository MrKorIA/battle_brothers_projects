this.mod_ghost_split_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.split";
		this.m.Name = "Рассекание";
		this.m.Description = "Размашистый удар, позволяющий атаковать сразу две цели, стоящие друг за другом.";
		this.m.KilledString = "Разрублен надвое";
		this.m.Icon = "skills/active_153.png";
		this.m.IconDisabled = "skills/active_07_sw.png";
		this.m.Overlay = "active_153";
		this.m.SoundOnUse = [
			"sounds/combat/split_01.wav",
			"sounds/combat/split_02.wav",
			"sounds/combat/split_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/ghost_death_01.wav",
			"sounds/enemies/ghost_death_02.wav",
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAOE = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = ::Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = ::Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 50;
		this.m.ChanceDisembowel = 25;
		this.m.ChanceSmash = 0;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();

		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = this.getContainer().getActor().getSkills().hasSkill("perk.mastery.sword") ? "[color=" + ::Const.UI.Color.PositiveValue  + "]+5%[/color] к шансу на попадание, благодаря специализации на мечах" : "[color=" + ::Const.UI.Color.NegativeValue  + "]-5%[/color] к шансу на попадание"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Может поразить до двух целей"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Полностью игнорирует броню"
			}
		]);

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
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], ::Const.Sound.Volume.Skill * this.m.SoundVolume, _target.getPos());
		}

		_target.kill(_user, this);
		return true;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, ::Const.Tactical.AttackEffectSplit);
		local ret = this.targetIsGhost(_targetTile.getEntity()) ? this.killGhost(_user, _targetTile.getEntity()) : this.attackEntity(_user, _targetTile.getEntity());

		if (!_user.isAlive() || _user.isDying())
		{
			return ret;
		}

		local ownTile = _user.getTile();
		local dir = ownTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local forwardTile = _targetTile.getNextTile(dir);

			if (forwardTile.IsOccupiedByActor && forwardTile.getEntity().isAttackable() && ::Math.abs(forwardTile.Level - ownTile.Level) <= 1)
			{
				ret = (this.targetIsGhost(forwardTile.getEntity()) ? this.killGhost(_user, forwardTile.getEntity()) : this.attackEntity(_user, forwardTile.getEntity())) || ret;
			}
		}

		return ret;
	}

	function onTargetSelected( _targetTile )
	{
		::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		local ownTile = this.getContainer().getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local forwardTile = _targetTile.getNextTile(dir);

			if (::Math.abs(forwardTile.Level - ownTile.Level) <= 1)
			{
				::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, forwardTile, forwardTile.Pos.X, forwardTile.Pos.Y);
			}
		}
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
			_properties.DamageArmorMult *= 0.0;
			_properties.IsIgnoringArmorOnAttack = true;

			if (!this.getContainer().getActor().getSkills().hasSkill("perk.mastery.sword")) _properties.MeleeSkill -= 5;
			else _properties.MeleeSkill += 5;
		}
	}

});

