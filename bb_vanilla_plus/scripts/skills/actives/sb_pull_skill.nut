this.sb_pull_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 7,
		Skillcool = 7
	},
	function create()
	{
		this.m.ID = "actives.sb_pull_skill";
		this.m.Name = "Шаровая Молния";
		this.m.Description = "Наносит небольшой урон по ОЗ и выносливости целям в зоне поражения и отталкивает их от центра. Ошеломляет цели и снимает защиту от стены щитов / стены копий / ответного удара.";
		this.m.Icon = "ui/xx57.png";
		this.m.IconDisabled = "ui/xx57_sw.png";
		this.m.Overlay = "active_rand";
		this.m.SoundOnUse = [
			"sounds/combat/hand_hit_01.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = true;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 25;
		this.m.MinRange = 0;
		this.m.MaxRange = 6;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Дальность " + this.getMaxRange() + " клеток"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Перезарядка: 7 ходов \nПерезарядка: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] хода(ов)"
		});
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (_originTile.Level + 1 < _targetTile.Level)
		{
			return false;
		}

		return true;
	}

	function onTargetSelected( _targetTile )
	{
		local tiles = this.getAffectedTiles(_targetTile);
		this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);

		if (tiles.len() != 0)
		{
			foreach( t in tiles )
			{
				this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, t, t.Pos.X, t.Pos.Y);
			}
		}
	}

	function getAffectedTiles( _targetTile )
	{
		local ret = [
			_targetTile
		];
		local ownTile = this.m.Container.getActor().getTile();
		for( local i = 0; i != 6; i = ++i )
		{
			if (_targetTile.hasNextTile(i))
			{
				local forwardTile = _targetTile.getNextTile(i);
				if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
				{
					ret.push(forwardTile);
				}
			}
		}
		return ret;
	}

	function onKnockedDown( _entity, _tag )
	{
		if (_tag.HitInfo.DamageRegular != 0)
		{
			_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfo);
		}
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		local maintarget = _targetTile.getEntity();
		local tiles = this.getAffectedTiles(_targetTile);
		this.Sound.play("sounds/combat/smash_03.wav", this.Const.Sound.Volume.Skill * 2, _targetTile);
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectThresh);
		for( local i = 0; i < this.Const.Tactical.DazeParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DazeParticles[i].Brushes, _targetTile, this.Const.Tactical.DazeParticles[i].Delay, this.Const.Tactical.DazeParticles[i].Quantity, this.Const.Tactical.DazeParticles[i].LifeTimeQuantity, this.Const.Tactical.DazeParticles[i].SpawnRate, this.Const.Tactical.DazeParticles[i].Stages);
		}
		local bookedTileIDs = [];
		foreach( t in tiles )
		{
			if (t.IsOccupiedByActor && t.getEntity().isAlive() && t.getEntity().isAttackable())
			{
			    local isAppley = false;
				local target = t.getEntity();
				local skills = target.getSkills();
				skills.removeByID("effects.shieldwall");
				skills.removeByID("effects.spearwall");
				skills.removeByID("effects.riposte");
				skills.add(this.new("scripts/skills/effects/staggered_effect"));
//				this.applyFatigueDamage(target, 33);
                local damage = this.Math.rand(5, 15);
                local tag = {
                    Attacker = _user,
                    Skill = this,
                    HitInfo = clone this.Const.Tactical.HitInfo
                };
                tag.HitInfo.DamageRegular = damage;
                tag.HitInfo.DamageArmor = damage * 0.5;
                tag.HitInfo.DamageFatigue = 15;
                tag.HitInfo.DamageDirect = 0.5;
                tag.HitInfo.BodyPart = this.Const.BodyPart.Body;
                tag.HitInfo.BodyDamageMult = 1.0;
                tag.HitInfo.FatalityChanceMult = 0.0;
				target.playSound(this.Const.Sound.ActorEvent.DamageReceived, 1);
				local dir = _targetTile.getDirectionTo(t);
				local rr = 0;

                if (!target.getCurrentProperties().IsImmuneToKnockBackAndGrab && !target.getCurrentProperties().IsRooted)
                {
                    if (maintarget == target)
                    {
                        rr = 1;
                        this.Tactical.getShaker().shake(target, _targetTile, 7);
                    }
                    if (t.hasNextTile(dir))
                    {
                        local knockToTile = t.getNextTile(dir);
                        if (rr == 0 && bookedTileIDs.find(knockToTile.ID) == null && knockToTile.IsEmpty && knockToTile.Level - t.Level <= 1)
                        {
                            rr = 1;
                            bookedTileIDs.push(knockToTile.ID);
                            this.Tactical.getNavigator().teleport(target, knockToTile, this.onKnockedDown, tag, false, 1.5);
                            isAppley = true;
                        }
                    }
                    local altdir = dir - 1 >= 0 ? dir - 1 : 5;
                    if (t.hasNextTile(altdir))
                    {
                        local knockToTile = t.getNextTile(altdir);
                        if (rr == 0 && bookedTileIDs.find(knockToTile.ID) == null && knockToTile.IsEmpty && knockToTile.Level - t.Level <= 1)
                        {
                            rr = 1;
                            bookedTileIDs.push(knockToTile.ID);
                            this.Tactical.getNavigator().teleport(target, knockToTile, this.onKnockedDown, tag, false, 1.5);
                            isAppley = true;
                        }
                    }
                    altdir = dir + 1 <= 5 ? dir + 1 : 0;
                    if (t.hasNextTile(altdir))
                    {
                        local knockToTile = t.getNextTile(altdir);
                        if (rr == 0 && bookedTileIDs.find(knockToTile.ID) == null && knockToTile.IsEmpty && knockToTile.Level - t.Level <= 1)
                        {
                            rr = 1;
                            bookedTileIDs.push(knockToTile.ID);
                            this.Tactical.getNavigator().teleport(target, knockToTile, this.onKnockedDown, tag, false, 1.5);
                            isAppley = true;
                        }
                    }
                }
				if (!isAppley) target.onDamageReceived(tag.Attacker, tag.Skill, tag.HitInfo);
			}
		}
		local effect = {
				Delay = 0,
				Quantity = 50,
				LifeTimeQuantity = 50,
				SpawnRate = 300,
				Brushes = [
					"sparkleflare_1",
					"sparkleflare_2"
				],
				Stages = [
					{
						LifeTimeMin = 0.2,
						LifeTimeMax = 0.4,
						ColorMin = this.createColor("ffffff40"),
						ColorMax = this.createColor("ffffff80"),
						ScaleMin = 0.1,
						ScaleMax = 0.3,
						RotationMin = 0,
						RotationMax = 300,
						VelocityMin = 100,
						VelocityMax = 300,
						DirectionMin = this.createVec(-1.0, -1.0),
						DirectionMax = this.createVec(1.0, 1.0),
						SpawnOffsetMin = this.createVec(0, 0),
						SpawnOffsetMax = this.createVec(0, 0),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					},
					{
						LifeTimeMin = 0.3,
						LifeTimeMax = 0.5,
						ColorMin = this.createColor("ffffff80"),
						ColorMax = this.createColor("ffffffcc"),
						ScaleMin = 0.1,
						ScaleMax = 0.2,
						RotationMin = 0,
						RotationMax = 300,
						VelocityMin = 100,
						VelocityMax = 300,
						DirectionMin = this.createVec(-1.0, -1.0),
						DirectionMax = this.createVec(1.0, 1.0),
						ForceMin = this.createVec(0, -100),
						ForceMax = this.createVec(0, -100)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.3,
						ColorMin = this.createColor("ffffff80"),
						ColorMax = this.createColor("ffffffcc"),
						ScaleMin = 0.2,
						ScaleMax = 0.3,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 200,
						VelocityMax = 300,
						DirectionMin = this.createVec(-1.0, -1.0),
						DirectionMax = this.createVec(1.0, 1.0),
						ForceMin = this.createVec(0, -100),
						ForceMax = this.createVec(0, -100)
					}
				]
			};
		this.Tactical.spawnParticleEffect(false, effect.Brushes, _targetTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
		return true;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		if (this.m.Skillcool < this.m.Cooldown)
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

