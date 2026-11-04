this.treasure_hunters_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.hackflows_treasure_hunters";
		this.m.Name = "Охотники за сокровищами";
		this.m.Description = "[p=c][img]gfx/ui/events/event_04.png[/img][/p][p]Вы промышляете охотой за сокровищами уже долгие годы. И хотя ваш прежний отряд распался, вы и несколько оставшихся верными соратников решаете, что помимо золота пришла пора обрести настоящую известность и славу.\n\n[color=#bcad8c]Охотники за сокровищами:[/color] Начните с тремя персонажами: историком, картографом и сокольничим.\n[color=#bcad8c]Легендарная трио:[/color] В вашем отряде не может быть больше 12-ти человек. Если все трое стартовых персонажей погибнут, то кампания закончится.\n[color=#bcad8c]Честная доля:[/color] Начните со знаменитым оружием и ценными сокровищами, добытыми в былых опасных приключениях.[/p]";
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
		local historian;
		historian = roster.create("scripts/entity/tactical/player");
		historian.setStartValuesEx([
			"historian_background"
		]);
		historian.getSkills().removeByID("trait.survivor");
		historian.getSkills().removeByID("trait.greedy");
		historian.getSkills().removeByID("trait.loyal");
		historian.getSkills().removeByID("trait.disloyal");
		historian.getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
		historian.setPlaceInFormation(3);
		historian.getFlags().set("IsPlayerCharacter", true);
		historian.getBaseProperties().Hitpoints += 8;
		historian.getBaseProperties().MeleeSkill += 3;
		historian.getSprite("miniboss").setBrush("bust_miniboss_lone_wolf");
		historian.m.HireTime = this.Time.getVirtualTimeF();
		historian.m.PerkPoints = 2;
		historian.m.LevelUps = 2;
		historian.m.Level = 3;
		historian.m.Talents = [];
		historian.m.Attributes = [];
		local cartographer;
		cartographer = roster.create("scripts/entity/tactical/player");
		cartographer.setStartValuesEx([
			"hackflows/cartographer_background"
		]);
		cartographer.getSkills().removeByID("trait.survivor");
		cartographer.getSkills().removeByID("trait.greedy");
		cartographer.getSkills().removeByID("trait.loyal");
		cartographer.getSkills().removeByID("trait.disloyal");
		cartographer.getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
		cartographer.setPlaceInFormation(4);
		cartographer.getFlags().set("IsPlayerCharacter", true);
		cartographer.getSprite("miniboss").setBrush("bust_miniboss_lone_wolf");
		cartographer.m.HireTime = this.Time.getVirtualTimeF();
		cartographer.getBaseProperties().MeleeSkill += 3;
		cartographer.getBaseProperties().Hitpoints += 10;
		cartographer.m.PerkPoints = 2;
		cartographer.m.LevelUps = 2;
		cartographer.m.Level = 3;
		cartographer.m.Talents = [];
		cartographer.m.Attributes = [];
		local falconer;
		falconer = roster.create("scripts/entity/tactical/player");
		falconer.setStartValuesEx([
			"hackflows/falconer_background"
		]);
		falconer.getSkills().removeByID("trait.survivor");
		falconer.getSkills().removeByID("trait.greedy");
		falconer.getSkills().removeByID("trait.loyal");
		falconer.getSkills().removeByID("trait.disloyal");
		falconer.getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
		falconer.setPlaceInFormation(5);
		falconer.getFlags().set("IsPlayerCharacter", true);
		falconer.getSprite("miniboss").setBrush("bust_miniboss_lone_wolf");
		falconer.m.HireTime = this.Time.getVirtualTimeF();
		falconer.m.PerkPoints = 2;
		falconer.m.LevelUps = 2;
		falconer.m.Level = 3;
		falconer.m.Talents = [];
		falconer.m.Attributes = [];
		local bros = roster.getAll();
		local a;
		local u;
		bros[0].setTitle("Мозг");
		bros[0].getTalents().resize(this.Const.Attributes.COUNT, 0);
		bros[0].getTalents()[this.Const.Attributes.MeleeDefense] = 3;
		bros[0].getTalents()[this.Const.Attributes.Hitpoints] = 2;
		bros[0].getTalents()[this.Const.Attributes.MeleeSkill] = 3;
		bros[0].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		local historian_items = bros[0].getItems();
		historian_items.unequip(historian_items.getItemAtSlot(this.Const.ItemSlot.Body));
		historian_items.unequip(historian_items.getItemAtSlot(this.Const.ItemSlot.Head));
		historian_items.unequip(historian_items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		historian_items.unequip(historian_items.getItemAtSlot(this.Const.ItemSlot.Offhand));
		a = this.new("scripts/items/armor/oriental/linothorax");
		bros[0].getItems().equip(a);
		a = this.new("scripts/items/helmets/greatsword_hat");
		bros[0].getItems().equip(a);
		bros[0].getItems().equip(this.new("scripts/items/weapons/dagger"));
		bros[0].improveMood(0.75, "Горит желанием проявить себя в рядах отряда наёмников");
		bros[1].setTitle("Сердце");
		bros[1].getTalents().resize(this.Const.Attributes.COUNT, 0);
		bros[1].getTalents()[this.Const.Attributes.Hitpoints] = 3;
		bros[1].getTalents()[this.Const.Attributes.Fatigue] = 2;
		bros[1].getTalents()[this.Const.Attributes.MeleeDefense] = 3;
		bros[1].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		local cartographer_items = bros[1].getItems();
		cartographer_items.unequip(cartographer_items.getItemAtSlot(this.Const.ItemSlot.Body));
		cartographer_items.unequip(cartographer_items.getItemAtSlot(this.Const.ItemSlot.Head));
		cartographer_items.unequip(cartographer_items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		cartographer_items.unequip(cartographer_items.getItemAtSlot(this.Const.ItemSlot.Offhand));
		a = this.new("scripts/items/armor/oriental/linothorax");
		cartographer.getItems().equip(a);
		a = this.new("scripts/items/helmets/greatsword_hat");
		bros[1].getItems().equip(a);
		bros[1].getItems().equip(this.new("scripts/items/weapons/arming_sword"));
		bros[1].getItems().equip(this.new("scripts/items/shields/oriental/metal_round_shield"));
		bros[1].improveMood(0.75, "Горит желанием проявить себя в рядах отряда наёмников");
		bros[2].setTitle("Глаза");
		bros[2].getTalents().resize(this.Const.Attributes.COUNT, 0);
		bros[2].getTalents()[this.Const.Attributes.RangedDefense] = 2;
		bros[2].getTalents()[this.Const.Attributes.Initiative] = 3;
		bros[2].getTalents()[this.Const.Attributes.RangedSkill] = 3;
		bros[2].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		local falconer_items = bros[2].getItems();
		falconer_items.unequip(falconer_items.getItemAtSlot(this.Const.ItemSlot.Body));
		falconer_items.unequip(falconer_items.getItemAtSlot(this.Const.ItemSlot.Head));
		falconer_items.unequip(falconer_items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		falconer_items.unequip(falconer_items.getItemAtSlot(this.Const.ItemSlot.Offhand));
		a = this.new("scripts/items/armor/ragged_surcoat");
		bros[2].getItems().equip(a);
		a = this.new("scripts/items/helmets/hunters_hat");
		bros[2].getItems().equip(a);
		bros[2].getItems().equip(this.new("scripts/items/weapons/hunting_bow"));
		bros[2].improveMood(0.75, "Горит желанием проявить себя в рядах отряда наёмников");
		bros[0].getBackground().m.RawDescription = "Когда-то " + historian.getName() + " был неотъемлемой частью прежней команды искателей сокровищ, где заслужил прозвище \'Мозг\'. Он способен с первого взгляда безошибочно распознать любые древние реликвии и легендарные артефакты, определяя их подлинную ценность. Кроме того, этот книжник - признанный мастер в расшифровке иноземных рун и разгадывании хитроумных секретов древних святилищ. Он надеется, что его выдающийся ум и скромные навыки владения оружием принесут немало пользы и золота отряду.";
		bros[0].getBackground().buildDescription(true);
		bros[1].getBackground().m.RawDescription = "Когда-то " + cartographer.getName() + " был неотъемлемой частью прежней команды искателей сокровищ, где заслужил прозвище \'Сердце\'. Он и прежде был картографом, и как член команды охотников за сокровищами его топографическое чутьё помогало вычислять координаты скрытых руин. Наряду с \'Мозгом\', этот человек был жизненно важен для поиска сокровищ. Ведь если блестящему уму необходим мотор, чтобы двигаться вперёд, то " + cartographer.getName() + " как раз и стал этим мотором. Он был душой старой компании, а его защитные способности всегда были на голову выше остальных... по крайней мере, по сравнению с другими картографами.";
		bros[1].getBackground().buildDescription(true);
		bros[2].getBackground().m.RawDescription = "Когда-то " + falconer.getName() + " был неотъемлемой частью прежней команды искателей сокровищ, где заслужил прозвище \'Глаза\'. Для команды охотников за сокровищами всегда было жизненно важно уметь избегать ненужных стычек, а также быстро оценивать местность. Сокольничий надеется оказать новому отряду столь необходимую поддержку - как в разведке, так и в дальнем бою.";
		bros[2].getBackground().buildDescription(true);
		this.World.Assets.m.BusinessReputation = 100;
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/dried_lamb_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/wine_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/bread_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/trade/uncut_gems_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/loot/jeweled_crown_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/loot/ancient_gold_coins_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/loot/looted_valuables_item"));
		local weapons = clone this.Const.Items.NamedWeapons;
		this.World.Assets.getStash().add(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		this.World.Assets.m.Money = this.World.Assets.m.Money / 2 - (this.World.Assets.getEconomicDifficulty() == 0 ? 0 : 300);
		this.World.Assets.m.ArmorParts = this.World.Assets.m.ArmorParts / 2;
		this.World.Assets.m.Medicine = this.World.Assets.m.Medicine / 2;
		this.World.Assets.m.Ammo = 50;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isIsolatedFromRoads() && !randomVillage.isSouthern())
			{
				break;
			}

			i = ++i;
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
		this.World.Assets.updateLook(9);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/civilians_01.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.hackflows_treasure_hunters_intro");
		}, null);
	}

	function onInit()
	{
		this.World.Assets.m.BrothersMax = 12;
	}

	function onCombatFinished()
	{
		local roster = this.World.getPlayerRoster().getAll();
		local treasure_hunters = 0;

		foreach( bro in roster )
		{
			if (bro.getFlags().get("IsPlayerCharacter"))
			{
				treasure_hunters = ++treasure_hunters;
			}
		}

		return treasure_hunters != 0;
	}

});

