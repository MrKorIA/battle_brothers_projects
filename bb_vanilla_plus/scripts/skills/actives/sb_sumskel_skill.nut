this.sb_sumskel_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 2
	},
	function create()
	{
		this.m.ID = "actives.sb_sumskel_skill";
		this.m.Name = "66. Воскресить мертвого";
		this.m.Description = "Воскрешает труп в виде скелета-приспешника. \n[color=#8f1e1e]Требование:[/color] В целевом месте должно находиться тело.";
		this.m.Icon = "ui/xx22.png";
		this.m.IconDisabled = "ui/xx22_sw.png";
		this.m.SoundOnUse = [
			"sounds/enemies/gruesome_feast_01.wav",
			"sounds/enemies/gruesome_feast_02.wav",
			"sounds/enemies/gruesome_feast_03.wav"
		];
		this.m.SoundVolume = 1.2;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 229;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 5;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Может использоваться [color=#8f1e1e]" + this.m.Skillcharge + "[/color] еще несколько раз в этой битве."
		});
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (!_targetTile.IsCorpseSpawned)
		{
			return false;
		}

		if (!_targetTile.IsEmpty)
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcharge = this.m.Skillcharge - 1
		local entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/xxsum_skeleton", _targetTile.Coords);
		entity.setFaction(this.Const.Faction.PlayerAnimals);
		entity.riseFromGround(0.7);
		for( local i = 0; i < this.Const.Tactical.KrakenDevourParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.KrakenDevourParticles[i].Brushes, _targetTile, this.Const.Tactical.KrakenDevourParticles[i].Delay, this.Const.Tactical.KrakenDevourParticles[i].Quantity, this.Const.Tactical.KrakenDevourParticles[i].LifeTimeQuantity, this.Const.Tactical.KrakenDevourParticles[i].SpawnRate, this.Const.Tactical.KrakenDevourParticles[i].Stages);
		}
		for( local i = 0; i < this.Const.Tactical.KrakenDevourVictimParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.KrakenDevourVictimParticles[i].Brushes, _targetTile, this.Const.Tactical.KrakenDevourVictimParticles[i].Delay, this.Const.Tactical.KrakenDevourVictimParticles[i].Quantity, this.Const.Tactical.KrakenDevourVictimParticles[i].LifeTimeQuantity, this.Const.Tactical.KrakenDevourVictimParticles[i].SpawnRate, this.Const.Tactical.KrakenDevourVictimParticles[i].Stages);
		}
		this.Tactical.Entities.removeCorpse(_targetTile);
		_targetTile.clear(this.Const.Tactical.DetailFlag.Corpse);
		_targetTile.Properties.remove("Corpse");
		_targetTile.Properties.remove("IsSpawningFlies");
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
		this.m.Skillcharge = 2;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.sb2_sumskel_skill"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/sb2_sumskel_skill"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.sb2_sumskel_skill");
	}

});

