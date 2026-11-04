this.sb_shockwave_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 3,
		Skillcool = 3
	},
	function create()
	{
		this.m.ID = "actives.sb_shockwave_skill";
		this.m.Name = "59. Ударная волна";
		this.m.Description = "Создает ударную волну с помощью оружия, чтобы атаковать цели по прямой линии. Может поразить до 5 целей по прямой линии. (Навык ближнего боя)\n[color=#8f1e1e]Требование:[/color] Оружие ближнего боя";
		this.m.Icon = "ui/xx29.png";
		this.m.IconDisabled = "ui/xx29_sw.png";
		this.m.SoundOnUse = [
			"sounds/combat/strike_01.wav",
			"sounds/combat/strike_02.wav",
			"sounds/combat/strike_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/impale_hit_01.wav",
			"sounds/combat/impale_hit_02.wav",
			"sounds/combat/impale_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsWeaponSkill = true;
		this.m.IsDoingForwardMove = true;
		this.m.IsTargetingActor = false;
		this.m.IsAOE = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Двуручное оружие ближнего боя: [color=" + this.Const.UI.Color.PositiveValue + "]110%[/color] Ущерб, \nОдноручное оружие ближнего боя: [color=" + this.Const.UI.Color.PositiveValue + "]120%[/color] Ущерб"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Перезарядка: 3 ходов \nПерезарядка: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] ход"
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		local myTile = _user.getTile();
		local dir = myTile.getDirectionTo(_targetTile);
		local effect = {
		Delay = 0,
		Quantity = 100,
		LifeTimeQuantity = 100,
		SpawnRate = 550,
		Brushes = [
			"blood_splatter_sand_01",
			"blood_splatter_sand_02",
			"blood_splatter_bones_01",
			"blood_splatter_bones_01",
			"blood_splatter_red_08",
			"blood_splatter_red_09"
		],
		Stages = [
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("fffffff00"),
				ColorMax = this.createColor("fffffff00"),
				ScaleMin = 0.5,
				ScaleMax = 0.75,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 400,
				VelocityMax = 500,
				DirectionMin = this.createVec(-1.0, 0.25),
				DirectionMax = this.createVec(1.0, 1.0),
				SpawnOffsetMin = this.createVec(-20, -60),
				SpawnOffsetMax = this.createVec(20, -20),
				ForceMin = this.createVec(0, 90),
				ForceMax = this.createVec(0, 90)
			},
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("ffffffff"),
				ColorMax = this.createColor("ffffffff"),
				ScaleMin = 0.75,
				ScaleMax = 1.0,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 400,
				VelocityMax = 500,
				DirectionMin = this.createVec(-1.0, 0.25),
				DirectionMax = this.createVec(1.0, 1.0),
				ForceMin = this.createVec(0, 90),
				ForceMax = this.createVec(0, 90)
			},
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("fffffff0"),
				ColorMax = this.createColor("fffffff0"),
				ScaleMin = 1.0,
				ScaleMax = 1.0,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 400,
				VelocityMax = 500,
				ForceMin = this.createVec(0, -90),
				ForceMax = this.createVec(0, -90)
			},
			{
				LifeTimeMin = 0.2,
				LifeTimeMax = 0.3,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 1.0,
				ScaleMax = 1.0,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 500,
				VelocityMax = 600,
				ForceMin = this.createVec(0, -90),
				ForceMax = this.createVec(0, -90)
			}
		]
		};

	local effect2 = {
		Delay = 0,
		Quantity = 12,
		LifeTimeQuantity = 12,
		SpawnRate = 512,
		Brushes = [
			"explosion_03"
		],
		Stages = [
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("99887400"),
				ColorMax = this.createColor("99887400"),
				ScaleMin = 0.25,
				ScaleMax = 0.5,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 300,
				VelocityMax = 400,
				DirectionMin = this.createVec(-1.25, 0.25),
				DirectionMax = this.createVec(1.25, 0.25),
				SpawnOffsetMin = this.createVec(-10, -50),
				SpawnOffsetMax = this.createVec(10, -30),
				ForceMin = this.createVec(0, 10),
				ForceMax = this.createVec(0, 10)
			},
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("99887430"),
				ColorMax = this.createColor("99887430"),
				ScaleMin = 0.25,
				ScaleMax = 0.5,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 300,
				VelocityMax = 400,
				DirectionMin = this.createVec(-1.25, 0.25),
				DirectionMax = this.createVec(1.25, 0.25),
				ForceMin = this.createVec(0, 10),
				ForceMax = this.createVec(0, 10)
			},
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("998e7400"),
				ColorMax = this.createColor("998e7400"),
				ScaleMin = 0.5,
				ScaleMax = 0.75,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 300,
				VelocityMax = 400,
				ForceMin = this.createVec(0, 10),
				ForceMax = this.createVec(0, 10)
			}
		]
		};
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSplit);

		for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, _targetTile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages, this.createVec(0, -30));
		}
		this.Tactical.spawnParticleEffect(false, effect.Brushes, _targetTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, -30));
		this.Tactical.spawnParticleEffect(false, effect2.Brushes, _targetTile, effect2.Delay, effect2.Quantity, effect2.LifeTimeQuantity, effect2.SpawnRate, effect2.Stages, this.createVec(0, -30));
		this.Sound.play("sounds/combat/pound_hit_0" + this.Math.rand(1, 3) + ".wav", this.Const.Sound.Volume.Skill * 1.0, _user.getPos());
		if (_targetTile.IsOccupiedByActor && _targetTile.getEntity().isAttackable())
		{
			this.Tactical.getShaker().shake(_targetTile.getEntity(), _targetTile, 7);
		}
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 311, function ( _tag )
		{
			if (_targetTile.IsOccupiedByActor && _targetTile.getEntity().isAttackable() && _user.isAlive())
			{
				this.attackEntity(_user, _targetTile.getEntity(), false);
			}
		}.bindenv(this), null);

		if (_targetTile.hasNextTile(dir))
		{
			local aatile = _targetTile.getNextTile(dir);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, function ( _tag )
			{
				for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, aatile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages, this.createVec(0, -30));
				}
				this.Tactical.spawnParticleEffect(false, effect.Brushes, aatile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, -30));
				this.Tactical.spawnParticleEffect(false, effect2.Brushes, aatile, effect2.Delay, effect2.Quantity, effect2.LifeTimeQuantity, effect2.SpawnRate, effect2.Stages, this.createVec(0, -30));
				this.Sound.play("sounds/combat/lash_hit_03.wav", this.Const.Sound.Volume.Skill * 1.0, _user.getPos());
				if (aatile.IsOccupiedByActor && aatile.getEntity().isAttackable())
				{
					this.Tactical.getShaker().shake(aatile.getEntity(), aatile, 7);
				}
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 311, function ( _tag )
				{
					if (aatile.IsOccupiedByActor && aatile.getEntity().isAttackable() && _user.isAlive())
					{
						this.attackEntity(_user, aatile.getEntity(), false);
					}
				}.bindenv(this), null);
			}.bindenv(this), null);

		if (aatile.hasNextTile(dir))
		{
			local bbtile = aatile.getNextTile(dir);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 400, function ( _tag )
			{
				for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, bbtile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages, this.createVec(0, -30));
				}
				this.Tactical.spawnParticleEffect(false, effect.Brushes, bbtile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, -30));
				this.Tactical.spawnParticleEffect(false, effect2.Brushes, bbtile, effect2.Delay, effect2.Quantity, effect2.LifeTimeQuantity, effect2.SpawnRate, effect2.Stages, this.createVec(0, -30));
				this.Sound.play("sounds/combat/lash_hit_03.wav", this.Const.Sound.Volume.Skill * 1.0, _user.getPos());
				if (bbtile.IsOccupiedByActor && bbtile.getEntity().isAttackable())
				{
					this.Tactical.getShaker().shake(bbtile.getEntity(), bbtile, 7);
				}
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 311, function ( _tag )
				{
					if (bbtile.IsOccupiedByActor && bbtile.getEntity().isAttackable() && _user.isAlive())
					{
						this.attackEntity(_user, bbtile.getEntity(), false);
					}
				}.bindenv(this), null);
			}.bindenv(this), null);

		if (bbtile.hasNextTile(dir))
		{
			local cctile = bbtile.getNextTile(dir);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 600, function ( _tag )
			{
				for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, cctile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages, this.createVec(0, -30));
				}
				this.Tactical.spawnParticleEffect(false, effect.Brushes, cctile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, -30));
				this.Tactical.spawnParticleEffect(false, effect2.Brushes, cctile, effect2.Delay, effect2.Quantity, effect2.LifeTimeQuantity, effect2.SpawnRate, effect2.Stages, this.createVec(0, -30));
				this.Sound.play("sounds/combat/lash_hit_03.wav", this.Const.Sound.Volume.Skill * 1.0, _user.getPos());
				if (cctile.IsOccupiedByActor && cctile.getEntity().isAttackable())
				{
					this.Tactical.getShaker().shake(cctile.getEntity(), cctile, 7);
				}
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 311, function ( _tag )
				{
					if (cctile.IsOccupiedByActor && cctile.getEntity().isAttackable() && _user.isAlive())
					{
						this.attackEntity(_user, cctile.getEntity(), false);
					}
				}.bindenv(this), null);
			}.bindenv(this), null);

		if (cctile.hasNextTile(dir))
		{
			local ddtile = cctile.getNextTile(dir);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 800, function ( _tag )
			{
				for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, ddtile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages, this.createVec(0, -30));
				}
				this.Tactical.spawnParticleEffect(false, effect.Brushes, ddtile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, -30));
				this.Tactical.spawnParticleEffect(false, effect2.Brushes, ddtile, effect2.Delay, effect2.Quantity, effect2.LifeTimeQuantity, effect2.SpawnRate, effect2.Stages, this.createVec(0, -30));
				this.Sound.play("sounds/combat/lash_hit_03.wav", this.Const.Sound.Volume.Skill * 1.0, _user.getPos());
				if (ddtile.IsOccupiedByActor && ddtile.getEntity().isAttackable())
				{
					this.Tactical.getShaker().shake(ddtile.getEntity(), ddtile, 7);
				}
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 311, function ( _tag )
				{
					if (ddtile.IsOccupiedByActor && ddtile.getEntity().isAttackable() && _user.isAlive())
					{
						this.attackEntity(_user, ddtile.getEntity(), false);
					}
				}.bindenv(this), null);
			}.bindenv(this), null);
		}

		}

		}

		}

		return true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local mainh = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (mainh != null && mainh.isItemType(this.Const.Items.ItemType.MeleeWeapon))
			{
				this.m.DirectDamageMult = mainh.m.DirectDamageMult;
				if (mainh.isItemType(this.Const.Items.ItemType.TwoHanded))
				{
					_properties.MeleeDamageMult *= 1.1;
				}
				else
				if (mainh.isItemType(this.Const.Items.ItemType.OneHanded))
				{
					_properties.MeleeDamageMult *= 1.2;
				}
			}
		}
	}

	function onTargetSelected( _targetTile )
	{
		local ownTile = this.m.Container.getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);
		this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);

		if (_targetTile.hasNextTile(dir))
		{
			local aatile = _targetTile.getNextTile(dir);
			if (aatile.IsOccupiedByActor || aatile.IsEmpty)
			{
				this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, aatile, aatile.Pos.X, aatile.Pos.Y);
			}

			if (aatile.hasNextTile(dir))
			{
				local bbtile = aatile.getNextTile(dir);
				if (bbtile.IsOccupiedByActor || bbtile.IsEmpty)
				{
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, bbtile, bbtile.Pos.X, bbtile.Pos.Y);
				}

			if (bbtile.hasNextTile(dir))
			{
				local cctile = bbtile.getNextTile(dir);
				if (cctile.IsOccupiedByActor || cctile.IsEmpty)
				{
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, cctile, cctile.Pos.X, cctile.Pos.Y);
				}

			if (cctile.hasNextTile(dir))
			{
				local ddtile = cctile.getNextTile(dir);
				if (ddtile.IsOccupiedByActor || ddtile.IsEmpty)
				{
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, ddtile, ddtile.Pos.X, ddtile.Pos.Y);
				}
			}

			}

			}
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

		local mainh = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
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

