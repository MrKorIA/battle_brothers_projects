this.tudun <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.tudun";
		this.m.Name = "Тотон";
		this.m.Description = "Прячься в скалах, двигайся под песками, появляйся и неси смерть.";
		this.m.Icon = "skills/tudun.png";
		this.m.IconDisabled = "skills/tudun_sw.png";
		this.m.Overlay = "tudun";
		this.m.SoundOnUse = [
			"sounds/combat/tudun.wav",
		];
		this.m.SoundOnHit = [
			"sounds/combat/tudun.wav",
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local p = this.getContainer().getActor().getCurrentProperties();
		return [
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
			}
		];
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!_targetTile.IsEmpty)
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile,
			OnDone = this.onTeleportDone,
			OnFadeIn = this.onFadeIn,
			OnFadeDone = this.onFadeDone,
			OnTeleportStart = this.onTeleportStart,
			IgnoreColors = false
		};

		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " использует Тотон");
		}

		if (_user.getTile().IsVisibleForPlayer)
		{
			if (this.Const.Tactical.SmokeParticles.len() != 0)
			{
				for( local i = 0; i < this.Const.Tactical.SmokeParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.SmokeParticles[i].Brushes, _user.getTile(), this.Const.Tactical.SmokeParticles[i].Delay, this.Const.Tactical.SmokeParticles[i].Quantity, this.Const.Tactical.SmokeParticles[i].LifeTimeQuantity, this.Const.Tactical.SmokeParticles[i].SpawnRate, this.Const.Tactical.SmokeParticles[i].Stages);
				}
			}

			_user.storeSpriteColors();
			_user.fadeTo(this.createColor("00000000"), 400);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 400, this.onTeleportStart, tag);
		}
		else if (_targetTile.IsVisibleForPlayer)
		{
			_user.storeSpriteColors();
			_user.fadeTo(this.createColor("00000000"), 0);
			this.onTeleportStart(tag);
		}
		else
		{
			tag.IgnoreColors = true;
			this.onTeleportStart(tag);
		}

		return true;
	}

	function onTeleportStart( _tag )
	{
		this.Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, _tag.OnDone, _tag, false, 2.0);
	}

	function onTeleportDone( _entity, _tag )
	{
		if (!_entity.isHiddenToPlayer())
		{
			if (this.Const.Tactical.SmokeParticles.len() != 0)
			{
				for( local i = 0; i < this.Const.Tactical.SmokeParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.SmokeParticles[i].Brushes, _entity.getTile(), this.Const.Tactical.SmokeParticles[i].Delay, this.Const.Tactical.SmokeParticles[i].Quantity, this.Const.Tactical.SmokeParticles[i].LifeTimeQuantity, this.Const.Tactical.SmokeParticles[i].SpawnRate, this.Const.Tactical.SmokeParticles[i].Stages);
				}
			}

			this.Time.scheduleEvent(this.TimeUnit.Virtual, 800, _tag.OnFadeIn, _tag);

			if (_entity.getTile().IsVisibleForPlayer && _tag.Skill.m.SoundOnHit.len() > 0)
			{
				this.Sound.play(_tag.Skill.m.SoundOnHit[this.Math.rand(0, _tag.Skill.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _entity.getPos());
			}
		}
		else
		{
			_tag.OnFadeIn(_tag);
		}
	}

	function onFadeIn( _tag )
	{
		if (!_tag.IgnoreColors)
		{
			if (_tag.User.isHiddenToPlayer())
			{
				_tag.User.restoreSpriteColors();
			}
			else
			{
				_tag.User.fadeToStoredColors(500);
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, _tag.OnFadeDone, _tag);
			}
		}
	}

	function onFadeDone( _tag )
	{
		_tag.User.restoreSpriteColors();
	}

});

