this.xxmob_cultist <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M24;
		this.m.Type = this.Const.EntityType.Cultist;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Cultist.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.Military;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/bounty_hunter_melee_agent");
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Cultist);
		b.IsSpecializedInBows = true;
		b.IsSpecializedInCrossbows = true;
		b.IsSpecializedInThrowing = true;
		b.IsSpecializedInAxes = true;
		b.IsSpecializedInDaggers = true;
		b.IsSpecializedInFlails = true;
		b.IsSpecializedInHammers = true;
		b.IsSpecializedInMaces = true;
		b.IsSpecializedInPolearms = true;
		b.IsSpecializedInSpears = true;
		b.IsSpecializedInSwords = true;
		b.IsSpecializedInCleavers = true;
		b.MeleeSkill += this.Math.rand(1, 10);
		b.Bravery += 20;
		b.Stamina += 20;
		b.Hitpoints += 50;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_militia");
		this.actor.getSprite("tattoo_body").setBrush("tattoo_01_" + this.actor.getSprite("body").getBrush().Name);
		this.actor.getSprite("tattoo_body").Visible = true;
		this.actor.getSprite("tattoo_head").setBrush("tattoo_01_head");
		this.actor.getSprite("tattoo_head").Visible = true;
		this.m.Skills.add(this.new("scripts/skills/perks/perk_backstabber"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_berserk"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/effects/dodge_effect"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_overwhelm"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_duelist"));
	}

	function assignRandomEquipment()
	{
		local w = [
			"weapons/dagger",
			"weapons/battle_whip",
			"weapons/billhook",
			"weapons/pike",
			"weapons/warbrand",
			"weapons/longsword",
			"weapons/hand_axe",
			"weapons/fighting_spear",
			"weapons/boar_spear",
			"weapons/morning_star",
			"weapons/falchion",
			"weapons/arming_sword",
			"weapons/flail",
			"weapons/military_pick"
		];
		if (this.Const.DLC.Unhold && this.Const.DLC.Wildmen && this.Const.DLC.Desert)
		{
			w.extend([
				"weapons/spetum",
				"weapons/polehammer",
				"weapons/three_headed_flail",
				"weapons/bardiche",
				"weapons/scimitar",
				"weapons/shamshir",
				"weapons/oriental/two_handed_saif",
				"weapons/oriental/two_handed_scimitar"
			]);
		}
		this.m.Items.equip(this.new("scripts/items/" + w[this.Math.rand(0, w.len() - 1)]));
		w = [
			"helmets/cultist_hood",
			"helmets/cultist_leather_hood"
		];
		this.m.Items.equip(this.new("scripts/items/" + w[this.Math.rand(0, w.len() - 1)]));
		w = [
			"armor/leather_wraps",
			"armor/worn_mail_shirt",
			"armor/cultist_leather_robe",
			"armor/monk_robe"
		];
		this.m.Items.equip(this.new("scripts/items/" + w[this.Math.rand(0, w.len() - 1)]));
		if (this.Math.rand(1, 100) <= 50)
		{
			if (this.Math.rand(1, 2) == 1 && this.Const.DLC.Unhold)
			{
				this.m.Items.addToBag(this.new("scripts/items/weapons/throwing_spear"));
			}
			else
			{
				this.m.Items.addToBag(this.new("scripts/items/weapons/javelin"));
			}
		}
	}

});

