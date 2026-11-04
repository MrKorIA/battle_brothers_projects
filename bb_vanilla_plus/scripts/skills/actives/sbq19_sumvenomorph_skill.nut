this.sbq19_sumvenomorph_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 1
	},
	function create()
	{
		this.m.ID = "actives.sbq19_sumvenomorph_skill";
		this.m.Name = "126. Summon Venomorph";
		this.m.Description = "Summon the ranged creature, Venomorph. Its attacks inflict Poisoned.";
		this.m.Icon = "ui/xx86.png";
		this.m.IconDisabled = "ui/xx86_sw.png";
		this.m.SoundOnUse = [
			"sounds/enemies/ghoul_death_01.wav",
			"sounds/enemies/ghoul_death_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsTargetingActor = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = [
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
				text = "Can be used [color=#8f1e1e]" + this.m.Skillcharge + "[/color] more times in this battle."
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "When caster level is 10 or higher: +10 Damage, Inflict bleed, Gains a bonus to Hit Chance based on the summoner\'s Ranged Skill."
			}
		];
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return this.skill.onVerifyTarget(_originTile, _targetTile) && _targetTile.IsEmpty;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcharge = this.m.Skillcharge - 1
		local entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/xxsum_venomorph", _targetTile.Coords);
		entity.setFaction(this.Const.Faction.PlayerAnimals);
		if (_user.getLevel() >= 10)
		{
			local sk = this.new("scripts/skills/actives/ai_poisonbleed_passive");
			sk.setDamage(10);
			entity.m.Skills.add(sk);
			entity.getSprite("body").setBrush("bust_longbug_02");
			entity.getBaseProperties().DamageRegularMin += 10;
			entity.getBaseProperties().DamageRegularMax += 10;
			entity.getBaseProperties().RangedSkill += this.Math.max(1, this.Math.floor(_user.getBaseProperties().RangedSkill * 0.3));
			entity.setName("Frenzied " + entity.getName());
		}
		if (this.Const.Tactical.RaiseUndeadParticles.len() != 0)
		{
			for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, _targetTile, this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
			}
			for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, _user.getTile(), this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
			}
		}
		entity.storeSpriteColors();
		entity.fadeTo(this.createColor("fc080800"), 0);
		local tag = {
			Entity = entity
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 300, this.onDelayedEffect.bindenv(this), tag);
		return true;
	}

	function onDelayedEffect( _tag )
	{
		_tag.Entity.fadeToStoredColors(500);
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

