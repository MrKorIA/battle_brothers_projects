this.xxmob_necromancer <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.Necromancer;
		this.m.Name = this.Const.Strings.EntityName[this.m.Type] + " " + this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)];
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Necromancer.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.Necromancer;
		this.m.Hairs = this.Const.Hair.Necromancer;
		this.m.HairColors = this.Const.HairColors.Zombie;
		this.m.Beards = this.Const.Beards.Raider;
		this.m.ConfidentMoraleBrush = "icon_confident_undead";
		this.m.SoundPitch = 0.9;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/necromancer_agent");
		this.m.AIAgent.setActor(this);
		this.getFlags().add("xomob_necromancer");
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Necromancer);
		b.Hitpoints += this.Math.floor(this.World.getTime().Days * 0.5) + 300;
		b.Bravery += 100;
		b.Stamina += 100;
		b.MeleeSkill += 15;
		b.MeleeDefense += 15;
		b.RangedDefense += 15;
		b.TargetAttractionMult = 3.0;
		b.IsAffectedByNight = false;
		b.Vision = 8;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_undead");
		this.getSprite("head").Color = this.createColor("#ffffff");
		this.getSprite("head").Saturation = 1.0;
		this.getSprite("body").Saturation = 0.6;
		this.m.Skills.add(this.new("scripts/skills/actives/ai_raise_undead"));
		this.m.Skills.add(this.new("scripts/skills/actives/possess_undead_skill"));
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.human.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function assignRandomEquipment()
	{
		local r = this.Math.rand(1, 2);
		if (r <= 1)
		{
			this.m.Items.equip(this.new("scripts/items/armor/ragged_dark_surcoat"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/armor/thick_dark_tunic"));
		}
		r = this.Math.rand(1, 3);
		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/witchhunter_hat"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/dark_cowl"));
		}
		else if (r == 3)
		{
			local hood = this.new("scripts/items/helmets/hood");
			hood.setVariant(63);
			this.m.Items.equip(hood);
		}
		local weapons = this.new("scripts/items/weapons/named/named_sword");
		weapons.m.IsDroppedAsLoot = false;
		this.m.Items.equip(weapons);
		this.m.Items.addToBag(this.new("scripts/items/weapons/arming_sword"));
		this.getSprite("miniboss").setBrush("bust_miniboss");
		this.m.ActionPoints = 9;
		this.m.BaseProperties.ActionPoints = 9;
		this.m.Skills.update();
	}

	function onTurnStart()
	{
		this.actor.onTurnStart();
		if (this.Tactical.Entities.isEnemyRetreating() || this.Tactical.State.isAutoRetreat() || !this.m.IsAlive || this.m.IsDying)
		{
			return;
		}
		if (this.Time.getRound() > 1)
		{
			return;
		}
		local myTile = this.getTile();
		for( local i = 0; i < 2; i = ++i )
		{
			local mapSize = this.Tactical.getMapSize();
			for( local attempts = 0; attempts < 500; attempts = ++attempts )
			{
				local x = this.Math.rand(this.Math.max(0, myTile.SquareCoords.X - 2), this.Math.min(mapSize.X - 1, myTile.SquareCoords.X + 8));
				local y = this.Math.rand(this.Math.max(0, myTile.SquareCoords.Y - 8), this.Math.min(mapSize.Y - 1, myTile.SquareCoords.Y + 8));
				local tile = this.Tactical.getTileSquare(x, y);
				if (!tile.IsEmpty)
				{
				}
				else
				{
					local spawn = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/zombie_yeoman", tile.Coords);
					spawn.m.Items.equip(this.new("scripts/items/weapons/greenskins/orc_axe_2h"));
					spawn.getBaseProperties().MeleeSkill += 15;
					spawn.getBaseProperties().Hitpoints = this.Math.floor(this.World.getTime().Days * 0.5) + 150;
					spawn.m.Name = spawn.m.Name + " " + this.Const.Strings.FallenHeroTitles[5];
					spawn.m.XP = spawn.m.XP * 0;
					spawn.assignRandomEquipment();
					spawn.setFaction(this.getFaction());
					spawn.riseFromGround();
					local allies = this.Tactical.Entities.getInstancesOfFaction(this.getFaction());
					for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
					{		
						this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, tile, this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
					}
					break;
				}
			}
		}
	}

	function onTurnEnd()
	{
		this.actor.onTurnEnd();
		if (this.Tactical.Entities.isEnemyRetreating() || this.Tactical.State.isAutoRetreat() || !this.m.IsAlive || this.m.IsDying)
		{
			return;
		}
		local r = 0;
		local rr = 0;
		local rrr = 0;
		local chks = this.Tactical.Entities.getInstancesOfFaction(this.actor.getFaction());
		foreach( a in chks )
		{
			if (a.getFaction() == this.actor.getFaction() && a.getFlags().has("zombie_minion"))
			{
				r = r + 1;
			}
			if (a.getFaction() == this.actor.getFaction() && a.getFlags().has("xomob_necromancer_sum"))
			{
				rr = rr + 1;
			}
			if (a.getFaction() == this.actor.getFaction() && a.getFlags().has("xomob_necromancer"))
			{
				rrr = rrr + 1;
			}
		}
		if (r >= rrr || rr >= rrr)
		{
			return;
		}

		local xxtile = this.actor.getTile();
		if (!xxtile.IsOccupiedByActor || xxtile.IsEmpty)
		{
			return;
		}

		local tile;
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
			}
		}
		if (tileG.len() > 0)
		{
			tile = tileG[this.Math.rand(0, tileG.len() - 1)];
		}
		if (tile != null)
		{
			local sounds = [
				"sounds/enemies/zombie_rise_01.wav",
				"sounds/enemies/zombie_rise_02.wav",
				"sounds/enemies/zombie_rise_03.wav",
				"sounds/enemies/zombie_rise_04.wav"
			];
			local spawnlist = [
				"scripts/entity/tactical/enemies/zombie_yeoman",
				"scripts/entity/tactical/enemies/zombie"
			];
			local spawn = this.Tactical.spawnEntity(spawnlist[this.Math.rand(0, spawnlist.len() - 1)], tile.Coords);
			spawn.getBaseProperties().MeleeSkill += 15;
			spawn.m.XP = spawn.m.XP * 0;
			spawn.assignRandomEquipment();
			spawn.setFaction(this.getFaction());
			spawn.riseFromGround();
			spawn.getFlags().add("xomob_necromancer_sum");
			local allies = this.Tactical.Entities.getInstancesOfFaction(this.getFaction());
			for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
			{		
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, tile, this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
			}
			this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], 1.5, tile.Pos);
		}
	}

});

