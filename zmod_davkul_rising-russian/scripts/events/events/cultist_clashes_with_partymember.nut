this.cultist_clashes_with_partymember <- this.inherit("scripts/events/event", {
	m = {
		Image = "",
		CultistBro = null,
		OtherBro = null,
		FearOrHate = null,
	},
	function create()
	{
		this.m.ID = "event.cultist_clashes_with_partymember";
		this.m.Title = "Во время путешествия...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%image%{%OtherBro% уже некоторое время смотрит с нескрываемой злобой на фанатика. Он хмурится и молится всякий раз, когда %CultistBro% встречается на его пути. В какой-то момент его нервы сдают и он изливает поток праведной ненависти.%SPEECH_ON%Древние боги точно надерут нам задницы, парни, если мы продолжим не замечать этого проклятого фанатика! Может вы и думаете, что в этом ничего такого нет, но я точно знаю, что потакание этим безумцам - это верная дорога в ад. Поступайте как хотите, но знайте, что я не пойду в пекло следом за вами. Древние боги могут быть уверены: я отвоюю себе место в раю, не важно, сколько демонопоклонников мне придётся истребить!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Так держать!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Casualty.getImagePath());
				local trait = this.new("scripts/skills/traits/hate_cultists_trait");
				_event.m.Casualty.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Casualty.getName() + " теперь ненавидит культистов"
				});
			}

		});
	}

	function onUpdateScore()
	{
		//disabled
		return
		if (!this.Const.DLC.Unhold)
		{
			return;
		}
		if (this.World.Assets.getOrigin().getID() == "scenario.cultists") return

		local brothers = this.World.getPlayerRoster().getAll();
		local cultistBros = [];
		local otherBros = [];

		foreach( bro in brothers )
		{
			if (bro.hasSkill("background.cultist")) cultistBros.push(bro)
			if (bro.hasSkill("trait.hate_cultists") || bro.hasSkill("trait.fear_cultists")) otherBros.push(bro)
		}

		if (cultistBros.len() == 0 || otherBros.len() == 0)
		{
			return;
		}

		this.m.CultistBro = this.Math.randArray(cultistBros);
		this.m.OtherBro = this.Math.randArray(otherBros);
		this.m.FearOrHate = this.m.OtherBro.hasSkill("trait.hate_cultists") ? "fears" : "hates"
		this.m.Score = 20;
	}

	function onPrepare()
	{
		this.m.Image = "[img]gfx/ui/events/event_46.png[/img]";
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"CultistBro",
			this.m.CultistBro.getName()
		]);
		_vars.push([
			"OtherBro",
			this.m.OtherBro.getName()
		]);
		_vars.push([
			"FearsHates",
			this.m.FearOrHate
		]);
	}

	function onClear()
	{
		this.m.CultistBro = null;
		this.m.OtherBro = null;
		this.m.Image = "";
	}

});

