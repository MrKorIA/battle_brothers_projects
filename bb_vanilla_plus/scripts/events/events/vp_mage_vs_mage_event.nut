this.vp_mage_vs_mage_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight1 = null,
		HedgeKnight2 = null,
		NonHedgeKnight = null,
		Monk = null
	},
	function create()
	{
		this.m.ID = "event.vp_mage_vs_mage_event";
		this.m.Title = "На привале...";
		this.m.Cooldown = 10.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%nonhedgeknight% вбегает в вашу палатку, едва не выдернув кол и не обрушив её. Пот капает с его лица на ваши карты. Вы смотрите на него взглядом, требующим объяснений. Он говорит, что маги %hedgeknight1% и %hedgeknight2% готовы убить друг друга. Их заклинания уже искажают воздух, а искры сыпятся из пальцев. Когда двое сильнейших чародеев в отряде выходят из-под контроля под угрозой оказываются все. Вы бросаетесь к месту происшествия.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Покажи мне их.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.NonHedgeKnight.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_174.png[/img]%hedgeknight1% сжимает в руке мерцающий жезл, вокруг его головы танцуют языки фиолетового пламени. %hedgeknight2% вращает посох, испещрённый рунами, от которых воздух дрожит. Вы подходите ближе, остальные братья держатся на расстоянии. %nonhedgeknight% объясняет, что {у них давний академический спор о природе магии, и теперь они решили разрешить его дуэлью насмерть | они работали над общим ритуалом, но каждый обвиняет другого в краже формулы | один из них случайно уничтожил лабораторию другого во время эксперимента}. Стоит ли вмешиваться?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Пусть победит сильнейший.",
					function getResult( _event )
					{
						return _event.m.Monk == null ? "C1" : "C2";
					}

				},
				{
					Text = "Приберегите себя для настоящего боя!",
					function getResult( _event )
					{
						return _event.m.Monk == null ? "C3" : "C4";
					}

				},
				{
					Text = "Тысяча крон каждому за то, чтобы остановить это безумие немедленно!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C1",
			Text = "[img]gfx/ui/events/event_174.png[/img]%nonhedgeknight% умоляет вас остановить их. Маги на секунду оборачиваются, их глаза горят. Вы машете рукой — пусть решают сами. Они кивают. В следующее мгновение воздух взрывается. Молния встречается с огнём, земля под ногами покрывается инеем, а затем плавится. %hedgeknight1% выпускает плеть чистой энергии, %hedgeknight2% отвечает копьём из чёрного льда. Оба получают ранения, но не останавливаются. Они бросают сложные заклинания и переходят к грубой силе — сжигают друг другу лица ладонями, ломают пальцы на жезлах. Кровь смешивается с искрами. Отряд снова смотрит на вас — очевидно, что они будут биться до конца.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ситуация вышла из-под контроля. Всё, остановите их!",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Посмотрим, кто сильнее в бою.",
					function getResult( _event )
					{
						return this.Math.rand(1, _event.m.HedgeKnight1.getLevel() + _event.m.HedgeKnight2.getLevel()) <= _event.m.HedgeKnight1.getLevel() ? "F" : "G";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				_event.m.HedgeKnight1.addLightInjury();
				_event.m.HedgeKnight2.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight1.getName() + " получает ранение"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight2.getName() + " получает ранение"
				});
			}

		});
		this.m.Screens.push({
			ID = "C3",
			Text = "[img]gfx/ui/events/event_174.png[/img]Маги не обращают внимания на ваши слова. В следующую секунду пространство искажается — и они бросаются друг на друга. Воздух наполняется треском разрядов, воем высвобожденной магии. %hedgeknight1% разряжает в грудь противника конус кинетической силы, но %hedgeknight2% отвечает телекинетическим ударом, ломающим челюсть. Они валятся в грязь, продолжая колдовать кулаками и зубами. Отряд ждёт вашего решения — эта драка, очевидно, не учебная.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ситуация вышла из-под контроля. Всё, остановите их!",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Посмотрим, кто сильнее в бою.",
					function getResult( _event )
					{
						return this.Math.rand(1, _event.m.HedgeKnight1.getLevel() + _event.m.HedgeKnight2.getLevel()) <= _event.m.HedgeKnight1.getLevel() ? "F" : "G";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				_event.m.HedgeKnight1.addLightInjury();
				_event.m.HedgeKnight2.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight1.getName() + " получает ранение"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight2.getName() + " получает ранение"
				});
			}

		});
		this.m.Screens.push({
			ID = "C2",
			Text = "[img]gfx/ui/events/event_174.png[/img]%nonhedgeknight% умоляет вас остановить их. Маги на секунду оборачиваются, их глаза горят. Вы машете рукой — пусть решают сами. Они кивают. В следующее мгновение воздух взрывается. Молния встречается с огнём, земля под ногами покрывается инеем, а затем плавится. %hedgeknight1% выпускает плеть чистой энергии, %hedgeknight2% отвечает копьём из чёрного льда. Оба получают ранения, но не останавливаются. Они бросают сложные заклинания и переходят к грубой силе — сжигают друг другу лица ладонями, ломают пальцы на жезлах. Кровь смешивается с искрами. Отряд снова смотрит на вас — очевидно, что они будут биться до конца. Ещё один чародей делает шаг вперёд, предлагая свои услуги в усмирении разгорячившихся магов.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ситуация вышла из-под контроля. Всё, остановите их!",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Посмотрим, кто сильнее в бою.",
					function getResult( _event )
					{
						return this.Math.rand(1, _event.m.HedgeKnight1.getLevel() + _event.m.HedgeKnight2.getLevel()) <= _event.m.HedgeKnight1.getLevel() ? "F" : "G";
					}

				},
				{
					Text = "%monk%, сделай с этим что-нибудь, пока они не разнесли все тут!",
					function getResult( _event )
					{
						return "H";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				_event.m.HedgeKnight1.addLightInjury();
				_event.m.HedgeKnight2.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight1.getName() + " получает ранение"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight2.getName() + " получает ранение"
				});
			}

		});
		this.m.Screens.push({
			ID = "C4",
			Text = "[img]gfx/ui/events/event_174.png[/img]Маги не обращают внимания на ваши слова. В следующую секунду пространство искажается — и они бросаются друг на друга. Воздух наполняется треском разрядов, воем высвобожденной магии. %hedgeknight1% разряжает в грудь противника конус кинетической силы, но %hedgeknight2% отвечает телекинетическим ударом, ломающим челюсть. Они валятся в грязь, продолжая колдовать кулаками и зубами. Ещё один чародей делает шаг вперёд, предлагая свои услуги в усмирении разгорячившихся магов. Отряд ждёт вашего решения — эта драка, очевидно, не учебная.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ситуация вышла из-под контроля. Всё, остановите их!",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Посмотрим, кто сильнее в бою.",
					function getResult( _event )
					{
						return this.Math.rand(1, _event.m.HedgeKnight1.getLevel() + _event.m.HedgeKnight2.getLevel()) <= _event.m.HedgeKnight1.getLevel() ? "F" : "G";
					}

				},
				{
					Text = "%monk%, сделай с этим что-нибудь, пока они не разнесли все тут!",
					function getResult( _event )
					{
						return "H";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				_event.m.HedgeKnight1.addLightInjury();
				_event.m.HedgeKnight2.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight1.getName() + " получает ранение"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight2.getName() + " получает ранение"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_04.png[/img]Вы достаёте тяжёлый мешок с монетами. Маги оглядываются. Звон золота трудно игнорировать.%SPEECH_ON%Тысяча крон каждому, если прекратите это безумие прямо сейчас.%SPEECH_OFF%Они переглядываются. Пожимают плечами. Вы киваете.%SPEECH_ON%Хорошо. Но чтобы я больше не слышал о ваших формулах и арканумах. Ясно?%SPEECH_OFF%Они неохотно кивают, забирая деньги. Кто-то из братьев обиженно смотрит: они просто получили плату за то, что не убили друг друга. Маги расходятся, уже считая монеты. Надеемся, этого хватит надолго.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Это лучший исход.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				this.World.Assets.addMoney(-2000);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Вы теряете [color=" + this.Const.UI.Color.NegativeEventValue + "]2000[/color] крон"
					}
				];
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.HedgeKnight1.getID() || bro.getID() == _event.m.HedgeKnight2.getID())
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.greedy"))
					{
						bro.worsenMood(2.0, "Разозлён подкупом ради прекращения драки");
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(1.0, "Обеспокоен подкупом ради прекращения драки");
					}

					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[bro.getMoodState()],
						text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_174.png[/img]Вы приказываете братьям вмешаться. Те колеблются, но подчиняются. Люди хватают намокшие одеяла, вёдра, мешки — всё, что может успокоить магов, оставив их в живых. Они набрасывают тряпки на головы чародеям, заливают их водой, пытаются скрутить. Один маг разряжает заклинание вслепую, отшвыривая троих. Другой взрывает костёр. В конце концов их удаётся повалить и связать — но лагерь превращён в руины, а несколько человек ранены осколками льда и ожогами. Битва окончена. Чародеи ворчат, но молчат. Вы начинаете оказывать помощь.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Наконец-то всё кончено.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.HedgeKnight1.getID() || bro.getID() == _event.m.HedgeKnight2.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 60)
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 75)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " получает ранение "
						});
					}
					else
					{
						local injury = bro.addInjury(this.Const.Injury.Brawl);
						this.List.push({
							id = 10,
							icon = injury.getIcon(),
							text = bro.getName() + " получает травму " + injury.getNameOnly()
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_174.png[/img]Вы садитесь на пень наблюдать. Маги больше не сдерживаются. %hedgeknight1% выкрикивает последнее слово формулы — и реальность вокруг головы %hedgeknight2% схлопывается. Тот падает, но успевает выпустить импульс чистой нестабильности. %hedgeknight1% перехватывает его горло, сжигая кожу разрядами. Он вдавливает пальцы в виски противника, и из ушей %hedgeknight2% течёт тёмная жидкость. Раздаётся хруст. Всё кончено. %hedgeknight1% поднимается, вытирая кровь с лица, и произносит:%SPEECH_ON%Эксперимент завершён.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Кажется одного мага в отряде вполне достаточно...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				local dead = _event.m.HedgeKnight2;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Убит в поединке с " + _event.m.HedgeKnight1.getName(),
					Expendable = false
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.HedgeKnight2.getName() + " погибает"
				});
				_event.m.HedgeKnight2.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.HedgeKnight2.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.HedgeKnight2);
				local injury = _event.m.HedgeKnight1.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.HedgeKnight1.getName() + " получает травму " + injury.getNameOnly()
				});

				if (this.Math.rand(1, 2) == 1)
				{
					local v = this.Math.rand(1, 2);
					_event.m.HedgeKnight1.getBaseProperties().RangedSkill += v;
					this.List.push({
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.HedgeKnight1.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] к навыку дальнего боя"
					});
				}
				else
				{
					local v = this.Math.rand(1, 2);
					_event.m.HedgeKnight1.getBaseProperties().RangedDefense += v;
					this.List.push({
						id = 16,
						icon = "ui/icons/melee_defense.png",
						text = _event.m.HedgeKnight1.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] к защите в дальнем бою"
					});
				}

				_event.m.HedgeKnight1.getSkills().update();
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_174.png[/img]Вы не успеваете найти место, чтобы сесть. %hedgeknight2% ломает посох %hedgeknight1% коленом и вгоняет осколок тому в глазницу. Магия выходит из-под контроля — тело %hedgeknight1% начинает светиться изнутри, затем рассыпается чёрным пеплом. %hedgeknight2% стоит над ним, тяжело дыша. Он смотрит на свои руки, потом на вас.%SPEECH_ON%Он первый начал.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Кажется одного мага в отряде вполне достаточно...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				local dead = _event.m.HedgeKnight1;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Убит в поединке с " + _event.m.HedgeKnight2.getName(),
					Expendable = false
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.HedgeKnight1.getName() + " погибает"
				});
				_event.m.HedgeKnight1.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.HedgeKnight1.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.HedgeKnight1);
				local injury = _event.m.HedgeKnight2.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.HedgeKnight2.getName() + " получает травму " + injury.getNameOnly()
				});

				if (this.Math.rand(1, 2) == 1)
				{
					local v = this.Math.rand(1, 2);
					_event.m.HedgeKnight2.getBaseProperties().RangedSkill += v;
					this.List.push({
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.HedgeKnight2.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] к навыку дальнего боя"
					});
				}
				else
				{
					local v = this.Math.rand(1, 2);
					_event.m.HedgeKnight2.getBaseProperties().RangedDefense += v;
					this.List.push({
						id = 16,
						icon = "ui/icons/melee_defense.png",
						text = _event.m.HedgeKnight2.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] к защите в дальнем бою"
					});
				}

				_event.m.HedgeKnight2.getSkills().update();
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_05.png[/img]Из толпы выступает третий маг — %monk%. Он не говорит ни слова. Поднимает руку. Между %hedgeknight1% и %hedgeknight2% вспыхивает ослепительная дуга — и оба падают замертво, их лица обращены в пепел. %monk% опускает руку.%SPEECH_ON%Они чуть не разнесли лагерь. Я спас нас всех.%SPEECH_OFF%Тишина. Братья отступают на шаг. Третий маг поворачивается к вам.%SPEECH_ON%Если вы хотели порядка — теперь он есть. Дальше работаем без них.%SPEECH_OFF%Он уходит в свою палатку. В отряде никто не сомкнул глаз этой ночью.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Кажется одного мага в отряде вполне достаточно...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());

				local dead = _event.m.HedgeKnight1;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Убит соратником " + _event.m.Monk.getName(),
					Expendable = false
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.HedgeKnight1.getName() + " погибает"
				});
				_event.m.HedgeKnight1.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.HedgeKnight1.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.HedgeKnight1);

				dead = _event.m.HedgeKnight2;
				fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Убит соратником " + _event.m.Monk.getName(),
					Expendable = false
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.HedgeKnight2.getName() + " погибает"
				});
				_event.m.HedgeKnight2.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.HedgeKnight2.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.HedgeKnight2);
			}

		});
	}

	function onUpdateScore()
	{
//	    ::logWarning("===vp_mage_vs_mage_event onUpdateScore?===");
		if (this.World.Assets.getMoney() < 2000)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 4)
		{
			return;
		}

		local candidates = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "vp.crio.background")
			{
				candidates.push(bro);
			}
