this.xxhero_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.adventurer";
		this.m.Name = "Авантюрист";
		this.m.Icon = "ui/backgrounds/background_10.png";
		this.m.BackgroundDescription = "Авантюристы представляют различные расы и являются опытными воинами, которые идут на риск и принимают вызовы ради чести, убеждений, финансовой выгоды или просто ради острых ощущений.";
		this.m.GoodEnding = "%name% ушел из %companyname%. После ухода на пенсию, {Желая спокойной жизни, %name% поселился в маленькой деревне, купил землю, построил дом и жил нормальной, но счастливой жизнью, как и надеялся. | %name% вернулся к жизни авантюриста, убивая монстров, находя сокровища и открывая загадочные места, и остался в памяти как великий авантюрист. | %name% собрал единомышленников, чтобы сформировать группу наемников, стал их лидером, заслужил уважение и сделал себе имя в мире. | %name% стал отличным учителем для начинающих искателей приключений, заработал репутацию и в конце концов был избран мастером Гильдии искателей приключений.}";
		this.m.BadEnding = "%name% ушел на пенсию из %companyname%. {С тех пор никто не слышал никаких новостей о %name% | %name% Считается, что он скончался вскоре после этого от ран, полученных в бою. | %name% вернулся как авантюрист, но, как говорят, умер в нищете, не совершив ничего примечательного.}";
		this.m.HiringCost = 500;
		this.m.DailyCost = 35;
	}

	function onBuildDescription()
	{
		return "Авантюристы принадлежат к разным расам и являются искусными воинами, которые рискуют и берут на себя испытания ради чести, веры, финансовой выгоды или ради самого духа приключений. %fullname% — один из таких авантюристов.";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				1,
				10
			],
			Bravery = [
				5,
				10
			],
			Stamina = [
				1,
				10
			],
			MeleeSkill = [
				8,
				15
			],
			RangedSkill = [
				15,
				18
			],
			MeleeDefense = [
				1,
				2
			],
			RangedDefense = [
				1,
				2
			],
			Initiative = [
				1,
				10
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
		if (!this.m.Container.hasSkill("actives.xxzzfantasy_skill"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/xxzzfantasy_skill"));
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 5);
		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/two_handed_flail"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/polehammer"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/billhook"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/longaxe"));
		}
		else
		{
			items.equip(this.new("scripts/items/weapons/longsword"));
		}

		r = this.Math.rand(0, 17);
		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/ragged_dark_surcoat"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 6)
		{
			items.equip(this.new("scripts/items/armor/thick_tunic"));
		}
		else if (r == 7)
		{
			items.equip(this.new("scripts/items/armor/oriental/nomad_robe"));
		}
		else if (r == 8)
		{
			items.equip(this.new("scripts/items/armor/oriental/thick_nomad_robe"));
		}
		else if (r == 9)
		{
			items.equip(this.new("scripts/items/armor/oriental/stitched_nomad_armor"));
		}
		else if (r == 10)
		{
			items.equip(this.new("scripts/items/armor/oriental/gladiator_harness"));
		}
		else if (r == 11)
		{
			items.equip(this.new("scripts/items/armor/werewolf_hide_armor"));
		}
		else if (r == 12)
		{
			items.equip(this.new("scripts/items/armor/ancient/ancient_mail"));
		}
		else if (r == 13)
		{
			items.equip(this.new("scripts/items/armor/barbarians/scrap_metal_armor"));
		}
		else if (r == 14)
		{
			items.equip(this.new("scripts/items/armor/barbarians/thick_furs_armor"));
		}
		else if (r == 15)
		{
			items.equip(this.new("scripts/items/armor/thick_dark_tunic"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/oriental/gladiator_harness"));
		}
	}

});

