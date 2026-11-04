this.mgl_baihuzhang <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.Baihuzhang;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Baihuzhang.XP;
		this.human.create();
		this.m.Bodies = this.Const.Bodies.SouthernMale;
		this.m.Faces = this.Const.Faces.MglMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.SouthernOnly;
		this.m.BeardChance = 0;
		this.m.Ethnicity = 1;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/bounty_hunter_ranged_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.human.onInit();
		local tattoos = [
			3,
			4,
			5,
			6
		];

		if (this.Math.rand(1, 100) <= 66)
		{
			local tattoo_body = this.actor.getSprite("tattoo_body");
			local body = this.actor.getSprite("body");
			tattoo_body.setBrush("tattoo_0" + tattoos[this.Math.rand(0, tattoos.len() - 1)] + "_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			local tattoo_head = this.actor.getSprite("tattoo_head");
			tattoo_head.setBrush("tattoo_0" + tattoos[this.Math.rand(0, tattoos.len() - 1)] + "_head");
			tattoo_head.Visible = true;
		}

		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Baihuzhang);
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		b.IsSpecializedInSwords = true;
		b.IsSpecializedInAxes = true;
		b.IsSpecializedInMaces = true;
		b.IsSpecializedInFlails = true;
		b.IsSpecializedInPolearms = true;
		b.IsSpecializedInThrowing = true;
		b.IsSpecializedInHammers = true;
		b.IsSpecializedInSpears = true;
		b.IsSpecializedInCleavers = true;
		this.m.Skills.update();
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_nomads");
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_anticipation"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_bullseye"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_flow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_quick_hands"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_head_hunter"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_forged"));
		this.m.Skills.add(this.new("scripts/skills/actives/throw_dirt_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/rotation"));
		this.m.Skills.add(this.new("scripts/skills/actives/footwork"));
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));

		if (!this.Tactical.State.isScenarioMode())
		{
			local dateToSkip = 0;

			switch(this.World.Assets.getCombatDifficulty())
			{
			case this.Const.Difficulty.Easy:
				dateToSkip = 100;
				break;

			case this.Const.Difficulty.Normal:
				dateToSkip = 80;
				break;

			case this.Const.Difficulty.Hard:
				dateToSkip = 60;
				break;

			case this.Const.Difficulty.Legendary:
				dateToSkip = 40;
				break;
			}

			if (this.World.getTime().Days >= dateToSkip)
			{
				local bonus = this.Math.min(1, this.Math.floor((this.World.getTime().Days - dateToSkip) / 20.0));
				b.MeleeSkill += this.Math.floor(bonus / 2);
				b.RangedSkill += this.Math.floor(bonus * 2);
				b.MeleeDefense += this.Math.floor(bonus / 2);
				b.RangedDefense += this.Math.floor(bonus / 2);
				b.Hitpoints += this.Math.floor(bonus * 2);
				b.Initiative += this.Math.floor(bonus / 2);
				b.Stamina += bonus;
				b.Bravery += bonus;
				b.FatigueRecoveryRate += this.Math.floor(bonus / 4);
			}
		}
	}

	function onOtherActorFleeing( _actor )
	{
		if (_actor.getType() == this.Const.EntityType.Slave && _actor.isAlliedWith(this))
		{
			return;
		}

		this.actor.onOtherActorFleeing(_actor);
	}

	function assignRandomEquipment()
	{
		if (this.m.Items.hasEmptySlot(this.Const.ItemSlot.Mainhand))
		{
			this.m.Items.equip(this.new("scripts/items/weapons/mgl_13"));
			this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		}

		local weapons = [
			"weapons/mgl_03",
			"weapons/mgl_04",
			"weapons/mgl_08",
			"weapons/mgl_10",
			"weapons/mgl_12"
		];
		this.m.Items.addToBag(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));

		if (this.m.Items.hasEmptySlot(this.Const.ItemSlot.Body))
		{
			local armor = [
				"armor/mgl03_armor_01",
				"armor/mgl04_armor_01",
				"armor/mgl05_armor_01"
			];
			this.m.Items.equip(this.new("scripts/items/" + armor[this.Math.rand(0, armor.len() - 1)]));
		}

		if (this.m.Items.hasEmptySlot(this.Const.ItemSlot.Head) && this.Math.rand(1, 100) <= 80)
		{
			local helmet = [
				"helmets/mgl05_helmet_01"
			];
			this.m.Items.equip(this.new("scripts/items/" + helmet[this.Math.rand(0, helmet.len() - 1)]));
		}
	}

	function makeMiniboss()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		this.getSprite("miniboss").setBrush("bust_miniboss");
		local weapons = [
			"weapons/named/named_mgl_05",
			"weapons/named/named_mgl_09"
		];

		if (this.Math.rand(1, 100) <= 99)
		{
			this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		}
		this.m.Skills.add(this.new("scripts/skills/perks/perk_killing_frenzy"));
		return true;
	}

});

