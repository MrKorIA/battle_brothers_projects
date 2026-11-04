this.xxmob_subzero <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M70;
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
		this.m.ConfidentMoraleBrush = "icon_confident_orcs";
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BanditPoacher);
		b.IsImmuneToDisarm = true;
		b.Hitpoints += 145;
		b.MeleeSkill += 25;
		b.RangedSkill += 25;
		b.Bravery += 100;
		b.Stamina += 100;
		b.MeleeDefense += 15;
		b.RangedDefense += 15;
		b.Initiative += 50;
		b.Vision += 1;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_beasts");

		local wtt = this.new("scripts/items/weapons/named/xx_mob_fakeweapon15");
		wtt.m.RangeMin = 1;
		wtt.m.RangeMax = 2;
		wtt.m.RangeIdeal = 2;
		this.m.Items.equip(wtt);

		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_bonushit"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_nopunch"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_punch_subzero"));
		if (this.Math.rand(1, 3) == 2)
		{
			this.getSprite("hair").setBrush("bust_helmet_47");
			this.getSprite("hair").Visible = true;
			this.getSprite("beard").setBrush("bust_helmet_27");
			this.getSprite("beard").Saturation = 0.1;
			this.getSprite("beard").Color = this.createColor("#c4c4c4");
			this.getSprite("beard").Visible = true;
			this.getSprite("beard_top").setBrush("bust_helmet_19");
			this.getSprite("beard_top").Saturation = 0.1;
			this.getSprite("beard_top").Color = this.createColor("#dedede");
			this.getSprite("beard_top").Visible = true;
		}
		else
		{
			local hair_type = [
				"hair_grey_02",
				"hair_grey_04",
				"hair_grey_06",
				"hair_grey_07",
				"hair_grey_08",
				"hair_grey_09",
				"hair_grey_13",
				"hair_grey_14"
			];
			hair_type = hair_type[this.Math.rand(0, hair_type.len() - 1)];
			this.getSprite("hair").setBrush(hair_type);
			this.getSprite("hair").Visible = true;
			this.getSprite("beard").setBrush("bust_head_darkeyes_01");
			this.getSprite("beard").Visible = true;
			this.getSprite("beard_top").setBrush("bust_helmet_47");
			this.getSprite("beard_top").Visible = true;
		}
		this.getSprite("body").setBrush("bust_naked_body_00");
		if (this.Math.rand(1, 2) == 2)
		{
			this.getSprite("tattoo_body").setBrush("tattoo_02_bust_naked_body_00");
		}
		else
		{
			this.getSprite("tattoo_body").setBrush("bust_frozen");

		}
		this.getSprite("tattoo_body").Visible = true;
		this.getSprite("surcoat").setBrush("surcoat_02");
		this.getSprite("surcoat").Visible = true;
		this.getSprite("tattoo_head").setBrush("zombie_rage_eyes");
		this.getSprite("tattoo_head").Color = this.createColor("#61daff");
		this.getSprite("tattoo_head").Visible = true;
		this.setSpriteOffset("tattoo_head", this.createVec(2, -2));
		this.setAlwaysApplySpriteOffset(true);

		local itt = this.new("scripts/items/armor/named/black_leather_armor");
		itt.m.ShowOnCharacter = false;
		itt.m.Condition = 150;
		itt.m.ConditionMax = itt.m.Condition;
		this.m.Items.equip(itt);
		itt = this.new("scripts/items/helmets/named/wolf_helmet");
		itt.m.ShowOnCharacter = false;
		itt.m.Condition = 150;
		itt.m.ConditionMax = itt.m.Condition;
		this.m.Items.equip(itt);
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
			for( local i = 0; i < this.Const.Tactical.SpiritWalkEndParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.SpiritWalkEndParticles[i].Brushes, _tile, this.Const.Tactical.SpiritWalkEndParticles[i].Delay, this.Const.Tactical.SpiritWalkEndParticles[i].Quantity, this.Const.Tactical.SpiritWalkEndParticles[i].LifeTimeQuantity, this.Const.Tactical.SpiritWalkEndParticles[i].SpawnRate, this.Const.Tactical.SpiritWalkEndParticles[i].Stages);
			}
			for( local i = 0; i < this.Const.Tactical.SpiritWalkStartParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.SpiritWalkStartParticles[i].Brushes, _tile, this.Const.Tactical.SpiritWalkStartParticles[i].Delay, this.Const.Tactical.SpiritWalkStartParticles[i].Quantity, this.Const.Tactical.SpiritWalkStartParticles[i].LifeTimeQuantity, this.Const.Tactical.SpiritWalkStartParticles[i].SpawnRate, this.Const.Tactical.SpiritWalkStartParticles[i].Stages);
			}
			local flip = this.Math.rand(0, 100) < 50;
			this.m.IsCorpseFlipped = flip;
			local decal;
			for( local i = 0; i != this.Const.CorpsePart.len(); i = ++i )
			{
				decal = _tile.spawnDetail(this.Const.CorpsePart[i]);
				decal.Scale = 1.15;
			}
			this.spawnTerrainDropdownEffect(_tile);
			this.spawnBloodPool(_tile, 1);
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

