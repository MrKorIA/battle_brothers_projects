this.xxmob_vamp <- this.inherit("scripts/entity/tactical/actor", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M73;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.XP = this.Const.Tactical.Actor.Vampire.XP;
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/vampire_hurt_01.wav",
			"sounds/enemies/vampire_hurt_02.wav",
			"sounds/enemies/vampire_hurt_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/vampire_death_01.wav",
			"sounds/enemies/vampire_death_02.wav",
			"sounds/enemies/vampire_death_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/vampire_idle_01.wav",
			"sounds/enemies/vampire_idle_02.wav",
			"sounds/enemies/vampire_idle_03.wav"
		];
		this.getFlags().add("undead");
		this.getFlags().add("vampire");
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/xxmonster_a_agent");
		this.m.AIAgent.setActor(this);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.m.BloodType = this.Const.BloodType.Ash;
		local flip = this.Math.rand(0, 100) < 50;
		this.m.IsCorpseFlipped = flip;
		if (_tile != null)
		{
			local decal = _tile.spawnDetail("bust_skeleton_vampire_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false);
			decal.Scale = 0.9;
			decal.setBrightness(0.9);
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
		if (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			local loot;
			if (this.Math.rand(1, 100) <= 30)
			{
				loot = this.new("scripts/items/loot/soul_splinter_item");
				loot.drop(_tile);
			}
			if (this.Math.rand(1, 100) <= 5)
			{
				loot = this.new("scripts/items/loot/ancient_gold_coins_item");
				loot.drop(_tile);
			}
		}
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = !this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("body_detailA").setHorizontalFlipping(flip);
		this.getSprite("body_detailB").setHorizontalFlipping(flip);
		this.getSprite("body_detailC").setHorizontalFlipping(flip);
		this.getSprite("armor").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("hair").setHorizontalFlipping(flip);
		this.getSprite("beard").setHorizontalFlipping(flip);
		this.getSprite("beard_top").setHorizontalFlipping(flip);
		this.getSprite("helmet").setHorizontalFlipping(flip);
		this.getSprite("helmet_damage").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
		this.getSprite("injury_skin").setHorizontalFlipping(flip);
		this.getSprite("injury_body").setHorizontalFlipping(flip);
		this.getSprite("dirt").setHorizontalFlipping(flip);
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Vampire);
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToPoison = true;
		b.IsSpecializedInSwords = true;
		b.MeleeSkill += 5;
		b.Hitpoints += 50;
		b.Initiative += -30;
		b.AdditionalActionPointCost = -1;
		b.MovementAPCostAdditional += 10;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_undead");
		local body = this.addSprite("body");
		body.setBrush("bust_skeleton_body_05");
		body.Color = this.createColor("#ffe3ba");
		body.varyColor(0.03, 0.03, 0.03);
		body.setHorizontalFlipping(true);
		this.addSprite("armor");
		local body_detailA = this.addSprite("body_detailA");
		body_detailA.setBrush("bust_skeleton_detail_03");
		local body_detailB = this.addSprite("body_detailB");
		body_detailB.setBrush("bust_body_noble_0" + this.Math.rand(8, 9));
		this.setSpriteOffset("body_detailB", this.createVec(0, -5));
		local body_detailC = this.addSprite("body_detailC");
		body_detailC.setBrush("bust_skeleton_detail_0" + this.Math.rand(1, 2));
		local head = this.addSprite("head");
		head.setBrush("bust_skeleton_head_0" + this.Math.rand(4, 5));
		head.Color = body.Color;
		head.Saturation = 2.0;
		head.setBrightness(3.0);
		local hair = this.addSprite("hair");
		hair.setBrush("hair_" + this.Const.HairColors.All[this.Math.rand(0, 4)] + "_" + this.Const.Hair.WildMale[this.Math.rand(3, 3)]);
		hair.varyColor(0.02, 0.02, 0.02);
		this.setSpriteOffset("hair", this.createVec(3, -3));
		local beard = this.addSprite("beard");
		beard.setBrush("bust_helmet_187");
		beard.Color = this.createColor("#fff200");
		beard.Saturation = 2.8;
		beard.setBrightness(5.7);
		this.setSpriteOffset("beard", this.createVec(3, 5));

		this.addSprite("beard_top");
		this.addSprite("helmet");
		this.addSprite("helmet_damage");
		this.addSprite("injury").setBrush("bust_naked_body_01_injured");
		this.addSprite("injury_skin").setBrush("bust_skeleton_head_05_injured");
		this.addSprite("injury_body").setBrush("bust_body_bloodied_02");
		local body_dirt = this.addSprite("dirt");
		body_dirt.setBrush("bust_body_dirt_02");
		body_dirt.setHorizontalFlipping(true);
		body_dirt.Visible = this.Math.rand(1, 100) <= 33;
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.55;
		this.m.Items.equip(this.new("scripts/items/weapons/named/named_greatsword"));
		this.m.Skills.add(this.new("scripts/skills/special/double_grip"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_head_hunter"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_reach_advantage"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_berserk"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_killing_frenzy"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_anticipation"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lone_wolf"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_underdog"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(this.new("scripts/skills/racial/vampire_racial"));
		this.m.Skills.add(this.new("scripts/skills/traits/teamplayer_trait"));
		this.m.Skills.add(this.new("scripts/skills/actives/darkflight"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_bonushit"));
		this.setAlwaysApplySpriteOffset(true);
	}

});

