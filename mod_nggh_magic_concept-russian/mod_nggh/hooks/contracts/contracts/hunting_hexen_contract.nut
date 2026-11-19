::Nggh_MagicConcept.HooksMod.hook("scripts/contracts/contracts/hunting_hexen_contract", function(q) 
{
	q.createStates = @(__original) function()
	{
		__original();

		foreach(i, state in m.States)
		{
			if (state.ID == "Offer") {
				state.countHexe <- function()
				{
					if (::Const.GoodMoralReputaions.find(::World.Assets.getMoralReputationAsText()) != null)
						return 999;
					
					if (::Const.GoodOrigins.find(::World.Assets.getOrigin().getID()) != null)
						return 999;
					
					local count = 0;
					foreach( bro in ::World.getPlayerRoster().getAll() )
					{
						if (bro.getFlags().has("isBonus") && bro.getSkills().hasSkill("background.hexe"))
							++count;
					}

					return count;
				};
				state.end = function()
				{
					::World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
					local r = ::Math.rand(1, 100);
					local hexeCount = this.countHexe();

					if (::World.Assets.getOrigin().getID() == "scenario.hexe")
					{
						if (hexeCount < ::Nggh_MagicConcept.Mod.ModSettings.getSetting("hired_hexe_num_max").getValue() * 3 && r <= ::Nggh_MagicConcept.ChanceToHireHexe * 3)
							this.Flags.set("IsHiringHexe", true);
						else if (r <= 20)
							this.Flags.set("IsSpiderQueen", true);
						else if (r <= 37)
							this.Flags.set("IsEnchantedVillager", true);
						else if (r <= 60)
							this.Flags.set("IsSinisterDeal", true);
					}
					else
					{
						if (hexeCount < ::Nggh_MagicConcept.Mod.ModSettings.getSetting("hired_hexe_num_max").getValue() && r <= ::Nggh_MagicConcept.ChanceToHireHexe)
							this.Flags.set("IsHiringHexe", true);
						else if (r <= 15)
							this.Flags.set("IsSpiderQueen", true);
						else if (r <= 35)
							this.Flags.set("IsCurse", true);
						else if (r <= 45)
							this.Flags.set("IsEnchantedVillager", true);
						else if (r <= 55)
							this.Flags.set("IsSinisterDeal", true);
					}

					this.Flags.set("StartTime", ::Time.getVirtualTimeF());
					this.Flags.set("Delay", ::Math.rand(10, 30) * 1.0);
					local envoy = ::World.getGuestRoster().create("scripts/entity/tactical/humans/firstborn");
					envoy.setName(this.Flags.get("ProtecteeName"));
					envoy.setTitle("");
					envoy.setFaction(1);
					this.Flags.set("ProtecteeID", envoy.getID());
					this.Contract.m.Home.setLastSpawnTimeToNow();
					this.Contract.setScreen("Overview");
					::World.Contracts.setActiveContract(this.Contract);
				};
			}
			else if (state.ID == "Running")
			{
				state.update = function()
				{
					if (!this.Contract.isPlayerNear(this.Contract.getHome(), 600))
						this.Flags.set("IsFail2", true);

					if (this.Flags.has("IsFail1") || ::World.getGuestRoster().getSize() == 0)
					{
						this.Contract.setScreen("Failure1");
						::World.Contracts.showActiveContract();
					}
					else if (this.Flags.has("IsFail2"))
					{
						this.Contract.setScreen("Failure2");
						::World.Contracts.showActiveContract();
					}
					else if (this.Flags.has("IsVictory"))
					{
						if (this.Flags.get("IsCurse"))
						{
							local candidates = [];

							foreach( bro in ::World.getPlayerRoster().getAll() )
							{
								if (bro.getSkills().hasSkill("trait.superstitious"))
									candidates.push(bro);
							}

							if (candidates.len() == 0)
								this.Contract.setScreen("Success");
							else
							{
								this.Contract.m.Dude = ::MSU.Array.rand(candidates);
								this.Contract.setScreen("Curse");
							}
						}
						else if (this.Flags.get("IsEnchantedVillager"))
							this.Contract.setScreen("EnchantedVillager");
						else
							this.Contract.setScreen("Success");

						::World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("StartTime") + this.Flags.get("Delay") <= ::Time.getVirtualTimeF())
					{
						if (this.Flags.get("IsHiringHexe") && ::World.getPlayerRoster().getSize() < ::World.Assets.getBrothersMax())
							this.Contract.setScreen("HiringHexe");
						else if (this.Flags.get("IsSpiderQueen"))
							this.Contract.setScreen("SpiderQueen");
						else if (this.Flags.get("IsSinisterDeal") && ::World.Assets.getStash().hasEmptySlot())
							this.Contract.setScreen("SinisterDeal");
						else
							this.Contract.setScreen("Encounter");

						::World.Contracts.showActiveContract();
					}
					else if (!this.Flags.get("IsBanterShown") && ::Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 6.0 <= ::Time.getVirtualTimeF())
					{
						this.Flags.set("IsBanterShown", true);
						this.Contract.setScreen("Banter");
						::World.Contracts.showActiveContract();
					}
				}
			}
		}
	}

	q.createScreens = @(__original)function()
	{
		__original();

		foreach(i, screen in m.Screens)
		{
			if (screen.ID == "SinisterDeal")
			{
				screen.Text = "[img]gfx/ui/events/event_106.png[/img]{%randombrother% присвистывает и склоняет шапку перед прекрасными дамами, которые появились словно из ниоткуда, чтобы упасть в обморок перед отрядом. Вы сдерживаете продавца и делаете шаг вперед, но прежде чем вы успеваете заговорить, одна из женщин поднимает руки вверх и идет вам навстречу.%SPEECH_ON%Let me show you my true self, sellsword.%SPEECH_OFF%Her arms goes to her sides and there turns grey and shrivel like wet almond skin. Некогда яркие и шелковистые волосы выпадают длинными прядями, пока не обнажается ее гротескный череп, последние корни которого держат скопище мошек и вшей, как последние скопления на умирающем мире. Она кланяется, поднимая к тебе лицо с желтой ухмылкой. %SPEECH_ON%Мы обладаем великой силой, торговец, в этом ты, конечно, убедился. Я предлагаю тебе сделку.%SPEECH_OFF%Она берет в каждую руку по крошечному флакончику, в одном - капля зеленой жидкости, в другом - синей. Она улыбается и вертит их в пальцах, пока говорит.%SPEECH_ON%Напиток для тела или для духа. Мужчины готовы убить за любой из них. Я предлагаю тебе один в обмен на жизнь первенца. Или ты хочешь оставить одну из моих рабынь в качестве домашнего животного. Что стоит потомство чужака? Ты уже зарезал свою долю, не так ли? Отойди, торговец, и позволь нам взять этого. Или вступай с нами в бой, рискуй жизнью своих людей и своей собственной, ради какого-то карлика, который в свое время не вспомнит твоего лица. Выбор за тобой. %SPEECH_OFF%}";
				screen.start <- function()
				{
					if (::World.getPlayerRoster().getSize() < ::World.Assets.getBrothersMax())
					{
						this.Options.push({
							Text = "Мне нужен верный раб, который будет выполнять мои приказы.",
							function getResult()
							{
								return "SinisterDealCharmedSlave";
							}
						});
					}
				};
			}
		}

		this.m.Screens.push({
			ID = "SinisterDealCharmedSlave",
			Title = "Неподалёку от поселения %townname%",
			Text = "[img]gfx/ui/events/event_106.png[/img]{Взмахом руки и ударом запястья ведьма отправляет зелено-голубой пузырек в рукав.%SPEECH_ON%Ты умный человек, продавец.%SPEECH_OFF% Она резко фыркнула, ее толстый нос сморщился, превратившись в личинку, и опустился обратно.%SPEECH_ON% Я чувствую, что в твоей крови, продавец, есть остроумные люди. Ее глаза смотрят на вас, как кошка на сверчка, который все еще осмеливается двигаться. Но потом ее улыбка возвращается, больше жвачки, чем зубов, больше черного, чем розового.%SPEECH_ON%Ах, что ж, сделка есть сделка. Вот вы где.%SPEECH_OFF% Пока она говорит, из тени позади нее выходит существо, оно опускает голову на вас. Когда вы оглядываетесь, ведьмы уже нет. Вы слышите слабый крик ужасной пытки, расстояние, казалось бы, одновременно близкое и далекое, и вы не сомневаетесь, что это кончина первенца %нанимателя%}.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Слишком хорошая сделка, чтобы отказаться.",
					function getResult()
					{
						::World.Assets.addBusinessReputation(::Const.World.Assets.ReputationOnContractBetrayal);
						::World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(::Const.World.Assets.RelationCivilianContractFail * 2, "Предал своего нанимателя по имени " + this.Contract.getEmployer().getName() + ", заключив сделку с ведьмами");
						::World.Contracts.finishActiveContract(true);
						return;
					}

				}
			],
			function start()
			{
				local roster = ::World.getPlayerRoster();
				local r = ::MSU.Array.rand(::Const.CharmedListRegularContract);
				local entity = roster.create("scripts/entity/tactical/player_beast/" + r);
				entity.worsenMood(1.5, "Быть проданной любовницей");
				entity.setStartValuesEx();
				entity.onHired();

				this.Characters.push(entity.getImagePath());
				this.List.push({
					id = 10,
					icon = entity.getBackground().getIcon(),
					text = entity.getName() + " присоединился к вашему отряду"
				});
			}

		});
		this.m.Screens.push({
			ID = "HiringHexe",
			Title = "Неподалёку от поселения %townname%",
			Text = "[img]gfx/ui/events/event_106.png[/img]{Одинокая женщина пересекает ваш путь и приближается между деревьями.%SPEECH_ON% Давайте не будем сразу драться, у меня есть предложение, которое я хочу вам сказать. Ты, конечно, знаешь, кто я, не так ли? %SPEECH_OFF%Ты жестом приглашаешь ее продолжать.%SPEECH_ON%Видишь ли, у меня большая сила, не думаешь ли ты, что такая сила когда-нибудь понадобится. Позволь мне получить жизнь первенца в обмен на мою службу. Вы не пожалеете, что позволили мне присоединиться к вашему отряду, я могу это гарантировать. Подумайте. %SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Я никогда не отдам этого мальчика вам, шлюхам. К оружию!",
					function getResult()
					{
						local p = ::World.State.getLocalCombatProperties(::World.State.getPlayer().getPos());
						p.CombatID = "Hexen";
						p.Entities = [];
						p.Music = ::Const.Music.CivilianTracks;
						p.PlayerDeploymentType = ::Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = ::Const.Tactical.DeploymentType.Line;
						::Const.World.Common.addUnitsToCombat(p.Entities, ::Const.World.Spawn.HexenAndNoSpiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), ::World.FactionManager.getFactionOfType(::Const.FactionType.Beasts).getID());
						::World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}
				},
				{
					Text = "Добро пожаловать в отряд, сестра!",
					function getResult()
					{
						return "SinisterDealHireHexe";
					}
				}
			],
		});
		this.m.Screens.push({
			ID = "SinisterDealHireHexe",
			Title = "Неподалёку от поселения %townname%",
			Text = "[img]gfx/ui/events/event_106.png[/img]{Ведьма улыбается.%SPEECH_ON%Человек ничто без тела, способного управлять им в этом мире. Спасибо, что позволили мне быть частью вашего отряда. Тогда, пожалуйста, позвольте мне получить мою плату. %SPEECH_OFF%. Ведьма быстро проходит сквозь вас, затем переходит на спринт, как кошка, набрасывающаяся на свою добычу. Одинокий крик - это все, что осталось, доносящийся из других мест. Без сомнения, это гибель первенца %работодателя%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Будьте быстры! У нас нет времени играть",
					function getResult()
					{
						::World.Assets.addBusinessReputation(::Const.World.Assets.ReputationOnContractBetrayal);
						::World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(::Const.World.Assets.RelationCivilianContractFail * 2, "Предал своего нанимателя по имени " + this.Contract.getEmployer().getName() + ", заключив сделку с ведьмами");
						::World.Contracts.finishActiveContract(true);
						return 0;
					}
				}
			],
			function start()
			{
				local roster = ::World.getPlayerRoster();
				local hexe = roster.create("scripts/entity/tactical/player");
				hexe.setStartValuesEx(["nggh_mod_hexe_regular_background"]);
				hexe.getBackground().buildDescription(true);
				hexe.onHired();

				this.Characters.push(hexe.getImagePath());
				this.List.push({
					id = 10,
					icon = hexe.getBackground().getIcon(),
					text = hexe.getName() + " присоединился к вашему отряду"
				});

				foreach ( _bro in roster.getAll() )
				{
					if (_bro.getSkills().hasSkill("effects.simp"))
					{
						continue;
					}

					if (::Const.WitchHaters.find(_bro.getBackground().getID()) == null)
					{
						continue;
					}

					_bro.worsenMood(2.0, "Ведьма присоединилась " + ::World.Assets.getName());
					_bro.worsenMood(2.0, "Подозревает, что вы еретик");

					if (_bro.getMoodState() < ::Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = ::Const.MoodStateIcon[_bro.getMoodState()],
							text = _bro.getName() + ::Const.MoodStateEvent[_bro.getMoodState()]
						});
					}
				}
			}
		});

	}
});
