this.cunmin02 <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.cunmin02";
		this.m.Name = "Расчленение";
		this.m.Description = "";
		this.m.KilledString = "Разорван в клочья";
		this.m.Icon = "skills/active_21.png";
		this.m.IconDisabled = "skills/active_21_sw.png";
		this.m.Overlay = "active_21";
		this.m.SoundOnUse = [
			"sounds/enemies/horrific_scream_01.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.1;
		this.m.ActionPointCost = 9;
		this.m.FatigueCost = 40;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 33;
		this.m.ChanceDisembowel = 33;
		this.m.ChanceSmash = 0;
	}

	function getTooltip()
	{
		local p = this.getContainer().getActor().getCurrentProperties();
		return [
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
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 4,
				type = "text",
				icon = "/ui/tooltips/heart.png",
				text = "Наносит [color=" + this.Const.UI.Color.DamageValue + "]" + p.DamageRegularMin + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + p.DamageRegularMax + "[/color] урона"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 25;
		_properties.DamageRegularMax += 40;
		_properties.DamageArmorMult *= 0.75;
		local size = this.getContainer().getActor().getSize();
		this.m.ChanceDecapitate = 25 * size;
		this.m.ChanceDisembowel = 25 * size;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectClaws);
		local target = _targetTile.getEntity();
		local ret = this.attackEntity(_user, target);

		if (this.Tactical.TurnSequenceBar.getActiveEntity().getID() == _user.getID() && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
		{
			this.m.IsDoingAttackMove = false;
			this.getContainer().setBusy(true);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, function ( _skill )
			{
				if (target.isAlive())
				{
					_skill.attackEntity(_user, target);
				}
			}.bindenv(this), this);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 400, function ( _skill )
			{
				if (target.isAlive())
				{
					_skill.attackEntity(_user, target);
				}

				_skill.m.IsDoingAttackMove = true;
				_skill.getContainer().setBusy(false);
			}.bindenv(this), this);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 600, function ( _skill )
			{
				if (target.isAlive())
				{
					_skill.attackEntity(_user, target);
				}

				_skill.m.IsDoingAttackMove = true;
				_skill.getContainer().setBusy(false);
			}.bindenv(this), this);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 800, function ( _skill )
			{
				if (target.isAlive())
				{
					_skill.attackEntity(_user, target);
				}

				_skill.m.IsDoingAttackMove = true;
				_skill.getContainer().setBusy(false);
			}.bindenv(this), this);
			return true;
		}
		else
		{
			if (target.isAlive())
			{
				ret = this.attackEntity(_user, target) || ret;
			}

			if (target.isAlive())
			{
				ret = this.attackEntity(_user, target) || ret;
			}

            if (target.isAlive())
			{
				ret = this.attackEntity(_user, target) || ret;
			}

            if (target.isAlive())
			{
				ret = this.attackEntity(_user, target) || ret;
			}

			return ret;
		}
		
	}

    function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity.getSkills().hasSkill("effects.horrified"))
		{
			_properties.DamageDirectMult *= 2.0;
		}
	}
});

