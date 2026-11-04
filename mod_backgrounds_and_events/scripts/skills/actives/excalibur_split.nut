this.excalibur_split <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.excalibur_split";
		this.m.Name = "Божественный разрез";
		this.m.Description = "Широкий рубящий удар сверху, призванный достать врага на предельной дистанции в ущерб убойной силе. Возможно, благодаря божественному благословению, рубящие удары \'Экскалибура\' достают дальше, чем позволяет размер клинка.";
		this.m.KilledString = "Рассечен надвое";
		this.m.Icon = "skills/active_07.png";
		this.m.IconDisabled = "skills/active_07_sw.png";
		this.m.Overlay = "active_07";
		this.m.SoundOnUse = [
			"sounds/combat/split_01.wav",
			"sounds/combat/split_02.wav",
			"sounds/combat/split_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/split_hit_01.wav",
			"sounds/combat/split_hit_02.wav",
			"sounds/combat/split_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAOE = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 50;
		this.m.ChanceDisembowel = 25;
		this.m.ChanceSmash = 0;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Может поразить до трёх целей"
		});

		if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInSwords)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5%[/color] к шансу на попадание"
			});
		}
		else
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] к шансу на попадание"
			});
		}

		return ret;
	}

	function onAfterUpdate( _properties )
	{
		if (::mods_getRegisteredMod("mod_msu")) {
			if (_properties.IsSpecializedInSwords) {
				this.m.FatigueCostMult *= ::Const.Combat.WeaponSpecFatigueMult;
			}
		} else {
			this.m.FatigueCostMult = _properties.IsSpecializedInSwords
				? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
		}
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSplit);
		local ret = this.attackEntity(_user, _targetTile.getEntity());

		if (!_user.isAlive() || _user.isDying())
		{
			return ret;
		}

		local ownTile = _user.getTile();
		local dir = ownTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local forwardTile = _targetTile.getNextTile(dir);

			if (forwardTile.IsOccupiedByActor && forwardTile.getEntity().isAttackable() && this.Math.abs(forwardTile.Level - ownTile.Level) <= 1)
			{
				ret = this.attackEntity(_user, forwardTile.getEntity()) || ret;
			}

			if (forwardTile.hasNextTile(dir))
			{
				local secondForwardTile = forwardTile.getNextTile(dir);

				if (secondForwardTile.IsOccupiedByActor && secondForwardTile.getEntity().isAttackable() && this.Math.abs(secondForwardTile.Level - forwardTile.Level) <= 1)
				{
					ret = this.attackEntity(_user, secondForwardTile.getEntity()) || ret;
				}
			}
		}

		return ret;
	}

	function onTargetSelected( _targetTile )
	{
		this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		local ownTile = this.m.Container.getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local forwardTile = _targetTile.getNextTile(dir);

			if (this.Math.abs(forwardTile.Level - ownTile.Level) <= 1)
			{
				this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, forwardTile, forwardTile.Pos.X, forwardTile.Pos.Y);
			}

			if (forwardTile.hasNextTile(dir))
			{
				local secondForwardTile = forwardTile.getNextTile(dir);

				if (this.Math.abs(secondForwardTile.Level - forwardTile.Level) <= 1)
				{
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, secondForwardTile, secondForwardTile.Pos.X, secondForwardTile.Pos.Y);
				}
			}
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInSwords)
			{
				_properties.MeleeSkill -= 5;
			}
			else
			{
				_properties.MeleeSkill += 5;
			}
		}
	}

});

