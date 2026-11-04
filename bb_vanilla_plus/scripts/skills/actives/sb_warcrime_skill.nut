this.sb_warcrime_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 2
	},
	function create()
	{
		this.m.ID = "actives.sb_warcrime_skill";
		this.m.Name = "73. Военное преступление";
		this.m.Description = "Наносит ужасный, непростительный, бесчеловечный удар по цели с очень низким здоровьем. Цель умирает мгновенно. Может быть использовано как на союзников, так и на врагов.";
		this.m.Icon = "ui/xx51.png";
		this.m.IconDisabled = "ui/xx51_sw.png";
		this.m.SoundOnHit = [
			"sounds/combat/pound_hit_01.wav",
			"sounds/combat/pound_hit_02.wav",
			"sounds/combat/pound_hit_03.wav",
			"sounds/combat/smash_hit_01.wav",
			"sounds/combat/smash_hit_02.wav",
			"sounds/combat/smash_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 1;
		this.m.ActionPointCost = 1;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.IsUsingHitchance = false;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 100;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Can be used [color=#8f1e1e]" + this.m.Skillcharge + "[/color] more times in this battle."
		});
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (_targetTile.IsEmpty || !_targetTile.getEntity().isAttackable() || !_targetTile.getEntity().isAlive() || _targetTile.getEntity().isDying())
		{
			return false;
		}
		if (this.m.Container.getActor().isAlliedWith(_targetTile.getEntity()))
		{
			return false;
		}
		if (_targetTile.getEntity().getFatigue() <= 30)
		{
			return false;
		}
		return true;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcharge = this.m.Skillcharge - 1
		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();
		local candidates = [];
		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local next = _targetTile.getNextTile(i);
				if (next.IsEmpty)
				{
					candidates.push(next);
				}
			}
		}
		if (candidates.len() == 0)
		{
			candidates.push(_targetTile);
		}
		local vomittile = candidates[this.Math.rand(0, candidates.len() - 1)];
		local helmet = _user.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		local target = _targetTile.getEntity();
		local xxap = actor.getActionPoints();
		actor.setActionPoints(0);
		if (helmet != null && actor.getSprite("head").Visible)
		{
			actor.getSprite("helmet").Visible = true;
		}
		actor.getSprite("armor").Visible = false;
		actor.getSprite("arms_icon").Visible = false;
		actor.getSprite("shield_icon").Visible = false;
		actor.addSprite("dirty_injury_wcrime1").setBrush("bust_slime");
		actor.getSprite("dirty_injury_wcrime1").Visible = true;
		actor.getSprite("dirty_injury_wcrime1").Color = this.createColor("#ff0000");
		actor.getSprite("dirty_injury_wcrime1").Alpha = 199;
		target.addSprite("dirty_injury_wcrime1").setBrush("bust_hex");
		target.getSprite("dirty_injury_wcrime1").setHorizontalFlipping(true);
		target.getSprite("dirty_injury_wcrime1").Visible = true;
		target.getSprite("dirty_injury_wcrime1").Alpha = 199;
		this.Sound.play("sounds/humans/0/human_flee_06.wav", this.Const.Sound.Volume.Skill * 1.7, actor.getPos());
		this.Sound.play("sounds/humans/5/human_fatigue_01.wav", this.Const.Sound.Volume.Skill * 1.5, actor.getPos());
		this.Tactical.getShaker().shake(target, myTile, 4, this.Const.Combat.ShakeEffectHitpointsHitColor, this.Const.Combat.ShakeEffectHitpointsHitHighlight, this.Const.Combat.ShakeEffectHitpointsHitFactor, this.Const.Combat.ShakeEffectHitpointsSaturation, this.Const.ShakeCharacterLayers[this.Const.BodyPart.All], 5.0);
		actor.playSound(this.Const.Sound.ActorEvent.Death, 2);
		target.playSound(this.Const.Sound.ActorEvent.Death, 2);
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 600, function ( _skill )
		{
			actor.playSound(this.Const.Sound.ActorEvent.Death, 1);
			target.playSound(this.Const.Sound.ActorEvent.Death, 1);
			this.Tactical.getShaker().shake(target, myTile, 1, this.Const.Combat.ShakeEffectHitpointsHitColor, this.Const.Combat.ShakeEffectHitpointsHitHighlight, this.Const.Combat.ShakeEffectHitpointsHitFactor, this.Const.Combat.ShakeEffectHitpointsSaturation, this.Const.ShakeCharacterLayers[this.Const.BodyPart.All], 5.0);
		}.bindenv(this), this);
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 800, function ( _skill )
		{
			actor.setActionPoints(xxap);
			if (actor.hasSprite("dirty_injury_wcrime1"))
			{
				actor.getSprite("dirty_injury_wcrime1").Visible = false;
				actor.removeSprite("dirty_injury_wcrime1");
			}
			if (target.hasSprite("dirty_injury_wcrime1"))
			{
				target.getSprite("dirty_injury_wcrime1").Visible = false;
				target.removeSprite("dirty_injury_wcrime1");
			}
			actor.getSprite("helmet").Visible = true;
			actor.getSprite("armor").Visible = true;
			actor.getSprite("arms_icon").Visible = true;
			actor.getSprite("shield_icon").Visible = true;
			actor.getItems().updateAppearance();
			local slime = _user.getSprite("dirt");
			slime.setBrush("bust_body_bloodied_02");
			slime.Visible = true;
			this.Sound.play("sounds/combat/taunt_0" + this.Math.rand(2, 3) + ".wav", this.Const.Sound.Volume.Skill * 3, actor.getPos());
			vomittile.clear(this.Const.Tactical.DetailFlag.Scorchmark);
			vomittile.spawnDetail("detail_vomit", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
			_skill.attackEntity(_user, target);
		}.bindenv(this), this);
		return true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this && _targetEntity != null)
		{
			_properties.HitChanceMult[this.Const.BodyPart.Head] = 0;
			_properties.HitChanceMult[this.Const.BodyPart.Body] = 1;
			local rr = this.Math.floor(_targetEntity.getFatigue() * 0.5);
			rr = this.Math.min(rr, 500);
			_properties.DamageRegularMin = rr;
			_properties.DamageRegularMax = rr;
		}
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
		this.m.Skillcharge = 2;
	}

});

