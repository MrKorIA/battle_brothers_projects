this.blacksmith_repairs_armor_event <- this.inherit("scripts/events/event", {
	m = {
		Blacksmith = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_blacksmith_repairs_armor";
		this.m.Title = "В лагере...";
		this.m.Cooldown = 5.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img][M] Занявшись инвентаризацией лагерного имущества, вы с удивлением обнаруживаете, что несколько повреждённых доспехов бесследно пропали. Взбешённый мыслью о том, что в отряде завёлся вор, вы принимаетесь прочёсывать лагерь в поисках улик. Тяжёлые следы кованых сапог приводят вас прямиком к палатке, где %blacksmith% преспокойно латает недостающую броню. Завидев ваше приближение, кузнец расплывается в широкой улыбке:%SPEECH_ON%Здравия желаю, капитан! Простите, что не предупредил заранее, но я рассудил, что в нашем ремесле кузнечные навыки нужно всегда держать в тонусе. А в эти смутные времена крепкая броня - залог долгой жизни. Вы ведь согласны со мной, сэр?%SPEECH_OFF%Сменив гнев на милость, вы одобрительно киваете, но строго наказываете мастеру, чтобы в следующий раз он предупреждал вас перед тем, как утаскивать снаряжение из обоза.",
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
					if (item != null && item.isItemType(this.Const.Items.ItemType.Armor) && item.getCondition() < item.getConditionMax())
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

