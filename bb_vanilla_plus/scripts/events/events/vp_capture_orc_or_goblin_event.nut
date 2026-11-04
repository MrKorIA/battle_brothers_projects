this.vp_capture_orc_or_goblin_event <- this.inherit("scripts/events/event", {
	m = {
		LastCombatID = 0,
		Dude = null,
		IsGoblinDone = false,
		IsOrcDone = false
	},
	function create()
	{
		this.m.ID = "event.vp_capture_orc_or_goblin_event";
		this.m.Title = "После битвы...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "Goblin",
			Text = "[img]gfx/ui/events/event_83.png[/img]Бойня позади. Вы идёте по полю, пиная бездыханных гоблинов, как вдруг один из них подаёт голос. Он привязан к камню ржавой цепью, весь в синяках и шишках, но явно жив. И явно очень хочет остаться в этом статусе. %SPEECH_ON%О, великие убийцы зелёных! О, ужасные мясники гоблинских морд! — тараторит он, падая ниц. — Не убивайте жалкого изгоя! Меня племя ненавидит! Я слишком маленький для боя, слишком большой для подземелий, слишком умный для леса и слишком глупый для всего остального! Меня связали, чтобы медведям скормить! Но я лучше к вам пойду! Я буду обувь чистить! Я буду костёр разжигать! Я даже умею смеяться над плохими шутками!%SPEECH_OFF%Вы делаете шаг в его сторону с занесённым мечом, и гоблин вдруг поднимает голову с совершенно иным выражением лица: хитрым, деловым, почти купеческим. %SPEECH_ON%Ладно, — шипит он, — без шуток. Сокровище. Реальное. Моё племя копило его три поколения. Я покажу, где... Только не сразу, если я сразу выдам эту тайну, то вы меня убьете. Вы дадите мне еду и защиту. Идёт? Или убивайте. Но тогда золото достанется воронам.%SPEECH_OFF%Вы смотрите на своих людей. Кто-то уже точит нож. Кто-то — задумчиво чешет подбородок.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Жалкое зрелище. Пусть живёт, пока полезен. Но глаз с него не спускать.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Ненавидит всех");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Гоблину не место среди людей. Прикончить тварь.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"vp_goblin_background"
				]);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Orc",
			Text = "[img]gfx/ui/events/event_81.png[/img]Битва с орками окончена. Поле усеяно зелёными тушами, воздух пропитан вонью пота и крови. Вы идёте по трупам, добивая раненых, когда слышите глухое рычание из-под груды тел. Вы переворачиваете очередного орка, в поисках хоть чего-то ценного, и вдруг замечаете, что один из «убитых» смотрит на вас. Он не похож на остальных. Слишком худой. Слишком спокойный. И привязанный цепью к копью — как провизия, а не как воин. Он не рычит и не рвётся в бой. Он просто сидит и смотрит в землю. %SPEECH_ON%Убей, — вдруг говорит он. Голос низкий, гортанный, с ужасным акцентом. — Убей, человек. Не орк я. Полукровка. На битву не брали. Копья носить заставляли. Дерьмо чистить. Жизнь — говно. Смерть лучше.%SPEECH_OFF%Он поднимает голову, и вы видите его глаза. В них нет злобы. Нет страха. Только усталость. Собачья, бесконечная усталость существа, которого били всю жизнь. %SPEECH_ON%Своих нет. Чужих — тем более. Орки смеются. Люди убегают. Пустота. Всегда пустота. Убей — и пустоту не надо терпеть.%SPEECH_OFF%Он смотрит на вас снизу вверх. Не просит. Не умоляет. Констатирует факт.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Сражаться хочешь? Будут тебе сражения. Живым пойдёшь с нами.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Ожидает худшего");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Ты прав, полукровка. Жизнь таких, как ты, никому не нужна.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"vp_orc_background"
				]);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function isValid()
	{
		if (this.m.IsGoblinDone && this.m.IsOrcDone)
		{
			return false;
		}

		if (this.World.Statistics.getFlags().getAsInt("LastCombatID") <= this.m.LastCombatID)
		{
			return false;
		}

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 5.0 || this.World.Statistics.getFlags().getAsInt("LastCombatResult") != 1)
		{
			return false;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return false;
		}

		local f = this.World.FactionManager.getFaction(this.World.Statistics.getFlags().getAsInt("LastCombatFaction"));

		if (f == null)
		{
			return false;
		}

		if (f.getType() == this.Const.FactionType.Goblins || f.getType() == this.Const.FactionType.Orcs)
		{
            this.m.LastCombatID = this.World.Statistics.getFlags().get("LastCombatID");
		    if (f.getType() == this.Const.FactionType.Orcs && this.m.IsOrcDone) return false;
		    if (f.getType() == this.Const.FactionType.Goblins && this.m.IsGoblinDone) return false;
		    local rand = this.Math.rand(1, 100);
            if (rand <= 5)
            {
                this.logInfo("P rand: " + rand);
                return true;
			}
			else
			{
			    this.logInfo("U rand: " + rand);
			    return false;
			}
		}

		return false;

	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		local f = this.World.FactionManager.getFaction(this.World.Statistics.getFlags().getAsInt("LastCombatFaction"));

		if (f.getType() == this.Const.FactionType.Orcs)
		{
		    this.m.IsOrcDone = true;
			return "Orc";
		}
		else if (f.getType() == this.Const.FactionType.Goblins)
		{
		    this.m.IsGoblinDone = true;
			return "Goblin";
		}
        return "Orc";
	}

	function onClear()
	{
		this.m.Dude = null;
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU32(this.m.LastCombatID);
		_out.writeBool(this.m.IsOrcDone);
		_out.writeBool(this.m.IsGoblinDone);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 54)
		{
			this.m.LastCombatID = _in.readU32();
			this.m.IsOrcDone = _in.readBool();
			this.m.IsGoblinDone = _in.readBool();
		}
	}

});

