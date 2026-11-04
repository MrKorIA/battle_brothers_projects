this.painter_and_herbalist_make_dyes_event <- this.inherit("scripts/events/event", {
	m = {
		Painter = null,
		Herbalist = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_painter_and_herbalist_make_dyes";
		this.m.Title = "По пути...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_55.png[/img][M] Едва отряд останавливается на короткий привал для разбивки лагеря, как вы замечаете, что у костра копошатся %painter% и %herbalist%. Эти двое умудрились притащить к огню едва ли не все котлы и кастрюли, которые нашлись в обозе отряда. Стоит вам подойти поближе, чтобы разузнать, в чём дело, как перед глазами предстаёт настоящий вихрь красок. %painter% вытаскивает руки из горшка, оборачивается к вам и буквально сияет от гордости.%SPEECH_ON%Эй, капитан! Для меня это было делом чести и личным вызовом - разобраться, как из подручных средств сварить по-настоящему яркие и стойкие краски!%SPEECH_OFF%Он уже заносит руку, чтобы по-свойски хлопнуть напарника по плечу, но вовремя замечает капающий с пальцев ядрёный пигмент и передумывает. Художник весело кивает на товарища.%SPEECH_ON%Этот парень - настоящий гений, проект у нас совместный! Я отвечал за теорию цвета, а %herbalist% раздобыл нужные коренья и травы. Теперь у меня наконец-то есть отличный материал для рисования!%SPEECH_OFF%Вы резонно интересуетесь, кто из этой парочки будет отмывать посуду отряда перед грядущим ужином. Услышав вопрос, %herbalist% задорно смеётся.%SPEECH_ON%Пусть за это возьмётся кто-нибудь другой, капитан. Мы сполна покроем расходы: излишки краски можно выгодно загнать купцам в следующем городе, а тем бедолагам, которые будут драить эти котлы, мы лично оплатим следующий вечер в таверне!%SPEECH_OFF%.В этот момент %painter% неловко вставляет.%SPEECH_ON%Да нам и самим придётся знатно отмываться. В таком виде мы только все спальники и палатки вокруг перемажем.%SPEECH_OFF%Рассудив, что наёмники предлагают вполне честную сделку, вы со спокойной душой возвращаетесь к своим обязанностям.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Оно того стоило.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Herbalist.getImagePath());
				this.Characters.push(_event.m.Painter.getImagePath());

				for( local i = 0; i < 4; i++ )
				{
					local item = this.new("scripts/items/trade/dies_item");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Вы получаете " + item.getName()
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 4)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		if (this.World.Assets.getStash().getNumberOfEmptySlots() < 4)
		{
			return;
		}

		local candidates_painter = [];
		local candidates_herbalist = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.hackflows_painter")
			{
				candidates_painter.push(b);
			}

			if (b.getBackground().getID() == "background.hackflows_herbalist")
			{
				candidates_herbalist.push(b);
			}
		}

		if (candidates_painter.len() == 0 || candidates_herbalist.len() == 0)
		{
			return;
		}

		this.m.Herbalist = candidates_herbalist[this.Math.rand(0, candidates_herbalist.len() - 1)];
		this.m.Painter = candidates_painter[this.Math.rand(0, candidates_painter.len() - 1)];
		this.m.Score = candidates_herbalist.len() * 10 + candidates_painter.len() * 20;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"herbalist",
			this.m.Herbalist.getName()
		]);
		_vars.push([
			"painter",
			this.m.Painter.getName()
		]);
	}

	function onClear()
	{
		this.m.Painter = null;
		this.m.Herbalist = null;
	}

});

