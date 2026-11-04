this.xxmob_vampguard <- this.inherit("scripts/entity/tactical/enemies/vampire", {
	m = {},
	function create()
	{
		this.vampire.create();
		this.m.Name = this.Const.Strings.FT.M74;
	}

	function onInit()
	{
		this.vampire.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Vampire);
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToPoison = true;
		b.IsSpecializedInSwords = true;
		b.IsSpecializedInShields = true;
		b.DamageTotalMult *= 1.1;
		b.DamageReceivedArmorMult *= 0.8;
		b.FatigueDealtPerHitMult *= 1.5;
		b.Initiative += -30;
		local body = this.getSprite("body");
		body.Color = this.createColor("#ffe3ba");
		body.varyColor(0.03, 0.03, 0.03);
		local head = this.getSprite("head");
		head.Color = body.Color;
		head.Saturation = 2.0;
		head.setBrightness(3.0);
		this.m.Skills.update();
	}

	function assignRandomEquipment()
	{
		local hat = this.new("scripts/items/helmets/nasal_helmet");
		hat.setVariant(1);
		this.m.Items.equip(hat);
		this.m.Items.equip(this.new("scripts/items/armor/decayed_reinforced_mail_hauberk"));
		this.m.Items.equip(this.new("scripts/items/weapons/named/named_sword"));
		this.m.Items.equip(this.new("scripts/items/shields/named/named_undead_heater_shield"));
	}

	function onUpdateInjuryLayer()
	{
		this.getSprite("body_injury").Visible = this.m.WasInjured;
		this.getSprite("injury").Visible = this.m.WasInjured;
		this.setDirty(true);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.m.BloodType = this.Const.BloodType.Ash;
		local flip = this.Math.rand(0, 100) < 50;
		this.m.IsCorpseFlipped = flip;
		if (_tile != null)
		{
			local decal = _tile.spawnDetail("bust_skeleton_vampire_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false);
			decal.Scale = 0.9;
			decal.setBrightness(0.9);
			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.Faction = this.getFaction();
			corpse.CorpseName = this.getName();
			corpse.Tile = _tile;
			corpse.IsHeadAttached = true;
			corpse.IsConsumable = true;
			corpse.IsResurrectable = false;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}
		if (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			local loot = this.new("scripts/items/misc/vampire_dust_item");
			loot.drop(_tile);
		}
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

});

