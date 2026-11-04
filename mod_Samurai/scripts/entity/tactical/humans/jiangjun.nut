this.jiangjun <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.Jiangjun;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Jiangjun.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.WushiMale;
		this.m.Hairs = this.Const.Hair.WushiMaleOnly;
		this.m.HairColors = this.Const.HairColors.Wushi;
		this.m.Beards = this.Const.Beards.SouthernUntidy;
		this.m.BeardChance = 0;
		this.m.SoundPitch = 0.95;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/jiangjun_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.human.onInit();

		if (::mods_getRegisteredMod("mod_more_heads_extended") == null)
		{
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
		}

		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Jiangjun);
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
		this.getSprite("socket").setBrush("bust_base_wildmen_01");
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_anticipation"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_flow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_duelist"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_underdog"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/effects/dodge_effect"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_berserk"));
		this.m.Skills.add(this.new("scripts/skills/actives/footwork"));
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
		
		if (("State" in this.Tactical) && this.Tactical.State != null && !this.Tactical.State.isScenarioMode())
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
				b.MeleeSkill += bonus;
				b.RangedSkill += bonus;
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
		local weapons = [
			
			"weapons/wushiweapon39"
			
		];

		this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));

		

		local armor = [
		"armor/wushi_armor19"
		];
		this.m.Items.equip(this.new("scripts/items/" + armor[this.Math.rand(0, armor.len() - 1)]));
		local helmet = [
		"helmets/wushi_helmet17"
		];
		this.m.Items.equip(this.new("scripts/items/" + helmet[this.Math.rand(0, helmet.len() - 1)]));
	}

	function readyToSettlement()
	{
		local armor = [
		"armor/wushi_armor19"
		];
		this.m.Items.equip(this.new("scripts/items/" + armor[this.Math.rand(0, armor.len() - 1)]));
		local helmet = [
		"helmets/wushi_helmet17"
		];
		this.m.Items.equip(this.new("scripts/items/" + helmet[this.Math.rand(0, helmet.len() - 1)]));
	}

	function makeMiniboss()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		this.getSprite("miniboss").setBrush("bust_miniboss");
		local weapons = [
			"weapons/named/named_wushiweapon41"
		];
		

		if (this.Math.rand(1, 100) <= 99)
		{
			this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		}
		
		this.m.BaseProperties.DamageDirectMult *= 1.25;
		this.m.Skills.add(this.new("scripts/skills/perks/perk_relentless"));
		return true;
	}

});

