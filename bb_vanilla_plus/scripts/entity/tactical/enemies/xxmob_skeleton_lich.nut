this.xxmob_skeleton_lich <- this.inherit("scripts/entity/tactical/skeleton", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.SkeletonLich;
		this.m.Name = this.Const.Strings.EntityName[this.m.Type] + " " + this.Const.Strings.AncientDeadTitles[0];
		this.m.XP = this.Const.Tactical.Actor.SkeletonPriest.XP;
		this.m.IsGeneratingKillName = false;
		this.m.IsResurrectable = false;
		this.skeleton.create();
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/bounty_hunter_melee_agent");
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Flee);
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
		this.m.AIAgent.setActor(this);
		this.getFlags().add("sandlich");
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		local corpses = clone this.Tactical.Entities.getCorpses();
		local nn = 0;
		foreach( c in corpses )
		{
			if (!c.IsEmpty)
			{
				continue;
			}
			if (!c.IsCorpseSpawned || !c.Properties.get("Corpse").IsResurrectable)
			{
				continue;
			}
			if (c.IsVisibleForPlayer)
			{
				for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(true, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, c, this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
				}
			}
			local e = this.spawnUndead(this.actor, c);
			if (e.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
			{
				local item;
				if (e.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) == null && this.Math.rand(1, 100) <= 70)
				{
					local w = [
						"pike",
						"longaxe",
						"longsword"
					];
					item = this.new("scripts/items/weapons/" + w[this.Math.rand(0, w.len() - 1)]);
				}
				else
				{
					local w = [
						"boar_spear",
						"hand_axe",
						"morning_star",
						"arming_sword"
					];
					item = this.new("scripts/items/weapons/" + w[this.Math.rand(0, w.len() - 1)]);
				}
				item.m.IsDroppedAsLoot = false;
				e.getItems().equip(item);
			}
			nn = ++nn;
			if (nn >= 8)
			{
				break;
			}
		}
		this.getItems().unequip(this.getItems().getItemAtSlot(this.Const.ItemSlot.Body));
		this.getItems().unequip(this.getItems().getItemAtSlot(this.Const.ItemSlot.Head));
		this.skeleton.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function spawnUndead( _actor, _tile )
	{
		local p = _tile.Properties.get("Corpse");
		p.Faction = _actor.getFaction();
		local e = this.Tactical.Entities.onResurrect(p, true);
		if (e != null)
		{
			e.getSprite("socket").setBrush(_actor.getSprite("socket").getBrush().Name);
		}
		return e;
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		this.actor.onDamageReceived(_attacker, _skill, _hitInfo);

		if (!this.isAlive() || this.isDying() || this.getCurrentProperties().IsRooted || this.getCurrentProperties().IsStunned)
		{
			return;
		}

		local result = {
			TargetTile = this.getTile(),
			Destinations = []
		};
		this.Tactical.queryTilesInRange(this.getTile(), 2, 5, false, [], this.onQueryTiles, result);

		if (result.Destinations.len() == 0)
		{
			return;
		}

		local targetTile = result.Destinations[this.Math.rand(0, result.Destinations.len() - 1)];

		if (this.getTile().IsVisibleForPlayer)
		{
			for( local i = 0; i < this.Const.Tactical.LichParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.LichParticles[i].Brushes, targetTile, this.Const.Tactical.LichParticles[i].Delay, this.Const.Tactical.LichParticles[i].Quantity, this.Const.Tactical.LichParticles[i].LifeTimeQuantity, this.Const.Tactical.LichParticles[i].SpawnRate, this.Const.Tactical.LichParticles[i].Stages);
			}
		}

		if (targetTile.IsVisibleForPlayer)
		{
			for( local i = 0; i < this.Const.Tactical.LichParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.LichParticles[i].Brushes, targetTile, this.Const.Tactical.LichParticles[i].Delay, this.Const.Tactical.LichParticles[i].Quantity, this.Const.Tactical.LichParticles[i].LifeTimeQuantity, this.Const.Tactical.LichParticles[i].SpawnRate, this.Const.Tactical.LichParticles[i].Stages);
			}
		}

		local tag = {
			User = this,
			OldTile = this.getTile()
		};
		this.Sound.play("sounds/enemies/skeleton_rise_0" + this.Math.rand(1, 4) + ".wav", this.Const.Sound.Volume.Skill * 1.5, this.getTile().Pos);
		this.Tactical.getNavigator().teleport(this, targetTile, null, null, false, 0);
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 10, this.onTeleportDone, tag);
	}

	function onQueryTiles( _tile, _tag )
	{
		if (!_tile.IsEmpty)
		{
			return;
		}

		_tag.Destinations.push(_tile);
	}

	function onTeleportDone( _tag )
	{
		if (_tag.OldTile.IsEmpty && !_tag.OldTile.IsOccupiedByActor)
		{
			local spawn = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/skeleton_lich_mirror_image", _tag.OldTile.Coords);
			spawn.setFaction(_tag.User.getFaction());
			spawn.m.XP = spawn.m.XP * 0;
			local allies = this.Tactical.Entities.getInstancesOfFaction(_tag.User.getFaction());
			spawn.m.Skills.removeByID("actives.wither");
			spawn.m.Skills.removeByID("actives.raise_undead");
			spawn.m.Skills.removeByID("actives.lightning_storm");
			local sk = this.new("scripts/skills/actives/ai_punch_sandlich");
			sk.m.ActionPointCost = 4;
			sk.m.ID = "actives.wither";
			spawn.m.Skills.add(sk);
			sk = this.new("scripts/skills/effects/ai_selfkill_effect");
			spawn.m.Skills.add(sk);
			sk.setTurns(4);
		}
	}

	function onInit()
	{
		this.actor.onInit();
		this.addSprite("socket").setBrush("bust_base_undead");
		local body = this.addSprite("body");
		body.setBrush("bust_skeleton_body_02");
		body.setHorizontalFlipping(true);
		body.Saturation = 0.8;

		if (this.Math.rand(0, 100) < 75)
		{
			body.varySaturation(0.2);
		}

		if (this.Math.rand(0, 100) < 90)
		{
			body.varyColor(0.025, 0.025, 0.025);
		}

		this.m.BloodColor = body.Color;
		this.m.BloodSaturation = body.Saturation;
		this.addSprite("body_injury").setBrush("bust_skeleton_body_injured");
		this.addSprite("armor");
		local head = this.addSprite("head");
		head.setBrush("bust_skeleton_head");
		head.Color = body.Color;
		head.Saturation = body.Saturation;
		local injury = this.addSprite("injury");
		injury.setBrush("bust_skeleton_head_injured");
		local beard = this.addSprite("beard");
		local face = this.addSprite("face");
		face.setBrush("bust_skeleton_face_03");
		local hair = this.addSprite("hair");
		this.addSprite("helmet");
		this.addSprite("helmet_damage");
		local beard_top = this.addSprite("beard_top");
		local body_blood = this.addSprite("body_blood");
		body_blood.setBrush("bust_body_bloodied_02");
		body_blood.setHorizontalFlipping(true);
		body_blood.Visible = false;
		local body_dirt = this.addSprite("dirt");
		body_dirt.setBrush("bust_body_dirt_02");
		body_dirt.setHorizontalFlipping(true);
		body_dirt.Visible = this.Math.rand(1, 100) <= 33;
		local book = this.addSprite("book");
		book.setBrush("icon_necronomicon");
		book.setHorizontalFlipping(true);
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.55;
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.SkeletonPriest);
		b.TargetAttractionMult = 3.0;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToDisarm = true;
		b.Hitpoints += 185;
		b.MeleeSkill += 75;
		b.MeleeDefense += 10;
		b.RangedDefense += 10;
		b.Initiative += -500;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.SameMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.m.Skills.add(this.new("scripts/skills/racial/skeleton_racial"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_underdog"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_punch_sandlich"));
		local wtt = this.new("scripts/items/weapons/named/xx_mob_fakeweapon15");
		wtt.m.RangeMin = 1;
		wtt.m.RangeMax = 7;
		wtt.m.RangeIdeal = 7;
		this.m.Items.equip(wtt);
	}

	function onTurnEnd()
	{
		this.actor.onTurnEnd();
		if (this.Tactical.Entities.isEnemyRetreating() || this.Tactical.State.isAutoRetreat() || !this.m.IsAlive || this.m.IsDying)
		{
			return;
		}

		local myTile = this.actor.getTile();
		if (!myTile.IsOccupiedByActor || myTile.IsEmpty)
		{
			return;
		}

		local tiles = [];
		local mapSize = this.Tactical.getMapSize();
		for( local x = 1; x < mapSize.X - 1; x = ++x )
		{
			for( local y = 1; y < mapSize.Y - 1; y = ++y )
			{
				local tile = this.Tactical.getTileSquare(x, y);
				if (tile.IsEmpty && tile.Type != this.Const.Tactical.TerrainType.Impassable)
				{
					tiles.push(tile);
				}
			}
		}

		if (tiles.len() == 0)
		{
			return;
		}

		local targetTile;
		local nn = 0;
		for( local i = 0; i < tiles.len(); i = ++i )
		{
			targetTile = tiles.remove(this.Math.rand(0, tiles.len() - 1));
			if (myTile.getDistanceTo(targetTile) >= 2 && myTile.getDistanceTo(targetTile) <= 4)
			{
				local spawn;
				if (nn < 2)
				{
					local spawn = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/xxmob_skullweak", targetTile.Coords);
					spawn.setFaction(this.getFaction());
					spawn.m.XP = spawn.m.XP * 0;
					local allies = this.Tactical.Entities.getInstancesOfFaction(this.getFaction());
					spawn.m.Sound[this.Const.Sound.ActorEvent.Other2] = spawn.m.Sound[this.Const.Sound.ActorEvent.Death];
					spawn.m.Sound[this.Const.Sound.ActorEvent.Move] = spawn.m.Sound[this.Const.Sound.ActorEvent.Idle];
					local sk = this.new("scripts/skills/effects/ai_selfkill_effect");
					spawn.m.Skills.add(sk);
					sk.setTurns(4);
					for( local i = 0; i < this.Const.Tactical.LichParticles.len(); i = ++i )
					{
						this.Tactical.spawnParticleEffect(false, this.Const.Tactical.LichParticles[i].Brushes, targetTile, this.Const.Tactical.LichParticles[i].Delay, this.Const.Tactical.LichParticles[i].Quantity, this.Const.Tactical.LichParticles[i].LifeTimeQuantity, this.Const.Tactical.LichParticles[i].SpawnRate, this.Const.Tactical.LichParticles[i].Stages);
					}
				}
				else
				{
					local spawn = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/skeleton_lich_mirror_image", targetTile.Coords);
					spawn.setFaction(this.getFaction());
					spawn.m.XP = spawn.m.XP * 0;
					local allies = this.Tactical.Entities.getInstancesOfFaction(this.getFaction());
					spawn.m.Skills.removeByID("actives.wither");
					spawn.m.Skills.removeByID("actives.raise_undead");
					spawn.m.Skills.removeByID("actives.lightning_storm");
					local sk = this.new("scripts/skills/actives/ai_punch_sandlich");
					sk.m.ActionPointCost = 4;
					sk.m.ID = "actives.wither";
					spawn.m.Skills.add(sk);
					sk = this.new("scripts/skills/effects/ai_selfkill_effect");
					spawn.m.Skills.add(sk);
					sk.setTurns(4);
					for( local i = 0; i < this.Const.Tactical.LichParticles.len(); i = ++i )
					{
						this.Tactical.spawnParticleEffect(false, this.Const.Tactical.LichParticles[i].Brushes, targetTile, this.Const.Tactical.LichParticles[i].Delay, this.Const.Tactical.LichParticles[i].Quantity, this.Const.Tactical.LichParticles[i].LifeTimeQuantity, this.Const.Tactical.LichParticles[i].SpawnRate, this.Const.Tactical.LichParticles[i].Stages);
					}
				}
			}
			else
			{
				continue;
			}
			nn = ++nn;
			if (nn >= 3)
			{
				break;
			}
		}
	}

	function assignRandomEquipment()
	{
		this.m.Items.equip(this.new("scripts/items/armor/ancient/ancient_lich_attire"));
		this.m.Items.equip(this.new("scripts/items/helmets/ancient/ancient_lich_headpiece"));
	}

});

