this.fantasy_monster_encounter_17_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_17_event";
		this.m.Title = "По пути...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Собралась группа вооруженных людей. Увидев вашу банду наемников, они смотрят на вас с напряженными выражениями лиц. Судя по их скудному вооружению и неуверенной позе, они не похожи на опытных бандитов. Человек, который, по-видимому, является их представителем, выходит вперед и обращается к вам.%SPEECH_ON%Мы — те, кто поднялся за справедливость и равенство в этой стране. Поскольку мы восстали против жадности и дискриминации со стороны дворян, мы надеемся, что вы также поделитесь 1000 коронами на наше дело. Если вы откажетесь, мы будем судить вас в соответствии с нашим делом.%SPEECH_OFF%По желтым флагам, которые они несли, можно было понять, что это недавно сформированные крестьянские повстанческие силы. Известные как бандиты, которые захватывают богатства богатых и знати, чтобы свободно распределять их среди бедных, они приобрели значительную популярность среди простого народа. Однако, встретив их лично, все оказалось совсем не таким, как в рассказах, которые вы слышали.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-5);
						local pp = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						pp.CombatID = "Event";
						pp.Music = this.Const.Music.CivilianTracks;
						pp.IsAutoAssigningBases = false;
						pp.Entities = [];
						local moba;
						moba = [
							"scripts/entity/tactical/humans/peasant",
							"scripts/entity/tactical/humans/peasant",
							"scripts/entity/tactical/humans/peasant_armed",
							"scripts/entity/tactical/humans/peasant_armed",
							"scripts/entity/tactical/humans/peasant_armed",
							"scripts/entity/tactical/humans/slave_northern",
							"scripts/entity/tactical/humans/slave",
							"scripts/entity/tactical/humans/peasant_southern"
						];
						for( local i = 0; i < 5; i = ++i )
						{
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 0,
								Script = moba[this.Math.rand(0, moba.len() - 1)],
								Faction = this.Const.Faction.Enemy
							});
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 1,
								Script = moba[this.Math.rand(0, moba.len() - 1)],
								Faction = this.Const.Faction.Enemy
							});
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 2,
								Script = moba[this.Math.rand(0, moba.len() - 1)],
								Faction = this.Const.Faction.Enemy
							});
						}
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(pp, false, false, true);
						return 0;
					}
				},
				{
					Text = "Я согласен с твоей просьбой",
					function getResult( _event )
					{
						this.World.Assets.addMoney(-1000);
						this.World.Assets.addMoralReputation(5);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}
		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Вы вышли победителем из сражения. Умирающий повстанец, в последних вздохах, проклял вас, сказав, что это не конец и что его братья обязательно отомстят. %randombrother% положил конец его страданиям.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Вы должны были выбирать своего противника более разумно.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";
				local xxmoney = this.Math.rand(100, 500);
				this.World.Assets.addMoney(xxmoney);
				this.List.push({
					id = 11,
					icon = "ui/items/supplies/money.png",
					text = "Вы получаете " + xxmoney + " золота"
				});
			}
		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Вы потерпели поражение в битве и едва успели спастись бегством.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Проклятье!",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";
			}
		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 50)
		{
			return;
		}
		if (this.World.Assets.getMoney() < 1000)
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

