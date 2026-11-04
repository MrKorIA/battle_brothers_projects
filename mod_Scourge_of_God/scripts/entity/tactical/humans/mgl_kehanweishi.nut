this.mgl_kehanweishi <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.Kehanweishi;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Kehanweishi.XP;
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
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Kehanweishi);
		b.DamageDirectMult = 1.25;
		b.IsSpecializedInBows = true;
		b.Vision = 8;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
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

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (!this.Tactical.State.isScenarioMode() && _killer != null && _killer.isPlayerControlled() && _skill != null && _skill.isRanged())
		{
			this.updateAchievement("Bullseye", 1, 1);
		}

		this.human.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.actor.onAppearanceChanged(_appearance, false);
		this.setDirty(true);
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
				"armor/mgl06_armor_01"
			];
			this.m.Items.equip(this.new("scripts/items/" + armor[this.Math.rand(0, armor.len() - 1)]));
		}

		if (this.m.Items.hasEmptySlot(this.Const.ItemSlot.Head) && this.Math.rand(1, 100) <= 80)
		{
			local helmet = [
				"helmets/mgl06_helmet_01"
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
			"weapons/named/named_warbow",
			"ammo/quiver_of_arrows"
		];
		local armor = [
			"armor/named/named_mgl07_armor_01",
			"armor/named/named_mgl08_armor_01",
			"armor/named/named_mgl09_armor_01"
		];
		
		local helmets = [
			"helmets/named/named_mgl07_helmet_01",
			"helmets/named/named_mgl08_helmet_01",
			"helmets/named/named_mgl09_helmet_01"
		];
		local r = this.Math.rand(1, 3);

		if (r == 1)
		{
			local r = this.Math.rand(0, weapons.len() - 1);

			foreach( w in weapons[r] )
			{
				this.m.Items.equip(this.new("scripts/items/" + w));
			}
		}
		
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/" + armor[this.Math.rand(0, armor.len() - 1)]));
		}
		else
		{
			this.m.Items.equip(this.new("scripts/items/" + helmets[this.Math.rand(0, helmets.len() - 1)]));
		}
        this.m.BaseProperties.DamageDirectMult *= 1.25;
		this.m.Skills.add(this.new("scripts/skills/perks/perk_relentless"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
		return true;
	}

});

