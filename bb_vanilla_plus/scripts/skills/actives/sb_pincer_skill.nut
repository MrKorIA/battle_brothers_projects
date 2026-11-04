this.sb_pincer_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 4,
		Skillcool = 4
	},
	function create()
	{
		this.m.ID = "actives.sb_pincer_skill";
		this.m.Name = "47. Клешневидный толчок";
		this.m.Description = "Атакуйте цель вместе с любыми союзниками с копьями в пределах 2 клеток от цели. (Навык ближнего боя)\n[color=#8f1e1e]Требования:[/color] Копье";
		this.m.Icon = "ui/xx62.png";
		this.m.IconDisabled = "ui/xx62_sw.png";
		this.m.SoundOnUse = [
			"sounds/combat/impale_01.wav",
			"sounds/combat/impale_02.wav",
			"sounds/combat/impale_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/impale_hit_01.wav",
			"sounds/combat/impale_hit_02.wav",
			"sounds/combat/impale_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 227;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.HitChanceBonus = 50;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 1;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]+50%[/color] chance to hit"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Cooldown: 4 turn \nCooldown left: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] turn"
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		local myTile = _user.getTile();
		local actors = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());
		local target = _targetTile.getEntity();
		local flip;
		local delay = 0; 
		foreach( a in actors )
		{
			if (a.getID() == _user.getID())
			{
				continue;
			}
			if (_targetTile.getDistanceTo(a.getTile()) > 1)
			{
				continue;
			}
			if (a.getFaction() == _user.getFaction())
			{
				flip = !this.m.IsProjectileRotated && target.getPos().X > a.getPos().X;
				this.Tactical.spawnProjectileEffect("effect_split_N", a.getTile(), _targetTile, 1.5, 1.1, true, flip);
				this.Tactical.spawnProjectileEffect("effect_split_N", a.getTile(), _targetTile, 1.5, 1.5, true, flip);
				delay = this.Math.rand(80, 150) + delay;
				this.Time.scheduleEvent(this.TimeUnit.Virtual, delay, function ( _data ) {
					local c_a = _data.Ally;
					local c_flip = !this.m.IsProjectileRotated && target.getPos().X > c_a.getPos().X;					
					this.Tactical.spawnProjectileEffect("effect_impale_N", c_a.getTile(), _targetTile, 2, 1.1, true, c_flip);
					this.Tactical.spawnProjectileEffect("effect_impale_N", c_a.getTile(), _targetTile, 2, 1.5, true, c_flip);
					this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill, _targetTile.Pos);
				}.bindenv(this), { Ally = a });
			}
		}
		flip = !this.m.IsProjectileRotated && target.getPos().X > _user.getPos().X;
		this.Tactical.spawnProjectileEffect("effect_impale_N", myTile, _targetTile, 2, 1.1, true, flip);
		this.Tactical.spawnProjectileEffect("effect_impale_N", myTile, _targetTile, 2, 1.5, true, flip);
		return this.attackEntity(_user, target, false);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local mainh = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (mainh != null && mainh.isItemType(this.Const.Items.ItemType.MeleeWeapon))
			{
				this.m.DirectDamageMult = mainh.m.DirectDamageMult;
				_properties.DamageRegularMin += 50;
				_properties.DamageRegularMax += 50;
				_properties.RangedSkill += 20;
			}
		}
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}
		local target = _targetTile.getEntity();
		if (target == null)
		{
			return false;
		}
		local myAllies = 0;
		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
				continue;
			}
			local n = _targetTile.getNextTile(i);
			if (n.IsOccupiedByActor)
			{
				local a = n.getEntity();
				if (a.isAlive() && a.isAlliedWith(this.getContainer().getActor()))
				{
					myAllies++;
				}
			}
		}
		if (myAllies >= 4)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	function isHidden()
	{
		if (this.m.Container.getActor().isPlacedOnMap())
		{
			local actor = this.getContainer().getActor();
			local mainh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (mainh != null && mainh.isItemType(this.Const.Items.ItemType.MeleeWeapon))
			{
				return false;
			}
			return true;
		}
		return false;
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
		local actor = this.getContainer().getActor();
		local mainh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (mainh != null && mainh.isItemType(this.Const.Items.ItemType.MeleeWeapon))
		{
			return true;
		}
		return false;
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

