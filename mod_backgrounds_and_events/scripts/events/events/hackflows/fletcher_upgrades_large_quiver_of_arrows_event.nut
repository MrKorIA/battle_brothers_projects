this.fletcher_upgrades_large_quiver_of_arrows_event <- this.inherit("scripts/events/event", {
	m = {
		Fletcher = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_fletcher_upgrades_large_quiver_of_arrows";
		this.m.Title = "В лагере...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img][M] Пока вы заняты скучной инвентаризацией припасов в лагере, в палатку без лишнего стука заходит %fletcher%. Он аккуратно кладёт перед вами колчан, доверху набитый превосходными стрелами.%SPEECH_ON%Я тут мельком глянул на колчаны, с которыми приходится бегать нашим стрелкам, капитан. Дай, думаю, пущу в ход свои знания, чтобы сделать их немного вместительнее. Дело житейское, у меня как раз завалялись свободные материалы и пара часов времени.%SPEECH_OFF%Не дожидаясь вашего ответа или похвалы, %fletcher% молча разворачивается и уходит обратно к кострам, оставляя вас наедине с лагерными записями.",
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
				this.Characters.push(_event.m.Fletcher.getImagePath());
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "ammo.arrows" && item.getAmmoMax() == 14)
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

				local item = this.new("scripts/items/ammo/huge_quiver_of_arrows");
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
			if (bro.getLevel() >= 4 && bro.getBackground().getID() == "background.hackflows_fletcher")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local largeQuiverInInventory = false;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "ammo.arrows" && item.getAmmoMax() == 14)
			{
				largeQuiverInInventory = true;
				break;
			}
		}

		if (!largeQuiverInInventory)
		{
			return;
		}

		this.m.Fletcher = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10.0 * candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"fletcher",
			this.m.Fletcher.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Fletcher = null;
	}

});

