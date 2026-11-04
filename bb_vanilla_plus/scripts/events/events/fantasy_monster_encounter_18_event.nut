this.fantasy_monster_encounter_18_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_18_event";
		this.m.Title = "По пути...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Пришел {мужчина | женщина} в потрепанном виде.%SPEECH_ON%Здравствуйте, наемники. Вам не нужна девушка? Я продам свою дочь за хорошую цену. Моя дочь умная и будет делать все, что вы ей скажете. Все что угодно..%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ты сутенер, который продает свою дочь. Убирайся к черту.",
					function getResult( _event )
					{
						return 0;
					}
				},
				{
					Text = "Отсечь шею.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							this.World.Assets.addMoralReputation(-2);
						}
						else
						{
							this.World.Assets.addMoralReputation(2);
						}
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B1";
						}
						else
						{
							return "B2";
						}
					}
				},
				{
					Text = "Купить её за 10 крон.",
					function getResult( _event )
					{
						this.World.Assets.addMoney(-10);
						return "C";
					}
				}
			],
			function start( _event )
			{
			}
		});
		this.m.Screens.push({
			ID = "B1",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Вы отрубили голову мерзавцу, который пытался продать свою дочь. Оставив плачущую девочку, вы дали команду отряду продолжить путь. Только время покажет, станут ли ваши действия для нее спасением или источником обиды.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Мы продолжим идти вперед.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
			}
		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Вы отрубили голову мерзавцу, который пытался продать свою дочь. Несмотря на то, что ее родители умерли на ее глазах, она осталась невозмутимой, пока ты очищал окровавленный клинок. Когда ты повернулся спиной и собирался уходить, она попросила тебя об одолжении.%SPEECH_ON%Пожалуйста, возьми меня с собой. Теперь мне некуда пойти. Я сделаю все, что ты попросишь.%SPEECH_OFF%Ты повернулся с бесстрастным выражением лица, но она безрассудно последовала за тобой. Ты не знаешь, о чем она думает, но хорошо, что у тебя есть хотя бы один человек, который будет готовить и стирать.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Вам придется научиться готовить, стирать и пользоваться мечом.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
				{
					local roster = this.World.getPlayerRoster();
					local xxlonexx = roster.create("scripts/entity/tactical/player");
					xxlonexx.setStartValuesEx([
						"xxi_female_background"
					]);
					xxlonexx.m.HireTime = this.Time.getVirtualTimeF();
					xxlonexx.getBackground().m.RawDescription = "Вы отрезали головы родителям, которые пытались продать %name% прямо на ее глазах. Она последовала за вами, убив своих родителей, и теперь является членом%companyname%.";
					xxlonexx.getBackground().buildDescription(true);
					if (xxlonexx.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
					{
						xxlonexx.getItems().getItemAtSlot(this.Const.ItemSlot.Body).removeSelf();
						xxlonexx.getItems().equip(this.new("scripts/items/armor/tattered_sackcloth"));
					}
					this.Characters.push(xxlonexx.getImagePath());
				}
			}
		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Вы видите, как девушка плачет от отчаяния из-за того, что ее продали, и говорите ей, что делать дальше.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Вам придется научиться готовить, стирать и пользоваться мечом.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
				{
					local roster = this.World.getPlayerRoster();
					local xxlonexx = roster.create("scripts/entity/tactical/player");
					xxlonexx.setStartValuesEx([
						"xxi_female_background"
					]);
					xxlonexx.m.HireTime = this.Time.getVirtualTimeF();
					local background = this.new("scripts/skills/backgrounds/slave_background");
					xxlonexx.getSkills().removeByID("background.messenger");
					xxlonexx.getSkills().add(background);
					xxlonexx.getSkills().add(this.new("scripts/skills/actives/xxzzvoice_skill"));
					xxlonexx.getFlags().add("xxzzvoice_girl");
					xxlonexx.m.Background = background;
					xxlonexx.getBackground().m.RawDescription = "%name% плакала от отчаяния, узнав, что ее родители продали ее за несколько крон, но вскоре ей пришлось приспособиться к %companyname%.";
					xxlonexx.getBackground().buildDescription(true);
					if (xxlonexx.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
					{
						xxlonexx.getItems().getItemAtSlot(this.Const.ItemSlot.Body).removeSelf();
						xxlonexx.getItems().equip(this.new("scripts/items/armor/tattered_sackcloth"));
					}
					this.Characters.push(xxlonexx.getImagePath());
				}
			}
		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 50)
		{
			return;
		}
		if (this.World.Assets.getMoney() < 100)
		{
			return;
		}

		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

