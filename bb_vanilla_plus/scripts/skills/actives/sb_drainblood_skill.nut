this.sb_drainblood_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 2,
		Skillcool = 2
	},
	function create()
	{
		this.m.ID = "actives.sb_drainblood_skill";
		this.m.Name = "Слить кровь";
		this.m.Description = "Накладывает заклинание на кровоточащую цель, чтобы нанести урон и восстановить усталость заклинателя. Этот эффект усиливается при накоплении кровотечения у цели..";
		this.m.Icon = "ui/xx63.png";
		this.m.IconDisabled = "ui/xx63_sw.png";
		this.m.SoundOnUse = [
			"sounds/enemies/gruesome_feast_01.wav",
			"sounds/enemies/gruesome_feast_02.wav",
			"sounds/enemies/gruesome_feast_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/overhead_strike_hit_01.wav",
			"sounds/combat/overhead_strike_hit_02.wav",
			"sounds/combat/overhead_strike_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.DirectDamageMult = 1;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 1;
		this.m.MinRange = 1;
		this.m.MaxRange = 4;
		this.m.IsUsingHitchance = false;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 50;
		this.m.ChanceSmash = 50;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Наносит 30 урона за каждый эффект кровотечения и восстанавливает 15 ед. усталости заклинателя."
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Перезарядка: 2 хода \nПерезарядка: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] ход(а)"
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " on " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()));
		}
		this.m.Skillcool = 0;
		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();
		local target = _targetTile.getEntity();
		local xxstack = 0;
		local xxap = actor.getActionPoints();
		actor.setActionPoints(0);
		while (target.getSkills().hasSkill("effects.bleeding"))
		{
			target.getSkills().removeByID("effects.bleeding");
			xxstack = xxstack + 1;
		}
		local overwhelm = this.getContainer().getSkillByID("perk.overwhelm");
		if (overwhelm != null)
		{
			overwhelm.onTargetHit(this, target, this.Const.BodyPart.Body, 0, 0);
		}
		actor.storeSpriteColors();
		actor.fadeTo(this.createColor("690404ff"), 100);
		target.storeSpriteColors();
		target.fadeTo(this.createColor("690404ff"), 100);
		this.Tactical.getShaker().shake(target, myTile, 4);
		target.playSound(this.Const.Sound.ActorEvent.Death, 2.5);
		local n = _user.m.BloodType;
		for( local i = 0; i < this.Const.Tactical.BloodEffects[n].len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BloodEffects[n][i].Brushes, myTile, this.Const.Tactical.BloodEffects[n][i].Delay, this.Const.Tactical.BloodEffects[n][i].Quantity, this.Const.Tactical.BloodEffects[n][i].LifeTimeQuantity, this.Const.Tactical.BloodEffects[n][i].SpawnRate, this.Const.Tactical.BloodEffects[n][i].Stages);
		}
		n = this.Const.BloodType.Red;
		for( local i = 0; i < this.Const.Tactical.BloodEffects[n].len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BloodEffects[n][i].Brushes, _targetTile, this.Const.Tactical.BloodEffects[n][i].Delay, this.Const.Tactical.BloodEffects[n][i].Quantity * 5, this.Const.Tactical.BloodEffects[n][i].LifeTimeQuantity * 2, this.Const.Tactical.BloodEffects[n][i].SpawnRate * 2, this.Const.Tactical.BloodEffects[n][i].Stages);
		}
		local flip = !this.m.IsProjectileRotated && target.getPos().X > _user.getPos().X;
		this.Tactical.spawnProjectileEffect("blood_splatter_red_0" + this.Math.rand(1, 6), _targetTile, myTile, 1.6, 2, true, flip);
		this.Tactical.spawnProjectileEffect("blood_splatter_red_0" + this.Math.rand(1, 6), _targetTile, myTile, 1.4, 4, true, flip);
		this.Tactical.spawnProjectileEffect("blood_splatter_red_0" + this.Math.rand(1, 6), _targetTile, myTile, 1.2, 6, true, flip);
		this.Tactical.spawnProjectileEffect("blood_splatter_red_0" + this.Math.rand(1, 6), _targetTile, myTile, 1.0, 8, true, flip);
		this.Tactical.spawnProjectileEffect("blood_splatter_red_0" + this.Math.rand(1, 6), _targetTile, myTile, 0.8, 10, true, flip);
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 300, function ( _skill )
		{
			if (actor.isAlive() && !actor.isDying() && target.isAlive() && !target.isDying())
			{
				actor.fadeToStoredColors(700);
				target.fadeToStoredColors(700);
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 600, function ( _skill )
				{
					if (actor.isAlive() && !actor.isDying() && target.isAlive() && !target.isDying() && target.isAttackable())
					{
						actor.setActionPoints(xxap);
						actor.setFatigue(this.Math.max(0, actor.getFatigue() - xxstack * 15));
						actor.getItems().updateAppearance();
						actor.restoreSpriteColors();
						target.restoreSpriteColors();
						target.playSound(this.Const.Sound.ActorEvent.DamageReceived, 2);
						this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill * 1.2, target.getPos());
						local hitInfo = clone this.Const.Tactical.HitInfo;
						hitInfo.DamageRegular = xxstack * 30;
						hitInfo.DamageDirect = 1;
						hitInfo.BodyPart = 0;
						hitInfo.FatalityChanceMult = 100;
						target.onDamageReceived(actor, _skill, hitInfo);
					}
				}.bindenv(this), this);
			}
		}.bindenv(this), this);
		return true;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (!_targetTile.getEntity().getSkills().hasSkill("effects.bleeding"))
		{
			return false;
		}

		return true;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else if (this.m.Skillcool < this.m.Cooldown)
		{
			return false;
		}
		return true;
	}

	function onTurnStart()
	{
		this.m.Skillcool = this.m.Skillcool + 1;
	}

	function onCombatFinished()
	{
		this.m.Skillcool = this.m.Cooldown;
	}

});

