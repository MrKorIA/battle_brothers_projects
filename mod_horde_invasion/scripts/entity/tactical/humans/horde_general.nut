this.horde_general <- this.inherit("scripts/entity/tactical/humans/nomad_centurion", {
	m = {},
	function create()
	{
		this.nomad_centurion.create();
		this.m.Type = this.Const.EntityType.HordeGeneral;
		this.m.XP = this.Const.Tactical.Actor.HordeGeneral.XP;
	}

	function onInit()
	{
		this.human.onInit();

		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.HordeGeneral);
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
		this.m.Skills.add(this.new("scripts/skills/perks/perk_underdog"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_adrenalin"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_anticipation"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_forged"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_berserk"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_recover"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_brawny"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_killing_frenzy"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_rally_the_troops"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_stalwart"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_indomitable"));
	}

	function assignRandomEquipment()
	{
		// Оружие — ВСЕГДА именное (TZ §6): любое из named-пулов Jurchen и Mgl
		local weapons = [
			"weapons/named/named_jinweapon02",
			"weapons/named/named_jinweapon03",
			"weapons/named/named_jinweapon04",
			"weapons/named/named_jinweapon05",
			"weapons/named/named_jinweapon13",
			"weapons/named/named_mgl_05",
			"weapons/named/named_mgl_09"
		];
		this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));

		this.m.Items.equip(this.new("scripts/items/armor/horde_general_armor"));
		this.m.Items.equip(this.new("scripts/items/helmets/horde_general_helmet"));
	}

	function makeMiniboss()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		this.getSprite("miniboss").setBrush("bust_miniboss");

		local weapons = [
			"weapons/named/named_jinweapon02",
			"weapons/named/named_jinweapon03",
			"weapons/named/named_jinweapon04",
			"weapons/named/named_jinweapon05",
			"weapons/named/named_jinweapon13",
			"weapons/named/named_mgl_05",
			"weapons/named/named_mgl_09"
		];
		this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		return true;
	}

});
