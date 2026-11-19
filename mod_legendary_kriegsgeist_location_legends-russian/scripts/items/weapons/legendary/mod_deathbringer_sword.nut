this.mod_deathbringer_sword <- ::inherit("scripts/items/weapons/weapon", {
	// directory scripts/items/weapons/legendary/mod_deathbringer_sword
	m = {
		IsForcedDrop = false,
		StunChance = 0,
		LastSound = "",
		GhostSound = [
			"sounds/enemies/geist_idle_01.wav",
			"sounds/enemies/geist_idle_02.wav",
			"sounds/enemies/geist_idle_03.wav",
			"sounds/enemies/geist_idle_04.wav",
			"sounds/enemies/geist_idle_05.wav",
			"sounds/enemies/geist_idle_06.wav",
			"sounds/enemies/geist_idle_07.wav",
			"sounds/enemies/geist_idle_08.wav",
			"sounds/enemies/geist_idle_09.wav",
			"sounds/enemies/geist_idle_10.wav",
			"sounds/enemies/geist_idle_11.wav",
			"sounds/enemies/geist_idle_12.wav",
			"sounds/enemies/geist_idle_13.wav",
			"sounds/enemies/geist_idle_14.wav",
			"sounds/enemies/geist_idle_15.wav",
			"sounds/enemies/geist_idle_16.wav",
			"sounds/enemies/geist_idle_17.wav",
			"sounds/enemies/dlc4/madman_death_01.wav",
			"sounds/enemies/dlc6/lich_death_01.wav"
		]
	},
	function isCurseRemoved()
	{
		return ::ModLegendaryKriegsgeistLocation.ModSettings.getSetting("curse_is_removed_sword").getValue();
	}

	function getStunChance()
	{
		return ::ModLegendaryKriegsgeistLocation.ModSettings.getSetting("stun_sword").getValue();
	}

	function getName()
	{
		return ::ModLegendaryKriegsgeistLocation.ModSettings.getSetting("name_sword").getValue();
	}

	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.mod_deathbringer_sword";
		this.m.Name = "Нечестивое могущество";
		this.m.Description = "Длинный призрачный двуручный клинок, способный легко пройти сквозь сталь и плоть, разрывая душу того, кто коснется его лезвия. При взгляде на него чувствуется жуткий холод, а слабый голос призывает взять его в руки. По слухам, только смерть может избавить владельца от этого проклятия.";
		this.m.IconLarge = "weapons/melee/mod_deathbringer_sword_02.png"; 
		this.m.Icon = "weapons/melee/mod_deathbringer_sword_02_70x70.png";
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.WeaponType = ::Const.Items.WeaponType.Sword;
		this.m.ItemType = ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded | ::Const.Items.ItemType.Legendary;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.IsIndestructible = true;
		this.m.IsDroppedAsLoot = true;
		this.m.ArmamentIcon = "icon_mod_deathbringer_sword_02";
		this.m.Value = 30000;
		this.m.Condition = 1.0;
		this.m.ConditionMax = 1.0;
		this.m.StaminaModifier = -18;
		//this.m.RegularDamage = 90;
		//this.m.RegularDamageMax = 110;
		//this.m.ShieldDamage = 999;
		this.m.ArmorDamageMult = 0.0;
		this.m.DirectDamageMult = 1.0;
		this.m.ChanceToHitHead = 5;

		// change a bit
		this.m.RegularDamage = ::ModLegendaryKriegsgeistLocation.ModSettings.getSetting("min_damage_sword").getValue();
		this.m.RegularDamageMax = ::ModLegendaryKriegsgeistLocation.ModSettings.getSetting("max_damage_sword").getValue();
		this.m.ShieldDamage = ::ModLegendaryKriegsgeistLocation.ModSettings.getSetting("shield_damage_sword").getValue();
	}

	function getTooltip()
	{
		local result = this.weapon.getTooltip();
		local a = {
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Полностью игнорирует доспехи, может победить большинство бесплотных существ."
		};
		
		if (this.isEquipped() && !this.isCurseRemoved())
		{
			result.push({
				id = 25,
				type = "hint",
				icon = "ui/tooltips/negative.png",
				text = "Даёт [color=" + ::Const.UI.Color.DamageValue + "]травму руки[/color], если владелец снимает этот предмет"
			});
		}
		
		return result;
	}

	// let the weapon play ghost sound when turn starts, a gimmick feature
	function onTurnStart()
	{
		local s;
		do
		{
			s = ::MSU.Array.rand(this.m.GhostSound);
		}
		while (this.m.LastSound == s && this.m.GhostSound.len() > 1);

		this.Sound.play(s, ::Const.Sound.Volume.Actor * ::Const.Sound.Volume.ActorIdle * (::Math.rand(60, 100) * 0.01), this.getContainer().getActor().getPos(), ::Math.rand(85, 125) * 0.01);
		this.m.LastSound = s;
	}

	function isForcedDrop()
	{
		return this.m.IsForcedDrop;
	}

	function drop( _tile = null )
	{
		this.m.IsForcedDrop = true;
		this.weapon.drop(_tile);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.m.IsForcedDrop = false;

		local skillToAdd = ::new("scripts/skills/actives/mod_ghost_overhead_strike_skill");
		skillToAdd.setStunChance(this.getStunChance());
		skillToAdd.setGhostSound(this.m.GhostSound);
		this.addSkill(skillToAdd);

		this.addSkill(::new("scripts/skills/actives/mod_ghost_split_skill"));
		this.addSkill(::new("scripts/skills/actives/mod_ghost_swing_skill"));

		skillToAdd = ::new("scripts/skills/actives/split_shield");
		skillToAdd.setFatigueCost(skillToAdd.getFatigueCostRaw() + 7);
		this.addSkill(skillToAdd);
	}

	function onUnequip()
	{
		if (!this.m.IsForcedDrop && !this.isCurseRemoved()) 
		{
			local a = [];
			a.extend(::Const.Injury.FeedDog);
			a.remove(a.len() - 1);
			this.getContainer().getActor().addInjury(a);
		}

		this.weapon.onUnequip();
	}

	function onUpdateProperties( _properties )
	{
		this.m.ArmorDamageMult = 1.0;
		this.weapon.onUpdateProperties(_properties);
		_properties.IsImmuneToDisarm = true;
		_properties.DamageReceivedMiasmaMult *= 0.5;
		this.m.ArmorDamageMult = 0.0;
	}

	function setBloodied( _isBloodied )
	{
		this.weapon.setBloodied(false);
	}

});

