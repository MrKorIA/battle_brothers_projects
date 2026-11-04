this.xxmob_execut <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M34;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Cultist.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.WildMale;
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
		b.setValues(this.Const.Tactical.Actor.Cultist);
		b.IsSpecializedInAxes = true;
		b.MeleeSkill += this.Math.rand(5, 10);
		b.Bravery += 20;
		b.Stamina += 20;
		b.Hitpoints += 50;
		b.Initiative += -50;
		b.HitChance[this.Const.BodyPart.Head] += 100;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.getSprite("armor").Color = this.createColor("#9c9c9c");
		this.getSprite("armor").Saturation = 0;
		this.getSprite("helmet").Color = this.createColor("#e0e0e0");
		this.getSprite("helmet").Saturation = 0;
		this.getSprite("helmet_damage").Color = this.createColor("#e0e0e0");
		this.getSprite("helmet_damage").Saturation = 0;
		this.setAppearance();
		this.addSprite("socket").setBrush("bust_base_beasts");
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		this.getSprite("tattoo_head").setBrush("bust_helmet_236");
		this.getSprite("tattoo_head").Color = this.createColor("#bfbfbf");
		this.getSprite("tattoo_head").Saturation = 0;
		this.getSprite("surcoat").setBrush("bust_body_01");
		this.getSprite("surcoat").Color = this.createColor("#9c9c9c");
		this.getSprite("surcoat").Saturation = 0;
		if (this.Math.rand(1, 2) != 2)
		{
			this.getSprite("tattoo_body").setBrush("bust_body_11");
			this.getSprite("tattoo_body").Color = this.createColor("#9c9c9c");
			this.getSprite("tattoo_body").Saturation = 0;
		}
		else if (this.Math.rand(1, 2) != 2)
		{
			this.getSprite("surcoat").setBrush("upgrade_13_back");
			this.getSprite("surcoat").Scale = 0.9;
		}
		local kk = this.Math.rand(10, 30);
		b.Armor[this.Const.BodyPart.Head] += kk;
		b.ArmorMax[this.Const.BodyPart.Head] += kk;
		b.Armor[this.Const.BodyPart.Body] += kk;
		b.ArmorMax[this.Const.BodyPart.Body] += kk;
	}

	function assignRandomEquipment()
	{
		local w = this.new("scripts/items/weapons/longaxe");
		w.m.IsDroppedAsLoot = false;
		this.m.Items.equip(w);
		this.m.Items.addToBag(this.new("scripts/items/weapons/woodcutters_axe"));
	}

});

