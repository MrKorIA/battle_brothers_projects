this.xxmob_wokou <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M78;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.BanditPoacher.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/bounty_hunter_melee_agent");
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BanditPoacher);
		b.DamageTotalMult += 0.1;
		b.Hitpoints += 100;
		b.MeleeSkill += this.Math.rand(10, 20);
		b.MeleeDefense += 20;
		b.RangedDefense += 10;
		b.Bravery += 20;
		b.Stamina += 20;
		b.Initiative += 20;
		b.Vision += 1;
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

		this.getSprite("head").Color = this.createColor("#d6b074");
		this.getSprite("body").Color = this.getSprite("head").Color;
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_head_hunter"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_bonushit"));
	}

	function assignRandomEquipment()
	{		
		this.m.Items.equip(this.new("scripts/items/weapons/named/xx_mob_katana"));
		if (this.Math.rand(1, 3) == 2)
		{
			local xxitems = [
				"armor/tattered_sackcloth",
				"armor/sackcloth",
				"armor/leather_wraps",
				"armor/leather_lamellar",
				"armor/padded_leather"
			];
			this.m.Items.equip(this.new("scripts/items/" + xxitems[this.Math.rand(0, xxitems.len() - 1)]));
			if (this.Math.rand(1, 3) == 2)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/xxhat_hairband"));
				if (this.Math.rand(1, 3) == 2)
				{
					this.getSprite("hair").setBrush("hair_black_08");
				}
				else
				{
					this.getSprite("hair").setBrush("hair_black_8014");
				}
			}
		}
		else
		{
			this.m.Items.equip(this.new("scripts/items/armor/xxwokoulightarmor"));
			if (this.Math.rand(1, 2) == 2)
			{
				if (this.Math.rand(1, 3) == 2)
				{
					this.m.Items.equip(this.new("scripts/items/helmets/xxhat_hairband"));
					if (this.Math.rand(1, 3) == 2)
					{
						this.getSprite("hair").setBrush("hair_grey_shaved");
					}
					else
					{
						this.getSprite("hair").setBrush("hair_black_8014");
					}
				}
				else
				{
					this.m.Items.equip(this.new("scripts/items/helmets/xxhat_kasa"));
				}
			}
		}
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			local loot;
			if (this.Math.rand(1, 100) <= 20)
			{
				loot = this.new("scripts/items/loot/growth_pearls_item");
				loot.drop(_tile);
			}
		}
		this.human.onDeath(_killer, _skill, _tile, _fatalityType);
	}

});

