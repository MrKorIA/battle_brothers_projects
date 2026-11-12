// Событие-вестник: посланники короля варваров открывают на карте легендарную локацию
// «Гнездо Рогатой Крысы». Образец — zmod_davkul_rising-russian/scripts/events/events/
// cultists_location_uncovered_event.nut.
this.rat_god_camp_uncovered_event <- this.inherit("scripts/events/event", {
	m = {
		Location = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.rat_god_camp_uncovered";
		this.m.Title = "По дороге...";
		this.m.Cooldown = 99999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_108.png[/img]Маршируя с отрядом по северному тракту, вы замечаете на гребне холма несколько тёмных фигур, пристально следящих за вашей колонной. Несколько мгновений они стоят неподвижно на пронизывающем ветру, а затем тяжёлой, уверенной поступью спускаются к дороге. Это варвары — мощные, звериного вида воины в мехах, но без оружия в руках. Их предводитель, здоровяк со шрамом через всю щёку, останавливается в трёх шагах от вас и обращается с суровым приветствием.%SPEECH_ON%Король севера шлёт тебе слово, вождь наёмников. Наши племена по древнему обычаю держатся в стороне от дел ваших каменных городов, но теперь чёрная беда коснулась и наших очагов — и потому король приказал отыскать тебя. Часть наших родичей отвернулась от предков: их разум отравила гнилая проповедь подземного бога, которого твари зовут Рогатой Крысой. Сперва они просто ушли из общин, а теперь и вовсе сбиваются в стаи у крысиных нор — там мерзкие тварюги принимают отступников как братьев и щедро одаривают их доспехами из проклятого зелёного камня.%SPEECH_OFF%\n\nВарвар кивает своему спутнику, и тот бросает к вашим ногам свёрнутую шкуру с обгоревшими краями.%SPEECH_ON%На ней выжжено место их великого сборища. Там сейчас сбились в кучу и наши отрёкшиеся, и орды крысолюдов, и само рогатое чудовище, что именует себя богом. Они собирают силу для похода — похода на всех нас. Пока войско не собралось, его можно разбить. Король говорит: ты умеешь убивать таких тварей. Убей их — и варвары запомнят твоё имя. Если хочешь, я пойду с тобой и покажу дорогу..%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Мне пригодится проводник, умеющий держать топор.",
					function getResult( _event )
					{
						return "B";
					}
				},
				{
					Text = "Спасибо за весть. Дальше мы справимся сами.",
					function getResult( _event )
					{
						_event.uncoverLocation();
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
				_event.m.Dude.getBackground().m.RawDescription = "Посланник короля варваров, %name%, привёл отряд к Гнезду Рогатой Крысы и остался сражаться с бывшими соплеменниками, отрёкшимися от людей.";
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
						_event.uncoverLocation();
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
		local camp = this.findCamp();

		if (camp == null || camp.isDiscovered())
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days < 80)
		{
			return;
		}

		if (this.World.State.getEscortedEntity() != null)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
		this.m.Location = this.findCamp();
	}

	function onClear()
	{
		this.m.Location = null;
		this.m.Dude = null;
	}

	function findCamp()
	{
		foreach (location in this.World.EntityManager.getLocations())
		{
			if (location.getTypeID() == "location.rat_god_camp")
			{
				return location;
			}
		}

		return null;
	}

});
