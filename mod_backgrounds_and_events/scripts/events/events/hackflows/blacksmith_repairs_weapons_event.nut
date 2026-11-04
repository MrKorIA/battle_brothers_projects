this.blacksmith_repairs_weapons_event <- this.inherit("scripts/events/event", {
	m = {
		Blacksmith = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_blacksmith_repairs_weapons";
		this.m.Title = "В лагере...";
		this.m.Cooldown = 5.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img][M] Совершая быстрый обход лагеря, вы натыкаетесь на рабочее место, где %blacksmith% усердно чинит повреждённое оружие. Справа от кузнеца лежит груда мечей и топоров в разной степени негодности, а слева - несколько клинков, которые уже блестят как новые.%SPEECH_ON%О, приветствую, сэр! Прошу прощения, что без спроса позаимствовал всё это из нашей оружейной повозки. Ремесленнику нужно постоянно держать руки в тонусе, сами понимаете.%SPEECH_OFF%Вы отмахиваетесь от его извинений и интересуетесь, где он умудрился раздобыть инструменты для такой тонкой работы в походных условиях.%SPEECH_ON%Ну, знаете. Как и все кузнецы.%SPEECH_OFF%Вы, конечно же, ни черта не знаете, но похоже, что %blacksmith% счастлив, а бесплатный ремонт оружия - безусловно, огромное благо для вашего отряда. Стоит вам развернуться, как за спиной кузнец уже вовсю начинает насвистывать какой-то весёлый мотив.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Превосходно.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Blacksmith.getImagePath());
				local stash = this.World.Assets.getStash().getItems();
				local items = 0;

				foreach( item in stash )
				{
					if (item != null && item.isItemType(this.Const.Items.ItemType.Weapon) && item.getCondition() < item.getConditionMax())
					{
						item.setCondition(item.getConditionMax());
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = item.getName() + " починен"
						});
						items = ++items;
						items = items;

						if (items > 5)
						{
							break;
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_blacksmith = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.hackflows_blacksmith")
			{
				candidates_blacksmith.push(b);
			}
		}

		if (candidates_blacksmith.len() == 0)
		{
			return;
		}

		this.m.Blacksmith = candidates_blacksmith[this.Math.rand(0, candidates_blacksmith.len() - 1)];
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"blacksmith",
			this.m.Blacksmith.getName()
		]);
	}

	function onClear()
	{
		this.m.Blacksmith = null;
	}

});

