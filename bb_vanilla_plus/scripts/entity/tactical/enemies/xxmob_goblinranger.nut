this.xxmob_goblinranger <- this.inherit("scripts/entity/tactical/goblin", {
	m = {	},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M40;
		this.m.Type = this.Const.EntityType.GoblinAmbusher;
		this.m.XP = this.Const.Tactical.Actor.OrcBerserker.XP;
		this.goblin.create();
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/goblin_ranged_agent");
		this.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_reload"));
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.goblin.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.GoblinLeader);
		b.TargetAttractionMult = 1.5;
		b.Hitpoints += 30;
		local r = this.Math.rand(1, 2);
		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
			this.m.Items.equip(this.new("scripts/items/weapons/greenskins/goblin_crossbow"));
			b.IsSpecializedInCrossbows = true;
		}
		else
		{
			this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
			if (this.Math.rand(1, 100) <= 22)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/named/named_goblin_heavy_bow"));
				this.m.Skills.add(this.new("scripts/skills/perks/perk_overwhelm"));
				this.m.Skills.add(this.new("scripts/skills/perks/perk_dodge"));
				this.m.Skills.add(this.new("scripts/skills/perks/perk_relentless"));
				this.m.Skills.add(this.new("scripts/skills/perks/perk_head_hunter"));
				this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
			}
			else
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/goblin_heavy_bow"));
			}
			b.DamageDirectMult = 1.3;
			b.IsSpecializedInBows = true;
		}
		b.IsSpecializedInSwords = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.getSprite("head").setBrush("bust_goblin_01_head_0" + this.Math.rand(1, 3));
		this.getSprite("quiver").Visible = true;
		this.addDefaultStatusSprites();
		if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 180)
		{
			b.DamageDirectMult = 1.35;
		}
		this.m.Skills.add(this.new("scripts/skills/racial/goblin_ambusher_racial"));
	}

	function assignRandomEquipment()
	{
		if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
		{
			local armor = [
				"armor/greenskins/goblin_skirmisher_armor",
				"armor/greenskins/goblin_light_armor",
				"armor/greenskins/goblin_medium_armor",
				"armor/greenskins/goblin_heavy_armor"
			];
			this.m.Items.equip(this.new("scripts/items/" + armor[this.Math.rand(0, armor.len() - 1)]));
		}
		if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
		{
			if (this.Math.rand(1, 100) <= 75)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/greenskins/goblin_light_helmet"));
			}
			else
			{
				this.m.Items.equip(this.new("scripts/items/helmets/greenskins/goblin_heavy_helmet"));
			}
		}
		this.m.Items.addToBag(this.new("scripts/items/accessory/poison_item"));
		this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/goblin_falchion"));
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		local flip = this.Math.rand(1, 100) < 50;

		if (_tile != null)
		{
			this.m.IsCorpseFlipped = flip;
			local decal;
			local skin = this.getSprite("body");
			decal = _tile.spawnDetail("bust_goblin_body_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = skin.Color;
			decal.Saturation = skin.Saturation;
			decal.setBrightness(0.9);
			decal.Scale = 0.95;
			_tile.spawnDetail(this.getItems().getAppearance().CorpseArmor, this.Const.Tactical.DetailFlag.Corpse, flip);

			if (_fatalityType != this.Const.FatalityType.Decapitated)
			{
				if (!this.getItems().getAppearance().HideCorpseHead)
				{
					decal = _tile.spawnDetail(this.getSprite("head").getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
					decal.Color = skin.Color;
					decal.Saturation = skin.Saturation;
					decal.setBrightness(0.9);
					decal.Scale = 0.95;
				}

				if (this.getItems().getAppearance().HelmetCorpse != "")
				{
					decal = _tile.spawnDetail(this.getItems().getAppearance().HelmetCorpse, this.Const.Tactical.DetailFlag.Corpse, flip);
					decal.setBrightness(0.9);
					decal.Scale = 0.95;
				}
			}
			else if (_fatalityType == this.Const.FatalityType.Decapitated)
			{
				local layers = [
					this.getSprite("head").getBrush().Name + "_dead",
					this.getItems().getAppearance().HelmetCorpse
				];
				local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(-50, 30), 180.0, this.getSprite("head").getBrush().Name + "_dead_bloodpool");
				decap[0].Color = skin.Color;
				decap[0].Saturation = skin.Saturation;
				decap[0].setBrightness(0.9);
				decap[0].Scale = 0.95;

				if (decap.len() >= 2)
				{
					decap[1].setBrightness(0.9);
				}
			}

			if (_fatalityType == this.Const.FatalityType.Disemboweled)
			{
				local decal = _tile.spawnDetail("bust_goblin_body_dead_guts", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail(this.getItems().getAppearance().CorpseArmor + "_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail(this.getItems().getAppearance().CorpseArmor + "_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}

			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = "A " + this.getName();
			corpse.Tile = _tile;
			corpse.IsResurrectable = false;
			corpse.IsConsumable = true;
			corpse.Items = this.getItems();
			corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}

		if (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			local loot;
			if (this.Math.rand(1, 100) <= 20)
			{
				loot = this.new("scripts/items/loot/growth_pearls_item");
				loot.drop(_tile);
			}
		}
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}


});

