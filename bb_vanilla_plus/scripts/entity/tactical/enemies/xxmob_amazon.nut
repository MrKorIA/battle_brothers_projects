this.xxmob_amazon <- this.inherit("scripts/entity/tactical/human", {
	m = {
		CLR = "#fff200"
	},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M90;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.BanditPoacher.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/xxmonster_a_agent");
		this.m.AIAgent.setActor(this);
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/ghost_death_01.wav",
			"sounds/enemies/ghost_death_02.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/ghost_death_01.wav",
			"sounds/enemies/ghost_death_02.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/ghost_death_01.wav",
			"sounds/enemies/ghost_death_02.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/ghastly_touch_01.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/ghastly_touch_01.wav"
		];
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BanditPoacher);
		if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 155)
		{
			b.DamageTotalMult += 0.2;
		}
		b.Hitpoints += 70;
		b.MeleeSkill += 10;
		b.RangedSkill += 10;
		b.MeleeDefense += 10;
		b.RangedDefense += 10;
		b.Bravery += 20;
		b.Stamina += 20;
		b.Initiative += 20;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_beasts");
		local xbody = this.getSprite("body");
		local xhead = this.getSprite("head");
		xbody.setBrush("bust_naked_body_78" + this.Math.rand(69, 70));
		xhead.setBrush("bust_head_78" + this.Math.rand(68, 71));
		xbody.varyColor(0.05, 0.05, 0.05);
		xbody.varySaturation(0.1);
		xhead.Color = xbody.Color;
		xhead.Saturation = xbody.Saturation;
		if (this.Math.rand(1, 100) <= 50)
		{
			local tattoo_body = this.getSprite("tattoo_body");
			local tattoo_head = this.getSprite("tattoo_head");
			tattoo_body.setBrush("warpaint_01_bust_naked_body_00");
			tattoo_head.setBrush("warpaint_01_head");
			tattoo_body.Visible = true;
			tattoo_head.Visible = true;
		}
		local xhair = this.getSprite("hair");
		local hair_type = [
			"01",
			"02",
			"03",
			"04",
			"08",
			"10",
			"19",
			"21",
			"southern_03"
		];
		xhair.setBrush("hair_" + this.Const.HairColors.All[this.Math.rand(0, 4)] + "_" + hair_type[this.Math.rand(0, hair_type.len() - 1)]);
		local xsurcoat = this.getSprite("surcoat");
		xsurcoat.setBrush("bust_body_noble_07")
		xsurcoat.Color = this.createColor("#ff7575");
		if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 122)
		{
			this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		}
		local AmaSpawns = 0;
		if (this.Tactical.Entities.getFlags().has("AmaCount"))
		{
			AmaSpawns = this.Tactical.Entities.getFlags().get("AmaCount");
		}
		AmaSpawns += 1;
		this.Tactical.Entities.getFlags().set("AmaCount", AmaSpawns);
		local JadeSpawns = 0;
		if (this.Tactical.Entities.getFlags().has("JadeAmaCount"))
		{
			JadeSpawns = this.Tactical.Entities.getFlags().get("JadeAmaCount");
		}
		local MaxJade = this.Math.floor((AmaSpawns - 1) / 8) + 1;
		local spx = this.Math.rand(1, 100);
		if (spx <= 59 && JadeSpawns < MaxJade)
		{
			this.Tactical.Entities.getFlags().set("JadeAmaCount", JadeSpawns + 1);
			this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
			this.m.Skills.add(this.new("scripts/skills/effects/dodge_effect"));
			local ssk = this.new("scripts/skills/racial/champion_racial");
			ssk.m.ID = "racial.jade";
			ssk.m.Name = "Irregular";
			ssk.m.Icon = "skills/status_effect_103.png";
			ssk.m.IconMini = "status_effect_103_mini";
			this.m.Skills.add(ssk);
			this.m.Name = this.Const.Strings.FT.M91;
			this.m.CLR = "#b3ffe8";
			xsurcoat.Color = this.createColor("#8affc0");
		}
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_nopunch"));
		local ssk = this.new("scripts/skills/actives/ai_punch_amazon");
		this.m.Skills.add(ssk);
	}

	function assignRandomEquipment()
	{
		local ww = this.new("scripts/items/shields/oriental/metal_round_shield");
		ww.m.MeleeDefense = 20;
		ww.m.RangedDefense = 20;
		ww.m.Condition = 40;
		ww.m.ConditionMax = 40;
		ww.setVariant(3);
		this.m.Items.equip(ww);
		if (this.m.CLR == "#fff200")
		{
			ww = this.new("scripts/items/helmets/barbarians/leather_headband");
			ww.setVariant(187);
		}
		else
		{
			ww = this.new("scripts/items/helmets/ancient/ancient_legionary_helmet");
			if (this.Math.rand(1, 100) <= 50)
			{
				ww.setVariant(66);
			}
			else
			{
				ww.setVariant(69);
			}
		}
		this.m.Items.equip(ww);
		ww = this.new("scripts/items/weapons/barbarians/heavy_javelin")
		ww.m.Ammo = 99999;
		ww.m.AmmoMax = 99999;
		this.m.Items.equip(ww);
		this.m.Items.equip(this.new("scripts/items/armor/ancient/ancient_breastplate"));
		this.m.Items.equip(this.new("scripts/items/weapons/barbarians/heavy_javelin"));
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.actor.onAppearanceChanged(_appearance, _setDirty);
		local ww = this.createColor(this.m.CLR);
		this.getSprite("armor").Color = ww;
		this.getSprite("helmet").Color = ww;
		this.getSprite("helmet_damage").Color = ww;
		this.getSprite("arms_icon").Color = this.createColor("#ffd400");
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		local appearance = this.getItems().getAppearance();
		local flip = this.Math.rand(0, 100) < 50;
		this.m.IsCorpseFlipped = flip;

		if (_tile != null)
		{
			local sprite_body = this.getSprite("body");
			local sprite_head = this.getSprite("head");
			local sprite_hair = this.getSprite("hair");
			local sprite_beard = this.getSprite("beard");
			local sprite_beard_top = this.getSprite("beard_top");
			local sprite_surcoat = this.getSprite("surcoat");
			local sprite_accessory = this.getSprite("accessory");
			local sprite_accessory_special = this.getSprite("accessory_special");
			local sprite_body_tattoo = this.getSprite("tattoo_body");
			local sprite_head_tattoo = this.getSprite("tattoo_head");
			local decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
			decal.Color = sprite_head.Color;
			decal.Saturation = sprite_head.Saturation;
			decal.Scale = 0.9;
			decal.setBrightness(0.9);
			local ww = this.createColor(this.m.CLR);

			if (sprite_body_tattoo.HasBrush && this.doesBrushExist(sprite_body_tattoo.getBrush().Name + "_dead"))
			{
				local decal = _tile.spawnDetail(sprite_body_tattoo.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
				decal.Color = sprite_head.Color;
				decal.Saturation = sprite_head.Saturation;
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}

			if (appearance.CorpseArmor != "")
			{
				decal = _tile.spawnDetail(appearance.CorpseArmor, this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
				decal.Color = ww;
			}

			if (_fatalityType == this.Const.FatalityType.None && (!_skill || _skill.getProjectileType() == this.Const.ProjectileType.None) && this.Math.rand(1, 100) <= 33)
			{
				decal = _tile.spawnDetail("dead_body_splatter", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
				decal.Alpha = 160;
			}

			if (_fatalityType == this.Const.FatalityType.Disemboweled)
			{
				decal = _tile.spawnDetail("bust_body_guts_0" + this.Math.rand(1, 3), this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
				decal.Scale = 0.9;
			}


			if (_fatalityType != this.Const.FatalityType.Decapitated)
			{
				if (!appearance.HideCorpseHead)
				{
					local decal = _tile.spawnDetail(sprite_head.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
					decal.Color = sprite_head.Color;
					decal.Saturation = sprite_head.Saturation;
					decal.Scale = 0.9;
					decal.setBrightness(0.9);
				}

				if (sprite_head_tattoo.HasBrush && this.doesBrushExist(sprite_head_tattoo.getBrush().Name + "_dead"))
				{
					local decal = _tile.spawnDetail(sprite_head_tattoo.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
					decal.Color = sprite_head.Color;
					decal.Saturation = sprite_head.Saturation;
					decal.Scale = 0.9;
					decal.setBrightness(0.9);
				}

				if (!appearance.HideBeard && !appearance.HideCorpseHead && sprite_beard.HasBrush)
				{
					local decal = _tile.spawnDetail(sprite_beard.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
					decal.Color = sprite_beard.Color;
					decal.Saturation = sprite_beard.Saturation;
					decal.Scale = 0.9;
					decal.setBrightness(0.9);

					if (sprite_beard_top.HasBrush)
					{
						local decal = _tile.spawnDetail(sprite_beard_top.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
						decal.Color = sprite_beard.Color;
						decal.Saturation = sprite_beard.Saturation;
						decal.Scale = 0.9;
						decal.setBrightness(0.9);
					}
				}

				if (!appearance.HideHair && !appearance.HideCorpseHead && sprite_hair.HasBrush)
				{
					local decal = _tile.spawnDetail(sprite_hair.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
					decal.Color = sprite_hair.Color;
					decal.Saturation = sprite_hair.Saturation;
					decal.Scale = 0.9;
					decal.setBrightness(0.9);
				}

				if (_fatalityType == this.Const.FatalityType.Smashed)
				{
					decal = _tile.spawnDetail("bust_head_smashed_01", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
					decal.Scale = 0.9;
				}
				else if (appearance.HelmetCorpse != "")
				{
					local decal = _tile.spawnDetail(this.getItems().getAppearance().HelmetCorpse, this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
					decal.Scale = 0.9;
					decal.setBrightness(0.9);
					decal.Color = ww;
				}
			}
			else if (_fatalityType == this.Const.FatalityType.Decapitated)
			{
				local layers = [];

				if (!appearance.HideCorpseHead)
				{
					layers.push(sprite_head.getBrush().Name + "_dead");
				}

				if (!appearance.HideCorpseHead && sprite_head_tattoo.HasBrush && this.doesBrushExist(sprite_head_tattoo.getBrush().Name + "_dead"))
				{
					layers.push(sprite_head_tattoo.getBrush().Name + "_dead");
				}

				if (!appearance.HideBeard && sprite_beard.HasBrush)
				{
					layers.push(sprite_beard.getBrush().Name + "_dead");
				}

				if (!appearance.HideHair && sprite_hair.HasBrush)
				{
					layers.push(sprite_hair.getBrush().Name + "_dead");
				}

				if (appearance.HelmetCorpse.len() != 0)
				{
					layers.push(appearance.HelmetCorpse);
				}

				if (!appearance.HideBeard && sprite_beard_top.HasBrush)
				{
					layers.push(sprite_beard_top.getBrush().Name + "_dead");
				}

				local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(0, 0), -90.0, "bust_head_dead_bloodpool");
				local idx = 0;

				if (!appearance.HideCorpseHead)
				{
					decap[idx].Color = sprite_head.Color;
					decap[idx].Saturation = sprite_head.Saturation;
					decap[idx].Scale = 0.9;
					decap[idx].setBrightness(0.9);
					idx = ++idx;
				}

				if (!appearance.HideCorpseHead && sprite_head_tattoo.HasBrush && this.doesBrushExist(sprite_head_tattoo.getBrush().Name + "_dead"))
				{
					decap[idx].Scale = 0.9;
					decap[idx].setBrightness(0.9);
					idx = ++idx;
				}

				if (!appearance.HideBeard && sprite_beard.HasBrush)
				{
					decap[idx].Color = sprite_beard.Color;
					decap[idx].Saturation = sprite_beard.Saturation;
					decap[idx].Scale = 0.9;
					decap[idx].setBrightness(0.9);
					idx = ++idx;
				}

				if (!appearance.HideHair && sprite_hair.HasBrush)
				{
					decap[idx].Color = sprite_hair.Color;
					decap[idx].Saturation = sprite_hair.Saturation;
					decap[idx].Scale = 0.9;
					decap[idx].setBrightness(0.9);
					idx = ++idx;
				}

				if (appearance.HelmetCorpse.len() != 0)
				{
					decap[idx].Scale = 0.9;
					decap[idx].setBrightness(0.9);
					decap[idx].Color = ww;
					idx = ++idx;
				}

				if (!appearance.HideBeard && sprite_beard_top.HasBrush)
				{
					decap[idx].Color = sprite_beard.Color;
					decap[idx].Saturation = sprite_beard.Saturation;
					decap[idx].Scale = 0.9;
					decap[idx].setBrightness(0.9);
				}
			}

			this.spawnTerrainDropdownEffect(_tile);
			this.spawnBloodPool(_tile, 1);
			this.spawnFlies(_tile);

			local corpse = clone this.Const.Corpse;
			corpse.Faction = this.getFaction();
			corpse.CorpseName = this.getName();
			corpse.Tile = _tile;
			corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
			corpse.IsConsumable = _fatalityType != this.Const.FatalityType.Unconscious;
			corpse.IsResurrectable = false;
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

