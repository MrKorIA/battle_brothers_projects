this.mod_hallucinated_effect <- ::inherit("scripts/skills/skill", {
	m = {
		IsSelfHarm = false,
		IsAttackingOther = false,
		IsCheckedOutcome = false,
		IsTurnResume = false,
	},
	function create()
	{
		this.m.ID = "effects.mod_hallucinated";
		this.m.Name = "Галлюцинация";
		this.m.Icon = "skills/status_effect_52.png";
		this.m.IconMini = "status_effect_52_mini";
		this.m.Overlay = "status_effect_52";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Этот персонаж погрузился в галлюцинации. Лучше держаться на расстоянии, так как этот персонаж может причинить вам вред. Эффект длится только в течение этого хода.";
	}

	function getTooltip()
	{
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
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-25%[/color] к наносимому урону"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-35%[/color] к решимости"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-10%[/color] к инициативе"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-3[/color] к восстановлению выносливости за один ход"
			}
		];
	}

	function onAdded()
	{
		if (this.getContainer().getActor().getCurrentProperties().IsResistantToAnyStatuses && ::Math.rand(1, 100) <= 50)
		{
			if (!this.getContainer().getActor().isHiddenToPlayer())
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " невосприимчив к холоду благодаря своей неестественной физиологии");
			}

			this.removeSelf();
		}
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();

		if (actor.hasSprite("status_hex") && actor.getFlags().has("human"))
		{
			actor.getSprite("status_hex").Visible = false;
		}
		else if (actor.hasSprite("status_stunned") && !this.getContainer().hasSkill("effects.stunned") && !this.getContainer().hasSkill("effects.dazed"))
		{
			actor.getSprite("status_stunned").Visible = false;
		}

		actor.setDirty(true);
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		_properties.DamageTotalMult *= 0.75;
		_properties.BraveryMult *= 0.65;
		_properties.InitiativeMult *= 0.9;
		_properties.FatigueRecoveryRate -= 3;

		if (actor.hasSprite("status_hex") && actor.getFlags().has("human"))
		{
			actor.getSprite("status_hex").setBrush("zombie_rage_eyes");
			actor.getSprite("status_hex").Visible = true;
			actor.setDirty(true);
		}
		else if (actor.hasSprite("status_stunned") && !this.getContainer().hasSkill("effects.stunned") && !this.getContainer().hasSkill("effects.dazed"))
		{
			actor.getSprite("status_stunned").setBrush("bust_distracted");
			actor.getSprite("status_stunned").Visible = true;
			actor.setDirty(true);
		}
	}

	function checkOutcome()
	{
		if (this.m.IsCheckedOutcome || this.getContainer().getActor().getCurrentProperties().IsStunned)
		{
			return;
		}

		local rolled = ::Math.rand(1, 100);

		if (this.isAnnoyingOpponentForTheBoss())
		{
			if (rolled <= 50)
			{
				this.m.IsSelfHarm = true;
			}
			else
			{
				this.m.IsAttackingOther = true;
			}
		}
		else
		{
			if (rolled <= 30)
			{
				// safe roll
			}
			else if (rolled <= 65 || this.getContainer().getActor().isArmedWithRangedWeapon() || this.getContainer().getActor().getCurrentProperties().IsRooted)
			{
				this.m.IsSelfHarm = true;
			}
			else
			{
				this.m.IsAttackingOther = true;
			}
		}

		this.m.IsCheckedOutcome = true;
	}

	function isAnnoyingOpponentForTheBoss()
	{
		if (this.getContainer().getActor().getCurrentProperties().IsImmuneToPoison)
		{
			return true;
		}

		return false;
	}

	function onQueryEnemyInMeleeRange( _actor, _tag )
	{
		local tile = _actor.getTile();

		if (!_actor.isAlive() || !_actor.isAttackable())
		{
			return;
		}

		if (!tile.IsVisibleForEntity)
		{
			return;
		}

		if (::Math.abs(tile.Level - _tag.Actor.getTile().Level) > 1)
		{
			return;
		}

		if (_actor.isAlliedWith(_tag.Actor))
		{
			_tag.Targets.push(tile);
			_tag.Targets.push(tile);
			return;
		}

		_tag.Targets.push(tile);
	}

	function checkNearby( _skill )
	{
		local actor = this.getContainer().getActor();
		local result = {
			Actor = actor,
			Targets = []
		};
		::Tactical.queryActorsInRange(actor.getTile(), 1, _skill.getMaxRange(), this.onQueryEnemyInMeleeRange.bindenv(this), result);
		return ::MSU.Array.rand(result.Targets);
	}

	function onAttackWildly( _tile , _skill )
	{
		if (_tile != null)
		{
			local defaultProperty = _skill.isTargeted();
			this.m.IsAttackingOther = false;
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " становится возбужденным и уже не может отличить друзей от врагов!");
			_skill.m.IsTargeted = false;
			_skill.use(_tile);
			_skill.m.IsTargeted = defaultProperty;
		}
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		this.checkOutcome();

		if (this.m.IsAttackingOther)
		{
			local skill = this.getContainer().getAttackOfOpportunity();

			if (skill != null)
			{
				this.onAttackWildly(this.checkNearby(skill), skill);
			}

			return;
		}

		if (this.m.IsSelfHarm)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " начинает наносить себе увечья!");
			actor.m.IsAbleToDie = false;
			this.m.IsSelfHarm = false;
			this.spawnIcon("status_effect_104", actor.getTile());
			local hitInfo = clone ::Const.Tactical.HitInfo;
			hitInfo.DamageRegular = ::Math.rand(5, 20);
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = ::Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			actor.onDamageReceived(actor, this, hitInfo);
			actor.setFatigue(::Math.min(actor.getFatigueMax(), actor.getFatigue() + 7));
			actor.setActionPoints(actor.getActionPoints() - 4);
			actor.m.IsAbleToDie = true;
		}
	}

	function onResumeTurn()
	{
		if (!this.m.IsCheckedOutcome && this.getContainer().getActor().getActionPoints() < 4)
		{
			this.m.IsTurnResume = true;
			return;
		}

		this.onTurnStart();
	}

	function onTurnEnd()
	{
		if (!this.m.IsTurnResume)
		{
			this.removeSelf();
		}
		else
		{
			this.m.IsTurnResume = false;
			this.m.IsCheckedOutcome = false;
		}
	}

	function onMovementCompleted( _tile )
	{
		if (this.m.IsAttackingOther)
		{
			local skill = this.getContainer().getAttackOfOpportunity();

			if (skill != null && skill.isUsable())
			{
				this.onAttackWildly(this.checkNearby(skill), skill);
			}

			return;
		}
	}

});

