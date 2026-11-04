this.xxmob_minder <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M56;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.BanditPoacher.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Raider;
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
		b.setValues(this.Const.Tactical.Actor.NomadOutlaw);
		b.IsSpecializedInSwords = true;
		b.IsSpecializedInAxes = true;
		b.IsSpecializedInMaces = true;
		b.IsSpecializedInFlails = true;
		b.IsSpecializedInPolearms = true;
		b.IsSpecializedInThrowing = true;
		b.IsSpecializedInHammers = true;
		b.IsSpecializedInSpears = true;
		b.IsSpecializedInCleavers = true;
		b.Hitpoints += 75;
		b.MeleeSkill += this.Math.rand(0, 5);
		b.Bravery += 50;
		b.Stamina += 100;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_beasts");
		local dirt = this.getSprite("dirt");
		dirt.Visible = true;
		dirt.Alpha = this.Math.rand(150, 255);
		this.getSprite("armor").Saturation = 0.85;
		this.getSprite("helmet").Saturation = 0.85;
		this.getSprite("helmet_damage").Saturation = 0.85;
		this.getSprite("shield_icon").Saturation = 0.85;
		this.getSprite("shield_icon").setBrightness(0.85);
		local bandage1 = this.addSprite("bandage_1");
		bandage1.Visible = true;
		bandage1.setBrush("bust_minder_0" + this.Math.rand(1, 6));
		bandage1.varySaturation(0.25);
		bandage1.varyColor(0.15, 0.15, 0.15);
		if (this.Math.rand(1, 100) <= 59)
		{
			this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
		}
		if (this.Math.rand(1, 100) <= 59)
		{
			this.m.Skills.add(this.new("scripts/skills/effects/dodge_effect"));
		}
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_damaged_passive"));
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.actor.onAppearanceChanged(_appearance, false);
		this.setDirty(true);
	}

	function assignRandomEquipment()
	{
		local r;
		if (this.Math.rand(1, 100) <= 20)
		{
			if (this.Const.DLC.Unhold)
			{
				r = this.Math.rand(0, 8);
				if (r == 0)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/woodcutters_axe"));
				}
				else if (r == 1)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/hooked_blade"));
				}
				else if (r == 2)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/pike"));
				}
				else if (r == 3)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/warbrand"));
				}
				else if (r == 4)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/longaxe"));
				}
				else if (r == 5)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/two_handed_wooden_hammer"));
				}
				else if (r == 6)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/two_handed_wooden_flail"));
				}
				else if (r == 7)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/two_handed_mace"));
				}
				else if (r == 8)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/longsword"));
				}
			}
			else
			{
				r = this.Math.rand(0, 4);
				if (r == 0)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/woodcutters_axe"));
				}
				else if (r == 1)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/hooked_blade"));
				}
				else if (r == 2)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/pike"));
				}
				else if (r == 3)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/warbrand"));
				}
				else if (r == 4)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/longaxe"));
				}
			}
		}
		else
		{
			r = this.Math.rand(2, 10);
			if (r == 2)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/shortsword"));
			}
			else if (r == 3)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/hand_axe"));
			}
			else if (r == 4)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/boar_spear"));
			}
			else if (r == 5)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/morning_star"));
			}
			else if (r == 6)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/falchion"));
			}
			else if (r == 7)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/arming_sword"));
			}
			else if (r == 8)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/flail"));
			}
			else if (r == 9)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/scramasax"));
			}
			else if (r == 10)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/military_pick"));
			}
			if (this.Math.rand(1, 100) <= 75)
			{
				if (this.Math.rand(1, 100) <= 75)
				{
					this.m.Items.equip(this.new("scripts/items/shields/wooden_shield"));
				}
				else
				{
					this.m.Items.equip(this.new("scripts/items/shields/kite_shield"));
				}
			}
		}
		if (this.getIdealRange() == 1 && this.Math.rand(1, 100) <= 35)
		{
			if (this.Const.DLC.Unhold)
			{
				r = this.Math.rand(1, 3);
				if (r == 1)
				{
					this.m.Items.addToBag(this.new("scripts/items/weapons/throwing_axe"));
				}
				else if (r == 2)
				{
					this.m.Items.addToBag(this.new("scripts/items/weapons/javelin"));
				}
				else if (r == 3)
				{
					this.m.Items.addToBag(this.new("scripts/items/weapons/throwing_spear"));
				}
			}
			else
			{
				r = this.Math.rand(1, 2);
				if (r == 1)
				{
					this.m.Items.addToBag(this.new("scripts/items/weapons/throwing_axe"));
				}
				else if (r == 2)
				{
					this.m.Items.addToBag(this.new("scripts/items/weapons/javelin"));
				}
			}
		}
		r = this.Math.rand(2, 7);
		local armor;
		if (r == 2)
		{
			armor = this.new("scripts/items/armor/ragged_surcoat");
		}
		else if (r == 3)
		{
			armor = this.new("scripts/items/armor/padded_leather");
		}
		else if (r == 4)
		{
			armor = this.new("scripts/items/armor/worn_mail_shirt");
		}
		else if (r == 5)
		{
			armor = this.new("scripts/items/armor/patched_mail_shirt");
		}
		else if (r == 6)
		{
			armor = this.new("scripts/items/armor/worn_mail_shirt");
		}
		else if (r == 7)
		{
			armor = this.new("scripts/items/armor/patched_mail_shirt");
		}
		this.m.Items.equip(armor);
		if (this.Math.rand(1, 100) <= 85)
		{
			local r = this.Math.rand(1, 5);
			if (r == 1)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/nasal_helmet"));
			}
			else if (r == 2)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/dented_nasal_helmet"));
			}
			else if (r == 3)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/nasal_helmet_with_rusty_mail"));
			}
			else if (r == 4)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/rusty_mail_coif"));
			}
			else if (r == 5)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/headscarf"));
			}
		}
	}

	function onUpdateInjuryLayer()
	{
		this.human.onUpdateInjuryLayer();
		local b = this.getSprite("body_blood");
		local p = this.m.Hitpoints / this.getHitpointsMax();
		if (p > 0.6)
		{
			b.setBrush("bust_body_bloodied_02");
			b.Scale = 1;
			b.Visible = false;
		}
		else
		{
			b.setBrush("bust_snake_injury");
			b.Scale = 0.7;
			b.Visible = true;
		}
	}

	function onTurnStart()
	{
		if (this.actor.getHitpoints() < this.actor.getHitpointsMax() * 0.99)
		{
			local b = this.m.BaseProperties;
			if (this.getTile().IsVisibleForPlayer)
			{
				this.Tactical.spawnIconEffect("status_effect_79", this.getTile(), this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
			}
			this.Sound.play("sounds/enemies/unhold_regenerate_01.wav", 1.5, this.getTile().Pos);
			this.actor.getSkills().removeByType(this.Const.SkillType.TemporaryInjury);
			local r = this.Math.rand(40, 60);
			this.actor.setHitpoints(this.Math.min(this.actor.getHitpointsMax(), this.actor.getHitpoints() + r));
		}
		this.actor.onTurnStart();
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		local appearance = this.getItems().getAppearance();
		local flip = this.Math.rand(0, 100) < 50;
		this.m.IsCorpseFlipped = flip;

		if (_tile != null)
		{
			local sprite_body = this.getSprite("body");
			local decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
			decal.Color = sprite_body.Color;
			decal.Saturation = sprite_body.Saturation;
			decal.Scale = 0.9;
			decal.setBrightness(0.9);

			if (appearance.CorpseArmor != "")
			{
				decal = _tile.spawnDetail(appearance.CorpseArmor, this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
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
			local layers = [
			"blood_splatter_bones_01",
			"blood_splatter_green_04",
			"blood_splatter_red_02",
			"blood_splatter_red_08"
			];
			this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(0, 0), -90.0, "bust_head_dead_bloodpool_zombified");
			decal = _tile.spawnDetail("bust_head_cut_off", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
			this.spawnTerrainDropdownEffect(_tile);
			this.spawnBloodPool(_tile, 1);
			this.spawnFlies(_tile);

			local corpse = clone this.Const.Corpse;
			corpse.Type = "scripts/entity/tactical/enemies/zombie_player";
			corpse.Faction = this.getFaction();
			corpse.CorpseName = this.getName();
			corpse.Tile = _tile;
			corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
			corpse.IsConsumable = true;
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

