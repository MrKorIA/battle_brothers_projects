this.hangman_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_hangman";
		this.m.Name = "Палач";
		this.m.Icon = "ui/backgrounds/background_hangman.png";
		this.m.BackgroundDescription = "Палачи не понаслышке знакомы со смертью, но не видали её во всём многообразии неуклюжих способов, что встречаются на поле боя.";
		this.m.GoodEnding = "Бывший ополченец %name% в конце концов покинул %companyname%. Он путешествовал по землям, посещая деревни и помогая им создавать боеспособные отряды ополчения для самозащиты. Добившись успеха во все более опасном мире, %name% в конце концов стал известным человеком, к которому обращались как к своего рода \'решале\', чтобы он помогал деревням оставаться в безопасности. Последнее, что вы слышали, - он купил участок земли и растит семью вдали от мирских распрей.";
		this.m.BadEnding = "%name% покинул распадающуюся отряд и вернулся в свою деревню. Вернувшись в ополчение, он вскоре узнал, что {зеленокожие | налетчики} нападают, и его призвали на защиту. Говорят, он стоял насмерть, руководя обороной и убивая бесчисленных врагов, пока не пал от смертельных ран. Когда вы посетили деревню, вы нашли детей, играющих в войну под статуей, сделанной по образу ополченца.";
		this.m.HiringCost = 85;
		this.m.DailyCost = 7;
		this.m.Excluded = [
			"trait.ailing",
			"trait.athletic",
			"trait.bright",
			"trait.deathwish",
			"trait.drunkard",
			"trait.fragile",
			"trait.gluttonous",
			"trait.hate_undead",
			"trait.impatient",
			"trait.insecure",
			"trait.loyal",
			"trait.lucky",
			"trait.optimist",
			"trait.quick",
			"trait.short_sighted",
			"trait.spartan",
			"trait.swift",
			"trait.tough",
			"trait.weasel"
		];
		this.m.Titles = [
			"Палач",
			"Палач",
			"Рычаг",
			"Последнее слово",
			"Хладнокровный"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.IsLowborn = true;
	}

	function onBuildDescription()
	{
		return "{Будучи в прошлом коронером, %name% всегда был равнодушен к виду смерти. Однажды, когда местные крестьяне хотели линчевать осквернителя могил, %name% сам вызвался дёрнуть рычаг. Переход от осмотра трупов к их созданию не тяготил совесть %name%, и вскоре он стал городским палачом. %name% смотрит на вас холодным взглядом мёртвой рыбы и просто говорит, что раз роль палача не всколыхнула его чувства, возможно, это сделает пыл битвы.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [4, 4]
			Bravery = [4, 4]
			Stamina = [0, 0]
			MeleeSkill = [0, 0]
			RangedSkill = [0, 0]
			MeleeDefense = [0, 0]
			RangedDefense = [0, 0]
			Initiative = [0, -2]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 4) == 4)
		{
			local actor = this.getContainer().getActor();
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		local weapons = [
			"weapons/hooked_blade",
			"weapons/bludgeon",
			"weapons/hand_axe",
			"weapons/militia_spear",
			"weapons/shortsword"
		];

		if (this.Const.DLC.Wildmen)
		{
			weapons.extend([
				"weapons/warfork"
			]);
		}

		items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));

		if (items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null && this.Math.rand(1, 100) <= 50)
		{
			items.equip(this.new("scripts/items/shields/buckler_shield"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_lamellar"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 6);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/full_leather_cap"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});

