this.south_drive_away_rat_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0,
		OriginalReward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.south_drive_away_rat";
		this.m.Name = "Прогнать скавенов";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function generateName()
	{
		local vars = [
			[
				"randomname",
				this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
			],
			[
				"randomtown",
				this.Const.World.LocationNames.VillageWestern[this.Math.rand(0, this.Const.World.LocationNames.VillageWestern.len() - 1)]
			]
		];
		return this.buildTextFromTemplate(this.Const.Strings.RatGreyseerNames[this.Math.rand(0, this.Const.Strings.RatGreyseerNames.len() - 1)], vars);
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local ratcamp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(ratcamp);
		this.m.Flags.set("DestinationName", ratcamp.getName());
		this.m.Flags.set("RatGreyseerName", this.generateName());
		this.m.Payment.Pool = 550 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Изгнать скавенов из местечка " + this.Flags.get("DestinationName") + " к %direction% от поселения %origin%"
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
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setLastSpawnTimeToNow();

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.RatDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.World.Assets.getBusinessReputation() >= 500 && this.Contract.getDifficultyMult() >= 0.95 && this.Math.rand(1, 100) <= 20)
				{
					this.Flags.set("IsRatGreyseerPresent", true);

					if (this.World.Assets.getBusinessReputation() > 600 && this.Math.rand(1, 100) <= 50)
					{
						this.Flags.set("IsBountyHunterPresent", true);
					}
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsRatGreyseerDead"))
					{
						this.Contract.setScreen("RatGreyseerDead");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Math.rand(1, 100) <= 10 && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
					{
						this.Contract.setScreen("Volunteer1");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsRatGreyseerPresent"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("AttackRatGreyseer");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.RatTracks;
						properties.Entities.push({
							ID = this.Const.EntityType.RatGreyseer,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/enemies/rat_greyseer",
							Faction = _dest.getFaction(),
							Callback = this.onRatGreyseerPlaced.bindenv(this)
						});
						properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

			function onRatGreyseerPlaced( _entity, _tag )
			{
				_entity.getFlags().set("IsRatGreyseer", true);
				_entity.setName(this.Flags.get("RatGreyseerName"));
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getFlags().get("IsRatGreyseer") == true)
				{
					this.Flags.set("IsRatGreyseerDead", true);
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
					if (this.Flags.get("IsRatGreyseerDead"))
					{
						this.Contract.setScreen("Success2");
					}
					else
					{
						this.Contract.setScreen("Success1");
					}

					this.World.Contracts.showActiveContract();
				}

				if (this.Flags.get("IsRatGreyseerDead") && this.Flags.get("IsBountyHunterPresent") && !this.TempFlags.get("IsBountyHunterTriggered") && this.World.Events.getLastBattleTime() + 7.0 < this.Time.getVirtualTimeF() && this.Math.rand(1, 1000) <= 2)
				{
					this.Contract.setScreen("BountyHunters1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsBountyHunterRetreat"))
				{
					this.Contract.setScreen("BountyHunters3");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "BountyHunters")
				{
					this.Flags.set("IsBountyHunterPresent", false);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "BountyHunters")
				{
					this.Flags.set("IsBountyHunterPresent", false);
					this.Flags.set("IsBountyHunterRetreat", true);
					this.Flags.set("IsRatGreyseerDead", false);
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer% сидит на корточках перед разбитым глиняным кувшином, водя пальцем по трещине в глине. Вода стекает тёмным пятном на ковёр, но он будто не замечает этого.%SPEECH_ON%Вот.%SPEECH_OFF%Говорит он, не поднимая глаз, и постукивает ногтём по черепку. Затем наконец поднимает взгляд — усталый и тяжёлый.%SPEECH_ON%Мои люди достали это из колодца у северных ворот. Вода была отравлена. Думаешь, дело рук взбунтовавшихся рабов? Нет. Это крысы. Им мало нападать на караваны — теперь они хотят, чтобы мы пили смерть. Мой лазутчик прошёл по их следу до старого караван-сарая на краю пустыни. Там их логово. Выжги его дотла, и я щедро заплачу тебе за труды.%SPEECH_OFF% | %employer% восседает в гареме, но вместо наложниц вокруг него — груды свитков с картами. Он разворачивает один из них и упирает палец в точку у подножия гор.%SPEECH_ON%Здесь. Отсюда крысы выходят на разбой. Мои верблюды не могут пройти, торговля встала. За последнюю неделю я потерял два каравана. Товары — не беда, их можно купить заново. Но я потерял погонщиков, которые знали дорогу через пески, а таких людей не купишь. Теперь там засела целая стая, и она жрёт моих людей одного за другим. Ступай туда, перебей их всех — и получишь щедрую плату. Откажешься — деньги достанутся другому.%SPEECH_OFF%Визирь откидывается на подушки и закрывает глаза, показывая, что разговор окончен. | %employer% сидит в тени пальмы у себя в саду, скармливая ручному соколу кусочки мяса. Он не смотрит на вас, но говорит так, будто вы уже согласились на его условия.%SPEECH_ON%Ты слышал, как по ночам пищат шакалы за стенами? Так вот, это не шакалы. Это крысы. Они подбираются к стенам города %townname% и утаскивают моих стражников прямо с постов. После заката люди боятся выходить за ворота. Мой разведчик нашёл их нору в заброшенном храме к югу отсюда. Приди туда и вырежи их всех — я не поскуплюсь на награду. Иначе скоро мои стены будут охранять одни только тени.%SPEECH_OFF%Сокол срывается с его руки и взмывает в небо; визирь провожает его взглядом, будто ваш ответ его больше не занимает. | Вы входите в покои визиря — %employer% стоит у карты, где пустыня исчерчена красными линиями, будто шрамами. Он проводит пальцем по одной из них.%SPEECH_ON%Крысы перерезают караванные пути один за другим. Мои купцы не могут добраться до города %randomtown% — каждую ночь на них нападают. Я потерял столько товара, что мог бы снарядить небольшое войско. Но войско мне не нужно — мне нужна тишина. Их логово где-то у старого русла реки. Найди его и перебей всех до единого. За это — щедрая награда. Не подведи меня.%SPEECH_OFF%Он резко сворачивает карту в трубку и смотрит на вас в упор. | %employer% сидит у чаши с водой, вглядываясь в своё отражение. Говорит тихо, почти шёпотом.%SPEECH_ON%Они приходят по ночам. Я слышу, как их когти скребут по камню. Я не спал уже три луны. Слуги твердят, что это ветер, но я знаю — это крысы. Они хотят пробраться в мою опочивальню. Мой звездочёт сказал, что их логово в пещерах неподалёку от города %townname%. Ступай туда и убей их всех. За это я щедро осыплю тебя золотом, алчущий крон.%SPEECH_OFF%Он поднимает взгляд, и вы видите под глазами тёмные круги, выжженные бессонницей. | %employer% стоит на плоской крыше, глядя в пустыню, и указывает рукой на столб дыма над горизонтом.%SPEECH_ON%Видишь? Это горит мой склад. Крысы подожгли его прошлой ночью. Они не грабят — они просто уничтожают. Мои люди нашли их след, он ведёт к старой крепости неподалёку. Если ты выкуришь их оттуда со своим отрядом, то я осыплю тебя золотом, алчущий крон.%SPEECH_OFF%Он оборачивается к вам, и в глазах его вспыхивает яростный блеск. | %employer% сидит за столом, заваленным бумагами, и вертит в пальцах обломок древка.%SPEECH_ON%Это обломок крысиного копья. Мои люди нашли его в спине убитого погонщика. Они не просто грабят — они охотятся на нас, как на дичь. Я хочу, чтобы ты показал им, что мы не дичь. Их логово недалеко от города %townname%, в старых руинах. Ступай туда, вырежи их всех, и получишь достойную награду.%SPEECH_OFF%Он отбрасывает обломок в сторону и смотрит на вас в ожидании ответа. | %employer% пьёт вино из серебряного кубка, но руки его дрожат.%SPEECH_ON%Они отравили моего любимого скакуна — отравили воду в стойле. Я мог бы купить другого коня, но дело не в нём. Дело в том, что они приходят, когда хотят, и делают, что хотят. Мой человек выследил их до старого колодца за городом %townname%. Там их нора. Ступай туда и заткни её их же шкурами. За это получишь щедрую плату. И не вздумай торговаться, алчущий крон.%SPEECH_OFF%Он осушает кубок одним глотком и швыряет его в угол.}",
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
					Text = "{Не интересует. | У нас есть более важные дела. | Подобная работа нам не интересна. | Желаю тебе удачи, но мы не станем в этом участвовать.}",
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
			ID = "AttackRatGreyseer",
			Title = "Перед атакой...",
			Text = "[img]gfx/ui/events/rat_event_13.png[/img]{Вы лежите на бархане, наблюдая за лагерем крыс. Среди снующих теней выделяется одна фигура — она не мечется, а отдаёт приказы. Это %ratgreyseer%. Серый провидец сидит у котла, и даже отсюда вы чувствуете исходящую от него зловонную магию. Рядом с ним — четверо верзил с ржавыми тесаками наготове. Убейте провидца, и остальные разбегутся, как тараканы. А его голова, доставленная в город %townname%, принесёт вам достойную награду. | Вы не планировали встретить его здесь, но судьба подкинула вам шанс. %ratgreyseer% расхаживает по лагерю, а охрана следует за ним по пятам, точно тени. Он останавливается у расчерченной на песке карты и что-то чертит когтем — видно, что он голова всей стаи. На глаз в лагере не меньше %totalenemy% скавенов, но без своего вожака они быстро потеряют волю к бою. | Контракт был простым: зачистить нору. Но теперь ясно, что перед вами не просто стая. %ratgreyseer% стоит посреди лагеря, сжимая в лапах череп, покрытый резными рунами, — похоже, он проводит какой-то обряд. Телохранители встали кругом, но всё их внимание приковано к ритуалу. Самое время ударить, пока они меньше всего этого ждут. | Вы всматриваетесь в лагерь и видите сгорбленную фигуру серого провидца. %ratgreyseer% сидит на груде камней и что-то шепчет в огонь. Рядом с ним лежит мешок, из которого торчат человеческие кости. Это не просто крыса — это колдун. Убейте его, и визирь %employer% щедро вас отблагодарит. | В лагере, кишащем крысами, вы замечаете то, чего не было в контракте. Серый провидец %ratgreyseer% отдаёт приказы своим воинам, размахивая посохом с черепом на конце. Голос его звучит змеиным шипением, и даже подчинённые вздрагивают, заслышав его. Убейте его — и остальные скавены бросятся врассыпную, как самые обычные крысы. А доставьте его голову визирю — и вместо обещанной платы получите настоящее состояние.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Готовьтесь к атаке!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RatGreyseerDead",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_08.png[/img]{%ratgreyseer% лежит перед вами, оскалив морду в последнем зверином рычании — даже мёртвый, он словно готов укусить. Вы хватаете его за шерсть и одним ударом отсекаете голову. Она тяжелее, чем вы ожидали — в ней всё ещё чувствуется смрадная магия. Вы бросаете её в мешок и затягиваете верёвку. Трофей для визиря. | Бой окончен, и вы отправляетесь искать тело провидца. Находите его среди груды мёртвых крыс — роба изодрана в клочья, но на морде застыла злая усмешка. Вы отсекаете голову и прицепляете её к поясу. Кровь капает на песок, а вы чувствуете, как непонятная тяжесть тянет вас к земле. | %ratgreyseer% пал от вашего клинка. Вы пинаете его тело, чтобы убедиться, что он не дышит, и отрубаете голову. Смотреть в его мёртвые глаза неприятно, но вы знаете: в городе %townname% эта голова принесёт вам лишнюю сотню-другую крон. | %ratgreyseer% лежит перед вами; вы опускаетесь на колено и для верности перерезаете ему горло. Берёте его за уши, отсекаете голову — кости, на удивление, поддаются легко. Вы швыряете её в мешок и идёте к своим людям. Дело сделано. | Вы опускаетесь на колено рядом с телом серого провидца и одним взмахом клинка отделяете голову от туловища. Поднимаете её за шерсть — %ratgreyseer% невидяще смотрит на вас пустыми глазами. %randombrother% подходит и сплёвывает в сторону.%SPEECH_ON%Это он? Серый провидец?%SPEECH_OFF%Вы киваете.%SPEECH_ON%Был. Теперь это просто мешок с кронами.%SPEECH_OFF%Вы прячете голову в мешок и идёте дальше.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Выступаем!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters1",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Вы идёте по пустыне, и навстречу выходят трое в пыльных плащах. Один из них тычет пальцем в ваш мешок с головой.%SPEECH_ON%Наёмник, эта голова нам нужна. Мы выслеживали её владельца три недели. Отдай её по-хорошему, и мы разойдёмся.%SPEECH_OFF%Вы усмехаетесь.%SPEECH_ON%Я тоже её выслеживал. И я убил её владельца. Она моя.%SPEECH_OFF%Главарь охотников ухмыляется и обнажает кинжал.%SPEECH_ON%Тогда мы её отберём.%SPEECH_OFF% | На дороге появляется фигура в плаще и спокойно заговаривает с вами.%SPEECH_ON%Приветствую, наёмник. Я знаю, ты несёшь голову в мешке серого провидца по имени %ratgreyseer%. Это моя добыча. Отдай её.%SPEECH_OFF%Вы качаете головой в ответ. Человек вздыхает и свистит — из-за барханов появляются воины.%SPEECH_ON%Я же попросил по-хорошему...%SPEECH_OFF% | Из-за дюн выходит хорошо снаряжённый отряд. Их главарь носит ожерелье из человеческих, орочьих и крысиных зубов.%SPEECH_ON%Наёмник, мы знаем, что ты несёшь голову серого провидца, известного как %ratgreyseer%. Это наша работа. Отдай её по-хорошему, и мы, так и быть, оставим тебе уши — вместо того, чтобы повесить их себе на пояс.%SPEECH_OFF%Вы спокойно снимаете мешок с пояса и сжимаете свой меч.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Забери тогда эту проклятую голову и уходи.",
					function getResult()
					{
						this.Flags.set("IsRatGreyseerDead", false);
						this.Flags.set("IsBountyHunterPresent", false);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractPoor);
						return "BountyHunters2";
					}

				},
				{
					Text = "{Если ты так хочешь её получить, придётся заплатить кровью. | Если хочешь, чтобы твоя голова присоединилась к этой, давай, рискуй.}",
					function getResult()
					{
						this.TempFlags.set("IsBountyHunterTriggered", true);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.RatTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "BountyHunters";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BountyHunters, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters2",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Вы оцениваете силы противника и решаете, что кровь не стоит этих крон. Вы бросаете голову на землю и отходите. Охотники хватают добычу и исчезают в песках, не сказав ни слова. Вы остаётесь стоять с пустыми руками, но живым.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Пойдём дальше. Нам ещё нужно получить плату.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters3",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Охотников слишком много. Ваши люди устали, и вы не хотите хоронить их в пустыне. Вы приказываете отступать и в спешке роняете мешок с головой. %ratgreyseer% остаётся лежать в песках — кто-то из ваших людей это замечает, но вы не останавливаетесь.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ну что ж. Нам всё ещё нужно получить плату.",
					function getResult()
					{
						this.Flags.set("IsBountyHunterRetreat", false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Volunteer1",
			Title = "После битвы...",
			Text =  "[img]gfx/ui/events/rat_event_08.png[/img]{Вы слышите крик из клетки, которую крысы использовали как темницу. Внутри сидит человек, весь в грязи и верёвках. Вы освобождаете пленника — отдышавшись, он говорит, что родом из города %randomtown%, и просит взять его в отряд: возвращаться ему всё равно некуда. | В лагере вы находите пленника, сидящего в яме с пустыми, ничего не выражающими глазами. Родом из города %randomtown%, он рассказывает, что крысы съели его брата, и просит взять его в отряд — возвращаться всё равно некуда. | Вы обыскиваете лагерь скавенов и находите человека, спрятанного в яме. Дрожащим голосом он говорит, что родом из города %randomtown%, и был бы рад присоединиться к вашему отряду.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Можешь присоединиться к нам.",
					function getResult()
					{
						return "Volunteer2";
					}

				},
				{
					Text = "Иди домой.",
					function getResult()
					{
						return "Volunteer3";
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterLaborerBackgrounds);

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Volunteer2",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_08.png[/img]{Он вливается в ваши ряды, исчезая в толпе братьев, которые принимают его достаточно тепло для группы наёмных убийц. Новичок хвастается, что хорош со всеми видами оружия, но вы сами решите, чем он будет владеть. | Пленник улыбается от уха до уха, когда вы его принимаете. Несколько братьев спрашивают, какое оружие ему дать, но вы пожимаете плечами — решите позже.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Давай-ка подберём тебе оружие.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				this.World.getPlayerRoster().add(this.Contract.m.Dude);
				this.World.getTemporaryRoster().clear();
				this.Contract.m.Dude.onHired();
				this.Contract.m.Dude = null;
			}

		});
		this.m.Screens.push({
			ID = "Volunteer3",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_08.png[/img]{Вы качаете головой. Мужчина хмурится.%SPEECH_ON%Вы уверены? Я довольно хорош в...%SPEECH_OFF%Вы перебиваете.%SPEECH_ON%Уверен. А теперь наслаждайся своей свободой, незнакомец.%SPEECH_OFF% | Вы оцениваете мужчину и понимаете, что он не подходит для жизни наёмника.%SPEECH_ON%Мы ценим предложение, но жизнь наёмника опасна. Возвращайся домой, к семье, к работе.%SPEECH_OFF% | У вас достаточно людей, новички не нужны. Однако вам интересно: как отреагирует %randombrother%, если вы заговорите о его замене? Вместо этого вы пожимаете руку пленнику и отправляете его восвояси. Он разочарован, но благодарит за освобождение.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Иди.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				this.World.getTemporaryRoster().clear();
				this.Contract.m.Dude = null;
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Вы возвращаетесь в город %townname% и подходите к дворцу. Стражник у ворот не пропускает вас внутрь, но слуга выносит кошелёк.%SPEECH_ON%%employer% слышал о твоём успехе. Он сказал: \'Наконец-то этот алчущий крон сделал что-то полезное. Передай ему его %reward% крон и скажи, чтобы он уходил\'. Вот твоя плата. А теперь ступай.%SPEECH_OFF%Слуга бросает кошелёк вам под ноги и исчезает за воротами. | Вы ждёте у дворца почти час, и только после этого из дверей выходит писарь с кошельком в руках. Он не смотрит на вас, разворачивает свиток и читает.%SPEECH_ON%\'Алчущий крон, уничтоживший мерзких крыс, получает %reward% крон. %employer% выражает своё... удовлетворение... тем фактом, что работа наконец-то выполнена. Он также настоятельно рекомендует тебе покинуть город до заката, потому что его терпение не безгранично\'. Забирай свои деньги и уходи.%SPEECH_OFF%Писарь швыряет кошелёк вам и уходит, захлопывая за собой дверь. | Вы подходите к воротам дворца, и изнутри доносится голос визиря, громкий и властный.%SPEECH_ON%Не впускайте его! Просто отдайте ему его жалкую плату и пусть убирается. Я не хочу видеть его грязное лицо и чувствовать исходящий от него смрад. Он сделал то, что должен был сделать, и за это получит свои %reward% крон. А теперь проваливай, алчущий крон, пока я не решил, что ты стоишь дешевле.%SPEECH_OFF%Слуга выбегает из ворот, суёт вам в руки тяжёлый кошелёк и убегает обратно, закрывая за собой двери.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Ну, плату-то мы получили...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Уничтожен лагерь скавенов");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] крон"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Вы возвращаетесь в город %townname% и ждёте у ворот дворца, пока слуги докладывают о вашем прибытии. Проходит почти час, прежде чем вас приглашают внутрь — но не в покои, а в приёмный зал. %employer% сидит на троне, окружённый советниками, и не поднимает глаз, когда вы входите. Вы кладёте голову серого провидца по имени %ratgreyseer% на пол к его ногам, и он наконец смотрит вниз.%SPEECH_ON%Ты принёс это в мой дом? На пол? Ты мог бы хотя бы завернуть её в тряпку, алчущий крон.%SPEECH_OFF%Он делает знак слуге, и тот поднимает голову за шерсть и уносит её.%SPEECH_ON%Мои советники говорят, что это действительно тот самый серый провидец. Я не знаю, что это значит, но они говорят, что без него крысы разбегутся, как тараканы. Ты сделал больше, чем должен был. Это не делает тебя героем — просто делает твою плату выше. Вот твои %reward% крон. И запомни: если ты когда-нибудь ещё принесёшь в мой дом грязные трофеи без позволения — я прикажу выпороть тебя на площади. А теперь уходи.%SPEECH_OFF%Он отворачивается к советникам, давая понять, что аудиенция окончена. | Вас проводят в малый зал, где %employer% сидит за столом и изучает какие-то бумаги. Вы останавливаетесь у двери, и слуга забирает у вас голову, чтобы передать её визирю. %employer% поднимает взгляд, когда слуга кладёт трофей на стол, и долго рассматривает его, не прикасаясь.%SPEECH_ON%Так вот как выглядит %ratgreyseer%, скавен, который мучил меня во снах. Я ожидал чего-то более... внушительного. Но он выглядит достаточно мёртвым, и за это я заплачу тебе.%SPEECH_OFF%Он кивает, и слуга протягивает вам кошелёк.%SPEECH_ON%Твои %reward% крон. Не трать их все сразу, алчущий крон.%SPEECH_OFF%Он снова опускает глаза к бумагам, и слуга начинает выпроваживать вас из комнаты. | Слуга проводит вас в пустой зал, где %employer% стоит у высокого окна и смотрит на пустыню. Вы передаёте голову его помощнику, который кладёт её на поднос и ставит рядом с визирем. Тот не оборачивается, но говорит так, будто вы стоите прямо перед ним.%SPEECH_ON%Я слышал, ты принёс голову их колдуна. Мои люди подтвердили — это действительно %ratgreyseer%. Я не думал, что ты способен на такое, но, видимо, у тебя есть талант. Или удача. Мне всё равно. Ты сделал работу, и я заплачу.%SPEECH_OFF%Он щёлкает пальцами, и слуга протягивает вам кошелёк.%SPEECH_ON%%reward% крон. Я был щедр, потому что это важный трофей. Но не думай, что я теперь что-то должен тебе. Ты просто сделал свою работу, алчущий крон. А теперь убирайся с глаз моих.%SPEECH_OFF%Он машет рукой, и слуга указывает вам на дверь. | У входа в зал вас останавливает слуга и молча забирает мешок с головой, скрываясь за дверью. Когда вас наконец впускают, %employer% сидит на подушках и пьёт вино. Перед ним стоит столик, и на нём, укрытая куском шёлка, лежит голова серого провидца по имени %ratgreyseer%. Он не предлагает вам сесть, только поднимает кубок и смотрит на вас поверх его края.%SPEECH_ON%Я признаю, алчущий крон, ты удивил меня. Я не верил, что серый провидец существует, но теперь его голова лежит на моём столике, и я могу спать спокойно. Это стоит того, чтобы заплатить тебе %reward% крон.%SPEECH_OFF%Он кивает, и слуга бросает кошелёк к вашим ногам.%SPEECH_ON%Но не обольщайся. Ты просто клинок за плату, который сделал свою работу. Ты не герой, не спаситель, не тот, о ком будут слагать песни. Ты просто тот, кто умеет убивать крыс. И если тебе понадобится ещё работа — ты знаешь, где меня найти. Но не думай, что я буду рад тебя видеть. Ступай.%SPEECH_OFF%Он отворачивается к своим наложницам, и вас молча выпроваживают из зала. | У входа в зал вас останавливает слуга и молча забирает мешок с головой, скрываясь за дверью. Через некоторое время вас ведут через длинный коридор в комнату, где %employer% стоит у алтаря с зажжёнными свечами. %ratgreyseer% лежит перед ним, и он смотрит на голову, сложив руки в молитвенном жесте. Когда вы входите, он не оборачивается, но говорит, глядя на пламя.%SPEECH_ON%Я молился Златоликому, чтобы этот день наступил. И он послал мне тебя — грязного, смердящего, алчущего крон. Ты выполнил то, что должно было быть сделано, и я благодарю за это не тебя, а свет Его. Но ты получишь свою награду.%SPEECH_OFF%Он щёлкает пальцами, и слуга передаёт кошелёк вам.%SPEECH_ON%%reward% крон. Это больше, чем я обещал. Не потому что ты заслужил, а потому что я хочу, чтобы ты ушёл и никогда не возвращался. Если твоя тень ещё раз упадёт на мой порог, я прикажу выпустить моих львов. А теперь уходи.%SPEECH_OFF%Он отворачивается, и вы понимаете, что аудиенция окончена.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Ну, плату-то мы получили...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Уничтожен лагерь скавенов");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() * 2;
				this.Contract.m.OriginalReward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] крон"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"reward",
			this.m.Reward
		]);
		_vars.push([
			"original_reward",
			this.m.OriginalReward
		]);
		_vars.push([
			"ratgreyseer",
			this.m.Flags.get("RatGreyseerName")
		]);
		_vars.push([
			"totalenemy",
			this.m.Destination != null && !this.m.Destination.isNull() ? this.beautifyNumber(this.m.Destination.getTroops().len()) : 0
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/rat_plague_outbreak_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(4);
			}
		}
	}

	function onIsValid()
	{
		if (this.m.IsStarted)
		{
			if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive())
			{
				return false;
			}

			return true;
		}
		else
		{
			return true;
		}
	}

	function onSerialize( _out )
	{
		_out.writeI32(0);

		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		_in.readI32();
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});

