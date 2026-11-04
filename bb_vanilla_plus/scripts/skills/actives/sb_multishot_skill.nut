this.sb_multishot_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 2,
		Skillcool = 2
	},
	function create()
	{
		this.m.ID = "actives.sb_multishot_skill";
		this.m.Name = "45. Мульти-выстрел";
		this.m.Description = "Стреляет стрелами по 3 целям. (Ranged Skill)\n[color=#8f1e1e]Требования:[/color] Лук или арбалет";
		this.m.KilledString = "Shot";
		this.m.Icon = "ui/xx11.png";
		this.m.IconDisabled = "ui/xx11_sw.png";
		this.m.Overlay = "active_rand";
		this.m.SoundOnUse = [
			"sounds/combat/quick_shot_01.wav",
			"sounds/combat/quick_shot_02.wav",
			"sounds/combat/quick_shot_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/arrow_hit_01.wav",
			"sounds/combat/arrow_hit_02.wav",
			"sounds/combat/arrow_hit_03.wav"
		];
		this.m.SoundOnHitShield = [
			"sounds/combat/shield_hit_arrow_01.wav",
			"sounds/combat/shield_hit_arrow_02.wav",
			"sounds/combat/shield_hit_arrow_03.wav"
		];
		this.m.SoundOnMiss = [
			"sounds/combat/arrow_miss_01.wav",
			"sounds/combat/arrow_miss_02.wav",
			"sounds/combat/arrow_miss_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.Delay = 1000;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsAOE = true;
		this.m.IsWeaponSkill = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = true;
		this.m.IsDoingForwardMove = false;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 20;
		this.m.MinRange = 2;
		this.m.MaxRange = 6;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.ProjectileType = this.Const.ProjectileType.Arrow;
		this.m.ProjectileTimeScale = 1.2;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Дальность " + this.getMaxRange() + " плитки"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Имеет +5% шанса на попадание и -3% за каждую клетку расстояния"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "+10% урона. -4 ОД стоимость при использовании лука."
		});
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Перезарядка: 2 хода \nПерезарядка: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] ход"
		});
		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Не может быть использовано, так как этот персонаж участвует в ближнем бою.[/color]"
			});
		}
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		if (this.getContainer().hasSkill("actives.quick_shot") || this.getContainer().hasSkill("actives.aimed_shot"))
		{
			this.m.ActionPointCost = 4;
			this.m.SoundOnUse = [
				"sounds/combat/quick_shot_01.wav",
				"sounds/combat/quick_shot_02.wav",
				"sounds/combat/quick_shot_03.wav"
			];
			this.m.SoundOnHit = [
				"sounds/combat/arrow_hit_01.wav",
				"sounds/combat/arrow_hit_02.wav",
				"sounds/combat/arrow_hit_03.wav"
			];
			this.m.SoundOnHitShield = [
				"sounds/combat/shield_hit_arrow_01.wav",
				"sounds/combat/shield_hit_arrow_02.wav",
				"sounds/combat/shield_hit_arrow_03.wav"
			];
			this.m.SoundOnMiss = [
				"sounds/combat/arrow_miss_01.wav",
				"sounds/combat/arrow_miss_02.wav",
				"sounds/combat/arrow_miss_03.wav"
			];
		}
		else
		{
			this.m.ActionPointCost = 8;
			this.m.SoundOnUse = [
				"sounds/combat/bolt_shot_01.wav",
				"sounds/combat/bolt_shot_02.wav",
				"sounds/combat/bolt_shot_03.wav"
			];
			this.m.SoundOnHit = [
				"sounds/combat/bolt_shot_hit_01.wav",
				"sounds/combat/bolt_shot_hit_02.wav",
				"sounds/combat/bolt_shot_hit_03.wav"
			];
			this.m.SoundOnHitShield = [
				"sounds/combat/shield_hit_arrow_01.wav",
				"sounds/combat/shield_hit_arrow_02.wav",
				"sounds/combat/shield_hit_arrow_03.wav"
			];
			this.m.SoundOnMiss = [
				"sounds/combat/bolt_shot_miss_01.wav",
				"sounds/combat/bolt_shot_miss_02.wav",
				"sounds/combat/bolt_shot_miss_03.wav"
			];
		}
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		local ret = false;
		local myTile = _user.getTile();
		local myTile = this.m.Container.getActor().getTile();
		local d = myTile.getDistanceTo(_targetTile);
		local result = {
			Tiles = [],
			MyTile = myTile,
			TargetTile = _targetTile,
			Num = 0
		};
		this.Tactical.queryTilesInRange(myTile, d, d, false, [], this.onQueryTilesHit, result);
		local tiles = [];

		for( local i = 0; i != result.Tiles.len(); i = ++i )
		{
			if (result.Tiles[i].ID == _targetTile.ID)
			{
				tiles.push(result.Tiles[i]);
				local idx = i - 1;

				if (idx < 0)
				{
					idx = idx + result.Tiles.len();
				}

				tiles.push(result.Tiles[idx]);
				idx = i - 2;

				if (idx < 0)
				{
					idx = idx + result.Tiles.len();
				}

				tiles.push(result.Tiles[idx]);
				break;
			}
		}

		foreach( t in tiles )
		{
			if (!t.IsVisibleForEntity)
			{
				continue;
			}

			if (this.Math.abs(t.Level - myTile.Level) > this.m.MaxLevelDifference || this.Math.abs(t.Level - _targetTile.Level) > this.m.MaxLevelDifference)
			{
				continue;
			}

			if (!t.IsEmpty && t.getEntity().isAttackable())
			{
				ret = this.attackEntity(_user, t.getEntity()) || ret;
			}

			if (!_user.isAlive() || _user.isDying())
			{
				break;
			}
		}

		return true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local mainh = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (mainh != null)
			{
				this.m.DirectDamageMult = mainh.m.DirectDamageMult;
			}
			_properties.RangedSkill += 5;
			_properties.HitChanceAdditionalWithEachTile += -3;
			_properties.DamageTotalMult += 0.1;
		}
	}

	function onQueryTilesHit( _tile, _result )
	{
		_result.Tiles.push(_tile);
	}

	function onTargetSelected( _targetTile )
	{
		local myTile = this.m.Container.getActor().getTile();
		local d = myTile.getDistanceTo(_targetTile);
		local result = {
			Tiles = [],
			MyTile = myTile,
			TargetTile = _targetTile,
			Num = 0
		};
		this.Tactical.queryTilesInRange(myTile, d, d, false, [], this.onQueryTilesHit, result);
		local tiles = [];

		for( local i = 0; i != result.Tiles.len(); i = ++i )
		{
			if (result.Tiles[i].ID == _targetTile.ID)
			{
				tiles.push(result.Tiles[i]);
				local idx = i - 1;

				if (idx < 0)
				{
					idx = idx + result.Tiles.len();
				}

				tiles.push(result.Tiles[idx]);
				idx = i - 2;

				if (idx < 0)
				{
					idx = idx + result.Tiles.len();
				}

				tiles.push(result.Tiles[idx]);
				break;
			}
		}

		foreach( t in tiles )
		{
			if (!t.IsVisibleForEntity)
			{
				continue;
			}

			if (this.Math.abs(t.Level - myTile.Level) > this.m.MaxLevelDifference || this.Math.abs(t.Level - _targetTile.Level) > this.m.MaxLevelDifference)
			{
				continue;
			}

			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, t, t.Pos.X, t.Pos.Y);
		}
	}

	function isHidden()
	{
		if (this.m.Container.getActor().isPlacedOnMap())
		{
			local actorsk = this.getContainer();
			local actor = this.getContainer().getActor();
			local mainh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (mainh != null)
			{
				if (actorsk.hasSkill("actives.quick_shot") || actorsk.hasSkill("actives.aimed_shot") || mainh.getID() == "weapon.goblin_crossbow" || mainh.getID() == "weapon.light_crossbow" || mainh.getID() == "weapon.crossbow" || mainh.getID() == "weapon.heavy_crossbow" || mainh.getID() == "weapon.named_crossbow")
				{
					return false;
				}
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
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (!actor.isAlive())
		{
			return false;
		}
		else if (actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions()))
		{
			return false;
		}
		else if (this.getContainer().hasSkill("actives.quick_shot") || this.getContainer().hasSkill("actives.aimed_shot"))
		{
			return true;
		}
		else if (item != null)
		{
			if (item.getID() == "weapon.goblin_crossbow" || item.getID() == "weapon.light_crossbow" || item.getID() == "weapon.crossbow" || item.getID() == "weapon.heavy_crossbow" || item.getID() == "weapon.named_crossbow")
			{
				return true;
			}
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

