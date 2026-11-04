this.sb_pull2_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 1
	},
	function create()
	{
		this.m.ID = "actives.sb_pull2_skill";
		this.m.Name = "49. Хватка Бездны";
		this.m.Description = "Притягивает к себе удаленную вражескую цель и связывает ее щупальцами.";
		this.m.Icon = "ui/xx72.png";
		this.m.IconDisabled = "ui/xx72_sw.png";
		this.m.Overlay = "active_149";
		this.m.SoundOnUse = [
			"sounds/enemies/lindwurm_gorge_hit_01.wav",
			"sounds/enemies/lindwurm_gorge_hit_02.wav",
			"sounds/enemies/lindwurm_gorge_hit_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/break_free_roots_00.wav",
			"sounds/combat/break_free_roots_01.wav",
			"sounds/combat/break_free_roots_02.wav",
			"sounds/combat/break_free_roots_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 25;
		this.m.MinRange = 2;
		this.m.MaxRange = 4;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет радиус действия " + this.getMaxRange() + " клеток."
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Воздействие на цель: Невозможность двигаться. Удаляет стену щитов /стену копий / ответный удар. -50% к защите в ближнем и дальнем бою. -70% к шансу попасть по врагам. Получает 10 ~ 15 единиц урона за ход. (Этот урон навсегда парализует врагов, а не убивает их)."
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Можно использовать ещё [color=#8f1e1e]" + this.m.Skillcharge + "[/color] раз(а) в этом бою."
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcharge = this.m.Skillcharge - 1;
		local target = _targetTile.getEntity();
		local knockToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);
		local skills = target.getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");
		this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, target.getPos());
		for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, _targetTile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity, this.Const.Tactical.DustParticles[i].LifeTimeQuantity, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
		}

		local ensnare = this.new("scripts/skills/effects/sb_snake_target_effect");
		ensnare.m.Icon = "skills/status_effect_95.png";
		ensnare.m.IconMini = "status_effect_95_mini";
		ensnare.m.Overlay = "status_effect_95";
		target.getSkills().add(ensnare);

		local breakFree = this.new("scripts/skills/actives/break_free_skill");
		breakFree.m.Icon = "skills/active_148.png";
		breakFree.m.IconDisabled = "skills/active_148_sw.png";
		breakFree.m.Overlay = "active_148";
		if (Math.rand(1, 2) == 1)
		{
			breakFree.setDecal(this.Const.BloodDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodDecals[this.Const.BloodType.Red].len() - 1)]);
		}
		else
		{
			breakFree.setDecal("bust_kraken_tentacle_body_dead");
		}
		breakFree.m.SoundOnUse = this.m.SoundOnHit;
		breakFree.m.SoundVolume = 0.9;
		breakFree.setChanceBonus(-10);
		target.getSkills().add(breakFree);

		local rooted = target.getSprite("status_rooted");
		local rooted_back = target.getSprite("status_rooted_back");
		if (Math.rand(1, 2) == 1)
		{
			rooted.setBrush("kraken_ensnare_front");
			rooted_back.setBrush("kraken_ensnare_back");
		}
		else
		{
			rooted.setBrush("kraken_ensnare_front_injured");
			rooted_back.setBrush("kraken_ensnare_back_2");
		}
		rooted.Scale = 1.0;
		rooted_back.Scale = 1.0;
		rooted.Visible = true;
		rooted_back.Visible = true;
		target.setDirty(true);

		if (knockToTile == null)
		{
			knockToTile = _targetTile;
		}

		this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onDone, {
			Target = target,
			KnockToTile = knockToTile,
			Skill = this
		});
	}

	function onDone( _data )
	{
		this.Tactical.getNavigator().teleport(_data.Target, _data.KnockToTile, null, null, true, 5);
		for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, _data.KnockToTile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity, this.Const.Tactical.DustParticles[i].LifeTimeQuantity, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
		}
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		local dir = _userTile.getDirectionTo(_targetTile);
		if (_userTile.hasNextTile(dir))
		{
			local tile = _userTile.getNextTile(dir);
			if (tile.IsEmpty && tile.Level - _userTile.Level <= 1)
			{
				return tile;
			}
		}

		dir = dir - 1 >= 0 ? dir - 1 : 5;
		if (_userTile.hasNextTile(dir))
		{
			local tile = _userTile.getNextTile(dir);
			if (tile.IsEmpty && tile.Level - _userTile.Level <= 1)
			{
				return tile;
			}
		}

		dir = _targetTile.getDirectionTo(_userTile);
		dir = dir + 1 <= 5 ? dir + 1 : 0;
		if (_userTile.hasNextTile(dir))
		{
			local tile = _userTile.getNextTile(dir);
			if (tile.IsEmpty && tile.Level - _userTile.Level <= 1)
			{
				return tile;
			}
		}

		for( local i = 5; i >= 0; i = --i )
		{
			if (!_userTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _userTile.getNextTile(i);
				if (tile.IsEmpty && this.Math.abs(tile.Level - _userTile.Level) <= 1)
				{
					return tile;
				}
			}
		}
		return null;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (_targetTile.getEntity().getCurrentProperties().IsImmuneToKnockBackAndGrab || _targetTile.getEntity().getCurrentProperties().IsRooted || _targetTile.getEntity().getCurrentProperties().IsImmuneToRoot)
		{
			return false;
		}

		local MoveTo = this.findTileToKnockBackTo(_originTile, _targetTile);
		if (MoveTo == null)
		{
			return false;
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

