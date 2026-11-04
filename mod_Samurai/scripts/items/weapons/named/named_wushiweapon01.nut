this.named_wushiweapon01 <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 2);
		this.updateVariant();
		this.m.ID = "weapon.named_wushiweapon01";
		this.m.Name = "Смерть Самурая-призрака";
		this.m.Description = "Огромная катана. Её хозяином был выдающийся самурай. Эта катана прошла с ним через все войны.";
		this.m.Categories = "Тесак, двуручный";
		this.m.IconLarge = "weapons/melee/wushi_weapon_01.png";
		this.m.Icon = "weapons/melee/wushi_weapon_01_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "wushi_weapon_01";
		this.m.Value = 3200;
		this.m.ShieldDamage = 16;
		this.m.Condition = 84.0;
		this.m.ConditionMax = 84.0;
		this.m.StaminaModifier = -12;
		this.m.RegularDamage = 75;
		this.m.RegularDamageMax = 85;
		this.m.ArmorDamageMult = 1.1;
		this.m.DirectDamageMult = 0.3;
		this.randomizeValues();
	}
	
	function getTooltip()
	{
		local result = this.weapon.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Воскрешает любого убитого им человека как Ведергангера, сражающегося за вас"
		});
		return result;
	}
	function onDamageDealt( _target, _skill, _hitInfo )
	{
		this.weapon.onDamageDealt(_target, _skill, _hitInfo);

		if (!this.isKindOf(_target, "player") && !this.isKindOf(_target, "human"))
		{
			return;
		}

		if (_target.getHitpoints() > 0)
		{
			return;
		}

		if (_hitInfo.Tile.IsCorpseSpawned && _hitInfo.Tile.Properties.get("Corpse").IsResurrectable)
		{
		    local actor = this.getContainer().getActor();
			local corpse = _hitInfo.Tile.Properties.get("Corpse");
			corpse.Faction = actor.getFaction() == this.Const.Faction.Player ? this.Const.Faction.PlayerAnimals : actor.getFaction();
			corpse.Hitpoints = 1.0;
			corpse.Items = _target.getItems();
			corpse.IsConsumable = false;
			corpse.IsResurrectable = false;
			this.Time.scheduleEvent(this.TimeUnit.Rounds, this.Math.rand(1, 1), this.Tactical.Entities.resurrect, corpse);
		}
	}
	function onEquip()
	{
		this.named_weapon.onEquip();
		local cleave = this.new("scripts/skills/actives/cleave");
		cleave.m.Icon = "skills/active_210.png";
		cleave.m.IconDisabled = "skills/active_210_sw.png";
		cleave.m.Overlay = "active_210";
		cleave.m.FatigueCost = 15;
		this.addSkill(cleave);
		this.addSkill(this.new("scripts/skills/actives/decapitate"));
		local skillToAdd = this.new("scripts/skills/actives/split_shield");
		skillToAdd.setFatigueCost(skillToAdd.getFatigueCostRaw() + 5);
		this.addSkill(skillToAdd);
	}

});

