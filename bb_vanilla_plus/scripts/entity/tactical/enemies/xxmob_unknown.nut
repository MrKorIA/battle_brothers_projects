this.xxmob_unknown <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M83;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Knight.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/bounty_hunter_melee_agent");
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Flee);
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Knight);
		b.IsSpecializedInSwords = true;
		b.IsSpecializedInAxes = true;
		b.IsSpecializedInMaces = true;
		b.IsSpecializedInFlails = true;
		b.IsSpecializedInPolearms = true;
		b.IsSpecializedInThrowing = true;
		b.IsSpecializedInHammers = true;
		b.IsSpecializedInSpears = true;
		b.IsSpecializedInCleavers = true;
		b.Hitpoints += 500;
		b.Bravery += 500;
		b.Stamina += 200;
		b.Armor[this.Const.BodyPart.Head] += 350;
		b.ArmorMax[this.Const.BodyPart.Head] += 350;
		b.Armor[this.Const.BodyPart.Body] += 350;
		b.ArmorMax[this.Const.BodyPart.Body] += 350;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.addSprite("socket").setBrush("bust_base_beasts");
		local head = this.getSprite("head");
		local body = this.getSprite("body");
		head.Saturation = 0.1;
		head.Color = this.createColor("#858585");
		body.Saturation = 0.1;
		body.Color = this.createColor("#999999");
		head.setBrush("xxknighthelm_100");
		body.setBrush("bust_body_37");
		local surcoat = this.getSprite("surcoat");
		surcoat.setBrush("bust_body_74");
		surcoat.Color = this.createColor("#ff0000");
		if (this.Math.rand(7, 8) == 7)
		{
			local b2 = this.getSprite("bandage_2");
			local b1 = this.getSprite("bandage_1");
			b2.setBrush("upgrade_02_back");
			b1.setBrush("upgrade_02_front");
			b2.Visible = true;
			b1.Visible = true;
			b2.Color = this.createColor("#800b0b");
			b1.Color = this.createColor("#800b0b");
			b2.Scale = 0.85;
			b1.Scale = 0.85;
		}
		this.m.Items.equip(this.new("scripts/items/weapons/named/named_greatsword"));
		this.m.Skills.add(this.new("scripts/skills/racial/champion_racial"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_forged"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_duelist"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_reach_advantage"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_head_hunter"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_berserk"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/actives/rotation"));
		this.m.Skills.add(this.new("scripts/skills/actives/footwork"));
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
	}

	function onUpdateInjuryLayer()
	{
		local p = this.getArmor(this.Const.BodyPart.Head) / this.getArmorMax(this.Const.BodyPart.Head);
		if (p < 0.2)
		{
			this.getSprite("head").setBrush("xxknighthelm_100_damaged");
		}
		p = this.getArmor(this.Const.BodyPart.Body) / this.getArmorMax(this.Const.BodyPart.Body);
		if (p <= 0)
		{
			this.getSprite("surcoat").setBrush("");
			this.getSprite("bandage_2").setBrush("");
			this.getSprite("bandage_1").setBrush("");
		}
		if (p < 0.5)
		{
			this.getSprite("body").setBrush("bust_body_37_damaged");
		}
		this.human.onUpdateInjuryLayer();
	}

	function onTurnStart()
	{
		this.actor.onTurnStart();
		if (this.Tactical.Entities.isEnemyRetreating() || this.Tactical.State.isAutoRetreat() || !this.m.IsAlive || this.m.IsDying)
		{
			return;
		}
		this.getItems().unequip(this.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
		this.getItems().unequip(this.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
		local w = [
			"named_billhook",
			"named_bladed_pike",
			"named_spetum",
			"named_polehammer",
			"named_longaxe",
			"named_pike"
			"named_swordlance"
		];
		if (this.Const.DLC.Unhold && this.Const.DLC.Wildmen && this.Const.DLC.Desert)
		{
			w.extend([
				"named_polemace",
			]);
		}
		if (this.Tactical.isActive() && this.getTile().hasZoneOfControlOtherThan(this.getAlliedFactions()))
		{
			w.extend([
				"named_bardiche",
				"named_greataxe",
				"named_greatsword",
				"named_warbrand",
				"named_two_handed_scimitar",
				"named_two_handed_mace",
				"named_two_handed_hammer",
				"named_orc_cleaver",
				"named_orc_axe",
				"named_axe",
				"named_flail",
				"named_shamshir",
				"named_warhammer"
			]);
		}
		this.m.Items.equip(this.new("scripts/items/weapons/named/" + w[this.Math.rand(0, w.len() - 1)]));
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			for( local i = 0; i < this.Const.Tactical.KrakenDevourVictimParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.KrakenDevourVictimParticles[i].Brushes, _tile, this.Const.Tactical.KrakenDevourVictimParticles[i].Delay, this.Const.Tactical.KrakenDevourVictimParticles[i].Quantity, this.Const.Tactical.KrakenDevourVictimParticles[i].LifeTimeQuantity, this.Const.Tactical.KrakenDevourVictimParticles[i].SpawnRate, this.Const.Tactical.KrakenDevourVictimParticles[i].Stages);
			}
			for( local i = 0; i < this.Const.Tactical.GruesomeFeastParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.GruesomeFeastParticles[i].Brushes, _tile, this.Const.Tactical.GruesomeFeastParticles[i].Delay, this.Const.Tactical.GruesomeFeastParticles[i].Quantity, this.Const.Tactical.GruesomeFeastParticles[i].LifeTimeQuantity, this.Const.Tactical.GruesomeFeastParticles[i].SpawnRate, this.Const.Tactical.GruesomeFeastParticles[i].Stages);
			}
			local flip = this.Math.rand(0, 100) < 50;
			this.m.IsCorpseFlipped = flip;
			this.spawnBloodPool(_tile, 1);
			local decal = _tile.spawnDetail("corpse_part_03", this.Const.Tactical.DetailFlag.Corpse, flip, false);
			decal.Scale = this.Math.rand(1, 10) * 0.01 + 1.1;
			decal.varySaturation(0.2);
			decal.varyColor(0.2, 0.2, 0.2);
			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.Faction = this.getFaction();
			corpse.CorpseName = this.getName();
			corpse.Tile = _tile;
			corpse.IsHeadAttached = true;
			corpse.IsConsumable = true;
			corpse.IsResurrectable = false;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

});

