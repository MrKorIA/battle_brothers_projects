// Контракт кризиса «Порох орды» (TZ §7.6, новый, с нуля).
// Сюжет: наниматель выдаёт огненную бомбу, отряд должен взорвать склады пороха
// в ближайшем лагере орды и отступить. Победа над гарнизоном не требуется.
// Поле боя — лагерь орды (tactical.jin_camp из mod_Jurchen), а не чистое поле.
// 6 бочек с порохом (mod_Jurchen/.../barrel_of_gunpowder.nut) в центрально-восточной
// части карты, север или юг (рандом). Местность под зоной выравнивается под средний
// уровень высоты и очищается (removeObject + clear) — бочки ставятся в подготовленное
// место без проверок. Формация: одна куча из 6 или две кучи по 3 (рандом; одна
// выданная бомба перехватывает любую формацию). Бочки спавнятся с
// IsNonCombatant = false: бой не завершается, пока стоит склад.
// Постоянные подкрепления — horde_call_reinforcements_effect.nut.
this.horde_powder_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.horde_powder";
		this.m.Name = "Порох орды";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		if (this.m.Target == null || this.m.Target.isNull())
		{
			local lowest_distance = 9999;
			local best;

			foreach( s in this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).getSettlements() )
			{
				local d = this.m.Home.getTile().getDistanceTo(s.getTile());

				if (d < lowest_distance)
				{
					lowest_distance = d;
					best = s;
				}
			}

			foreach( s in this.World.FactionManager.getFactionOfType(this.Const.FactionType.Mgl).getSettlements() )
			{
				local d = this.m.Home.getTile().getDistanceTo(s.getTile());

				if (d < lowest_distance)
				{
					lowest_distance = d;
					best = s;
				}
			}

			this.m.Target = this.WeakTableRef(best);
		}

		this.m.Flags.set("ObjectiveName", this.m.Target.getName());
		this.m.Name = "Порох орды: " + this.m.Target.getName();
		this.m.Payment.Pool = 1500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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

	// Выдача огненной бомбы при принятии контракта. Через метод инстанса:
	function hordeGiveFireBomb()
	{
		local item = this.new("scripts/items/tools/fire_bomb_item");
		this.World.Assets.getStash().makeEmptySlots(1);
		this.World.Assets.getStash().add(item);
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Отправиться в %objective% к %direction% отсюда",
					"Взорвать бочки с порохом (бомба выдана нанимателем)",
					"Отступить, как только склад взлетит на воздух",
					"Вернуться в город %townname%"
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
				this.Contract.hordeGiveFireBomb();
				this.Contract.m.Target.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Target.getTile().Pos, 500.0);
				this.Flags.set("TimeNextAttack", 0);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Взорвать бочки с порохом в %objective%",
					"Отступить, как только склад взлетит на воздух",
					"Вернуться в город %townname%"
				];

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setLastSpawnTimeToNow();
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}

				// Итоги боя показываем только здесь, на мировой карте: экраны,
				// вызванные прямо из onCombatVictory/onRetreatedFromCombat, всплывают
				// ещё в тактике и не закрываются уже на карте (паттерн free_greenskin —
				// там onCombatVictory лишь ставит флаг)
				if (this.Flags.get("IsDepotCombatWon"))
				{
					this.Flags.set("IsDepotCombatWon", false);
					this.TempFlags.set("IsAtTheGatesShown", false);
					this.Flags.set("TimeNextAttack", this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 0.33);
					this.Contract.setScreen(this.Flags.get("IsDepotDestroyed") ? "DepotBurning" : "WonDepotIntact");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsDepotCombatRetreated"))
				{
					this.Flags.set("IsDepotCombatRetreated", false);
					this.TempFlags.set("IsAtTheGatesShown", false);
					this.Flags.set("TimeNextAttack", this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 0.33);
					this.Contract.setScreen(this.Flags.get("IsDepotDestroyed") ? "RetreatAfterSuccess" : "RetreatAfterFailure");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.TempFlags.get("IsAtTheGatesShown") && this.Flags.get("TimeNextAttack") <= this.Time.getVirtualTimeF() && this.Contract.isPlayerAt(this.Contract.m.Target))
				{
					this.TempFlags.set("IsAtTheGatesShown", true);
					this.Contract.setScreen("AtTheGates");
					this.World.Contracts.showActiveContract();
				}
			}

			// Прямая атака лагеря с карты мира перехватывается: обычный бой с его
			// гарнизоном бочек не даст — показываем сцену у ворот со скриптованным боем
			function onTargetAttacked( _dest, _isPlayerAttacking = true )
			{
				this.TempFlags.set("IsAtTheGatesShown", true);
				this.Contract.setScreen("AtTheGates");
				this.World.Contracts.showActiveContract();
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "PowderDepot")
				{
					this.Flags.set("IsDepotCombatWon", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "PowderDepot")
				{
					this.Flags.set("IsDepotCombatRetreated", true);
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_combatID == "PowderDepot" && "ClassName" in _actor && _actor.ClassName == "barrel_of_gunpowder")
				{
					this.Flags.set("BarrelsDestroyed", this.Flags.get("BarrelsDestroyed") + 1);

					if (this.Flags.get("BarrelsDestroyed") >= this.Flags.get("BarrelsTotal"))
					{
						this.Flags.set("IsDepotDestroyed", true);
					}
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

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = false;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(null);
				}

				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success1");
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% разгребает бумаги на столе и вдруг хлопает ладонью по одному из листов.%SPEECH_ON%Вот оно! Разведчики добрались до стоянки орды — это %objective%, что к %direction% отсюда. Говорят, там целый холм бочек с порохом: чёрного, злого, степного. Если этот порох развезут по гарнизонам, нас всех спалят заживо.%SPEECH_OFF%Он достаёт из ларца тяжёлый кувшин с торчащим фитилём и ставит перед вами.%SPEECH_ON%Огненная бомба. Дорогая штука, так что не трать её на ерунду. Подберись к складам, подожги — и уходи. Убивать весь гарнизон не требуется: взорви бочки и беги. Справишься — не пожалею.%SPEECH_OFF% | В зале пахнет порохом ещё до того, как вы переступаете порог: %employer% разбирает ящики с осадными припасами и обводит карту.%SPEECH_ON%Наёмник. Орда навезла пороха в %objective% — столько, что там теперь не лагерь, а бочка без крышки. Один искристый камешек — и полстепи взлетит на воздух. Мне нужен человек, который наведёт туда порядок.%SPEECH_OFF%Слуга выносит кувшин с фитилем.%SPEECH_ON%Огненная бомба — твой ключ к их складам. Брось её в бочки, убедись, что всё горит, и уходи. Не геройствуй против целого гарнизона: задача — порох, а не кровь.%SPEECH_OFF% | %employer% встречает вас у сундука с оружием. Он отпирает его, достаёт тяжёлый кувшин и кладёт вам в руки.%SPEECH_ON%Знаешь, что это? Пороховая бомба. А знаешь, где сейчас самое большое скопление пороха во всей этой проклятой стране? В %objective%.%SPEECH_OFF%Он запирает сундук и поворачивается к вам.%SPEECH_ON%Я не прошу победить орду. Я прошу поджечь её порох и вернуться целым. Гарнизон тебя не отпустит просто так — он поднимет тревогу и зовёт подмогу, так что действуй быстро. Ну как, берёшься?%SPEECH_OFF% | За столом %employer% перебирает донесения разведчиков. Заметив вас, он отодвигает бумаги.%SPEECH_ON%Мои люди насчитали в %objective% штабеля бочек с порохом. Штабеля, наёмник! С таким запасом орда превратит в пепел любую крепость на границе.%SPEECH_OFF%Он протягивает вам тяжёлый кувшин с фитилём.%SPEECH_ON%Возьми. Это огненная бомба — подожгёшь фитиль, бросишь в бочки и уходишь, пока всё не рвануло. Сражаться со всем гарнизоном не нужно, слышишь? Поджог и отход. Плата будет щедрой.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Склад горит — деньги мои. | Поговорим об оплате. | Огонь и отход — простая работа. Поговорим о цене.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Оно того не стоит. | Найди другого дурака.}",
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
			ID = "AtTheGates",
			Title = "%objective%",
			Text = "[img]gfx/ui/events/event_50.png[/img]{%objective% вырастает на фоне степи перед отрядом \'%companyname%\' — шатры, палисад, дым костров. Ваш проводник показывает на фланг — сбоку от выстроившегося гарнизона, у края его строя, виднеются бочки. Тесные кучи. Пороховой склад, о котором говорил %employer%. Добраться до него придётся сквозь строй степняков, а как только начнётся бой — гарнизон поднимет тревогу, и подмога пойдёт со всех сторон. %randombrother% сглатывает и смотрит на вас.%SPEECH_ON%Так, командир. Поджигаем и бежим?%SPEECH_OFF% | С холма перед отрядом \'%companyname%\' раскинулся %objective% — больше, чем вы надеялись: цепи латников у ворот, лучники у шатров, а сбоку от всей этой живой стены — штабеля бочек с порохом. Ровно туда, куда вам и нужно. %randombrother% крутит в руках огненную бомбу.%SPEECH_ON%Одна искра — и нам лучше уже быть далеко.%SPEECH_OFF%Он прав: как только гарнизон поймёт, что происходит, он всколет всю округу. У вас будет один заход. | Проводник падает на землю рядом с вами и затаивает дыхание: впереди, в низине, раскинулся %objective%. У края цепи латников у ворот тянутся штабеля бочек — их видно даже отсюда, грязно-бурые бока ряд за рядом. Порох. Горючее сердце лагеря, которое вам предстоит вырвать. %randombrother% перехватывает бомбу.%SPEECH_ON%Одна искра, командир. Одна искра — и всем нам лучше быть уже далеко.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "К бочкам! Поджечь и отступить!",
					function getResult()
					{
						this.Contract.startDepotCombat();
						return 0;
					}

				},
				{
					Text = "Ещё не время. Отойдём и переждём.",
					function getResult()
					{
						this.TempFlags.set("IsAtTheGatesShown", false);
						this.Flags.set("TimeNextAttack", this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 0.33);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DepotBurning",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Позади ревёт огонь: склад пороха орды взлетел на воздух так, что земля дрогнула, а в небо над лагерем вздыбился чёрный столб. Кто-то из ваших людей захохотал, хрипло и облегчённо. Задача выполнена — пороха у орды больше нет, а вам пора собираться, пока сюда не стянули всю степь. %employer% ждёт вестей. | Бочки рванули одна за другой, словно сама земля отрыгивала огонь. Склад уничтожен полностью — ни одной целой бочки. Гарнизон орды разбит или разбежался, но возвращаться сюда незачем: %employer% ждёт вас, а %objective% пусть догорает. | Последний взрыв отбросил %randombrother% на несколько шагов. Поднимая его, вы смотрите на место склада: воронка, гарь, обломки бочек на сотню шагов вокруг. Пороха не осталось. Стоя у края воронки, вы отдаёте приказ собираться — %employer% заплатит за этот пожар щедро.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Склад уничтожен. Возвращаемся за наградой!",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WonDepotIntact",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_58.png[/img]{Гарнизон перебит, поле боя ваше — но цель не достигнута: бочки с порохом стоят нетронутыми за дымящимися рядами мёртвых степняков. %randombrother% пинает пустую бочку.%SPEECH_ON%Мы их всех положили, а порох-то цел.%SPEECH_OFF%Он прав. %employer% платит не за трупы, а за пепел. Склад придётся поджечь — как только гарнизон восстановится, здесь вновь будет полно вооружённых степняков. | Бой выигран, но сквозь разбитые ворота лагеря видны те самые бочки — целые, невредимые, дразнящие. Порох не взорван, а значит, работа не сделана. Люди устали и ранены; стоит отлежаться и ударить снова.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Отлежимся и попробуем снова.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RetreatAfterSuccess",
			Title = "В отступлении...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Вы уходите быстрым шагом, не разбирая дороги. Позади вспыхивает %objective%: склад пороха взорвался, когда вы уже были далеко, и даже отсюда долетел глухой удар. Задача выполнена — пусть и ценой крови. %employer% заплатит за этот дым в небе. | %randombrother% тащит раненого товарища, а вы оглядываетесь в последний раз: позади встаёт чёрный столб дыма. Склад рванул. Гарнизон сейчас тушит пожар и считает своих — вам осталось вернуться за наградой: %employer% ждёт вестей.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Склад уничтожен. Возвращаемся за наградой!",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RetreatAfterFailure",
			Title = "В отступлении...",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Вы отошли, оставив %objective% позади. Бочки с порохом стоят нетронутыми, гарнизон — разъярённым, а ваша миссия — невыполненной. %randombrother% перевязан и мрачен.%SPEECH_ON%Мы просто отступили. Как теперь %employer% это назовёт?%SPEECH_OFF%Не иначе как «неудачей». Но контракт ещё можно исправить: отлежаться, собраться с силами и ударить снова. | Отступление без результата — горькое зелье. Порох цел, гарнизон цел, ваши люди — нет. Но дело ещё можно сделать: орда не разберёт склад за одну ночь, и %employer% ещё не отказался от своей затеи. Стоит вернуться, когда раны затянутся.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Мы вернёмся. Склад должен гореть.",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% выходит вам навстречу ещё у ворот — видимо, дозорные передали весть о дыме над лагерем раньше, чем вы успели войти в город. Он смотрит на вас с непривычной теплотой.%SPEECH_ON%Всё, что осталось от их пороха — дым и гарь. Мои разведчики уже пели мне эту песнь. Возьми свои %reward_completion% крон — ты сберёг этим огнём не одну крепость.%SPEECH_OFF% | %employer% принимает вас в кабинете. На столе — карта, на карте %objective%, перечёркнутое углём.%SPEECH_ON%Я слышал этот грохот даже отсюда. Целый склад — в один присест! Орда теперь до следующего сбора пороха будет кусать нас без зубов.%SPEECH_OFF%Он толкает кошель через весь стол.%SPEECH_ON%%reward_completion% крон. Заслужил, наёмник. И запомни: мне нужны люди, которые умеют воевать огнём, а не только железом.%SPEECH_OFF% | Вас встречают как победителей: стражники у ворот стучат алебардами о мостовую, когда отряд \'%companyname%\' проходит мимо. %employer% ждёт на ступенях ратуши.%SPEECH_ON%Город говорит о пожаре в %objective%. Говорит, что небо горело до самой зари. Я говорю, что это сработал ты.%SPEECH_OFF%Он вручает кошель с %reward_completion% кронами и на мгновение сжимает вашу руку своими сухими пальцами.%SPEECH_ON%Если орда и вернётся с порохом — мы знаем, к кому идти.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Склад горит — деньги мои.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Взорвал склады пороха Великой Орды");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHordeInvasion())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCriticalContract);
						}

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
			ID = "Failure1",
			Title = "Около лагеря %objective%",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Когда вы вновь подходите к лагерю, вас встречает тишина. Лагерь пуст: костры потушены, шатры сняты, а на том месте, где стояли бочки с порохом, — лишь вывороченная земля и чужие следы. Орда ушла, увезя порох с собой, и догнать её обоз не выйдет. Задача, не выполненная вовремя, не стоит ничего — %employer% за такое не платит. | %objective% стоит выжженным: чужой отряд опередил вас. Следы боёв свежие, бочек нет — их увезли или взорвали в бою. Кем бы ни были эти люди, их добыча теперь не ваша, и контракт на порох орды теперь не стоит и бумаги, на которой написан.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Мы опоздали.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Не удалось взорвать склады пороха Великой Орды");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function startDepotCombat()
	{
		local tile = this.World.State.getPlayer().getTile();
		local p = this.Const.Tactical.CombatInfo.getClone();
		p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
		p.Tile = tile;
		p.CombatID = "PowderDepot";
		p.Music = this.Const.Music.JinTracks;
		p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
		p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
		p.EnemyBanners.push(this.m.Target.getBanner());
		p.Entities = [];

		// Поле боя — лагерь орды (шаблон mod_Jurchen), а не чистое поле
		p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
		p.LocationTemplate.Template[0] = "tactical.jin_camp";
		p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
		p.LocationTemplate.CutDownTrees = true;
		p.LocationTemplate.AdditionalRadius = 5;

		local factionID = this.World.FactionManager.getFaction(this.m.Target.getFaction()).getID();

		this.m.Flags.set("BarrelsTotal", 10);
		this.m.Flags.set("BarrelsDestroyed", 0);
		this.m.Flags.set("IsDepotDestroyed", false);

		// Гарнизон — только через p.Entities: showCombatDialog считает противников
		// по этому списку (hasOpponents), при пустом он молча отменяет бой. Поле
		// Callback вызывается setupEntity движка (паттерн raze_attached_location) —
		// каждый боец получает СВОЙ экземпляр эффекта подкреплений (волна одна на
		// всех — гейт по раундам в TempFlags, см. horde_call_reinforcements_effect).
		// Variant принудительно 0, иначе setupEntity сделает минибоссом каждого бойца.
		local garrison = [
			this.Const.World.Spawn.Troops.NomadIronPagoda,
			this.Const.World.Spawn.Troops.NomadIronPagoda,
			this.Const.World.Spawn.Troops.NomadIronPagoda,
			this.Const.World.Spawn.Troops.NomadIronPagoda,
			this.Const.World.Spawn.Troops.NomadIronPagoda,
			this.Const.World.Spawn.Troops.NomadFireBlunderbuss,
			this.Const.World.Spawn.Troops.NomadFireBlunderbuss,
			this.Const.World.Spawn.Troops.NomadHalberdMaster,
			this.Const.World.Spawn.Troops.NomadSpearMaster
		];

		if (this.getDifficultyMult() >= 1.1)
		{
			garrison.push(this.Const.World.Spawn.Troops.NomadIronPagoda);
			garrison.push(this.Const.World.Spawn.Troops.NomadFireBlunderbuss);
		}

		foreach( t in garrison )
		{
			local unit = clone t;
			unit.Faction <- factionID;
			unit.Name <- "";
			unit.Variant = 0;
			local skill = this.new("scripts/skills/effects/horde_call_reinforcements_effect");
			unit.Callback <- function ( _e, _tag )
			{
				_e.getSkills().add(skill);
			};
			p.Entities.push(unit);
		}

		// Подкрепления: первый выход — с 3-го раунда, далее раз в 3 раунда; волны
		// растут 3/6/12/24/32... Счётчики в TempFlags живут между боями, а раунды
		// в новом бою снова начинаются с нуля — сбрасываем при каждом заходе
		this.m.TempFlags.set("HordeReinfNextRound", 3);
		this.m.TempFlags.set("HordeReinfWave", 0);

		// Бочки ставим в AfterDeploymentCallback (гарнизон уже развёрнут). Схема:
		// рандомим север или юг, рандомим 1 или 2 кучи, берём центрально-восточную
		// зону (не у границы карты), выравниваем её под средний уровень высоты,
		// сносим объекты и декали — и спавним бочки в подготовленное место без
		// проверок. this.Tactical/this.Math внутри — глобалы тактического состояния
		// (образец — drive_away_barbarians_contract.nut).
		local math = this.Math;
		p.AfterDeploymentCallback = function () {
			local size = this.Tactical.getMapSize();
			local isTop = math.rand(0, 1) == 0;
			local twoPiles = math.rand(0, 1) == 0;

			// зона склада: центрально-восточная часть карты, северная или южная
			local xMin = math.floor(size.X * 0.55);
			local xMax = math.ceil(size.X * 0.72) - 1;
			local yMin = isTop ? math.floor(size.Y * 0.18) : math.floor(size.Y * 0.62);
			local yMax = isTop ? math.ceil(size.Y * 0.48) - 1 : math.ceil(size.Y * 0.72) - 1;

			// собираем тайлы зоны и средний уровень высоты
			local tiles = [];
			local levelSum = 0;

			for( local x = xMin; x <= xMax; x = ++x )
			{
				for( local y = yMin; y <= yMax; y = ++y )
				{
					if (!this.Tactical.isValidTileSquare(x, y))
					{
						continue;
					}

					local t = this.Tactical.getTileSquare(x, y);

					// тайлы под развёрнутым гарнизоном пропускаем: менять уровень
					// и звать clear() под стоящим актором нельзя (краш в AI
					// на старте первого хода), и бочку туда не поставить
					if (t.IsOccupiedByActor)
					{
						continue;
					}

					tiles.push(t);
					levelSum = levelSum + t.Level;
				}
			}

			if (tiles.len() == 0)
			{
				return;
			}

			local avgLevel = math.round(levelSum / tiles.len());

			// готовим местность: сглаживаем под средний уровень, сносим объекты и декали
			foreach( t in tiles )
			{
				t.Level = avgLevel;
				t.removeObject();
				t.clear();
			}

			// раскладка: одна куча из 6 или две кучи по 3
			local c1 = tiles.remove(math.rand(0, tiles.len() - 1));
			local centers = [c1];

			if (twoPiles)
			{
				local near = [];

				foreach( t in tiles )
				{
					local d = t.getDistanceTo(c1);

					if (d >= 1 && d <= 2)
					{
						near.push(t);
					}
				}

				if (near.len() != 0)
				{
					centers.push(near.remove(math.rand(0, near.len() - 1)));
				}
			}

			local maxPerPile = centers.len() == 2 ? 3 : 6;
			local barrels = [];

			foreach( c in centers )
			{
				local inPile = 0;

				if (barrels.find(c) == null)
				{
					barrels.push(c);
					inPile = ++inPile;
				}

				foreach( t in tiles )
				{
					if (inPile >= maxPerPile || barrels.len() >= 6)
					{
						break;
					}

					if (t.getDistanceTo(c) == 1 && barrels.find(t) == null)
					{
						barrels.push(t);
						inPile = ++inPile;
					}
				}
			}

			local spawned = 0;

			foreach( t in barrels )
			{
				local b = this.Tactical.spawnEntity("scripts/entity/tactical/objective/barrel_of_gunpowder", t.Coords);
				b.setFaction(factionID);
				b.m.IsNonCombatant = false;
				spawned = ++spawned;
			}

			// целью считаются реально поставленные бочки
			this.World.Contracts.getActiveContract().m.Flags.set("BarrelsTotal", spawned);
		};


		this.World.Contracts.startScriptedCombat(p, true, true, true);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Flags.get("ObjectiveName")
		]);
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull() && this.m.Target.hasSprite("selection"))
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			if (this.m.Home != null && !this.m.Home.isNull() && this.m.Home.hasSprite("selection"))
			{
				this.m.Home.getSprite("selection").Visible = false;
			}
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isHordeInvasion())
		{
			return false;
		}

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
