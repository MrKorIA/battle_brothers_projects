this.fantasy_monster_encounter_19_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_19_event";
		this.m.Title = "По пути...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_76.png[/img]{Перед вами появляется человек в черном капюшоне. Его лицо было невидимым, и он был похож на тень. Вскоре он заговорил голосом, который казался не от этого мира.%SPEECH_ON%Ваша репутация достигла своего пика, и это ваша награда.%SPEECH_OFF%Человек исчез, как дым, оставив после себя лекарство. Это действительно странно.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Что это было сейчас?",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/misc/xxreputation");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 12,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете "  + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}
		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoralReputation() < 90.0 && this.World.Assets.getMoralReputation() > 9.0)
		{
			return;
		}

		this.m.Score = 500;
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

