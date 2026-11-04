this.sbq24_spikeshower_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 3,
		Skillcool = 3
	},
	function create()
	{
		this.m.ID = "actives.sbq24_spikeshower_skill";
		this.m.Name = "131. Spike Shower";
		this.m.Description = "Attacks 4 tiles in a cone shape. (Melee Skill)\n[color=#8f1e1e]Requirements:[/color] Spear, Polearm";
		this.m.Icon = "ui/xx89.png";
		this.m.IconDisabled = "ui/xx89_sw.png";
		this.m.SoundOnUse = [
			"sounds/combat/thrust_01.wav",
			"sounds/combat/thrust_02.wav",
			"sounds/combat/thrust_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/thrust_hit_01.wav",
			"sounds/combat/thrust_hit_02.wav",
			"sounds/combat/thrust_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 227;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.IsTargetingActor = false;
		this.m.IsAOE = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 5;
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
			icon = "ui/icons/special.png",
			text = "Damage: [color=" + this.Const.UI.Color.PositiveValue + "]80% current weapon damage[/color]"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Cooldown: 3 turn \nCooldown left: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] turn"
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		local myTile = _user.getTile();
		local affectedTiles = this.getAffectedTiles(_targetTile);
		local targetEntity = _targetTile.getEntity();
		local tnum = affectedTiles.len();
		for( local i = 0; i < tnum + tnum; i++ )
		{
			local t;
			if (i < tnum) 
			{
				t = affectedTiles[i];
			}
			else 
			{
				t = affectedTiles[i - tnum];
			}
			this.Time.scheduleEvent(this.TimeUnit.Virtual,  i * 90, function ( _skill ) {
				local flip = !_skill.m.IsProjectileRotated && t.Pos.X > _user.getPos().X;
				this.Tactical.spawnProjectileEffect("effect_impale_N", myTile, t, 2, 1.1, true, flip);
				this.Tactical.spawnProjectileEffect("effect_impale_N", myTile, t, 2, 1.6, true, flip);
				this.Sound.play(_skill.m.SoundOnUse[this.Math.rand(0, _skill.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill, myTile.Pos);
			}.bindenv(this), this);
		}
		local tag = {
			Skill = this,
			User = _user,
			Targets = affectedTiles
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 600, this.applyEffectToTargets.bindenv(this), tag);
		return true;
	}

	function applyEffectToTargets( _tag )
	{
		local user = _tag.User;
		local targets = _tag.Targets;
		foreach( t in targets )
		{
			if (!t.IsOccupiedByActor || !t.getEntity().isAttackable())
			{
				continue;
			}
			local target = t.getEntity();
			this.attackEntity(user, target, false);
		}
	}

	function onTargetSelected( _targetTile )
	{
		local affectedTiles = this.getAffectedTiles(_targetTile);
		foreach( t in affectedTiles )
		{
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, t, t.Pos.X, t.Pos.Y);
		}
	}

	function getAffectedTiles( _targetTile )
	{
		local ret = [
			_targetTile
		];
		local ownTile = this.m.Container.getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local forwardTile = _targetTile.getNextTile(dir);

			if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
			{
				ret.push(forwardTile);
			}
		}

		local left = dir - 1 < 0 ? 5 : dir - 1;

		if (_targetTile.hasNextTile(left))
		{
			local forwardTile = _targetTile.getNextTile(left);

			if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
			{
				ret.push(forwardTile);
			}
		}

		local right = dir + 1 > 5 ? 0 : dir + 1;

		if (_targetTile.hasNextTile(right))
		{
			local forwardTile = _targetTile.getNextTile(right);

			if (this.Math.abs(forwardTile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
			{
				ret.push(forwardTile);
			}
		}

		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageTotalMult *= 0.8;
			local actor = this.getContainer().getActor();
			local mainh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (mainh != null)
			{
				this.m.DirectDamageMult = mainh.m.DirectDamageMult;
			}
		}
	}

	function onAfterUpdate( _properties )
	{
		local isSpecialized = _properties.IsSpecializedInSpears || _properties.IsSpecializedInPolearms;
		this.m.FatigueCostMult = isSpecialized ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function isHidden()
	{
		if (this.m.Container.getActor().isPlacedOnMap() && 
		!this.getContainer().hasSkill("actives.thrust") && !this.getContainer().hasSkill("actives.prong") &&
		!this.getContainer().hasSkill("actives.impale") && !this.getContainer().hasSkill("actives.strike") && !this.getContainer().hasSkill("actives.rupture"))
		{
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
		else if (this.getContainer().hasSkill("actives.thrust") || this.getContainer().hasSkill("actives.prong") ||
		this.getContainer().hasSkill("actives.impale") || this.getContainer().hasSkill("actives.strike") || this.getContainer().hasSkill("actives.rupture"))
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

