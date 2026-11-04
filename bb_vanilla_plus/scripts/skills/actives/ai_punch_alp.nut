this.ai_punch_alp <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.ai_punch";
		this.m.Name = "True Nightmare";
		this.m.Description = "";
		this.m.Icon = "skills/active_102.png";
		this.m.IconDisabled = "skills/active_102.png";
		this.m.Overlay = "active_102";
		this.m.SoundOnUse = [
			"sounds/enemies/horror_spell_01.wav",
			"sounds/enemies/horror_spell_02.wav",
			"sounds/enemies/horror_spell_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 4;
		this.m.MaxLevelDifference = 4;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local xxtile = target.getTile();
		if (this.Math.rand(1, 100) <= 50)
		{
			target.checkMorale(-1, 0, this.Const.MoraleCheckType.MentalAttack);
		}
		else
		{
			target.checkMorale(-1, -15, this.Const.MoraleCheckType.MentalAttack);
		}
		if (!target.checkMorale(0, -5, this.Const.MoraleCheckType.MentalAttack))
		{
			if (!target.getCurrentProperties().IsStunned && !target.getCurrentProperties().IsImmuneToStun)
			{
				target.getSkills().add(this.new("scripts/skills/effects/horrified_effect"));
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " is horrified");
				}
			}
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = 10;
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			target.onDamageReceived(_user, this, hitInfo);
		}
		local p = {
			Type = "alpfog",
			Tooltip = "Nightmare fog lingers here, harmful to any living being",
			IsPositive = false,
			IsAppliedAtRoundStart = false,
			IsAppliedAtTurnEnd = true,
			IsAppliedOnMovement = false,
			IsAppliedOnEnter = false,
			IsByPlayer = false,
			Timeout = this.Time.getRound() + 2,
			Callback = onApplyMagicFire,
			function Applicable( _a )
			{
				return true;
			}
		};

		if (xxtile.Properties.Effect != null && xxtile.Properties.Effect.Type == "alpfog")
		{
			xxtile.Properties.Effect.Timeout = this.Time.getRound() + 2;
		}
		else
		{
			if (xxtile.Properties.Effect != null)
			{
				this.Tactical.Entities.removeTileEffect(xxtile);
			}
			xxtile.Properties.Effect = clone p;
			local pparticles = [];
			for( local i = 0; i < this.Const.Tactical.AlpFogParticles.len(); i = ++i )
			{
				pparticles.push(this.Tactical.spawnParticleEffect(false, this.Const.Tactical.AlpFogParticles[i].Brushes, xxtile, this.Const.Tactical.AlpFogParticles[i].Delay, this.Const.Tactical.AlpFogParticles[i].Quantity, this.Const.Tactical.AlpFogParticles[i].LifeTimeQuantity, this.Const.Tactical.AlpFogParticles[i].SpawnRate, this.Const.Tactical.AlpFogParticles[i].Stages));
			}
			this.Tactical.Entities.addTileEffect(xxtile, xxtile.Properties.Effect, pparticles);
		}

		local Mtile;
		local tileG = [];
		for( local i = 0; i < 6; i = ++i )
		{
			if (!xxtile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = xxtile.getNextTile(i);
				if (!nextTile.IsEmpty || this.Math.abs(nextTile.Level - xxtile.Level) > 1)
				{
				}
				else
				{
					tileG.push(nextTile);
				}

				if (nextTile.Properties.Effect != null && nextTile.Properties.Effect.Type == "alpfog")
				{
					nextTile.Properties.Effect.Timeout = this.Time.getRound() + 2;
				}
				else
				{
					if (nextTile.Properties.Effect != null)
					{
						this.Tactical.Entities.removeTileEffect(nextTile);
					}
					nextTile.Properties.Effect = clone p;
					local particles = [];
					for( local i = 0; i < this.Const.Tactical.AlpFogParticles.len(); i = ++i )
					{
						particles.push(this.Tactical.spawnParticleEffect(false, this.Const.Tactical.AlpFogParticles[i].Brushes, nextTile, this.Const.Tactical.AlpFogParticles[i].Delay, this.Const.Tactical.AlpFogParticles[i].Quantity, this.Const.Tactical.AlpFogParticles[i].LifeTimeQuantity, this.Const.Tactical.AlpFogParticles[i].SpawnRate, this.Const.Tactical.AlpFogParticles[i].Stages));
					}
					this.Tactical.Entities.addTileEffect(nextTile, nextTile.Properties.Effect, particles);
				}
			}
		}
		if (tileG.len() > 0)
		{
			Mtile = tileG[this.Math.rand(0, tileG.len() - 1)];
		}
		if (Mtile != null)
		{
			local spawn = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/xxmob_alps", Mtile.Coords);
			spawn.riseFromGround();
			spawn.setFaction(_user.getFaction());
			spawn.m.XP = spawn.m.XP * 0;
			spawn.getFlags().add("xxalpson");
			for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, Mtile, this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
			}
			local selfkill = this.new("scripts/skills/effects/ai_selfkill_effect");
			spawn.m.Skills.add(selfkill);
			selfkill.setTurns(2);
		}
	}

	function onApplyMagicFire( _tile, _entity )
	{
		if (_entity.getFlags().has("xxalpmom") || _entity.getFlags().has("xxalpson") || _entity.getFlags().has("undead"))
		{
			return;
		}

		this.Tactical.spawnIconEffect("status_effect_102", _tile, this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
		local sounds = [];
		if (_entity.getFlags().has("human"))
		{
			sounds = [
				"sounds/humans/human_coughing_01.wav",
				"sounds/humans/human_coughing_02.wav",
				"sounds/humans/human_coughing_03.wav",
				"sounds/humans/human_coughing_04.wav"
			];
		}
		else
		{
			sounds = [
				"sounds/enemies/miasma_appears_01.wav",
				"sounds/enemies/miasma_appears_02.wav",
				"sounds/enemies/miasma_appears_03.wav"
			];
		}
		this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], this.Const.Sound.Volume.Actor, _entity.getPos());
		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = 5;
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		_tile.getEntity().onDamageReceived(_entity, null, hitInfo);
	}

});

