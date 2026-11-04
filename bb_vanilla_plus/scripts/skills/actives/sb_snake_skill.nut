this.sb_snake_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 3
	},
	function create()
	{
		this.m.ID = "actives.sb_snake_skill";
		this.m.Name = "Змеиные оковы";
		this.m.Description = "Связывает заклинателя и цель двумя гигантскими змеями. При освобождении от заклинания, освобождаются оба.";
		this.m.Icon = "ui/xx71.png";
		this.m.IconDisabled = "ui/xx71_sw.png";
		this.m.Overlay = "active_192";
		this.m.SoundOnUse = [
			"sounds/enemies/goblin_roots_01.wav",
			"sounds/enemies/goblin_roots_02.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/lindwurm_flee_01.wav",
			"sounds/enemies/lindwurm_flee_02.wav",
			"sounds/enemies/lindwurm_flee_03.wav",
			"sounds/enemies/lindwurm_flee_04.wav"
		];
		this.m.SoundVolume = 1.2,
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 9;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 4;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Эффект на цель: невозможность двигаться. Удаляет состояния стена щитов / стена копий / контратаку. -50% к защите в ближнем и дальнем бою. -70% к шансу поразить врага. Получает 10-15 единиц урона за ход. (Этот урон наносит врагам постоянные повреждения, а не убивает их)."
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Может использоваться [color=#8f1e1e]" + this.m.Skillcharge + "[/color] раз(а) в этой битве."
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcharge = this.m.Skillcharge - 1;
		local target = _targetTile.getEntity();
		local skills = target.getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");
		this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, target.getPos());

		local scaleBackup1 = target.getSprite("status_rooted").Scale;
		local scaleBackup2 = target.getSprite("status_rooted_back").Scale;
		local rooted = target.getSprite("status_rooted");
		rooted.setBrush("");
		rooted.Scale = 1.0;
		rooted.Visible = true;
		local rooted_back = target.getSprite("status_rooted_back");
		rooted_back.setBrush("");
		rooted_back.Scale = 1.0;
		rooted_back.Visible = true;
		rooted.setBrush("snake_ensnare_front_01");
		rooted_back.setBrush("snake_ensnare_back_01");
		target.setDirty(true);

		local scaleBackup3 = _user.getSprite("status_rooted").Scale;
		local scaleBackup4 = _user.getSprite("status_rooted_back").Scale;
		rooted = _user.getSprite("status_rooted");
		rooted.setBrush("");
		rooted.Scale = 1.0;
		rooted.Visible = true;
		rooted_back = _user.getSprite("status_rooted_back");
		rooted_back.setBrush("");
		rooted_back.Scale = 1.0;
		rooted_back.Visible = true;
		rooted.setBrush("snake_ensnare_front_02");
		rooted_back.setBrush("snake_ensnare_back_02");
		_user.setDirty(true);

		_user.getSkills().setBusy(true);
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 1, this.onDone, {
			User = _user,
			Target = target,
			ScaleBackup1 = scaleBackup1,
			ScaleBackup2 = scaleBackup2,
			ScaleBackup3 = scaleBackup3,
			ScaleBackup4 = scaleBackup4,
			Skill = this
		});
	}

	function onDone( _data )
	{
		local ensnare = this.new("scripts/skills/effects/sb_snake_target_effect");
		ensnare.setOnRemoveCallback(function ( _data )
		{
			local targetTile = _data.Target.getTile();
			local tile;
			local n = this.Const.BloodType.Red;
			for( local i = 0; i < this.Const.Tactical.BloodEffects[n].len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BloodEffects[n][i].Brushes, targetTile, this.Const.Tactical.BloodEffects[n][i].Delay, this.Const.Tactical.BloodEffects[n][i].Quantity, this.Const.Tactical.BloodEffects[n][i].LifeTimeQuantity, this.Const.Tactical.BloodEffects[n][i].SpawnRate, this.Const.Tactical.BloodEffects[n][i].Stages);
			}
			local rooted = _data.Target.getSprite("status_rooted");
			rooted.Scale = _data.ScaleBackup1;
			rooted.setBrush("");
			rooted.Visible = false;
			local rooted_back = _data.Target.getSprite("status_rooted_back");
			rooted_back.Scale = _data.ScaleBackup2;
			rooted_back.setBrush("");
			rooted_back.Visible = false;
			if (_data.User.isAlive() && _data.User.getSkills().hasSkill("effects.net") && _data.User.getSkills().hasSkill("actives.break_free"))
			{
				_data.User.getSkills().removeByID("effects.net");
				rooted = _data.User.getSprite("status_rooted");
				rooted.Scale = _data.ScaleBackup3;
				rooted.setBrush("");
				rooted.Visible = false;
				local rooted_back = _data.User.getSprite("status_rooted_back");
				rooted_back.setBrush("");
				rooted_back.Scale = _data.ScaleBackup4;
				rooted_back.Visible = false;
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 1, function ( _skill )
				{
					_data.User.getSkills().removeByID("actives.break_free");
				}.bindenv(this), this);
			}
		}, _data);
		_data.Target.getSkills().add(ensnare);
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
			breakFree.setDecal("bust_snake_body_01_dead");
		}
		breakFree.m.SoundOnUse = _data.Skill.m.SoundOnHit;
		breakFree.m.SoundVolume = 0.9;
		breakFree.setChanceBonus(-20);
		_data.Target.getSkills().add(breakFree);

		ensnare = this.new("scripts/skills/effects/sb_snake_caster_effect");
		ensnare.setOnRemoveCallback(function ( _data )
		{
			local targetTile = _data.User.getTile();
			local tile;
			local n = _data.User.m.BloodType;
			for( local i = 0; i < this.Const.Tactical.BloodEffects[n].len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BloodEffects[n][i].Brushes, targetTile, this.Const.Tactical.BloodEffects[n][i].Delay, this.Const.Tactical.BloodEffects[n][i].Quantity, this.Const.Tactical.BloodEffects[n][i].LifeTimeQuantity, this.Const.Tactical.BloodEffects[n][i].SpawnRate, this.Const.Tactical.BloodEffects[n][i].Stages);
			}
			local rooted = _data.User.getSprite("status_rooted");
			rooted.Scale = _data.ScaleBackup3;
			rooted.setBrush("");
			rooted.Visible = false;
			local rooted_back = _data.User.getSprite("status_rooted_back");
			rooted_back.Scale = _data.ScaleBackup4;
			rooted_back.setBrush("");
			rooted_back.Visible = false;
			if (_data.Target.isAlive() && _data.Target.getSkills().hasSkill("effects.net") && _data.Target.getSkills().hasSkill("actives.break_free"))
			{
				_data.Target.getSkills().removeByID("effects.net");
				rooted = _data.Target.getSprite("status_rooted");
				rooted.Scale = _data.ScaleBackup1;
				rooted.setBrush("");
				rooted.Visible = false;
				local rooted_back = _data.Target.getSprite("status_rooted_back");
				rooted_back.setBrush("");
				rooted_back.Scale = _data.ScaleBackup2;
				rooted_back.Visible = false;
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 1, function ( _skill )
				{
					_data.Target.getSkills().removeByID("actives.break_free");
				}.bindenv(this), this);
			}
		}, _data);
		_data.User.getSkills().add(ensnare);
		breakFree = this.new("scripts/skills/actives/break_free_skill");
		breakFree.m.Icon = "skills/active_148.png";
		breakFree.m.IconDisabled = "skills/active_148_sw.png";
		breakFree.m.Overlay = "active_191";
		if (Math.rand(1, 2) == 1)
		{
			breakFree.setDecal(this.Const.BloodDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodDecals[this.Const.BloodType.Red].len() - 1)]);
		}
		else
		{
			breakFree.setDecal("bust_snake_body_02_dead");
		}
		breakFree.m.SoundOnUse = _data.Skill.m.SoundOnHit;
		breakFree.m.SoundVolume = 0.9;
		breakFree.setChanceBonus(100);
		_data.User.getSkills().add(breakFree);

		_data.User.getSkills().setBusy(false);
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (_targetTile.getEntity().getCurrentProperties().IsRooted || _targetTile.getEntity().getCurrentProperties().IsImmuneToRoot)
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
		local actor = this.getContainer().getActor();
		if (actor.getCurrentProperties().IsRooted)
		{
			return false;
		}
		else if (actor.getCurrentProperties().IsImmuneToRoot)
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
		this.m.Skillcharge = 3;
	}

});