//			else if (bro.getBackground().getID() == "vp.shaman.background")
//			{
//				candidates.push(bro);
//			}
			else if (bro.getBackground().getID() == "vp.electro.background")
			{
				candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "vp.piro.background")
			{
				candidates.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates.len() < 2 || candidates_other.len() == 0 && candidates.len() <= 2)
		{
			return;
		}

		local r = this.Math.rand(0, candidates.len() - 1);
		this.m.HedgeKnight1 = candidates[r];
		candidates.remove(r);
		r = this.Math.rand(0, candidates.len() - 1);
		this.m.HedgeKnight2 = candidates[r];
		candidates.remove(r);

		if (candidates_other.len() > 0)
		{
			this.m.NonHedgeKnight = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		}
		else
		{
			this.m.NonHedgeKnight = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		if (candidates.len() > 0)
		{
			this.m.Monk = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = (2 + candidates.len()) * 500;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hedgeknight1",
			this.m.HedgeKnight1.getName()
		]);
		_vars.push([
			"hedgeknight2",
			this.m.HedgeKnight2.getName()
		]);
		_vars.push([
			"nonhedgeknight",
			this.m.NonHedgeKnight.getName()
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.HedgeKnight1 = null;
		this.m.HedgeKnight2 = null;
		this.m.NonHedgeKnight = null;
		this.m.Monk = null;
	}

});

