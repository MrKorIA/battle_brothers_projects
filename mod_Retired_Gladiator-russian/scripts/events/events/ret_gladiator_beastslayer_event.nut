this.ret_gladiator_beastslayer_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
	},
	function create()
	{
		this.m.ID = "event.ret_gladiator_beastslayer";
		this.m.Title = "Приближается чудовище...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_130.png[/img]Кустарник расступается, и вы замечаете огромное чудище. Вы тут же обнажаете клинок, но замечаете, что на великане надеты хорошо подогнанные доспехи, а за собой он тянет тело линдвурма, только что зарезанного, словно ягненка, попавшего в волчью яму. Незнакомец смотрит вам в глаза.%SPEECH_ON%Да озарит Златоликий твой путь.%SPEECH_OFF%Произносит великан, не сбавляя шага и волоча вурма мимо вас.\n\nКолосс начинает насвистывать радостную мелодию, но через несколько мгновений останавливается, выпуская из рук хвост вурма, с тяжёлым стуком падающего на землю. Ожившая гора поворачивается в вашу сторону.%SPEECH_ON%Погоди-ка... Я знаю тебя!%SPEECH_OFF%Вы готовите своё оружие - хотя для ходячей крепости это не имеет никакого значения. Великан останавливается в нескольких шагах от вас, открывая всю тяжесть нанесенных его телу наказаний - оно сплошь покрыто ожогами, шрамами и следами укусов. Все хорошо зажили, будто простые царапины. Гора наклоняется, чтобы заглянуть вам в глаза.%SPEECH_ON%Точно! Это же ты!%SPEECH_OFF%Великан выглядит счастливым, словно ребёнок, получивший новую игрушку.%SPEECH_ON%Ты же истребляешь чудищ? Я всегда хотел сражаться вместе с легендой!%SPEECH_OFF%Вы опускаете оружие и готовитесь к знакомству, но незнакомец опережает вас.%SPEECH_ON%Я пришел с юга... У меня много имен, но большинство знает меня как... %SPEECH_OFF%Труп вурма протестующе булькает, остатки его нижней челюсти слабо подергиваются. Незнакомец пинает зверя, и бульканье стихает.%SPEECH_ON%Не обращай внимания, он просто обиженный неудачник, только и всего.%SPEECH_OFF%Он поворачивается к вам с удивительной быстротой.%SPEECH_ON%Что бы ты сказал о небольшой компании? Два чужака в чужой стране должны получить много крон и славы!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Небольшая компания была бы кстати.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Мне не нужна твоя помощь.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"beastslayer_gladiator_background"
				]);
				_event.m.Dude.getSkills().add(this.new("scripts/skills/perks/perk_retglad_path"));
				_event.m.Dude.getBackground().m.RawDescription = "Вынужденный в детстве бороться с невероятными трудностями, %name% потряс всех, с одинаковой лёгкостью расправляясь как с гиенами, так и линдвурмами. Многие стекались посмотреть на великана, покрытого мускулами и шрамами, принеся ему богатство, достаточное, чтобы купить себе свободу и отправиться на север. Встретив со стороны северян лишь презрение, %name% отправился в пустоши, ища жарких схваток - и вот тогда, судьба свела вас, и вы завязали дружбу, которая, кажется, длится уже всю жизнь.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() != "scenario.ret_gladiator")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

    	local brothers = this.World.getPlayerRoster().getAll();
    	local hasCandidate = false;

    	foreach( bro in brothers )
        {
        	if (bro.getLevel() >= 11 && bro.getBackground().getID() == "background.retired_gladiator")
           {
               hasCandidate = true
           }
    	}

        if (hasCandidate){
        	this.m.Score = 13;
        }
    }

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

