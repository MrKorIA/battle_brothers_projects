this.xxmob_horseman_a <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M44;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.BarbarianMarauder.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/xxmonster_a_agent");
		this.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_terror"));
		this.m.AIAgent.setActor(this);
		this.m.AIAgent.onUpdate = function()
		{
			if (!this.getActor().getTile().hasZoneOfControlOtherThan(this.getActor().getAlliedFactions()))
			{
				this.m.Properties.EngageRangeIdeal = 3;
				this.m.Properties.EngageRangeMax = 3;
			}
			else
			{
				this.m.Properties.EngageRangeIdeal = 1;
				this.m.Properties.EngageRangeMax = 1;
			}
		};
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BanditPoacher);
		b.IsSpecializedInSwords = true;
		b.IsSpecializedInSpears = true;
		b.IsAffectedByFleeingAllies = false;
		b.IsAffectedByDyingAllies = false;
		b.Hitpoints += 100;
		b.MeleeSkill += this.Math.rand(15, 20);
		b.MeleeDefense += 10;
		b.RangedDefense += 1;
		b.Bravery += 50;
		b.Stamina += 50;
		b.Initiative += 120;
		b.Vision += 3;
		b.MovementAPCostAdditional += 10;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_beasts");
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_relentless"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_bonushit"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_horsecharge"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_horsejump"));
	}

	function assignRandomEquipment()
	{
		local w;
		if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 122)
		{
			if (this.Math.rand(1, 5) == 1)
			{
				this.getSprite("surcoat").setBrush("surcoat_0" + this.Math.rand(1, 9));
				w = this.new("scripts/items/weapons/noble_sword");
			}
			else
			{
				w = this.new("scripts/items/weapons/fighting_spear");
			}
			w.m.IsDroppedAsLoot = false;
			this.m.Items.equip(w);
			w = this.new("scripts/items/helmets/nasal_helmet_with_mail");
			w.setVariant(3);
			w.m.IsDroppedAsLoot = false;
			this.m.Items.equip(w);
			w = this.new("scripts/items/armor/mail_shirt");
		}
		else
		{
			w = this.new("scripts/items/weapons/boar_spear");
			w.m.IsDroppedAsLoot = false;
			this.m.Items.equip(w);
			w = this.new("scripts/items/helmets/nasal_helmet");
			w.setVariant(1);
			w.m.IsDroppedAsLoot = false;
			this.m.Items.equip(w);
			w = this.new("scripts/items/armor/worn_mail_shirt");
		}
		w.m.IsDroppedAsLoot = false;
		this.m.Items.equip(w);
		w = this.new("scripts/items/shields/xxhorse_shield");
		w.m.IsDroppedAsLoot = false;
		this.m.Items.equip(w);
	}

	function onUpdate()
	{
		this.actor.onUpdate();
		if (!this.m.Skills.hasSkill("effects.xxitem_horse_skill") && this.m.Skills.hasSkill("actives.wolf_bite"))
		{
			this.m.Skills.removeByID("actives.wolf_bite");
			this.m.Skills.removeByID("actives.horrific_scream");
			local b = this.m.BaseProperties;
			b.MeleeDefense -= 5;
			this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Terror);
			this.m.AIAgent.onUpdate = function()
			{
				this.m.Properties.EngageRangeIdeal = 1;
				this.m.Properties.EngageRangeMax = 1;
			};
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

