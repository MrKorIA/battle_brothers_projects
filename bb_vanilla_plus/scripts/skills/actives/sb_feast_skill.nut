this.sb_feast_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sb_feast_skill";
		this.m.Name = "22. Пир";
		this.m.Description = "Питайтесь трупом, чтобы восстановить здоровье и снять усталость.";
		this.m.Icon = "ui/xx1.png";
		this.m.IconDisabled = "ui/xx1_sw.png";
		this.m.SoundOnUse = [
			"sounds/enemies/gruesome_feast_01.wav",
			"sounds/enemies/gruesome_feast_02.wav",
			"sounds/enemies/gruesome_feast_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAudibleWhenHidden = false;
		this.m.IsUsingActorPitch = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 1;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getTooltip()
	{
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
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Восстанавливает 25 единиц здоровья и 25 единиц усталости. Устраняет все временные травмы."
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "15% вероятность получить отрицательный эффект."
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Можно использовать, когда на тайле заклинателя находится труп."
			}
		];
	}

	function isUsable()
	{
		local gg = this.getContainer().getActor().getTile()
		return !this.Tactical.isActive() || gg.IsCorpseSpawned && gg.Properties.get("Corpse").IsConsumable;
		return true;
	}

	function spawnBloodbath( _targetTile )
	{
		for( local i = 0; i != this.Const.CorpsePart.len(); i = ++i )
		{
			_targetTile.spawnDetail(this.Const.CorpsePart[i]);
		}

		for( local i = 0; i != 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);

				for( local n = this.Math.rand(0, 2); n != 0; n = --n )
				{
					local decal = this.Const.BloodDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodDecals[this.Const.BloodType.Red].len() - 1)];
					tile.spawnDetail(decal);
				}
			}
		}

		local myTile = this.getContainer().getActor().getTile();

		for( local n = 2; n != 0; n = --n )
		{
			local decal = this.Const.BloodDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodDecals[this.Const.BloodType.Red].len() - 1)];
			myTile.spawnDetail(decal);
		}
	}

	function onRemoveCorpse( _tag )
	{
		this.Tactical.Entities.removeCorpse(_tag);
		_tag.clear(this.Const.Tactical.DetailFlag.Corpse);
		_tag.Properties.remove("Corpse");
		_tag.Properties.remove("IsSpawningFlies");
	}

	function onUse( _user, _targetTile )
	{
		_targetTile = _user.getTile();

		if (_targetTile.IsVisibleForPlayer)
		{
			if (this.Const.Tactical.GruesomeFeastParticles.len() != 0)
			{
				for( local i = 0; i < this.Const.Tactical.GruesomeFeastParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.GruesomeFeastParticles[i].Brushes, _targetTile, this.Const.Tactical.GruesomeFeastParticles[i].Delay, this.Const.Tactical.GruesomeFeastParticles[i].Quantity, this.Const.Tactical.GruesomeFeastParticles[i].LifeTimeQuantity, this.Const.Tactical.GruesomeFeastParticles[i].SpawnRate, this.Const.Tactical.GruesomeFeastParticles[i].Stages);
				}
			}
		}
		this.onRemoveCorpse(_targetTile);
		this.spawnBloodbath(_targetTile);
		_user.setHitpoints(this.Math.min(_user.getHitpoints() + 25, _user.getHitpointsMax()));
		_user.setFatigue(this.Math.max(0, _user.getFatigue() - 25));
		_user.getSkills().removeByType(this.Const.SkillType.TemporaryInjury);
		_user.setDirty(true);
		_user.onUpdateInjuryLayer();
		if (this.Math.rand(1, 100) <= 15)
		{
			local effect = _user.getSkills().getSkillByID("effects.insect_swarm");
			if (effect != null)
			{
				effect.resetTime();
			}
			else
			{
				_user.getSkills().add(this.new("scripts/skills/effects/insect_swarm_effect"));
			}
			if (!_user.getCurrentProperties().IsImmuneToDaze)
			{
				_user.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
			}
			_user.getSkills().add(this.new("scripts/skills/effects/distracted_effect"));
			_user.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));
		}
		return true;
	}

});

