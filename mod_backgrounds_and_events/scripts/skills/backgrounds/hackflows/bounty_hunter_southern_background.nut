this.bounty_hunter_southern_background <- this.inherit("scripts/skills/backgrounds/hackflows/bounty_hunter_background", {
	m = {},
	function create()
	{
		this.bounty_hunter_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernMale;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.ailing",
			"trait.asthmatic",
			"trait.brute",
			"trait.clubfooted",
			"trait.clumsy",
			"trait.craven",
			"trait.dastard",
			"trait.deathwish",
			"trait.drunkard",
			"trait.dumb",
			"trait.fat",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.fragile",
			"trait.hesitant",
			"trait.huge",
			"trait.insecure",
			"trait.iron_jaw",
			"trait.iron_lungs",
			"trait.irrational",
			"trait.loyal",
			"trait.night_blind",
			"trait.night_owl",
			"trait.optimist",
			"trait.paranoid",
			"trait.superstitious",
			"trait.teamplayer",
			"trait.tough"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
    {
        return "{%name% - загадка для всех, кто с ним сталкивался: даже те, кто работал с ним прежде, редко слышали от него больше пары фраз, не относящихся напрямую к делу | %name% немногословен настолько, что за ним закрепилась дурная слава человека без прошлого - будто оно ему без надобности. | %name% известен немногим, и он явно не намерен ничего менять - на все расспросы он отвечает лишь долгим, изучающим взглядом. | %name% говорит ровно столько, сколько требует дело, и ни словом больше - расспрашивать его о чём-то ещё бесполезно. | Никто не помнит, чтобы %name% рассказывал о себе хоть что-то личное - те немногие, кто пытался разговорить его, быстро оставляли эту затею.} {Ходят слухи, что он выслеживает беглых рабов для богатых домов, которым проще заплатить ему, чем снаряжать погоню самим. | Поговаривают, что не один торговец, откупившийся от воинской повинности мошенническим золотом, однажды находил его у своих дверей. | Рассказывают, что он способен неделями идти по следу одного-единственного человека через самую глухую часть пустыни, если цена за его голову того стоит. | Слухи о его работе редко бывают приятными: беглые преступники, укрывшиеся под вымышленным именем в чужом городе, знают, что от него не спрятаться и за высокими стенами. | Говорят, что городская стража охотно платит ему за головы тех, кого сама поймать не в силах - и что взятки на него почему-то никогда не действуют. | Говорят, что он выслеживает тех, кто нарушил законы Златоликого или сбежал из цепей визиря.} {Его ремесло и без того недалеко от наёмничьего дела - выложить кроны за такого человека, как он, любой уважающий себя отряд счёл бы вложением не из худших. | Он не задаёт лишних вопросов о том, что от него потребуется - похоже, работа наёмника мало чем отличается от его обычного заработка. | Ему не нужны друзья и не нужны молитвы Златоликому - ему нужно только место, где платят за его умение находить тех, кто не должен быть найден живым. | Вас не смущает его немногословность - в конце концов, для человека его ремесла молчание куда полезнее, чем красноречие. | Такой человек, как %name%, станет ценным приобретением для любого отряда - он умеет читать следы там, где другие видят лишь голую землю.}";
    }

	function onAddEquipment()
    {
        local items = this.getContainer().getActor().getItems();
        local r;
        items.equip(this.new("scripts/items/tools/reinforced_throwing_net"));
        r = this.Math.rand(0, 1);

        if (r == 0)
        {
            items.addToBag(this.new("scripts/items/weapons/oriental/composite_bow"));
            items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
        }
        else if (r == 1)
        {
            items.addToBag(this.new("scripts/items/weapons/rondel_dagger"));
        }

        r = this.Math.rand(0, 2);

        if (r == 0)
        {
            items.equip(this.new("scripts/items/weapons/oriental/light_southern_mace"));
        }
        else if (r == 1)
        {
            items.equip(this.new("scripts/items/weapons/oriental/saif"));
        }
        else if (r == 2)
        {
            items.equip(this.new("scripts/items/weapons/oriental/heavy_southern_mace"));
        }

        r = this.Math.rand(0, 1);

        if (r == 0)
        {
            items.equip(this.new("scripts/items/armor/oriental/nomad_robe"));
        }

        if (r == 1)
        {
            items.equip(this.new("scripts/items/armor/oriental/leather_nomad_robe"));
        }
    }

});

