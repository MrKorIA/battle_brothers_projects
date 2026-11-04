this.cultists_location_uncovered_event <- this.inherit("scripts/events/event", {
	m = {
		Location = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.cultists_location_uncovered";
		this.m.Title = "По дороге...";
		this.m.Cooldown = 99999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_108.png[/img]Маршируя с отрядом по дороге вы вдруг осознали, что мир вокруг вас стал куда тише. Несколькими жестами вы приказываете отряду остановиться и приготовиться к возможной засаде. Несколько мгновений растягиваются длиною в вечность, пока вы ожидаете града стрел из-за деревьев и кустарников, однако раздавшийся громкий смех из-за огромного придорожного куста вводит вас в полное недоумение. Спустя секунду на дороге появляется отряд варваров. Их предводитель - крепко сложенный, татуированный воин - выступает вперёд и обращается к вам.%SPEECH_ON%Король севера шлёт вам своё приветствие, друзья. Шаман сказал, что древние боги недовольны пробуждением зла на этих землях, а потому нам поручили найти вас. Король верит, что если мы объединимся, то силы зла не смогут выстоять перед нашим натиском. Потому что если не мы, то никто не сделает этого. Ваши жалкие дворяне грызутся между собой по пустякам, не замечая великую беду, что подобно туче накрывает наши земли.%SPEECH_OFF%Воитель делает движение рукой и стоящий подле него невольник протягивает ему свиток, который варвар передаёт вам.%SPEECH_ON%Шаману во сне пришло видение, что тьма сгустилась слишком сильно и вот-вот прорвётся в наш мир. Он нарисовал эту карту и отправил нас в помощь вам. Король надеется на ваше благоразумие и что вы поможете нам в истреблении этих фанатиков. Если вы согласны, я с радостью вступлю в ваши ряды, чтобы приблизить победу добра над злом.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
					{
						Text = "Если ты готов выполнять приказы от алчущих крон, то присоединяйся к нам.",
						function getResult( _event )
						{
							return "B"
						}
					},	

					{
						Text = "Спасибо, но у нас всё в порядке и без тебя.",
						function getResult( _event )
						{
												
							_event.uncoverLocation()

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
					"barbarian_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Известный на севере воин, %name%, был послан королём варваров, чтобы помочь вам уничтожить угрозу культистов.";
				_event.m.Dude.getBackground().buildDescription(true);
				
				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}
				
				this.Characters.push(_event.m.Dude.getImagePath());
			}
			
		});
	        this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_139.png[/img]{Вы наблюдаете, как воин передаёт зловещего вида тесак одному из своих товарищей. Взамен вы даёте ему обычное оружие и одобрительно киваете головой, видя, что он держит его с лёгкостью, явно подкреплённой опытом.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Добро пожаловать в отряд '%companyname%'!",
					function getResult( _event )
					{
						_event.uncoverLocation()
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
			}
		});
	}
	function uncoverLocation()
	{
							
		this.World.uncoverFogOfWar(this.m.Location.getTile().Pos, 700.0);
		this.m.Location.getFlags().set("IsEventLocation", true);
		this.m.Location.setDiscovered(true);
		this.World.getCamera().moveTo(this.m.Location);
					
	}
	function onUpdateScore()
	{
		local cultists;
		foreach (location in this.World.EntityManager.getLocations()){
			if (location.getTypeID() == "location.cultist_legendary_camp"){
				cultists = location
				break;
			}
		}
		if (cultists == null || cultists.isDiscovered()) return
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days < 100)
		{
			return;
		}
		
		if (this.World.State.getEscortedEntity() != null)
		{
			return;
		}
		this.m.Score = 10

	}

	function onPrepare()
	{
		foreach (location in this.World.EntityManager.getLocations()){
			if (location.getTypeID() == "location.cultist_legendary_camp"){
				this.m.Location = location
				break;
			}
		}
		
	}

	function onClear()
	{
		this.m.Location = null;
		this.m.Dude = null;
	}

});

