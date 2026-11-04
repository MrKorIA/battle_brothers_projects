this.fantasy_monster_encounter_2_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_2_event";
		this.m.Title = "По пути...";
		this.m.Cooldown = 100 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Вдали вы видите людей, на которых нападают орды монстров. К сожалению, большинство из них уже погибли, и только несколько выживших умирают в агонии с криками боли. Спасти их уже слишком поздно, но, победив монстров, вы сможете спасти их багаж и ценные вещи. Или лучше убежать, пока монстры не обратили внимания на ваших наемников.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult( _event )
					{
						local pp = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						pp.CombatID = "Event";
						pp.Music = [
						"music/noble_01.ogg",
						"music/noble_02.ogg",
						"music/undead_01.ogg",
						"music/undead_02.ogg",
						"music/undead_03.ogg",
						"music/orcs_01.ogg",
						"music/orcs_02.ogg",
						"music/orcs_03.ogg",
						"music/goblins_01.ogg",
						"music/goblins_02.ogg",
						"music/beasts_01.ogg",
						"music/beasts_02.ogg",
						"music/civilians_01.ogg"
						];
						pp.IsAutoAssigningBases = false;
						if (this.Math.rand(1, 100) <= 25)
						{
							pp.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
							pp.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						}
						pp.Entities = [];
						local moba;
						moba = [
							"scripts/entity/tactical/enemies/xxmob_longbug",
							"scripts/entity/tactical/enemies/xxmob_bat",
							"scripts/entity/tactical/enemies/xxmob_boar",
							"scripts/entity/tactical/enemies/xxmob_wrider_wolf",
							"scripts/entity/tactical/enemies/xxmob_whitewolf",
							"scripts/entity/tactical/enemies/xxmob_slime_b",
							"scripts/entity/tactical/enemies/xxmob_spiderdemon",
							"scripts/entity/tactical/enemies/xxmob_toad",
							"scripts/entity/tactical/enemies/xxmob_lion",
							"scripts/entity/tactical/enemies/xxmob_bloodsucker",
							"scripts/entity/tactical/enemies/xxmob_liger"
						];
						moba = moba[this.Math.rand(0, moba.len() - 1)];
						for( local i = 0; i < this.Math.rand(7, 9); i = ++i )
						{
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 0,
								Script = moba,
								Faction = this.Const.Faction.Enemy
							});
						}
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(pp, false, false, true);
						return 0;
					}

				},
				{
					Text = "Отступаем!",
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
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_112.png[/img]{После ожесточенного сражения ваш отряд одержал победу. Все люди погибли, но их багаж и ценности остались невредимыми.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Давайте возьмем деньги и уйдем отсюда.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";
				local xxmoney = this.Math.rand(500, 1000);
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
			Text = "[img]gfx/ui/events/event_88.png[/img]{Ваша группа потерпела поражение и сумела сбежать.}",
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

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function epareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

