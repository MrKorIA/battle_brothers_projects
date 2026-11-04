this.sb_sumwolf_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 1
	},
	function create()
	{
		this.m.ID = "actives.sb_sumwolf_skill";
		this.m.Name = "Призыв духа волка";
		this.m.Description = "Призыв Духа Волка, который будет атаковать врага в меру своих способностей.";
		this.m.Icon = "ui/xx5.png";
		this.m.IconDisabled = "ui/xx5_sw.png";
		this.m.SoundOnUse = [
			"sounds/enemies/wolf_idle_00.wav",
			"sounds/enemies/wolf_idle_01.wav",
			"sounds/enemies/wolf_idle_02.wav",
			"sounds/enemies/wolf_idle_03.wav",
			"sounds/enemies/wolf_idle_04.wav",
			"sounds/enemies/wolf_idle_06.wav",
			"sounds/enemies/wolf_idle_07.wav",
			"sounds/enemies/wolf_idle_08.wav",
			"sounds/enemies/wolf_idle_09.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsTargetingActor = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
	}

	function getTooltip()
	{
		local ret = [
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
				icon = "ui/icons/special.png",
				text = "Может использоваться [color=#8f1e1e]" + this.m.Skillcharge + "[/color] раз в этой битве."
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Когда уровень заклинателя 10 или выше: +100% к урону, +10 к навыку ближнего боя, +100 к ОЗ"
			}
		];
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return this.skill.onVerifyTarget(_originTile, _targetTile) && _targetTile.IsEmpty;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcharge = this.m.Skillcharge - 1
		local entity = this.Tactical.spawnEntity("scripts/entity/tactical/warwolf", _targetTile.Coords.X, _targetTile.Coords.Y);
		entity.setFaction(this.Const.Faction.PlayerAnimals);
		entity.storeSpriteColors();
		entity.fadeTo(this.createColor("00000000"), 0);
		entity.getFlags().add("wolf_minion");
		entity.getSkills().add(this.new("scripts/skills/effects/vp_ghost_effect"));
		if (_user.getLevel() >= 10)
		{
			entity.getBaseProperties().MeleeSkill += 10;
			entity.getBaseProperties().DamageTotalMult *= 2;
			entity.getBaseProperties().Hitpoints += 100;
			entity.setName("Древний Дух Волка");
		}
		else
		{
			entity.setName("Дух Волка");
		}
		if (this.Const.Tactical.RaiseUndeadParticles.len() != 0)
		{
			for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, _targetTile, this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
			}
			for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, _user.getTile(), this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
			}
		}
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 300, this.onDelayedEffect.bindenv(this), tag);
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local user = _tag.User;
		local ttile = _tag.TargetTile;
		local mtile = user.getTile();
		for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, ttile, this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
		}
		for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, mtile, this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
		}
		if (ttile.IsOccupiedByActor && ttile.getEntity().getFlags().has("wolf_minion"))
		{
			local xtarget = ttile.getEntity();
			xtarget.fadeToStoredColors(500);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 510, function ( _tag )
			{
				xtarget.restoreSpriteColors();
                xtarget.getSprite("head").Color = this.createColor("#82fdff");
                xtarget.getSprite("head").Alpha = 141;
                xtarget.getSprite("body").Color = this.createColor("#82fdff");
                xtarget.getSprite("body").Alpha = 141;
				if (user.getLevel() >= 10)
				{
					xtarget.getSprite("armor").setBrush("zombie_rage_eyes");
					xtarget.getSprite("armor").setHorizontalFlipping(false);
					xtarget.getSprite("armor").Visible = true;
					xtarget.getSprite("armor").Scale = 1.05;
					xtarget.getSprite("armor").Saturation = 1.5;
					xtarget.setSpriteOffset("armor", this.createVec(17, -27));
				}
                xtarget.setAlwaysApplySpriteOffset(true);
			}.bindenv(this), this);
		}
		return true;
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
		this.m.Skillcharge = 1;
	}

});

