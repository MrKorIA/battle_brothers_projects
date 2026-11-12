this.gardener_provides_mysterious_herbs_event <- this.inherit("scripts/events/event", {
	m = {
		Gardener = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_gardener_provides_mysterious_herbs";
		this.m.Title = "По пути...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img][M] Пока отряд %companyname% находится в пути, вы направляетесь к обозу, дабы проверить лагерные припасы. У одной из повозок вашему взору открывается любопытная картина: %gardener% с походным мастерком в руках увлечённо возится со странными побегами в деревянном ящике, доверху наполненном землёй. Заметив ваше приближение, садовник аккуратно отряхивает ладони и заговаривает первым.%SPEECH_ON%Как удачно, что вы зашли, капитан! Я тут стараюсь не забывать своё прежнее ремесло в пути... Рассудил, что заодно можно вырастить немного целебных кореньев и трав. Так и руки делом заняты, и отряду чистая выгода, сэр.%SPEECH_OFF%Он откладывает инструмент в сторону и бережно протягивает вам пучок свежесрезанных стеблей.%SPEECH_ON%Большая часть пойдёт на приготовление лечебных мазей для раненых. А вот из этой пары листочков выйдет отличный, ароматный отвар... Я бы хотел припрятать их для себя, на память о былых счастливых днях.%SPEECH_OFF%Садовник на мгновение умолкает, и его взор устремляется куда-то вдаль, словно он пытается разглядеть в тумане воспоминаний своё утраченное прошлое. Наваждение длится всего пару секунд - %gardener% неловко кашляет и поспешно возвращается к прерванному занятию. Вы молча убираете пахучие травы в походную сумку и возвращаетесь к своим делам.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Возможно, мы сможем найти применение этим травам...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gardener.getImagePath());

				for( local i = 0; i < 4; i++ )
				{
					local item = this.new("scripts/items/misc/mysterious_herbs_item");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Вы получаете " + item.getName()
					});
				}

				this.World.Assets.addMedicine(6);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_medicine.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + 6 + "[/color] медикаментов."
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hackflows_gardener")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Gardener = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 20.0 * candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gardener",
			this.m.Gardener.getName()
		]);
	}

	function onClear()
	{
		this.m.Gardener = null;
	}

});

