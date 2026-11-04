this.perk_legend_smackdown <- this.inherit("scripts/skills/skill", {
	m = {
		TilesUsed = []
	},
	function create()
	{
		this.m.ID = "perk.legend_smackdown";
		this.m.Name = "Сокрушительный удар";
		this.m.Description = "Используйте свою стать и силу, чтобы доминировать на поле боя, сочетая лучшее из нападения и защиты.";
		this.m.Icon = "ui/perks/smackdown_circle.png";
		this.m.IconDisabled = "ui/perks/smackdown_circle_bw.png"
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
		this.m.SoundOnUse = [
			"sounds/combat/shatter_01.wav",
			"sounds/combat/shatter_02.wav",
			"sounds/combat/shatter_03.wav"
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/combat/shatter_hit_01.wav",
			"sounds/combat/shatter_hit_02.wav",
			"sounds/combat/shatter_hit_03.wav"
		];
	}

	function getTooltip()
	{
		local chance = this.getChance();
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
				id = 7,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Пассивное умение: Эффективность против доспехов увеличена на [color=" + this.Const.UI.Color.PositiveValue + "]+30%[/color] для любого используемого оружия."
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Открывает способность [color=" + this.Const.UI.Color.PositiveValue + "]Замах[/color], которая позволяет оттолкнуть противника и [color=" + this.Const.UI.Color.PositiveValue + "]ошеломить[/color] его следующим ударом.\n[color=" + this.Const.UI.Color.PositiveValue + "]Ошеломлённые[/color] враги получают [color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] к урону, выносливости и инициативе.\nСтоимость: [color=" + this.Const.UI.Color.NegativeValue + "]2[/color] ОД и [color=" + this.Const.UI.Color.NegativeValue + "]15[/color] выносливости."
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "При использовании двуручного оружия стоимость в ОД снижается до [color=" + this.Const.UI.Color.PositiveValue + "]1[/color]. Работает только с оружием ближнего боя, ударами без оружия и одноручными пращами. С одноручными пращами дарует эффект [color=" + this.Const.UI.Color.PositiveValue + "]Зарядить снаряд[/color]."
			}
		];
	}

	function onAdded()
	{
        if (!this.m.Container.hasSkill("actives.legend_wind_up"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/legend_wind_up_skill"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.legend_wind_up");
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{

		if (_targetTile == null)
		{
			return null;
		}

		if (_userTile == null)
		{
			return null;
		}

		local dir = _userTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local knockToTile = _targetTile.getNextTile(dir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1 && this.m.TilesUsed.find(knockToTile.ID) == null)
			{
				return knockToTile;
			}
		}

		local altdir = dir - 1 >= 0 ? dir - 1 : 5;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1 && this.m.TilesUsed.find(knockToTile.ID) == null)
			{
				return knockToTile;
			}
		}

		altdir = dir + 1 <= 5 ? dir + 1 : 0;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1  && this.m.TilesUsed.find(knockToTile.ID) == null)
			{
				return knockToTile;
			}
		}

		return null;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.m.TilesUsed = [];
		if (_skill.isRanged())
			return;

        if (_targetEntity == null || !_targetEntity.isAlive() || _targetEntity.isDying())
            return;

		if (_targetEntity.isNonCombatant())
			return;

		local user = _skill.getContainer().getActor();

		if (!user.getSkills().hasSkill("effects.legend_knockback_prepared"))
			return;

		if (_targetEntity.getCurrentProperties().IsRooted || _targetEntity.getCurrentProperties().IsImmuneToKnockBackAndGrab)
			return;

		local knockToTile = this.findTileToKnockBackTo(user.getTile(), _targetEntity.getTile());

		if (knockToTile == null)
			return;

		this.m.TilesUsed.push(knockToTile.ID);

		if (!user.isHiddenToPlayer() && (_targetEntity.getTile().IsVisibleForPlayer || knockToTile.IsVisibleForPlayer))
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " has knocked back " + this.Const.UI.getColorizedEntityName(_targetEntity));
		}

		_targetEntity.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
		local damage = this.Math.max(0, this.Math.abs(knockToTile.Level - _targetEntity.getTile().Level) - 1) * this.Const.Combat.FallingDamage;
		if (damage == 0)
		{
			this.Tactical.getNavigator().teleport(_targetEntity, knockToTile, null, null, true);
		}
		else
		{
			local p = user.getCurrentProperties();
			local tag = {
				Attacker = user,
				Skill = _skill,
				HitInfo = clone this.Const.Tactical.HitInfo
			};
			tag.HitInfo.DamageRegular = damage;
			tag.HitInfo.DamageDirect = 1.0;
			tag.HitInfo.BodyPart = this.Const.BodyPart.Body;
			tag.HitInfo.BodyDamageMult = 1.0;
			tag.HitInfo.FatalityChanceMult = 1.0;
			this.Tactical.getNavigator().teleport(_targetEntity, knockToTile, this.onKnockedDown, tag, true);
		}

		this.m.TilesUsed = [];
		return true;

	}

	function onKnockedDown( _entity, _tag )
	{
		if (_tag.Skill.m.SoundOnHit.len() != 0)
		{
			this.Sound.play(_tag.Skill.m.SoundOnHit[this.Math.rand(0, _tag.Skill.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _entity.getPos());
		}

		if (_tag.HitInfo.DamageRegular != 0)
		{
			_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfo);
		}
	}

	function onUpdate( _properties )
	{
		_properties.DamageArmorMult *= 1.30;
	}


});

