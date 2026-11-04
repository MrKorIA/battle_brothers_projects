this.roaming_beasts_desert_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.roaming_beasts_desert";
		this.m.Name = "Охота на чудовищ";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Выследить угрозу городу " + this.Contract.m.Home.getName()
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 40 || this.World.getTime().Days <= 15 && r <= 80)
				{
					this.Flags.set("IsHyenas", true);
				}
				else if (r <= 80)
				{
					this.Flags.set("IsSerpents", true);
				}
				else
				{
					this.Flags.set("IsGhouls", true);
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10);
				local party;

				if (this.Flags.get("IsHyenas"))
				{
				    if (35 <= this.Math.rand(1, 100))
				    {
                        party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Гиены", false, this.Const.World.Spawn.Hyenas, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
                        party.setDescription("Стая злобных гиен на охоте.");
				    }
				    else
				    {
                        party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Львы", false, this.Const.World.Spawn.XXMobLion, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
                        party.setDescription("Прайд злобных львов на охоте.");
				    }
					party.setFootprintType(this.Const.World.FootprintsType.Hyenas);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Hyenas, 0.75);
				}
				else if (this.Flags.get("IsGhouls"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Нахцереры", false, this.Const.World.Spawn.Ghouls, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Стая алчущих крови нахцереров.");
					party.setFootprintType(this.Const.World.FootprintsType.Ghouls);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Ghouls, 0.75);
				}
				else
				{
				    if (35 <= this.Math.rand(1, 100))
				    {
                        party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Аспиды", false, this.Const.World.Spawn.Serpents, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
                        party.setDescription("Огромные змеи, обитающие в округе.");
				    }
				    else
				    {
                        party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Анхеги", false, this.Const.World.Spawn.XXMobAnkheg, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
                        party.setDescription("Рой агрессивных Анхегов, обитающих в округе.");
				    }
					party.setFootprintType(this.Const.World.FootprintsType.Serpents);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Serpents, 0.75);
				}

				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
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
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsHyenas"))
					{
						this.Contract.setScreen("CollectingHyenas");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("CollectingGhouls");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsSerpents"))
					{
						this.Contract.setScreen("CollectingSerpents");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsWorkOfBeastsShown") && this.World.getTime().IsDaytime && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 9000) <= 1)
				{
					this.Flags.set("IsWorkOfBeastsShown", true);
					this.Contract.setScreen("WorkOfBeasts");
					this.World.Contracts.showActiveContract();
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
					if (this.Flags.get("IsHyenas"))
					{
						this.Contract.setScreen("Success1");
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("Success2");
					}
					else if (this.Flags.get("IsSerpents"))
					{
						this.Contract.setScreen("Success3");
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{Войдя в покои нанимателя, вы обнаруживаете его рассматривающим узорчатый ковёр, покрытый грудой растерзанных людских тел. %employer% переводит взгляд на вас.%SPEECH_ON%Это, судя по всему, были убийцы чудовищ. И ныне они здесь, \'отдыхают\' от дела, на которое были отправлены.%SPEECH_OFF%Визирь кивает, несколько слуг, подойдя, сворачивают ковёр. Ошмётки плоти и внутренностей, скользя друг по другу, вываливаются наружу. Слуги поднимают получившийся свёрток, взваливают его себе на плечи и уносят, заставляя свисающую с конца ковра оторванную руку покачиваться в такт шагам. %employer% хлопает в ладоши.%SPEECH_ON%Они обитают в пустыне - стая жестоких чудищ, что пожирают местных жителей. Посмотрев в Вечный огонь, я обрёл знание: лишь алчущий крон справится с этими тварями. А потому я спрашиваю тебя: находишь находишь ли ты %reward% крон подходящей платой для приобретения твоей временной верности?%SPEECH_OFF% | Вы входите в покои нанимателя, но стена охранников останавливает вас от приближения к нему самому. %employer% стоит у подножия трона, с которого спускается короткая лесенка. Пока он неспешно сходит по ней, один из стражей оглядывается и ловит взгляд визиря. Тот кивает и охранник тут же протягивает вам свиток. Он гласит, что неведомые чудища разоряют земли, которыми владеет %townname%. Если вы выследите и перебьёте этих тварей, то получите соответствующую сложности задания плату: %reward% крон. | %employer% отдыхает в своём гареме в окружении полуобнажённых женщин. В руках он держит отрубленную руку, которая, как ни странно, вызывает у наложниц скорее любопытство, нежели отвращение. Завидев вас, визирь бросает свою ношу на пол и вытирает руку о плечо одной из женщин, на сей раз добившись вспышки брезгливости, хоть и рабски приглушённой.\n\n%employer% щелчком пальцев подзывает слугу, несущего кувшин вина. Визирь, вздохнув, отмахивается от него и вновь щёлкает пальцами. Другой прислужник, осознав, что подзывают его, спешно подходит к вам, разворачивает свиток и громко оглашает его содержание: на землях города %townname% замечены чудища, что должны быть немедленно уничтожены.\n\n А вот награда столь громогласно уже не оглашается. Вместо этого, слуга указывает на строчку в свитке, где выведено: %reward% крон. | %employer% изучает карту, столь огромную, что не уместится ни на одном столе. Вместо этого она расстелена на мраморном полу. Всё это кажется совершенно излишним, ведь изображённые на ней земли с лёгкостью поместились бы на куда как более скромной карте - но эти мысли вы держите при себе. Визирь проходит по карте и указывает на одно из мест.%SPEECH_ON%Чудища наводнили эту часть наших владений и разоряют её, с чем я не могу смириться. У меня есть более важные дела.%SPEECH_OFF%Он указывает на другую область карты, которая изображает одну лишь пустыню и продолжает объяснения.%SPEECH_ON%Поэтому мне нужен человек, подобный тебе, алчущий крон, способный выследить сих рыскающих чудовищ. В случае успеха ты будешь вознаграждён золотом в количестве %reward% крон - более чем щедрая плата.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Поговорим о плате. | Эта работа нам подходит.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Подобная работа нам не интересна. | Желаю тебе удачи, но мы не станем в этом участвовать.}",
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
			ID = "WorkOfBeasts",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_161.png[/img]{Кровь. Много крови, достаточно, чтобы скрыть вездесущий песок пустыни. Вы идёте по багровому следу к большой песчаной дюне и взбираетесь на неё. Другая сторона усеяна расчленёнными телами. Конечности оторваны, а лица выгрызены. Глубокие следы в песке ведут в сторону от бойни. Вы не успели спасти этих людей, но цель уже близка. | Вы подходите к колодцу, стоящему рядом с хижиной. Незапертая дверь свисает со сломанной петли. Обнажив меч, вы медленно открываете её и видите кучу гниющего мяса, когда-то по всей видимости бывшую человеком. С потолка капает кровь, а в противоположной стене хижины зияет дыра - что бы ни сотворило всё это, оно удалилось столь же разрушительно, сколь и появилось. Чудовища уже близко. | Земля вокруг пустынного колодца усеяна телами. Когда вы подходите ближе, из колодца появляется пара рук, вытягивающих за собой старика. Он перебрасывает ноги через стенку, садится, собираясь с духом, указывает на бойню и пожимает плечами. Похоже, чудовища были здесь, но вы упустили их. Вы предлагаете старику воды из своего бурдюка, но он отмахивается. В его глазах застыла огромная боль, а все его силы уходят на то, чтобы не показать её вам.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Выдвигаемся.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingHyenas",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_159.png[/img]{Вы до конца не можете понять почему, ведь вы мало что знаете об этих существах, но обнаруживаете себя с презрением рассматривающим гиен. О них говорят как о мусорщиках, любителях лёгкой поживы, что охотятся лишь на слабых, несмотря на свою силу и число, вполне достаточное для борьбы за пищу. И лишь встретившись с вами, увидев свою близкую кончину, они решили явить своё звериное естество. Вы срубаете им головы и собираете их. %employer% ждёт вас. | Хоть гиен и презирают, но никто не скажет, что они слабы. Даже умерев, они всё ещё сопротивляются - слишком уж много времени уходит на отрубание голов и сдирание шкур. Но вот, дело уже сделано, а у вас появились доказательства проделанной работы. %employer% ждёт вас.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Покончим с этим побыстрее, нам нужно ещё забрать золото.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingGhouls",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_131.png[/img]{Сражение окончено, вы подходите к мёртвому нахцереру и опускаетесь на колено. Если бы не частокол кривых клыков, можно было бы с лёгкостью просунуть свою голову в его огромную пасть. Впрочем, вместо любования воплощённой мечтой зубодёра, вы вытаскиваете нож и отрезаете голову чудища. Подняв сей знак победы, вы приказываете отряду \'%companyname%\' последовать вашему примеру. %employer%, в конце концов, ждёт доказательств, а одной отрубленной головы будет недостаточно. | Распластавшаяся на земле неподвижная туша упыря больше походит на камень, нежели на чудовище. Мухи уже вовсю копошатся в его приоткрытой пасти, сея новую жизнь в мёртвых останках. Вы приказываете своим людям прихватить эту голову с собой. %employer% определённо захочет увидеть доказательства. | Повсюду разбросаны тела мёртвых упырей. Вы опускаетесь на колено рядом с телом одним из чудищ и заглядываете в его пасть. Из его глотки всё ещё исторгается отвратительное зловоние. Прикрыв нос куском ткани, вы отпиливаете голову чудовища кинжалом, веля нескольким братьям последовать вашему примеру. %employer% определённо потребует доказательств. | Мёртвый упырь выглядит весьма любопытно. Удивительно, как подобное создание вообще возникло в природе. Сложенный словно дикарь-отшельник, он обвит мышцами подобно зверю, а его голова усеяна ужасными костяными наростами, больше похожими на камень. Вы приказываете своим людям приступить к сбору голов мерзких созданий, %employer% наверняка ожидает увидеть доказательства.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Возвращаемся в %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingSerpents",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_169.png[/img]{Вы присаживаетесь рядом с убитой змеёй. Длина её столь велика, что потребовалось бы уложить в ряд несколько людей вашего роста, чтобы сравняться с ней. Какая всё же... диковинная тварь. Вы начинаете сдирать с неё кожу. %employer% наверняка ожидает увидеть доказательства. | Змеи порублены на куски, так что вам остаётся выбрать лучшие - в основном головы и хвосты, чтобы %employer% убедился в должном выполнении работы.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Возвращаемся в %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer% ожидает вас у входа в свой дворец. Его сопровождают несколько человек в шёлковых одеяниях. Когда вы вываливаете то, что осталось от гиен, они тут же уносят всё это прочь. Визирь же с несколькими охранниками остаётся на месте. Он щёлкает пальцами, и слуга передаёт вам сундучок с золотом. Визирь кивает.%SPEECH_ON%Хорошая работа, алчущий крон. Мы найдём применение твоей добыче, особенно, учитывая её своевременное прибытие.%SPEECH_OFF%Добыче? Вы-то думали, что спасаете этих людей от чудовищ... Пока охранники выпроваживают вас с площади, вы успеваете заметить, как один из мудрецов начинает измерять шкуру гиены с помощью угломера, а другой начинает делать наброски головы на холсте. | %employer% отходит к двери, хотя вы ещё даже не приблизились к нему. Его слуги, напротив, приветствуют вас. Они собирают головы гиен и складывают их в посеребрённые тачки. Визирь же свистит, словно ястреб, пикирующий на добычу. Вы было забеспокоились, но всё заканчивается лишь приходом ещё пары слуг, несущих сундучок с золотом. Один из них, разглядывая облака, произносит.%SPEECH_ON%С работой ты, наёмник, справился отлично, за это в кошельке твоём прибавится прилично.%SPEECH_OFF%Слуга цокает языком и, ухмыльнувшись, переводит взгляд на вас.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Избавил округу от гиен");
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
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer% приглашает вас в свою тронную залу. Она до краёв полна важных на вид гостей, но вас всё же проводят к самому трону. Усомнившись, что собравшееся \'общество\' выдержит подобное, вы, пожав плечами, всё же высыпаете на пол останки нахцереров. Месиво из голов, внутренностей и крови расползается по мрамору, но зрители не издают ни звука.\n\n Слышны лишь мягкие шаги визиря, идущего к вам. Он рассматривает останки, сложив руки на груди, словно учёный, затем щёлкает пальцами - и толпа слуг тут же наводит порядок. Незнакомец с книгой и пером делает заметки. Когда всё сделано, визирь, не сказав ни слова, возвращается на трон. Единственный слышимый звук - позвякивание золота в сундучке, что подносят вам. %reward% крон, как и было обещано. После чего вас столь же тихо провожают из залы.\n\n Оглянувшись, вы видите, что толпа вновь обращает всё своё внимание на визиря, что начинает молитву. | Незнакомец останавливает вас у покоев, где должен находиться %employer%. Его окружают несколько сухопарых мужчин с перьями и счётными книгами. Они пересчитывают принесённые головы нахцереров и записывают результат в свои бумаги. Закончив, каждый из них вырывает страницу и передаёт её своему начальнику, который сравнивает подсчёты. Повеселев, он вручает вам плату - %reward% золотых.%SPEECH_ON%Да озарит Златоликий твой путь, алчущий крон.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Удачная охота.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Избавил округу от нахцереров");
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
			}

		});
		this.m.Screens.push({
			ID = "Success3",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{Вы встречаетесь с нанимателем в его саду. Он рассматривает вас, пощёлкивая ножницами, что держит в руках.%SPEECH_ON%Как я понимаю, задание выполнено?%SPEECH_OFF%Кивнув, вы достаёте змеиные головы и бросаете их на землю. Беззвучно ударяясь об неё, они катятся к ногам визиря, который степенно отходит в сторону. %employer% гневно смотрит на вас.%SPEECH_ON%Мне не нужны представления, алчущий крон - лишь выполнение поставленной задачи может впечатлить меня. Мои стражники отяготят твои руки весом %reward% крон, как и было условлено.%SPEECH_OFF% | Вы протягиваете змеиные шкуры нанимателю, но незнакомец в роскошном тюрбане, украшенном перьями, останавливает вас. Он быстро тараторит какую-то речь, из которой вы понимаете лишь отдельные слова. Похоже, он служит у визиря и собирается забрать останки змей. %employer% кивает в подтверждение, когда вы переводите взгляд на него. А ещё он замечает недоверие на вашем лице, ведь о плате ещё не было сказано ни слова. Визирь громко и горделиво произносит.%SPEECH_ON%Не бойся, алчущий крон, здесь есть лишь те змеи, которых ты сам и принёс сюда.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Удачная охота.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Избавил округу от змей");
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
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_helpful = [];
		local candidates_bro1 = [];
		local candidates_bro2 = [];
		local helpful;
		local bro1;
		local bro2;

		foreach( bro in brothers )
		{
			if (bro.getBackground().isLowborn() && !bro.getBackground().isOffendedByViolence() && !bro.getSkills().hasSkill("trait.bright") && bro.getBackground().getID() != "background.hunter")
			{
				candidates_helpful.push(bro);
			}

			if (!bro.getSkills().hasSkill("trait.player"))
			{
				candidates_bro1.push(bro);

				if (!bro.getBackground().isOffendedByViolence() && bro.getBackground().isCombatBackground())
				{
					candidates_bro2.push(bro);
				}
			}
		}

		if (candidates_helpful.len() != 0)
		{
			helpful = candidates_helpful[this.Math.rand(0, candidates_helpful.len() - 1)];
		}
		else
		{
			helpful = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		if (candidates_bro1.len() != 0)
		{
			bro1 = candidates_bro1[this.Math.rand(0, candidates_bro1.len() - 1)];
		}
		else
		{
			bro1 = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		if (candidates_bro2.len() > 1)
		{
			do
			{
				bro2 = candidates_bro2[this.Math.rand(0, candidates_bro2.len() - 1)];
			}
			while (bro2.getID() == bro1.getID());
		}
		else if (brothers.len() > 1)
		{
			do
			{
				bro2 = brothers[this.Math.rand(0, brothers.len() - 1)];
			}
			while (bro2.getID() == bro1.getID());
		}
		else
		{
			bro2 = bro1;
		}

		_vars.push([
			"helpfulbrother",
			helpful.getName()
		]);
		_vars.push([
			"bro1",
			bro1.getName()
		]);
		_vars.push([
			"bro2",
			bro2.getName()
		]);
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
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

