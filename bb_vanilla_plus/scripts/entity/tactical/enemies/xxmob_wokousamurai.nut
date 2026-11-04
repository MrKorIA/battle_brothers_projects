this.xxmob_wokousamurai <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M79;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.OrcBerserker.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/bounty_hunter_melee_agent");
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Flee);
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
		this.m.AIAgent.setActor(this);
		this.getFlags().add("riposter");
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BanditPoacher);
		b.IsSpecializedInSwords = true;
		b.Hitpoints += 170;
		b.MeleeSkill += 25;
		b.MeleeDefense += 30;
		b.RangedDefense += 20;
		b.Bravery += 50;
		b.Stamina += 50;
		b.Initiative += 20;
		b.Vision += 2;
		b.DamageTotalMult += 0.2;
		b.HitChance[this.Const.BodyPart.Head] += 15;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_beasts");
		local rrr_type;
		rrr_type = [
			"",
			"",
			"beard_black_03",
			"beard_black_05",
			"beard_black_06",
			"beard_black_07",
			"beard_black_09",
			"beard_black_10",
			"beard_black_11",
			"beard_black_16"
		];
		rrr_type = rrr_type[this.Math.rand(0, rrr_type.len() - 1)]
		this.getSprite("beard").setBrush(rrr_type);

		rrr_type = [
			"",
			"hair_black_16",
			"hair_black_19",
			"hair_black_8012",
			"hair_black_8013",
			"hair_black_8014",
			"hair_black_8014",
			"hair_black_8014",
			"hair_black_8014",
			"hair_black_8014"
		];
		rrr_type = rrr_type[this.Math.rand(0, rrr_type.len() - 1)]
		this.getSprite("hair").setBrush(rrr_type);

		if (this.Math.rand(1, 100) <= 15)
		{
			if (this.Math.rand(1, 100) <= 50)
			{
				this.getSprite("head").setBrush("bust_head_787" + this.Math.rand(6, 7));
				this.getSprite("beard").setBrush("");
			}
			else
			{
				rrr_type = [
					"bust_helmet_41",
					"bust_helmet_45"
				];
				this.getSprite("beard").setBrush(rrr_type[this.Math.rand(0, rrr_type.len() - 1)]);
			}
			this.m.Skills.add(this.new("scripts/skills/perks/perk_fortified_mind"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_colossus"));
		}
		else
		{
			this.getSprite("head").Color = this.createColor("#d6b074");
			this.getSprite("body").Color = this.getSprite("head").Color;
		}
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_head_hunter"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_forged"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_damaged_passive"));
		local bh = this.new("scripts/skills/actives/ai_bonushit");
		bh.m.HitChanceBonus = 7;
		this.m.Skills.add(bh);
	}

	function assignRandomEquipment()
	{
		this.m.Items.equip(this.new("scripts/items/helmets/xxhat_samurai"));
		this.m.Items.equip(this.new("scripts/items/armor/xxsamuraiarmor"));
		this.m.Items.equip(this.new("scripts/items/weapons/named/xx_mob_katana"));
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
			}

			if (this.m.Surcoat != null && this.doesBrushExist(sprite_surcoat.getBrush().Name + "_dead"))
			{
				decal = _tile.spawnDetail("surcoat_" + (this.m.Surcoat < 10 ? "0" + this.m.Surcoat : this.m.Surcoat) + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
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

});

