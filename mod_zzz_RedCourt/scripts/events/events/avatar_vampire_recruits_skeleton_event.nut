this.avatar_vampire_recruits_skeleton_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.avatar_vampire_recruits_skeleton";
		this.m.Title = "Вблизи монолита";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({ //-
			ID = "A",
			Text = "[img]gfx/ui/events/event_73.png[/img]Вы снова очутились у Чёрного монолита, где остатки вашего рода столпились вокруг артефакта, как нищие у открытого огня. Вы не знаете, почему вернулись сюда - возможно, остатки дома всё ещё слишком сильны, чтобы долго находиться вдали от него. Неподалеку собиралась толпа и кружит вокруг ямы, крошечные чёрные фигуры на фоне тёмных мазков большого кратера. Монолит мягко гудит, а вы тем временем замечаете знакомое лицо со скелетом в лохмотьях на привязи.%SPEECH_ON%Рад, что ты вернулся, я уже позабыл, когда видел тебя тут в последний раз.%SPEECH_OFF%Вильгельм улыбнулся своими кривыми клыками, прекрасно зная, что вы не посмеете ударить посланника Императора.%SPEECH_ON%Он внимательно наблюдал за тобой и сжалился над твоим благородным делом, притом настолько, что предоставил одного из своих лучших и самых верных подданных!%SPEECH_OFF%Легионер скрипел под тяжестью доспехов. - его обесцвеченные кости выглядели абсолютно не примечательно, пока он молча стоял в ожидании. Когда вы пристально вглядывались в его пустые глазницы, в них что-то шевельнулось, что-то, что заставило вас и его почувствовать краткую связь.%SPEECH_ON%Наши повелители считают, что хотя ты и заслужил дополнительную помощь, твой прогресс до сих пор не заслуживает ничего сверх этого. Ты можешь взять его или оставить мне, для меня это не имеет никакого значения.%SPEECH_OFF%",
			Image = "", 
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ладно, я стерплю это оскорбление. Отдай его мне",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}
				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.getFlags().add("PlayerSkeleton");
				_event.m.Dude.getFlags().add("undead");
				_event.m.Dude.getFlags().add("skeleton");
				_event.m.Dude.setStartValuesEx([
					"hemovore_praetorian_background"
				]);
				_event.m.Dude.getSkills().add(this.new("scripts/skills/racial/skeleton_racial"));
		        ::TheRedCourt.AddRedCourtTalents(_event.m.Dude);

				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{

		if (this.World.Assets.getOrigin().getID() != "scenario.hemovores_avatar") //only happens with this origin
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();
		local locations = this.World.EntityManager.getLocations();
		local nearSite = false;

		foreach( v in locations )
		{
			if (v.getTypeID() == "location.black_monolith" && v.getTile().getDistanceTo(currentTile) < 5)
			{
				nearSite = true;
				break;
			}
		}

		if (!nearSite)
		{
			return;
		}

		this.m.Score = 25;
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

