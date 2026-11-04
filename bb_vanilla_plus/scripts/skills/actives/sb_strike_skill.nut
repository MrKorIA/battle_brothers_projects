this.sb_strike_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skilltime = 0
	},
	function create()
	{
		this.m.ID = "actives.sb_strike_skill";
		this.m.Name = "64. Удар ярости";
		this.m.Description = "Использует 100 очков ярости, чтобы нанести 3 удара по цели. (Навык ближнего боя)\n[color=#8f1e1e]Требования:[/color] Без оружия / Кастети";
		this.m.Icon = "ui/xx68.png";
		this.m.IconDisabled = "ui/xx68_sw.png";
		this.m.Overlay = "active_08";
		this.m.SoundOnUse = [
			"sounds/combat/shatter_01.wav",
			"sounds/combat/shatter_02.wav",
			"sounds/combat/shatter_03.wav"
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
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.2;
		this.m.ActionPointCost = 1;
		this.m.FatigueCost = 1;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 10;
		this.m.ChanceDisembowel = 10;
		this.m.ChanceSmash = 50;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=#135213]Passive:[/color] : Increased damage for Unarmed and Cestus. Extra damage if the Off-Hand, Head, and Body slots are empty."
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "You gain fury points with Unarmed or Cestus attacks. (Currently [color=#8f1e1e]" + this.m.Skilltime + "[/color] points)"
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skilltime = this.m.Skilltime - 100;
		local actor = this.getContainer().getActor();
		local target = _targetTile.getEntity();
		this.m.IsDoingAttackMove = false;
		this.getContainer().setBusy(true);
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectThrust);
		this.Sound.play("sounds/combat/hand_0" + this.Math.rand(1, 3) + ".wav", this.Const.Sound.Volume.Skill * 1, actor.getPos());
		if (target.m.IsShakingOnHit)
		{
			this.Tactical.getShaker().shake(target, _targetTile, 1);
		}
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 100, function ( _skill )
		{
			if (target.isAlive())
			{
				_skill.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSlash);
				_skill.attackEntity(_user, target);
			}
		}.bindenv(this), this);
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, function ( _skill )
		{
			if (target.isAlive())
			{
				_skill.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
				_skill.attackEntity(_user, target);
			}
		}.bindenv(this), this);
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 300, function ( _skill )
		{
			if (target.isAlive())
			{
				_skill.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSplit);
				_skill.attackEntity(_user, target);
			}
			_skill.m.IsDoingAttackMove = true;
			_skill.getContainer().setBusy(false);
		}.bindenv(this), this);
		return true;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill.getID() == "actives.hand_to_hand")
		{
			this.m.Skilltime = this.m.Skilltime + 25;
		}
		else if (_skill.getID() == "actives.xxitem_cestusaa_skill")
		{
			this.m.Skilltime = this.m.Skilltime + 50;
		}
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		if (_skill.getID() == "actives.hand_to_hand")
		{
			this.m.Skilltime = this.m.Skilltime + 10;
		}
		else if (_skill.getID() == "actives.xxitem_cestusaa_skill")
		{
			this.m.Skilltime = this.m.Skilltime + 20;
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		local xys = 0;

		if (_skill == this)
		{
			xys = 1;
			local actor = this.getContainer().getActor();
			_properties.DamageRegularMin = 50;
			_properties.DamageRegularMax = actor.getLevel() * 1 + 70;
			if (actor.getSkills().hasSkill("perk.duelist"))
			{
				_properties.DamageDirectAdd += 0.01;
			}
			_properties.DamageArmorMult = 0.7;
		}
		else if (_skill.getID() == "actives.hand_to_hand")
		{
			xys = 1;
			if("LegendMod" in this.Const)
			{
				_properties.DamageTotalMult *= 3;
			}
			else
			{
				_properties.DamageTotalMult *= 8;
			}
			if (this.getContainer().getActor().getBackground().getID() == "background.brawler" )
			{
				_properties.DamageTotalMult *= 0.6;
			}
		}
		else if (_skill.getID() == "actives.xxitem_cestusaa_skill")
		{
			xys = 1;
			_properties.DamageTotalMult *= 1.5;
		}

		if (xys == 1)
		{
			local rr = 1.0;
			local actor = this.getContainer().getActor();
			local offh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
			local head = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
			local body = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
			if (offh == null)
			{
				rr += 0.3;
			}
			if (head == null)
			{
				rr += 0.3;
			}
			if (body == null)
			{
				rr += 0.3;
			}
			_properties.DamageTotalMult *= rr;
		}
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}

		if (this.m.Skilltime < 100)
		{
			return false;
		}

		local mainhand = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (mainhand == null)
		{
			return true;
		}
		else if (this.getContainer().hasSkill("actives.xxitem_cestusaa_skill"))
		{
			return true;
		}
		else if (this.getContainer().hasSkill("effects.disarmed"))
		{
			return true;
		}

		return false;
	}

	function isHidden()
	{
		if (this.m.Container.getActor().isPlacedOnMap())
		{
			local mainhand = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			return mainhand != null && !this.getContainer().hasSkill("actives.xxitem_cestusaa_skill") && !this.getContainer().hasSkill("effects.disarmed") || this.skill.isHidden();
		}
		return false;
	}

	function onCombatFinished()
	{
		this.m.Skilltime = 0;
	}

});

