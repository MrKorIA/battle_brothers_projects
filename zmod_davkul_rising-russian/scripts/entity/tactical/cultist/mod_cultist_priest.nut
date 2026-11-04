//bannerman, buffs the others to keep their morale up, is in every cultist party
this.mod_cultist_priest <- this.inherit("scripts/entity/tactical/human", {
	m = {
	},
	function create()
	{
		#this.m.Type = this.Const.EntityType.Cultist_Prophet;
		this.m.BloodType = this.Const.BloodType.Red;
		this.human.create();
		this.m.SoundPitch = 0.9;
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Raider;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/cultist_prophet_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.human.onInit();
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_mod_cultist");
		local dirt = this.getSprite("dirt");
		dirt.Visible = true;
		dirt.Alpha = this.Math.rand(150, 255);
		this.getSprite("armor").Saturation = 0.85;
		this.getSprite("helmet").Saturation = 0.85;
		this.getSprite("helmet_damage").Saturation = 0.85;
		this.getSprite("shield_icon").Saturation = 0.85;
		this.getSprite("shield_icon").setBrightness(0.85);

		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_captain"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_inspiring_presence"));
		this.m.Skills.add(this.new("scripts/skills/actives/rotation"));
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/sacrifice_ally_skill"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_footwork"));

		this.m.Skills.add(this.new("scripts/skills/actives/mod_dark_chant"));
		this.m.Skills.add(this.new("scripts/skills/traits/cultist_prophet_trait"));
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.actor.onAppearanceChanged(_appearance, false);
		this.setDirty(true);
	}

	function assignRandomEquipment()
	{
		local banner = 13;
		local weapon = this.new("scripts/items/tools/player_banner");
		weapon.setVariant(13);
		weapon.m.IsDroppedAsLoot = false;
		this.m.Items.equip(weapon);

		local armors = [
		"scripts/items/armor/mail_shirt",
		"scripts/items/armor/worn_mail_shirt",
		"scripts/items/armor/basic_mail_shirt",
		]

		local armor = this.new(armors[this.Math.rand(0, armors.len()-1)])	//armor
		local tabard = this.new("scripts/items/armor_upgrades/tabard_01_upgrade")
		armor.setUpgrade(tabard)
		this.m.Items.equip(armor);

	}

	function hasPriest()
	{
		local actors = this.Tactical.Entities.getInstancesOfFaction(this.getFaction());
		foreach(a in actors )
		{
			if (a == null || !a.isAlive() || a == this) continue
			if (::mods_isClass(a, "mod_cultist_priest"))
			{
				return true;
			}
		}
		return false;
	}

	function getSacrifices()
	{
		local actors = this.Tactical.Entities.getInstancesOfFaction(this.getFaction());
		local sacrifices = []
		foreach(a in actors )
		{

			if (a == null || !a.isAlive() || a == this) continue
			if (a.m.Type == this.Const.EntityType.Cultist_Sacrifice)
			{
				sacrifices.push(a);
			}
		}
		return sacrifices;
	}

	function killSacrifices()
	{
		if (!this.hasPriest())
		{
			foreach (a in this.getSacrifices()) a.kill(this)
		}
	}

	function onDeath(_killer, _skill, _tile, _fatalityType)
	{
		this.human.onDeath(_killer, _skill, _tile, _fatalityType);
		local actors = this.Tactical.Entities.getInstancesOfFaction(this.getFaction());
		foreach(a in actors )
		{

			if (a == null || !a.isAlive() || a == this) continue
			if (!::mods_isClass(a, "mod_cultist_priest") && a.m.Type != this.Const.EntityType.Cultist_Sacrifice)
			{
				a.checkMorale(-1, 0, this.Const.MoraleCheckType.MentalAttack);
			}
		}
		this.killSacrifices();
	}

	function retreat()
	{
		this.killSacrifices();
		this.actor.retreat();
	}

});