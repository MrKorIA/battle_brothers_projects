this.hunting_hellpit_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_hellpit";
		this.m.Name = "Охота на Мерзость Адской Ямы";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.DifficultyMult = this.Math.rand(95, 135) * 0.01;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 800 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("Bribe", this.Math.rand(300, 600));
		this.m.Flags.set("MerchantsDead", 0);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Выследить Мерзость Адской Ямы в окрестностях " + this.Contract.m.Home.getName()
				];

				if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else
				{
					this.Contract.setScreen("Task");
				}
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					this.Flags.set("IsAnimalActivist", true);
				}
				else if (r <= 25)
				{
					this.Flags.set("IsBeastFight", true);
				}
				else if (r <= 35)
				{
					this.Flags.set("IsMerchantInDistress", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 6, 12, [
					this.Const.World.TerrainType.Mountains
				]);
				local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 4, 7);
				local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.RatBeast).spawnEntity(tile, "Мерзость Адской Ямы", false, this.Const.World.Spawn.HellPit, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("Мерзость Адской Ямы - это гора уродливой плоти, которая движется пульсирующей волной неестественных судорог, извиваясь подобно червю и используя свои многочисленные конечности, чтобы подтягивать и волочить своё чудовищное тело вперёд.");
				party.setFootprintType(this.Const.World.FootprintsType.Skavens);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.SkavenFootprints, this.Const.World.FootprintsType.Skavens, 0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(2);
				roam.setMaxRange(8);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsMerchantInDistress"))
					{
						if (this.Flags.get("MerchantsDead") < 5)
						{
							this.Contract.setScreen("MerchantDistressSuccess");
						}
						else
						{
							this.Contract.setScreen("MerchantDistressFailure");
						}
					}
					else
					{
						this.Contract.setScreen("Victory");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 15.0 <= this.Time.getVirtualTimeF())
				{
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsBeastFight"))
				{
					this.Contract.setScreen("BeastFight");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsMerchantInDistress"))
				{
					this.Contract.setScreen("MerchantDistress");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAnimalActivist"))
				{
					this.Contract.setScreen("AnimalActivist");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsEncounterShown"))
				{
					this.Flags.set("IsEncounterShown", true);
					this.Contract.setScreen("Encounter");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_combatID != "HellPit")
				{
					return;
				}

				if (_actor.getType() == this.Const.EntityType.CaravanDonkey || _actor.getType() == this.Const.EntityType.CaravanHand)
				{
					this.Flags.increment("MerchantsDead");
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Вернуться в " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("BribeAccepted") && this.Math.rand(1, 100) <= 40)
					{
						this.Contract.setScreen("Failure");
					}
					else
					{
						this.Contract.setScreen("Success");
					}

					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Переговоры",
			Text = "[img]gfx/ui/events/event_77.png[/img]{Вы входите в тёмную комнату. %employer% стоит у стены и рассматривает лист бумаги, на котором нарисовано нечто, похожее на месиво из мышц и зубов. Он оборачивается с улыбкой человека, который видел слишком много кошмаров.%SPEECH_ON%Ты слышал о тварях с юга? Из ущелья, где даже птицы не летают? Местные называют их \'Мерзостью Адской Ямы\'. Кто-то говорит, что их создали скавены в своих подземных лабораториях. Кто-то - что они сами вылезли из преисподней.%SPEECH_OFF%Он подходит к столу и кладёт на него лист, на котором грубо изображён силуэт - огромный, с множеством конечностей и пастей.%SPEECH_ON%Я хочу, чтобы ты нашёл этих тварей и уничтожил их. Я заплачу тебе за каждый добытый хвост. Что скажешь?%SPEECH_OFF% | Вы входите в тесную каморку, где пахнет сыростью и перегаром. %employer% сидит, уставившись в пустоту, и не замечает вашего прихода, пока вы не кашляете. Он вздрагивает и поворачивается.%SPEECH_ON%Прости, задумался. Ты знаешь, что такое \'Мерзость Адской Ямы\'? Это когда из твоих кошмаров вылезает существо, которого не должно существовать в природе. У нас такие бегают по полям. Они уже сожрали трёх фермеров и целое стадо овец.%SPEECH_OFF%Он встаёт и протягивает вам кошель с авансом.%SPEECH_ON%Иди, найди их, убей и принеси мне что-нибудь в доказательство. Я заплачу тебе вдвойне.%SPEECH_OFF% | Вы заходите в просторную комнату. %employer% сидит на полу, опёршись спиной о стену. Рядом с ним лежит пустая миска и разбитая кружка. Подняв голову, он смотрит на вас воспалёнными глазами - видно, что %employer% не спал уже несколько ночей.%SPEECH_ON%Я видел её. Своими глазами. Она вылезла из норы на холме - огромная, как дом, с сотнями лап и пастей, которые щёлкали одновременно. Эта тварь... \'Мерзость Адской Ямы\' смотрела на меня... и я понял, что она голодна.%SPEECH_OFF%Он встаёт на ноги, и его голос становится твёрже.%SPEECH_ON%Я хочу, чтобы ты пошёл на тот холм, нашёл эту тварь и уничтожил её. Я не хочу больше видеть её в своих снах. Заплачу чем угодно.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{О каком количестве крон идёт речь? | Это не такая уж простая просьба. | Я готов согласиться - за добрую плату. | Подобная работа и стоит немало. | И во сколько же ты оцениваешь безопасность своих подданых?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Похоже, вам нужны герои и дураки. | Риск не оправдан. | Я так не думаю.}",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Banter",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_66.png[/img]{Вы идёте по следу, и в воздухе витает запах - смесь гнили, сырости и чего-то кислого, от чего у некоторых из ваших людей начинают слезиться глаза. Следы странные - широкие, но неглубокие, словно тварь весила не так много, как должна. Или она умела распределять свой вес. Вы сжимаете рукоять меча. \'Мерзость Адской Ямы\' близко. | Вы находите место, где кормилась \'Мерзость Адской Ямы\'. Остатки овцы разбросаны по радиусу, как если бы тварь отрывала куски и раскидывала их в стороны. Кости гладко обглоданы, словно их вылизали. Ни один нормальный зверь не оставляет такие следы. Вы поднимаете голову и видите вдалеке чёрную, маслянистую тень. Она движется. | Ваши люди шепчутся между собой. Кто-то говорит, что \'Мерзость Адской Ямы\' может принимать чужой облик. Кто-то - что у неё нет глаз, и она чует жертву по запаху страха. Вы приказываете замолчать. Сейчас не время для баек. Мы на охоте.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Будьте начеку!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "Когда вы приближаетесь...",
			Text = "[img]gfx/ui/events/rat_event_01.png[/img]{Вы выходите на поляну и видите её. Это невозможно описать словами - она похожа на месиво из плоти, которое кто-то слепил из десятка разных тварей, а потом забыл, как это сделал. У неё нет головы - вместо неё несколько пастей, расположенных по всему телу, которые открываются и закрываются вразнобой. Она движется не как живое существо - она течёт, как грязевая лавина, разбрасывая отростки и конечности во все стороны. \'Мерзость Адской Ямы\' замечает вас, и все её пасти разом поворачиваются в вашу сторону. Чувствуя, как холодок пробегает по спине, вы не отступаете и поднимаете меч. | Вы обходите скалу и замираете. Тварь сидит на холме, её тело мерно подрагивает, но с места она не двигается - словно ждёт. Но когда вы делаете ещё шаг, её отростки оживают, и \'Мерзость Адской Ямы\' начинает разворачиваться. Вы видите, как из глубины её тела открывается огромная пасть, полная рядов зубов. Она издаёт звук - не рык, а скорее визг, который заставляет землю дрожать. Вы командуете: в атаку! | Вы выходите на равнину и видите её, стоящую на четырёх, шести, восьми конечностях - их количество постоянно меняется. \'Мерзость Адской Ямы\' похожа на огромного спрута, который выполз на сушу и забыл, как выглядит нормальное создание. Её кожа - серая, мокрая, покрытая наростами. Ваш отряд начинает отступать, но вы приказываете стоять на месте. Вы поднимаете меч и делаете шаг вперёд, завлекая своих людей за собой.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "В атаку!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AnimalActivist",
			Title = "Когда вы приближаетесь...",
			Text = "[img]gfx/ui/events/event_17.png[/img]{Вы подходите к месту, где, по слухам, обитает \'Мерзость Адской Ямы\', но вместо твари находите человека. Он сидит на корточках у входа в пещеру и что-то записывает в потёртую книгу. Когда вы подходите, он поднимает голову и смотрит на вас с удивлённым спокойствием.%SPEECH_ON%Ты здесь, чтобы убить её?%SPEECH_OFF%Вы киваете. Он вздыхает и закрывает книгу.%SPEECH_ON%Зря. Эта тварь - последняя в своём роде. Если ты убьёшь её, это существо исчезнет навсегда. Оно не нападает на людей - оно защищает свою территорию. Люди сами приходят к ней, не зная этого.%SPEECH_OFF%Он протягивает вам кошель.%SPEECH_ON%Я заплачу тебе %bribe% крон, если ты просто уйдёшь и скажешь своему работодателю, что тварь мертва. Я даже дам тебе кусок её старой кожи - он сгодится как доказательство. Ну что, по рукам?%SPEECH_OFF% | Вы находите странного человека у входа в логово. Он одет в лохмотья, но ведёт себя как учёный. Он рассказывает вам, что \'Мерзость Адской Ямы\' - не просто зверь, а ключевое звено в местной экосистеме. Вы слушаете его с полминуты, потом перебиваете.%SPEECH_ON%Мне плевать на экосистему. Мне платят за то, чтобы она была мертва.%SPEECH_OFF%Он вздыхает и протягивает вам мешок с монетами.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Прочь с дороги, глупец. Нам нужно убить зверя.",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				},
				{
					Text = "Хорошо. Я принимаю твоё предложение.",
					function getResult()
					{
						return "AnimalActivistAccept";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsAnimalActivist", false);
			}

		});
		this.m.Screens.push({
			ID = "AnimalActivistAccept",
			Title = "Когда вы приближаетесь...",
			Text = "[img]gfx/ui/events/event_17.png[/img]{Вы смотрите на кошель, потом на пещеру, потом снова на человека. Пожимаете плечами и забираете деньги.%SPEECH_ON%Дело твоё. Я скажу, что убил её.%SPEECH_OFF%Он радостно кивает и протягивает вам старую, потёртую шкуру \'Мерзости Адской Ямы\'.%SPEECH_ON%Вот, это должно сойти за доказательство. Она старая, но твой хозяин вряд ли отличит. Спасибо тебе, наёмник. Ты спас не просто зверя - ты сохранил частичку этого мира.%SPEECH_OFF%Вы прячете шкуру в мешок и уходите, чувствуя на себе его благодарный взгляд.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Праведник. Ага.",
					function getResult()
					{
						local bribe = this.Flags.get("Bribe");
						this.World.Assets.addMoney(bribe);

						if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
						{
							this.Contract.m.Target.getSprite("selection").Visible = false;
							this.Contract.m.Target.setOnCombatWithPlayerCallback(null);
							this.Contract.m.Target.die();
							this.Contract.m.Target = null;
						}

						this.Flags.set("BribeAccepted", true);
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				local bribe = this.Flags.get("Bribe");
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + bribe + "[/color] крон"
				});
			}

		});
		this.m.Screens.push({
			ID = "BeastFight",
			Title = "Когда вы приближаетесь...",
			Text = "[img]gfx/ui/events/event_129.png[/img]{Вы подходите к месту, где должна быть тварь, и замираете. Она не одна. Вокруг \'Мерзости Адской Ямы\' кружат несколько волкокрысов, и они явно не в дружеских отношениях. Один из волкокрысов вцепляется в щупальце твари, другой - в её бок. \'Мерзость Адской Ямы\' вращается, пытаясь сбросить их, в воздухе звенит визг и рык. Ваши люди смотрят на это с удивлением.%SPEECH_ON%Они что, дерутся между собой?%SPEECH_OFF%Вы киваете. Это наш шанс. Вы приказываете отряду атаковать - пока они заняты друг другом.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Я не знаю, хорошо это или плохо.",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "HellPit";
						p.Music = this.Const.Music.RatTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Random;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.WolfRat, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "MerchantDistress",
			Title = "Когда вы приближаетесь...",
			Text = "[img]gfx/ui/events/event_41.png[/img]{Вы выходите на дорогу и видите караван. Телеги спешно разворачиваются, погонщики кричат, а из леса с двух сторон вылетают расплывчатые тени. \'Мерзость Адской Ямы\' атакует караван. Вы видите, как один отросток обхватывает возницу и вытаскивает его из телеги. Его крик обрывается. Вы сжимаете рукоять меча и приказываете отряду ускориться - если поторопиться, сможем спасти хоть кого-то. | Караван уже разгромлен, но \'Мерзость Адской Ямы\' всё ещё кружит вокруг телег, выбирая, кого съесть следующим. Вы видите, как один из погонщиков прячется под телегой, прижимая руки к лицу. Вы кричите ему, чтобы он бежал, но крик тонет в общем шуме - погонщик не слышит вас. Вздохнув, вы поднимаете меч и бросаетесь вперёд.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Атакуйте!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "HellPit";
						p.Music = this.Const.Music.RatTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Random;
						p.Entities.push({
							ID = this.Const.EntityType.CaravanDonkey,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/objective/donkey",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.CaravanDonkey,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/objective/donkey",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.CaravanHand,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/humans/caravan_hand",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.CaravanHand,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/humans/caravan_hand",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.CaravanHand,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/humans/caravan_hand",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				},
				{
					Text = "Отступайте!",
					function getResult()
					{
						this.Flags.set("IsMerchantInDistress", false);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "MerchantDistressSuccess",
			Title = "Когда вы приближаетесь...",
			Text = "[img]gfx/ui/events/event_41.png[/img]{Вы вытираете клинок о траву и подходите к уцелевшему купцу. Он сидит на земле, обхватив голову руками, и трясётся. Вы кладёте руку ему на плечо.%SPEECH_ON%Всё кончено. Ты цел.%SPEECH_OFF%Он поднимает голову и смотрит на вас с благодарностью.%SPEECH_ON%Спасибо... спасибо, что пришли. Я думал, это конец.%SPEECH_OFF%Он достаёт из кармана карту и протягивает её вам.%SPEECH_ON%Я не могу отблагодарить вас деньгами - всё моё добро разграблено. Но вот... здесь на карте отмечено место, где, говорят, есть старые захоронения. Может, там есть что-то ценное. Возьми, это лучшее, что я могу дать.%SPEECH_OFF%Вы забираете карту и киваете.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Нам стоит как-нибудь навестить это место.",
					function getResult()
					{
						this.Contract.setState("Return");
						local bases = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
						local candidates_location = [];

						foreach( b in bases )
						{
							if (!b.getLoot().isEmpty() && !b.isLocationType(this.Const.World.LocationType.Unique) && !b.getFlags().get("IsEventLocation"))
							{
								candidates_location.push(b);
							}
						}

						if (candidates_location.len() == 0)
						{
							return 0;
						}

						local location = candidates_location[this.Math.rand(0, candidates_location.len() - 1)];
						this.World.uncoverFogOfWar(location.getTile().Pos, 700.0);
						location.getFlags().set("IsEventLocation", true);
						location.setDiscovered(true);
						this.World.getCamera().moveTo(location);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "MerchantDistressFailure",
			Title = "Когда вы приближаетесь...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Вы приходите слишком поздно. Караван разгромлен, купец мёртв, а его товары разбросаны по полю. Вы осматриваете тела - ни одного выжившего. Остаётся только приказать отряду собрать то, что ещё представляет какую-то ценность, и готовиться к возвращению. Вы не спасли их, но вы уничтожили тварей. Это уже что-то.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "По крайней мере, мы положили конец этим зверям.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_02.png[/img]{Последняя \'Мерзость Адской Ямы\' падает, пронзённая клинками ваших людей. Вы стоите над её телом - оно всё ещё подёргивается в последних судорогах. Вы отсекаете кусок её кожи и прячете в мешок - доказательство для нанимателя. Ваши люди перевязывают раны и собираются. Пора возвращаться. | Вы проходите по полю боя, проверяя, не осталось ли живых тварей. \'Мерзость Адской Ямы\' лежит, распластанная на земле, её тело медленно теряет форму. Вы поднимаете отросток и отсекаете кусок - он ещё тёплый. Затем бросаете его в мешок и приказываете отряду собираться. %employer% ждёт. | Битва окончена. Вы смотрите на тело твари и чувствуете странное опустошение - не от усталости, а от осознания того, что вы только что убили нечто, чего, казалось, не могло существовать на свете. Вы поднимаете меч и отсекаете кусок шкуры. Ваши люди уже собрались. Пора уходить.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Мы сделали это.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_77.png[/img]{Вы входите в кабинет нанимателя, заваленный бумагами и картами, и без лишних слов бросаете на стол кусок шкуры \'Мерзости Адской Ямы\'. %employer% смотрит на неё, потом на вас, потом снова на шкуру.%SPEECH_ON%Это... это оно?%SPEECH_OFF%Вы киваете. Он медленно поднимает шкуру и рассматривает её на свету.%SPEECH_ON%Значит, они действительно мертвы. Надеюсь я больше никогда не увижу этих тварей.%SPEECH_OFF%Он кладёт шкуру на стол и протягивает вам кошель.%SPEECH_ON%Плата, как договаривались. Ты заслужил каждую крону. Спасибо, наёмник.%SPEECH_OFF%Вы забираете кошель и выходите из комнаты. | %employer% стоит у окна, когда вы входите. Он поворачивается и видит шкуру в вашей руке.%SPEECH_ON%Ты сделал это. Я слышал, как стихли визги в полях. Ты избавил мою землю от этого кошмара.%SPEECH_OFF%Он подходит к столу и достаёт кошель.%SPEECH_ON%Возьми это. Я даю тебе ровно столько, сколько обещал.%SPEECH_OFF%Вы забираете кошель, чувствуя приятную тяжесть в руке.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Удачная охота.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Избавил город от \'Мерзости Адской Ямы\'");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] крон"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Вы входите в тесный кабинет нанимателя, пропахший воском и чернилами, и бросаете на его стол шкуру, которую вам дал странный человек. %employer% смотрит на неё, потом на вас, потом снова на шкуру.%SPEECH_ON%Это... это старая шкура. Ей лет пять, не меньше. Где тварь?%SPEECH_OFF%Вы открываете рот, чтобы ответить, но он поднимает руку.%SPEECH_ON%Не надо. Я уже знаю. Ты облажался. Жалко. Я думал, ты лучше.%SPEECH_OFF%Он качает головой и кивает в сторону двери.%SPEECH_ON%Убирайся из моего города, наёмник. И не возвращайся.%SPEECH_OFF%Вы выходите, и за вами захлопывается дверь.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Не удивительно.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "Пытался обманом выманить у города деньги.");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bribe",
			this.m.Flags.get("Bribe")
		]);
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/ambushed_trade_routes_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.setAttackableByAI(true);
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
				this.m.Target.getController().getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(true);
				this.m.Target.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(true);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(3);
			}
		}
	}

	function onIsValid()
	{
		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Target != null && !this.m.Target.isNull())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});

