this.hunting_ratorge_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = true
	},
	function setEnemyType( _t )
	{
		this.m.Flags.set("EnemyType", _t);
	}

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_ratorge";
		this.m.Name = "Охота на крысоогров";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 750 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Выследить крысоогров в окрестностях " + this.Contract.m.Home.getName()
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

				if (r <= 40)
				{
					this.Flags.set("IsDriveOff", true);
				}
				else if (r <= 50)
				{
					this.Flags.set("IsSignsOfAFight", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 6, 12, [
					this.Const.World.TerrainType.Mountains
				]);
				local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 4, 8);
				local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.RatBeast).spawnEntity(tile, "Крысоогры", false, this.Const.World.Spawn.RatOrge, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("Крысоогры — это массивные, громоздкие чудовища, представляющие собой вершину изобретательности Клана Молдер: смертоносные звери-машины для убийства, сочетающие в себе нечеловеческие рефлексы скавена с силой и размером огра.");
				party.setFootprintType(this.Const.World.FootprintsType.Skavens);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				party.getFlags().set("IsRatOrge", true);
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
					if (this.Flags.get("IsSignsOfAFight"))
					{
						this.Contract.setScreen("SignsOfAFight");
					}
					else
					{
						this.Contract.setScreen("Victory");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 10.0 <= this.Time.getVirtualTimeF())
				{
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsDriveOff") && !this.Flags.get("IsEncounterShown"))
				{
					this.Flags.set("IsEncounterShown", true);
					local bros = this.World.getPlayerRoster().getAll();
					local candidates = [];

					foreach( bro in bros )
					{
						if (bro.getBackground().getID() == "background.beast_slayer" || bro.getBackground().getID() == "background.wildman" || bro.getBackground().getID() == "background.barbarian" || bro.getSkills().hasSkill("trait.dumb"))
						{
							candidates.push(bro);
						}
					}

					if (candidates.len() == 0)
					{
						this.World.Contracts.showCombatDialog(_isPlayerAttacking);
					}
					else
					{
						this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
						this.Contract.setScreen("DriveThemOff");
						this.World.Contracts.showActiveContract();
					}
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
					if (this.Flags.get("IsDriveOffSuccess"))
					{
						this.Contract.setScreen("SuccessPeaceful");
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{Вы входите в заваленную всяческим хламом комнату, %employer% стоит на коленях перед распахнутым сундуком. Он роется в нём с таким видом, будто ищет улики, а не старые свитки.%SPEECH_ON%А, наёмник! Хорошо, что ты пришёл. Садись, только не на то кресло — оно сломано. Вернее, не сломано, но если ты сядешь в него, оно сломается.%SPEECH_OFF%Он встаёт и вытирает пыль с рук.%SPEECH_ON%У нас проблема. Большая, лохматая и с зубами, как кинжалы. Крестьяне видели в полях крысоогра. Не одного — нескольких. Они сожрали полстада овец и раздавили амбар, как стакан на пирушке.%SPEECH_OFF%Он подходит к вам и смотрит прямо в глаза.%SPEECH_ON%Я хочу, чтобы ты выследил этих тварей и избавил нас от них. Убей их, прогони — мне всё равно, лишь бы они убрались с моей земли. Сколько возьмёшь?%SPEECH_OFF% | Вы входите в тесную комнату, %employer% стоит у стены и разглядывает карту, где отмечены свежие следы разрушений. Он водит пальцем по линии, ведущей от леса к городу.%SPEECH_ON%Вот здесь они прошли в первый раз. Вот здесь — во второй. А здесь — раздавили телегу с зерном вместе с погонщиком. Крысоогры не просто бродят — они ищут что-то. Или кого-то.%SPEECH_OFF%Он поворачивается к вам, и в его голосе звучит сталь.%SPEECH_ON%Я не хочу знать, что они ищут. Я хочу знать, что они мертвы. Ты пойдёшь на охоту, наёмник. Найдёшь их логово и убьёшь их всех. Заплачу столько, что хватит на новый отряд.%SPEECH_OFF% | Вы входите в комнату, а %employer% сидит на подоконнике и смотрит на стаю птиц, кружащих над полями. Он не оборачивается, просто говорит в пространство.%SPEECH_ON%Они уже не первый день кружат над полем у старой мельницы. Там есть чем поживиться. Крысоогры сожрали быка и оставили только рога да копыта — вот это размах.%SPEECH_OFF%Спрыгнув с подоконника, %employer% подходит к столу, где лежит обломок рога — то немногое, что осталось от растерзанного быка.%SPEECH_ON%Судя по силе укуса, эта тварь вдвое крупнее сородичей. Не просто крысоогр — матёрый вожак стаи. Убей его, и остальные разбегутся. Ну что, ты возьмёшься?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Борьба с крысоограми дёшево не обойдётся. | %companyname% может помочь за соответствующую цену. | Поговорим об оплате.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Это не похоже на нашу работу. | Это не стоит риска.}",
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
			Text = "[img]gfx/ui/events/event_71.png[/img]{Вы идёте по следу, который ведёт через поле к лесу. На полпути находится то, что осталось от коровы — разорванной так, будто её рвали сразу с двух сторон. Кости лежат отдельно, шкура висит на кусте, а внутренности растянуты по земле на несколько шагов. %randombrother% подходит и присвистывает.%SPEECH_ON%И это сделала одна тварь?%SPEECH_OFF%Вы качаете головой. Следы большие и глубокие — крысоогр явно не один. Вы приказываете отряду быть наготове. Логово где-то рядом. | Вы находите разбитую телегу на перекрёстке дорог. Колёса разлетелись в стороны, а доски превращены в щепки. Рядом — тело возницы, расплющенное так, будто по нему прошёлся каменный каток. Следы вокруг — огромные, когтистые. Крысоогр. Вы поднимаете голову и видите дым на горизонте. Надо спешить. | Вы проходите мимо старого пня и замечаете вмятину в земле — след ступни, настолько огромной, что можно лечь в неё в полный рост. Рядом валяются остатки овцы. Поднимаете её череп — он разгрызен, как орех. Вы сжимаете рукоять меча. Пора заканчивать эту охоту.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Они не могут быть далеко.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/rat_event_03.png[/img]{Вы выходите на поляну и замираете. В центре сидят твари. Крысоогры. Они огромные — каждый на две головы выше самого рослого из вас. Их кожа серая, покрыта шрамами и наростами, а глаза горят тусклым красным светом. Один из них жуёт что-то, что совсем недавно было человеком. При виде вас тварь замирает, вскидывает голову и медленно поднимается во весь рост — под тяжестью каждого шага вздрагивает земля. Второй тоже встаёт, его пасть распахивается в утробном рыке. Вы чувствуете, как ваши люди сжимают оружие. Времени на размышления нет. | Вы идёте через чащу и вдруг слышите низкий, вибрирующий рык. Вы поднимаете руку, и отряд замирает. Из-за деревьев выходит тень — огромная горбатая фигура. Крысоогр. Он замечает вас и наклоняет голову, изучая, как диковинную зверюшку. В его пасти висит кусок кожи, и вы понимаете, что это была часть чьего-то доспеха. Он облизывает клыки и делает шаг вперёд. Вы медленно вытаскиваете меч. | Вы выходите на берег реки и видите их — крысоогров, которые пьют воду, стоя на коленях. Они выглядят почти безобидно, пока не замечают вас. Один из них поднимает голову, и в его глазах вспыхивает узнавание, будто он уже не раз встречал людей — и знает, что с ними делать. Он встаёт, и вода ручьём стекает с его шерсти. Остальные тоже поднимаются. Вы поднимаете клинок и отдаёте приказ к атаке.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Вперёд!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DriveThemOff",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/rat_event_03.png[/img]{Вы уже готовите отряд к бою, как вдруг %shouter% вырывается из строя и бежит прямо на крысоогров. Он орёт и размахивает руками, словно пытается убедить их, что он больше, чем они. Крысоогры замирают и переглядываются. Один из них неуверенно опускает голову, словно раздумывая, стоит ли драться с этим безумцем. Вы сжимаете рукоять меча, не зная — остановить безумца или дать ему шанс.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Атакуйте их!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				},
				{
					Text = "%shouter% знает, что делает.",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 35)
						{
							return "DriveThemOffSuccess";
						}
						else
						{
							return "DriveThemOffFailure";
						}
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DriveThemOffSuccess",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/rat_event_03.png[/img]{Вы не верите своим глазам. %shouter% бежит на крысоогров, и они отступают. Сначала медленно, потом быстрее. Один из них, самый крупный, делает шаг назад, спотыкается о корень и с грохотом валится на землю. %shouter% не останавливается — он орёт ещё громче, и крысоогры, наконец, разворачиваются и убегают в лес. Вы смотрите на поле, где только что стояла смерть, и в голове не укладывается — это сработало. %shouter% возвращается к отряду, тяжело дыша, и ухмыляется.%SPEECH_ON%Вот так, командир. Не надо убивать — надо пугать.%SPEECH_OFF%Вы качаете головой, но выдыхаете с облегчением.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "И не возвращайтесь!",
					function getResult()
					{
						this.Contract.m.Target.die();
						this.Contract.m.Target = null;
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				this.Contract.m.Dude.improveMood(3.0, "Сумел в одиночку прогнать крысоогра");

				if (this.Contract.m.Dude.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[this.Contract.m.Dude.getMoodState()],
						text = this.Contract.m.Dude.getName() + this.Const.MoodStateEvent[this.Contract.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "DriveThemOffFailure",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/rat_event_03.png[/img]{%shouter% бежит на крысоогров, и на мгновение вам кажется, что это сработает. Они отступают, пятятся назад, но один из них, самый огромный, вдруг останавливается. Он поворачивается и смотрит на бегущего человека с тем же любопытством, с каким кот смотрит на мышь. А потом он взмахивает своей лапищей, и %shouter% кубарем летит через всё поле и с глухим звуком от удара падает в кусты. Бегущие крысоогры останавливаются и поворачиваются к вашему отряду. Они больше не собираются уходить. Вы вытаскиваете меч.%SPEECH_ON%В атаку!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Вот тебе и на.",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, false);
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				local injury;

				if (this.Math.rand(1, 100) <= 50)
				{
					injury = this.Contract.m.Dude.addInjury(this.Const.Injury.BluntBody);
				}
				else
				{
					injury = this.Contract.m.Dude.addInjury(this.Const.Injury.BluntHead);
				}

				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = this.Contract.m.Dude.getName() + " страдает от " + injury.getNameOnly()
				});
				this.Contract.m.Dude.worsenMood(1.0, "Не сумел в одиночку прогнать крысоогров");

				if (this.Contract.m.Dude.getMoodState() <= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[this.Contract.m.Dude.getMoodState()],
						text = this.Contract.m.Dude.getName() + this.Const.MoodStateEvent[this.Contract.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_04.png[/img]{Последний крысоогр падает, пронзённый клинками ваших людей. Вы подходите к его телу и видите, что он ещё дышит — последним, хриплым вдохом. Ваш клинок обрывает его жизнь. Люди отряда \'%companyname%\' собираются вокруг знамени, тяжело дыша от усталости. Вы приказываете собрать трофеи — хотя бы когти или зубы, %employer% не поверит без доказательств. Лес стихает. Только ветер шелестит в листве, унося запах крови. Пора возвращаться. | Вы обходите поле боя и считаете тела. Это была стая — небольшая, но смертоносная. На месте вы находите обрывки доспехов и человеческие кости. Затем вы приказываете сжечь тела крысоогров, чтобы они не привлекли других хищников. Пламя взметается вверх. Усталость понемногу отпускает вас. Пора возвращаться, %employer% ждёт. | Битва окончена. Вы стоите над телом вожака — он был самым крупным, с белым шрамом через всю морду. Вы отрубаете ему голову и бросаете её в мешок. %employer% будет доволен. Вы оборачиваетесь к своим людям и приказываете уходить.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Время получить плату.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SignsOfAFight",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_04.png[/img]{Вы проходите по полю боя, проверяя, не осталось ли недобитых врагов, и вдруг замечаете, что один из крысоогров убит не вашими людьми. Его живот распорот тремя глубокими бороздами — будто исполинскими когтями, и от того же удара хрустнули и переломились рёбра. Вы подходите ближе и видите на его шее следы укусов — они намного больше, чем у любого хищника, которого вам доводилось встречать. %randombrother% подходит к вам и качает головой.%SPEECH_ON%Что могло сделать это?%SPEECH_OFF%Вы не знаете, и не хотите знать. Вы приказываете отряду собираться и уходить. В этих землях живут твари страшнее крысоогров.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Дикие земли темны и полны ужасов.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_79.png[/img]{%employer% работает за столом, вы входите в его кабинет и бросаете на стол клык крысоогра. Он смотрит на него, потом на вас, потом снова на клык.%SPEECH_ON%Я слышал, что в лесу стало тихо. Мои люди снова ходят по дорогам без страха. Ты сделал то, о чём я просил.%SPEECH_OFF%Он встаёт со стула, подходит к сундуку и достаёт тяжёлый кошель.%SPEECH_ON%Твоя плата. Ты заслужил каждую крону. Если захочешь ещё работы, заглядывай в любое время.%SPEECH_OFF%Вы забираете кошель и чувствуете его тяжесть. Хорошая охота. | %employer% стоит у окна, когда вы входите в его комнату. Он поворачивается к вам и улыбается.%SPEECH_ON%Я уже знаю. Мои люди видели, как ты шёл по полю с мешком, полным клыков. Ты спас мою землю, наёмник.%SPEECH_OFF%Он протягивает вам шкатулку с кронами.%SPEECH_ON%Возьми это. Я надеюсь, мы ещё встретимся.%SPEECH_OFF% | Вы заходите в комнату, когда %employer% стоит на коленях и собирает с пола монеты. Он поднимает голову и видит вас.%SPEECH_ON%Я знаю, что ты сделал. Я не слышал больше донесений о погромах и разорениях. Ты убил их всех?%SPEECH_OFF%Вы киваете. Он встаёт и протягивает вам кошель.%SPEECH_ON%Плата. Ты снял проклятие с моих земель. Спасибо, наёмник.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Избавил город от крысоогров");
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
			ID = "SuccessPeaceful",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Вы возвращаетесь к нанимателю и рассказываете, что крысоогры ушли. %employer% смотрит на вас с недоверием, но потом медленно кивает.%SPEECH_ON%Ты хочешь сказать, что один из твоих людей просто... напугал их?%SPEECH_OFF%Вы пожимаете плечами.%SPEECH_ON%Иногда это работает лучше меча.%SPEECH_OFF%Он качает головой, но в глазах его появляется уважение.%SPEECH_ON%Хорошо. Если они ушли и не вернутся, я заплачу. Вот твоя плата, как договаривались.%SPEECH_OFF%Он протягивает вам кошель. Вы забираете его и выходите на улицу, чувствуя, как ветер несёт с поля запах свежести. Здесь снова тихо и безопасно.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Избавил город от крысоогров");
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
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"shouter",
			this.m.Dude != null ? this.m.Dude.getName() : ""
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
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/ratorge_attacks_situation"));
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

