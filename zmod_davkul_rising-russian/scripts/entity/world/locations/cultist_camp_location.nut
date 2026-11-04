//normal cultist base that spawns close to a settlement and sens out raids
this.cultist_camp_location <- this.inherit("scripts/entity/world/location", {
	m = {
		SacrificeCount = 0,
		SituationID = "situation.cultist_incursion",
		TargetSettlement = null,
		NextRaiderSpawn = 0.0,
		SacrificeCount = 0,
		Size = 1,
		},
	function getDescription()
	{
		return "Зловещее логово, в котором культисты готовят набеги на близлежащие поселения.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.cultist_camp";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.CombatLocation.Template[0] = "tactical.cultist_camp";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.None;
		this.m.CombatLocation.CutDownTrees = true;
		this.m.IsDespawningDefenders = false;
		this.m.IsScalingDefenders = true;
		this.setDefenderSpawnList(this.Const.World.Spawn.CultistDefenders);
		this.m.Resources = this.Const.CultistConfig.MinLairResources;
		this.updateName()
		this.m.NamedWeaponsList = this.Const.Items.NamedCultistWeapons;
		this.m.NamedHelmetsList = this.Const.Items.NamedCultistHelmets;
	}

	function setTargetSettlement(_settlement)
	{
		local situation = this.new("scripts/entity/world/settlements/situations/cultist_incursion_situation");
		situation.setValidForDays(999);
		_settlement.addSituation(situation);
		this.m.TargetSettlement = this.WeakTableRef(_settlement);
	}

	function onSpawned()
	{
		this.location.onSpawned();
		this.setNextRaiderSpawn()
		this.m.Size = 1;
		this.m.SacrificeCount = 5;
		this.updateName();
		this.printDebug("создан лагерь культистов", "mod_cultists")
	}
	function addSacrifices(_num)
	{
		this.m.SacrificeCount = this.Math.min(this.Const.CultistConfig.MaxSacrifices, this.m.SacrificeCount + _num)
		this.grow()
	}

	function setNextRaiderSpawn(_days = 4)
	{
		this.m.NextRaiderSpawn = this.Time.getVirtualTimeF() + _days * this.World.getTime().SecondsPerDay
	}
	function getNextRaiderSpawn()
	{
		return this.m.NextRaiderSpawn
	}
	function readyToSpawnRaiders()
	{
		return (this.m.Size != 3) && (this.getNextRaiderSpawn() < this.Time.getVirtualTimeF())
	}
	function setSize()
	{
		local size = 1
		if (this.m.SacrificeCount >= this.Const.CultistConfig.SacrificeForLvl2) size = 2
		if (this.m.SacrificeCount >= this.Const.CultistConfig.SacrificeForLvl3) size = 3
		this.m.Size = size
	}
	function getSize()
	{
		return this.m.Size
	}
	function getResources()
	{
		return this.Math.min(this.Const.CultistConfig.MaxLairResources, this.Math.max(this.Const.CultistConfig.MinLairResources, this.m.SacrificeCount * this.Const.CultistConfig.LairResourcesPerSacrifice)) 
	}
	function grow()
	{
		if (this.m.Flags.get("ContractLocation")) return
		local currentSize = this.m.Size
		this.setSize()
		this.m.Resources = this.getResources()
		this.createDefenders()
		if (currentSize != this.getSize())
		{
			this.addNameds()
			this.updateName()
			this.updateSprite() 
		}
	}

	function addNameds()
	{
		if (this.Math.rand(0, 100) > this.m.Size * this.m.Size * 3) return //12% lvl2, 27% lvl3
		local items = clone this.Const.Items.NamedWeapons
		items.extend(clone this.Const.Items.NamedArmors)
		items.extend(clone this.Const.Items.NamedHelmets)
		items.extend(clone this.Const.Items.NamedCultistWeapons)
		items.extend(clone this.Const.Items.NamedCultistHelmets)
		this.m.Loot.add(this.new("scripts/items/" + items[this.Math.rand(0, items.len() - 1)]))
	}

	function onCombatLost()
	{
		foreach (settlement in this.getCultists().getLairs()) settlement.setNextRaiderSpawn(6)
		if (this.m.TargetSettlement != null){
			this.m.TargetSettlement.m.Flags.set("CultistProtection", this.Time.getVirtualTimeF() + 14 * this.World.getTime().SecondsPerDay)
			this.m.TargetSettlement.removeSituationByID(this.m.SituationID)
		}

		this.location.onCombatLost()
		if (this.getFlags().has("SlavesFreed") && this.getFlags().get("SlavesFreed") > 0)
		{
			local cultist_event = this.World.Events.getEvent( "event.party.cultist_destroyed" )
			if (cultist_event != null){
				cultist_event.m.SlavesFreed = this.getFlags().get("SlavesFreed")
				this.World.Events.fire("event.party.cultist_destroyed");
			}		
		}
	}
	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);

		local resources = this.getResources()
		if(this.Math.rand(0, 4) == 0) _lootTable.push(this.new("scripts/items/accessory/sacrificial_collar_item"))
		
		this.dropMoney(this.Math.rand(resources/2, resources * 2), _lootTable);
		this.dropArmorParts(this.Math.rand(resources*0.1, resources*0.2), _lootTable);
		this.dropAmmo(this.Math.rand(0, resources*0.1), _lootTable);
		this.dropMedicine(this.Math.rand(0, resources*0.05), _lootTable);
		this.dropFood(this.Math.rand(2, 4), [
			"roots_and_berries_item",
			"pickled_mushrooms_item",
			"smoked_ham_item",
			"mead_item",
			"cured_venison_item",
			"strange_meat_item",
			"strange_meat_item",
			"strange_meat_item"
		], _lootTable);

		local treasure = [
			"trade/furs_item",
			"trade/copper_ingots_item",
			"trade/cloth_rolls_item",
			"trade/salt_item",
			"trade/amber_shards_item",
			"loot/silverware_item",
			"loot/silver_bowl_item",
			"loot/signet_ring_item"
		];

		if (this.Const.DLC.Unhold)
		{
			treasure.extend(treasure);
			treasure.extend(treasure);
			treasure.extend(treasure);
			treasure.push("armor_upgrades/metal_plating_upgrade");
			treasure.push("armor_upgrades/metal_pauldrons_upgrade");
			treasure.push("armor_upgrades/mail_patch_upgrade");
			treasure.push("armor_upgrades/leather_shoulderguards_upgrade");
			treasure.push("armor_upgrades/leather_neckguard_upgrade");
			treasure.push("armor_upgrades/joint_cover_upgrade");
			treasure.push("armor_upgrades/heraldic_plates_upgrade");
			treasure.push("armor_upgrades/double_mail_upgrade");
		}
		this.dropTreasure(this.Math.rand(this.m.Size, this.m.Size*2), treasure, _lootTable);
	}

	function updateSprite()
	{
		if (this.m.Size == 1){
			this.getSprite("body").setBrush("world_cult_camp_01");
		}
		else if (this.m.Size == 2){
			this.getSprite("body").setBrush("world_cult_camp_02");
		}
		else if (this.m.Size == 3){
			this.getSprite("body").setBrush("world_cult_camp_03");
		}
	}
	function updateName()
	{
		this.m.Name = this.Math.randArray(this.Const.CultistConfig.LairNames[this.m.Size-1])
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_cult_camp_01")
		#this.updateName()
		this.setSize();
		this.getLabel("name").Text = this.getName();
	}
	function getTooltip()
	{
		local ret = this.location.getTooltip()
		local divider =  this.Const.CultistConfig.MaxSacrifices
		if (this.m.Size == 1) divider = this.Const.CultistConfig.SacrificeForLvl2
		if (this.m.Size == 2) divider = this.Const.CultistConfig.SacrificeForLvl3
		ret.push({
			id = 20,
			type = "text",
			icon = "ui/orientation/cultist_orientation.png",
			text = format("%i/%i жертв собрано", this.m.SacrificeCount, divider)
		})
		if(this.isDebug("mod_cultists")){
			ret.push({
				id = 21,
				type = "text",
				text = "Ресурсы: " + this.getResources()
			})
			ret.push({
				id = 22,
				type = "text",
				text = "Размер: " + this.getSize()
			})
		}
		return ret
	}
	function createDefenders()
	{
		this.getCultists().recomputeFanatics(this.Const.World.Spawn.CultistDefenders)
		this.location.createDefenders()
	}
	function onSerialize( _out )
	{
		this.location.onSerialize(_out);
		if (this.m.TargetSettlement != null && !this.m.TargetSettlement.isNull())
		{
			_out.writeU32(this.m.TargetSettlement.getID());
		}
		else
		{
			_out.writeU32(0);
		}
		_out.writeU8(this.m.Size)
		_out.writeU8(this.m.SacrificeCount)
		_out.writeF32(this.m.NextRaiderSpawn);
		_out.writeString(this.m.Name);

	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);

		local TargetSettlement = _in.readU32();

		if (TargetSettlement != 0)
		{
			this.m.TargetSettlement = this.WeakTableRef(this.World.getEntityByID(TargetSettlement));
		}
		this.m.Size =  _in.readU8();
		this.m.SacrificeCount  = _in.readU8();
		this.m.NextRaiderSpawn = _in.readF32();
		this.m.Name = _in.readString();

	}


});


