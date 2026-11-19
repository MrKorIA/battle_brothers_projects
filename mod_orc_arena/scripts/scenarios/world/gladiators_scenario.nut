this.gladiators_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.gladiators";
		this.m.Name = "Гладиаторы";
		this.m.Description = "[p=c][img]gfx/ui/events/event_155.png[/img][/p][p]Годами вы сражались на южных аренах. Сначала ради свободы, затем - золота, и наконец - ради бессмертной славы. Что ещё судьба уготовила для вас?\n\n[color=#bcad8c]Гладиаторы:[/color] Начните игру с тремя опытными бойцами, облачёнными в хорошее снаряжение и требующими повышенное жалование.\n[color=#bcad8c]Легенды арены:[/color] Каждый гладиатор имеет уникальную боевую особенность.\n[color=#bcad8c]Великолепная тройка:[/color] В вашем отряде не может быть больше 16-ти человек. Если все трое гладиаторов погибнут, то кампания закончится.[/p]";
		this.m.Difficulty = 3;
		this.m.Order = 100;
		this.m.IsFixedLook = true;
	}

	function isValid()
	{
		return this.Const.DLC.Desert;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();

		for( local i = 0; i < 3; i = ++i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.setStartValuesEx([
				"gladiator_origin_background"
			]);
			bro.getSkills().removeByID("trait.survivor");
			bro.getSkills().removeByID("trait.greedy");
			bro.getSkills().removeByID("trait.loyal");
			bro.getSkills().removeByID("trait.disloyal");
			bro.getSkills().add(this.new("scripts/skills/traits/arena_fighter_trait"));
			bro.getFlags().set("ArenaFightsWon", 5);
			bro.getFlags().set("ArenaFights", 5);
			bro.setPlaceInFormation(3 + i);
			bro.getFlags().set("IsPlayerCharacter", true);
			bro.getSprite("miniboss").setBrush("bust_miniboss_gladiators");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			bro.m.PerkPoints = 2;
			bro.m.LevelUps = 2;
			bro.m.Level = 3;
			bro.m.Talents = [];
			bro.m.Attributes = [];
		}

		local bros = roster.getAll();
		local a;
		local u;
		bros[0].setTitle("Лев");
		bros[0].getSkills().add(this.new("scripts/skills/traits/glorious_resolve_trait"));
//		bros[0].getSkills().add(this.new("scripts/skills/perks/perk_lianda"));
		bros[0].getTalents().resize(this.Const.Attributes.COUNT, 0);
		bros[0].getTalents()[this.Const.Attributes.MeleeDefense] = 2;
		bros[0].getTalents()[this.Const.Attributes.Fatigue] = 2;
		bros[0].getTalents()[this.Const.Attributes.MeleeSkill] = 3;
		bros[0].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		a = this.new("scripts/items/armor/oriental/gladiator_harness");
		a.setUpgrade(this.new("scripts/items/armor_upgrades/light_gladiator_upgrade"));
		bros[0].getItems().equip(a);
		a = this.new("scripts/items/helmets/oriental/gladiator_helmet");
		a.setVariant(13);
		bros[0].getItems().equip(a);
		bros[0].getItems().equip(this.new("scripts/items/weapons/scimitar"));
		bros[0].getItems().equip(this.new("scripts/items/tools/throwing_net"));
//		bros[0].getItems().equip(this.new("scripts/items/accessory/special/arena_collar_item"));
		bros[0].improveMood(0.75, "Желает проявить себя вне арены");
		bros[1].setTitle("Медведь");
		bros[1].getSkills().add(this.new("scripts/skills/traits/glorious_endurance_trait"));
		bros[1].getTalents().resize(this.Const.Attributes.COUNT, 0);
		bros[1].getTalents()[this.Const.Attributes.Hitpoints] = 3;
		bros[1].getTalents()[this.Const.Attributes.Fatigue] = 2;
		bros[1].getTalents()[this.Const.Attributes.Bravery] = 2;
		bros[1].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		a = this.new("scripts/items/armor/oriental/gladiator_harness");
		a.setUpgrade(this.new("scripts/items/armor_upgrades/heavy_gladiator_upgrade"));
		bros[1].getItems().equip(a);
		a = this.new("scripts/items/helmets/oriental/gladiator_helmet");
		a.setVariant(15);
		bros[1].getItems().equip(a);
		bros[1].getItems().equip(this.new("scripts/items/weapons/oriental/heavy_southern_mace"));
		bros[1].getItems().equip(this.new("scripts/items/shields/oriental/metal_round_shield"));
		bros[1].improveMood(0.75, "Желает проявить себя вне арены");
		bros[2].setTitle("Змей");
		bros[2].getSkills().add(this.new("scripts/skills/traits/glorious_quickness_trait"));
		bros[2].getTalents().resize(this.Const.Attributes.COUNT, 0);
		bros[2].getTalents()[this.Const.Attributes.MeleeDefense] = 2;
		bros[2].getTalents()[this.Const.Attributes.Initiative] = 3;
		bros[2].getTalents()[this.Const.Attributes.MeleeSkill] = 2;
		bros[2].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		a = this.new("scripts/items/armor/oriental/gladiator_harness");
		a.setUpgrade(this.new("scripts/items/armor_upgrades/light_gladiator_upgrade"));
		bros[2].getItems().equip(a);
		a = this.new("scripts/items/helmets/oriental/gladiator_helmet");
		a.setVariant(14);
		bros[2].getItems().equip(a);
		bros[2].getItems().equip(this.new("scripts/items/weapons/oriental/qatal_dagger"));
		bros[2].getItems().equip(this.new("scripts/items/tools/throwing_net"));
		bros[2].improveMood(0.75, "Желает проявить себя вне арены");
		bros[0].getBackground().m.RawDescription = "{%fullname% утверждает, что сила дарует славу. Чушь! Командир, вот я, " + bros[2].getName() + ", воистину повелеваю дамами этого мира! Узри! Посмотри на него! Взгляни, какой он огромный! А? Вот что я скажу: дурни, упражняйтесь сколько хотите, вам никогда не обрести подобного!}";
		bros[0].getBackground().buildDescription(true);
		bros[1].getBackground().m.RawDescription = "{Говоря начистоту, %fullname% - не лучший боец в нашей ватаге. Командир, посмотри на мои мышцы, разве это не я, " + bros[0].getName() + ", тот, кто повелевает величайшим даром жизни: страхом собственных врагов! Смотри, если я натрусь маслом и встану на свету, мои мышцы воссияют! Подумай, разве небеса не ошибочно размечают в вышине, ведь любая женщина скажет, что они здесь, буквально здесь, на моей прекрасной груди?}";
		bros[1].getBackground().buildDescription(true);
		bros[2].getBackground().m.RawDescription = "{Почему ты смотришь на %fullname%? Командир, это я, " + bros[1].getName() + ", - твой лучший гладиатор! Я - оторвавший хвост линдвурму и задушивший его им! Что вы там вякаете, ублюдки!? Какая это ещё развесистая небылица? Это в лучшем случае раздёрганная ящерица!}";
		bros[2].getBackground().buildDescription(true);
		this.World.Assets.m.BusinessReputation = 100;
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() - 9);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/dried_lamb_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/wine_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money / 2 - (this.World.Assets.getEconomicDifficulty() == 0 ? 0 : 300);
		this.World.Assets.m.ArmorParts = this.World.Assets.m.ArmorParts / 2;
		this.World.Assets.m.Medicine = this.World.Assets.m.Medicine / 2;
		this.World.Assets.m.Ammo = 0;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isIsolatedFromRoads() && randomVillage.isSouthern() && randomVillage.hasBuilding("building.arena"))
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 1), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 1));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 1), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 1));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) == 0)
				{
				}
				else if (!tile.HasRoad)
				{
				}
				else
				{
					randomVillageTile = tile;
					break;
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(16);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/worldmap_11.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.gladiators_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.starting_scenario.onInit();
		this.World.Assets.m.BrothersMax = 16;
		this.World.Assets.m.BrothersMaxInCombat = 16;
	}

	function onCombatFinished()
	{
		local roster = this.World.getPlayerRoster().getAll();
		local gladiators = 0;

		foreach( bro in roster )
		{
			if (bro.getFlags().get("IsPlayerCharacter"))
			{
				gladiators = ++gladiators;
			}
		}

		if (gladiators == 2 && !this.World.Flags.get("GladiatorsOriginDeath2"))
		{
			this.World.Flags.set("GladiatorsOriginDeath2", true);

			foreach( bro in roster )
			{
				if (bro.getFlags().get("IsPlayerCharacter"))
				{
					bro.getBackground().m.RawDescription = "{%fullname% опечален уходом старого друга, но глядя в будущее он понимает, что рядом всегда есть тот, кто поддержит его с тыла. Ну... в братском смысле поддержит с тыла. И в духовном. Только так.}";
					bro.getBackground().buildDescription(true);
				}
			}
		}
		else if (gladiators == 1 && !this.World.Flags.get("GladiatorsOriginDeath1"))
		{
			this.World.Flags.set("GladiatorsOriginDeath1", true);

			foreach( bro in roster )
			{
				if (bro.getFlags().get("IsPlayerCharacter"))
				{
					bro.getBackground().m.RawDescription = "{Ты должен кое-что знать, командир. Я рад, что ты сам не лезешь в бой, а оставляешь это дело за мной. За последние десять лет я не чувствовал себя столь живым, как сейчас. И если вдруг ты увидишь, что я падаю, оставайся на месте и не смей мне помогать, ибо я нахожусь именно там, где и хочу быть.}";
					bro.getBackground().buildDescription(true);
				}
			}
		}

		return gladiators != 0;
	}

});

