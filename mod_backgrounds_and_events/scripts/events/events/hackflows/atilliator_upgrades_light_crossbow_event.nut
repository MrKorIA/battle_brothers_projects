this.atilliator_upgrades_light_crossbow_event <- this.inherit("scripts/events/event", {
	m = {
		Atilliator = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_atilliator_upgrades_light_crossbow";
		this.m.Title = "В лагере...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img][M] Пока вы заняты рутинной инвентаризацией припасов в лагере, в палатку без лишнего шума заходит %atilliator% и бережно кладёт перед вами великолепно выглядящий арбалет.%SPEECH_ON%У меня тут завалялось несколько редких запасных деталей, капитан. Подумал, почему бы не пустить их в дело и не довести до ума один из наших арбалетов? В конце концов, в прежней жизни я именно этим ремеслом зарабатывал себе на жизнь.%SPEECH_OFF%Не дожидаясь ваших расспросов или похвалы, %atilliator% молча разворачивается и уходит, оставляя вас наедине с лагерными записями.",
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
				this.Characters.push(_event.m.Atilliator.getImagePath());
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "weapon.light_crossbow")
					{
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Вы теряете " + item.getName()
						});
						break;
					}
				}

				local item = this.new("scripts/items/weapons/crossbow");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hackflows_atilliator")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local lightCrossbowInInventory = false;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "weapon.light_crossbow")
			{
				lightCrossbowInInventory = true;
				break;
			}
		}

		if (!lightCrossbowInInventory)
		{
			return;
		}

		this.m.Atilliator = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 5.0 * candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"atilliator",
			this.m.Atilliator.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Atilliator = null;
	}

});

