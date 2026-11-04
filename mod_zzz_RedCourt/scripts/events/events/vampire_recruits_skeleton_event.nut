this.vampire_recruits_skeleton_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.vampire_recruits_skeleton";
		this.m.Title = "Эхо прошлого";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({ //-
			ID = "A",
			Text = "[img]gfx/ui/events/event_73.png[/img]После долгого времени вы оказываетесь дома. Небо кружится и корчится от боли над монолитом, а на дне ямы проносятся вытянутые фигуры. Изредка из подземных пещер появляется разведывательный отряд легионеров, марширующих строевым шагом, или кровососы кружатся и вращаются в небе, устраиваясь на более высоких частях строительных лесов под нависшей тенью монолита. Вам здесь не рады, но пока что вы должны слиться с толпой.\n\nИз-за ближайшего кургана с разрушенным ландшафтом из тени деревьев появляется одетая в одни лохмотья фигура, облаченная в потрёпанные доспехи и с расколотым оружием. По мере того, как сокращается расстояние, вам становится ясно: это был, или, скорее, всё ещё остается, легионер, который, похоже, принял вас за своего офицера. Пустые глазницы тупо смотрят на вас, исследуя ваш разум в поисках признания, как бездомная собака ищет привязанности.\nКости воина испещрены вмятинами, порезами, переломами и другими повреждениями - непонятно, что привело его к такому состоянию, возможно он получил их по дороге. Кто бы это ни был, вы уверены, что сможете придумать ему подходящее имя и место в вашей банде неудачников.",
			Image = "",
			List = [],
			Characters = [], 
			Options = [
				{
					Text = "Давай подберём тебе какое-нибудь хорошее имя...",
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
		if (this.World.Assets.getOrigin().getID() != "scenario.hemovores") //only happens with this origin
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

