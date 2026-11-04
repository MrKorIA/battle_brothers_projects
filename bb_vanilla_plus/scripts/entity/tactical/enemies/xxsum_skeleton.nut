this.xxsum_skeleton <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M82;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.XP = this.Const.Tactical.Actor.SkeletonPhylactery.XP;
		this.m.BloodType = this.Const.BloodType.Bones;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.human.create();
		this.m.Faces = null;
		this.m.Hairs = null;
		this.m.HairColors = null;
		this.m.Beards = null;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/zombie_agent");
		this.m.AIAgent.setActor(this);
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/skeleton_hurt_01.wav",
			"sounds/enemies/skeleton_hurt_02.wav",
			"sounds/enemies/skeleton_hurt_03.wav",
			"sounds/enemies/skeleton_hurt_04.wav",
			"sounds/enemies/skeleton_hurt_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/skeleton_death_01.wav",
			"sounds/enemies/skeleton_death_02.wav",
			"sounds/enemies/skeleton_death_03.wav",
			"sounds/enemies/skeleton_death_04.wav",
			"sounds/enemies/skeleton_death_05.wav",
			"sounds/enemies/skeleton_death_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Resurrect] = [
			"sounds/enemies/skeleton_rise_01.wav",
			"sounds/enemies/skeleton_rise_02.wav",
			"sounds/enemies/skeleton_rise_03.wav",
			"sounds/enemies/skeleton_rise_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/skeleton_idle_01.wav",
			"sounds/enemies/skeleton_idle_02.wav",
			"sounds/enemies/skeleton_idle_03.wav",
			"sounds/enemies/skeleton_idle_04.wav",
			"sounds/enemies/skeleton_idle_05.wav",
			"sounds/enemies/skeleton_idle_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Move] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
		this.getFlags().add("undead");
		this.getFlags().add("skeleton");
		this.getFlags().add("skeleton_minion");
		this.m.ConfidentMoraleBrush = "icon_confident_orcs";
	}

	function playSound( _type, _volume, _pitch = 1.0 )
	{
		if (_type == this.Const.Sound.ActorEvent.Move && this.Math.rand(1, 100) <= 50)
		{
			return;
		}

		this.actor.playSound(_type, _volume, _pitch);
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.ZombieYeoman);
		b.SurroundedBonus = 5;
		b.Hitpoints += 10;
		b.MeleeSkill += 2;
		b.MeleeDefense += 2;
		b.Bravery += 200;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.setAppearance();

		this.getSprite("socket").setBrush("bust_base_undead");
		local body = this.getSprite("body");
		body.setBrush("bust_skeleton_body_01");
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
		local tattoo_body = this.getSprite("tattoo_body");
		this.getSprite("armor");
		local head = this.getSprite("head");
		head.setBrush("bust_skeleton_head");
		head.Color = body.Color;
		head.Saturation = body.Saturation;
		local injury = this.getSprite("injury");
		injury.setBrush("bust_skeleton_head_injured");
		injury.Visible = false;
		local tattoo_head = this.getSprite("tattoo_head");
		local beard = this.getSprite("beard");
		local hair = this.getSprite("hair");
		this.getSprite("helmet");
		this.getSprite("helmet_damage");
		local body_blood = this.getSprite("body_blood");
		body_blood.setBrush("bust_body_bloodied_02");
		body_blood.Visible = false;
		local body_dirt = this.getSprite("dirt");
		body_dirt.setBrush("bust_body_dirt_02");
		body_dirt.Visible = this.Math.rand(1, 100) <= 33;
		this.getSprite("status_rooted").Scale = 0.55;

		local rr;
		if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 100)
		{
			rr = this.Math.rand(50, 100);
			b.Armor[this.Const.BodyPart.Head] += rr;
			b.Armor[this.Const.BodyPart.Body] += rr;
			b.ArmorMax[this.Const.BodyPart.Head] += rr;
			b.ArmorMax[this.Const.BodyPart.Body] += rr;
		}
		else
		{
			rr = this.Math.rand(30, 50);
			b.Armor[this.Const.BodyPart.Head] += rr;
			b.Armor[this.Const.BodyPart.Body] += rr;
			b.ArmorMax[this.Const.BodyPart.Head] += rr;
			b.ArmorMax[this.Const.BodyPart.Body] += rr;
		}
		if (this.Math.rand(1, 100) <= 15 && this.World.getTime().Days >= 100)
		{
			if (this.Math.rand(1, 100) <= 50)
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/barbarians/rusty_warblade"));
				}
				else
				{
					this.m.Items.equip(this.new("scripts/items/weapons/warbrand"));
				}
			}
			else
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/ancient/rhomphaia"));
				}
				else
				{
					this.m.Items.equip(this.new("scripts/items/weapons/ancient/crypt_cleaver"));
				}
			}
		}
		else
		{
			if (this.Math.rand(1, 100) <= 30)
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/barbarians/crude_axe"));
				}
				else
				{
					this.m.Items.equip(this.new("scripts/items/weapons/barbarians/axehammer"));
				}
			}
			else
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/ancient/ancient_spear"));
				}
				else
				{
					this.m.Items.equip(this.new("scripts/items/weapons/ancient/ancient_sword"));
				}
			}
		}
		this.m.Skills.add(this.new("scripts/skills/racial/skeleton_racial"));
		this.m.Skills.add(this.new("scripts/skills/special/double_grip"));
		this.m.Skills.add(this.new("scripts/skills/actives/zombie_bite"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			local flip = this.Math.rand(0, 100) < 50;
			this.m.IsCorpseFlipped = flip;
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
		this.m.BloodType = this.Const.BloodType.Ash;
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

});

