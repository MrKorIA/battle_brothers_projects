this.companions_xxmob_bear <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		Item = null,
		Name = "Медведь"
	},
	function create()
	{
		this.m.Type = this.Const.EntityType.XXMobBear;
		this.m.XP = this.Const.Tactical.Actor.Unhold.XP;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.IsActingImmediately = true;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(40, -20);
		this.m.DecapitateBloodAmount = 3.0;
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/bear_dead.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/unhold_flee_01.wav",
			"sounds/enemies/unhold_flee_02.wav",
			"sounds/enemies/unhold_flee_03.wav",
			"sounds/enemies/unhold_flee_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/bear_hit1.wav",
			"sounds/enemies/bear_hit2.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/bear_idle1.wav",
			"sounds/enemies/bear_idle2.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/bear_attack1.wav",
			"sounds/enemies/bear_attack2.wav"
		];
		this.m.SoundPitch = this.Math.rand(9, 11) * 0.1;
		this.m.SoundVolumeOverall = 1.25;
		this.m.AIAgent = this.new("scripts/companions/types/companions_unhold_agent");
		this.m.AIAgent.setActor(this);
	}

	function setItem( _i )
	{
		if (typeof _i == "instance")
		{
			this.m.Item = _i;
		}
		else
		{
			this.m.Item = this.WeakTableRef(_i);
		}
	}

	function setName( _n )
	{
		this.m.Name = _n;
	}

	function getName()
	{
		return this.m.Name;
	}

	function setVariant(_v)
	{
		this.getSprite("body").setBrush("bust_bear_0" + _v);
		this.setDirty(true);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			for( local i = 0; i < this.Const.Tactical.GruesomeFeastParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.GruesomeFeastParticles[i].Brushes, _tile, this.Const.Tactical.GruesomeFeastParticles[i].Delay, this.Const.Tactical.GruesomeFeastParticles[i].Quantity, this.Const.Tactical.GruesomeFeastParticles[i].LifeTimeQuantity, this.Const.Tactical.GruesomeFeastParticles[i].SpawnRate, this.Const.Tactical.GruesomeFeastParticles[i].Stages);
			}
			local flip = this.Math.rand(0, 100) < 50;
			this.m.IsCorpseFlipped = flip;
			this.spawnBloodPool(_tile, 1);
			local spriteName = this.getSprite("body").getBrush().Name;
			local corpse = clone this.Const.Corpse;
			corpse.Faction = this.getFaction();
			corpse.CorpseName = this.getName();
			corpse.Tile = _tile;
			corpse.IsHeadAttached = true;
			corpse.IsConsumable = true;
			corpse.IsResurrectable = false;
			local decal;

			if (_fatalityType == this.Const.FatalityType.Decapitated)
			{
				decal = _tile.spawnDetail(spriteName + "_body_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false);
				decal.Scale = this.Math.rand(1, 10) * 0.01 + 0.95;
				if (spriteName == "bust_bear_01") decal.Scale += 0.10;
				decal.varySaturation(0.2);
				decal.varyColor(0.2, 0.2, 0.2);
				this.spawnTerrainDropdownEffect(_tile);

				local layers = [
					spriteName + "_head_dead"
				];

				local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(0, 0), 0.0, "bust_direwolf_head_bloodpool");
				decap[0].Scale = this.Math.rand(1, 10) * 0.01 + 1.3;
			}
			else
			{
				decal = _tile.spawnDetail(spriteName + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false);
				decal.Scale = this.Math.rand(1, 10) * 0.01 + 0.95;
				if (spriteName == "bust_bear_01") decal.Scale += 0.10;
				decal.varySaturation(0.2);
				decal.varyColor(0.2, 0.2, 0.2);
				this.spawnTerrainDropdownEffect(_tile);
			}

			if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail("bust_orc_02_body_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail("bust_orc_02_body_dead_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}

		if (this.m.Item != null && !this.m.Item.isNull())
		{
			this.m.Item.setEntity(null);

			if (this.m.Item.getContainer() != null)
			{
				if (this.m.Item.getCurrentSlotType() == this.Const.ItemSlot.Bag)
				{
					this.m.Item.getContainer().removeFromBag(this.m.Item.get());
				}
				else
				{
					this.m.Item.getContainer().unequip(this.m.Item.get());
				}
			}

			this.m.Item = null;
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);

		if (!this.Tactical.State.isScenarioMode())
		{
			local f = this.World.FactionManager.getFaction(this.getFaction());

			if (f != null)
			{
				this.getSprite("socket").setBrush(f.getTacticalBase());
			}
		}
		else
		{
			this.getSprite("socket").setBrush(this.Const.FactionBase[this.getFaction()]);
		}
	}

	function onActorKilled(_actor, _tile, _skill)
	{
		this.actor.onActorKilled(_actor, _tile, _skill);

		if (this.getFaction() == this.Const.Faction.Player || this.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			local XPgroup = _actor.getXPValue();
			local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

			foreach( bro in brothers )
			{
				bro.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));

				local acc = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
				if (acc != null && "setType" in acc)
				{
					if (acc.getType() != null)
						acc.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
				}
			}
		}
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Unhold);
		b.TargetAttractionMult = 0.1;
		b.IsAffectedByInjuries = false;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		local variant = this.Math.rand(1, 2);
		this.addSprite("socket").setBrush("bust_base_beasts");
		local body = this.addSprite("body");
		body.setBrush("bust_bear_0" + variant);
		body.varySaturation(0.1);
		body.varyColor(0.04, 0.04, 0.04);
		local injury_body = this.addSprite("injury");
		injury_body.Visible = false;
		injury_body.setBrush("bust_orc_02_body_bloodied_02");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(-10, 16));
		local skilla = this.new("scripts/skills/actives/sweep_skill");
		skilla.m.Overlay = "active_154";
		this.m.Skills.add(skilla);
		skilla = this.new("scripts/skills/actives/sweep_zoc_skill");
		skilla.m.Overlay = "active_154";
		this.m.Skills.add(skilla);
	}

	function applyCompanionScaling()
	{
		local propertiesNew =
		{
			ActionPoints = 12,
			Hitpoints = this.m.Item.m.Attributes.Hitpoints,
			Stamina = this.m.Item.m.Attributes.Stamina,
			Bravery = this.m.Item.m.Attributes.Bravery,
			Initiative = this.m.Item.m.Attributes.Initiative,
			MeleeSkill = this.m.Item.m.Attributes.MeleeSkill,
			RangedSkill = this.m.Item.m.Attributes.RangedSkill,
			MeleeDefense = this.m.Item.m.Attributes.MeleeDefense,
			RangedDefense = this.m.Item.m.Attributes.RangedDefense,
			Armor = [0, 0],
			FatigueEffectMult = 1.0,
			MoraleEffectMult = 1.0,
			FatigueRecoveryRate = 20
		};
		local propertiesBase = this.m.BaseProperties;
		propertiesBase.setValues(propertiesNew);
		this.m.CurrentProperties = propertiesBase;
		this.m.Hitpoints = propertiesBase.Hitpoints;


		foreach(quirk in this.m.Item.m.Quirks)
		{
			this.m.Skills.add(this.new(quirk));
		}
		this.m.AIAgent.addQuirkBehaviors();
	}
});
