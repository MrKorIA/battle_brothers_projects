this.legend_legion_honour_guard_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.legend_legion_honour_guard"; //I don't care who they send, im not spelling it 'honor'.
        this.m.Name = "Почётный страж";
        this.m.Icon = "ui/backgrounds/background_puppet.png"; //TODO
        this.m.BackgroundDescription = "Ветеран сотен битв. Почётный страж получает награду за свою доблесть в виде всё возрастающей опасности.";
		this.m.GoodEnding = "";
		this.m.BadEnding = "";
		this.m.HiringCost = 0;
		this.m.DailyCost = 0;
		this.m.Excluded = [
            "trait.ailing",
            "trait.asthmatic",
            "trait.bleeder",
            "trait.brave",
            "trait.gluttonous",
            "trait.craven",
            "trait.dastard",
            "trait.deathwish",
            "trait.determined",
            "trait.disloyal",
            "trait.drunkard",
            "trait.fainthearted",
            "trait.fat",
            "trait.fear_undead",
            "trait.fear_greenskins",
            "trait.fear_beasts",
            "trait.fearless",
            "trait.eagle_eyes",
            "trait.greedy",
            "trait.hate_undead",
            "trait.insecure",
            "trait.iron_lungs",
            "trait.irrational",
            "trait.loyal",
            "trait.night_owl",
            "trait.night_blind",
            "trait.optimist",
            "trait.paranoid",
            "trait.pessimist",
            "trait.spartan",
            "trait.superstitious",
            "trait.weasel",
            "trait.legend_fear_nobles",
            "trait.legend_slack",
            "trait.legend_double_tongued",
            "trait.legend_gift_of_people",
            "trait.legend_seductive"
            ];

		this.m.ExcludedTalents = [
			// this.Const.Attributes.RangedSkill,
			//this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue,
			this.Const.Attributes.Bravery
		];

		//apperance
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.BeardChance = 0;
		//---
		this.m.Names = this.Const.Strings.AncientDeadNames;
		// this.m.LastNames = this.Const.Strings.AncientDeadTitles;
		this.m.Level = this.Math.rand(2, 4);

	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor().get();

		if (::MSU.isKindOf(actor, "player"))
		{
			if (actor.getFlags().has("human"))
				actor.getSprite("injury_body").setBrush("bust_skeleton_body_injured");

			local hairColor = this.Const.HairColors.Zombie[this.Math.rand(0, this.Const.HairColors.Zombie.len() - 1)];
			local body = actor.getSprite("body");
			body.setBrush("bust_skeleton_body_0" + this.Math.rand(1, 2));
			body.Saturation = 0.8;

			actor.getSprite("injury_body").setBrush("bust_skeleton_body_injured");

			local head = actor.getSprite("head");
			head.setBrush("bust_skeleton_head");
			head.Color = body.Color;
			head.Saturation = body.Saturation;

			local beard = actor.getSprite("beard");
			if (beard == !null)
			{
				beard.setBrush("beard_" + hairColor + "_" + this.Const.Beards.ZombieOnly[this.Math.rand(0, this.Const.Beards.ZombieOnly.len() - 1)]);
				local beard_top = actor.getSprite("beard_top");
				if (beard.HasBrush && this.doesBrushExist(beard.getBrush().Name + "_top"))
				{
					beard_top.setBrush(beard.getBrush().Name + "_top");
					beard_top.Color = beard.Color;
				}
			}

			local face = actor.getSprite("scar_head");
			if (face == !null)
				face.setBrush("bust_skeleton_face_0" + this.Math.rand(1, 6));

			local hair = actor.getSprite("hair");
			if (hair == !null)
			{
				hair.Color = beard.Color;
				hair.setBrush("hair_" + hairColor + "_" + this.Const.Hair.ZombieOnly[this.Math.rand(0, this.Const.Hair.ZombieOnly.len() - 1)]);
				actor.setSpriteOffset("hair", this.createVec(0, -3));
			}

			local injury = actor.getSprite("injury");
			if (injury == !null)
				injury.setBrush("bust_skeleton_head_injured");

		}
	}

	function onBuildDescription() //to do
	{
        return "{%name% был рождён в древней империи, которая простиралась от моря до самой пустыни, и с детства знал, что его долг - защищать трон ценой собственной жизни. | С юных лет %name% был отобран среди тысяч кандидатов за свою преданность и силу, ибо в Почётную стражу брали лишь лучших из лучших. | Он принёс клятву у подножия золотого трона - клятву, которая связывала его не только с Императором, но и с самой землёй, ибо империя была его истинной родиной. | %name% носил доспехи, которые весили больше обычного человека, и держал копьё, которое могло пронзить щит врага с одного удара. | Его семья веками служила имперской гвардии, и %name% продолжил эту традицию, зная, что его предки наблюдают за ним из чертогов мёртвых. | Немногие стражи могли похвастаться тем, что пережили столько покушений на трон, сколько пережил он - каждый раз оставаясь на ногах, пока вокруг падали те, кого он должен был защищать.} {Этот Почётный страж был обучен сражаться в любых условиях - от дворцовых залов до пустынных полей битв, и он знает каждую уловку врагов империи. | Когда Император отдавал приказ, он был первым, кто исполнял его, и последним, кто покидал поле боя, забирая с собой головы самых опасных противников. | Помимо охраны трона, ему доводилось сопровождать императорские караваны, усмирять мятежи и обрывать жизни тех, кто смел бросить вызов имперской воле. | В свободное от службы время он обучал молодых рекрутов искусству боя в строю, и многие из них выжили благодаря его урокам в тех битвах, что унесли жизни остальных.} { Когда империя рухнула, он встретил свой конец с оружием в руках, и с тех пор в его костях будто застыли отголоски того боя - каждый удар клинка, каждый шаг некогда безупречного строя. | Говорят, что проклятие павшей империи навсегда привязало стражей к их клятве, и теперь он восстаёт из песков, когда ветер приносит запах старой крови и остывшего золота.} {Среди мёртвых стражей он выделяется своей суровостью и бесконечной преданностью идеалам, которые давно сгинули в песках вместе с империей. | Он не разговаривает с живыми, ибо считает их лишь песком, проходящим сквозь пальцы времени, и его голос - это лишь скрежет костей, когда они трутся друг о друга. | Некоторые говорят, что он сохранил лишь частицу человечности - достаточно, чтобы помнить имя императора, но недостаточно, чтобы помнить своё собственное. | Он редко проявляет инициативу в мирное время, но как только чувствует угрозу, его кости оживают с такой яростью, что враги забывают, что он уже мёртв. | Он избегает живых, предпочитая стоять в безмолвном строю, пока песок не поднимается ветром и не засыпает его по колени. | Иногда его слышат, когда он нашёптывает старые молитвы, обращённые к богам, которых уже никто не помнит, и в его пустых глазницах мелькает огонёк, похожий на печаль. | Ходят слухи, что он ищет не славу и не золото - он ищет покой, которого его клятва не даст ему до тех пор, пока империя не восстанет из песков вновь. | И хотя он не понимает современных языков и не признаёт новых богов, его копьё всё ещё разит точно так же, как и тысячу лет назад. | %name% - это живое напоминание о том, что песок не хранит тайн, он лишь ждёт, когда кто-то достаточно сильный откроет их и столкнётся с тенью того, что было однажды утрачено.}";
	}

	function onChangeAttributes() //uses Character_background.nut template (Skeleton)
	{
		local c = {
			Hitpoints = [
				3,
				6
			],
			Bravery = [ //not needed except for resisting charm and sleep
				10,
				15
			],
			Stamina = [ //not needed except for equipment weight
				20,
				20
			],
			MeleeSkill = [
				5,
				8
			],
			RangedSkill = [
				2,
				4
			],
			MeleeDefense = [
				4,
				7
			],
			RangedDefense = [
				1,
				2
			],
			Initiative = [
				-2,
				1
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
		local actor = this.getContainer().getActor();
        if (!actor.getSkills().hasSkill("trait.legend_fleshless"))
        {
            actor.getSkills().add(this.new("scripts/skills/traits/legend_fleshless_trait"));
        }

		actor.m.ExcludedInjuries = [
            "injury.cut_artery",
            "injury.cut_throat",
            "injury.deep_abdominal_cut",
            "injury.deep_chest_cut",
            "injury.exposed_ribs",
            "injury.grazed_kidney",
            "injury.grazed_neck",
            "injury.infected_wound",
            "injury.sickness",
            "injury.stabbed_guts",
            "injury.broken_nose",
            "injury.crushed_windpipe",
            "injury.fractured_ribs",
            "injury.inhaled_flames",
            "injury.pierced_chest",
            "injury.ripped_ear",
            "injury.cut_arm_sinew",
            "injury.pierced_lung",
            "injury.cut_leg_muscles",
            "injury.pierced_side",
            "injury.pierced_cheek"
        ];
		actor.getFlags().add("legion_can_command");
	}

	function adjustHiringCostBasedOnEquipment() //reduces cost for equipment worn on skeletons to zero for recruiting purposes.
	{
		local actor = this.getContainer().getActor();
		actor.m.HiringCost = this.Math.floor(this.m.HiringCost + 500 * this.Math.pow(this.m.Level - 1, 1.5));
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();

        local weapon = ::MSU.Class.WeightedContainer([
            [1, "scripts/items/weapons/ancient/bladed_pike"],
            [1, "scripts/items/weapons/ancient/warscythe"],
            [1, "scripts/items/weapons/ancient/rhomphaia"],
            [1, "scripts/items/weapons/ancient/ancient_sword"],
            [1, "scripts/items/weapons/ancient/crypt_cleaver"]
        ]).roll();
        items.equip(this.new(weapon));

		if (items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null) {
            weapon = ::MSU.Class.WeightedContainer([
                [2, "scripts/items/shields/ancient/coffin_shield"],
                [1, "scripts/items/shields/ancient/tower_shield"]
            ]).roll();
            items.equip(this.new(weapon));
		}

		local r = this.Math.rand(0, 3);
		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ancient/ancient_plated_scale_hauberk"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/ancient/ancient_scale_coat"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/ancient/ancient_plate_harness"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/ancient/ancient_plated_mail_hauberk"));
		}

		r = this.Math.rand(0, 2);
        if (r == 0)
        {
            items.equip(this.new("scripts/items/helmets/ancient/ancient_honorguard_helmet"));
        }
        else if (r == 1)
        {
            items.equip(this.new("scripts/items/helmets/ancient/ancient_honorguard_helmet"));
        }

	}
});
