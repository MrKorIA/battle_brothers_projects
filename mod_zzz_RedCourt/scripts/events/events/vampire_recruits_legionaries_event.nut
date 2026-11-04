this.vampire_recruits_legionaries_event <- this.inherit("scripts/events/event", {
	m = {
		Boner1 = null
		Boner2 = null
		Boner3 = null
		Boner4 = null
		Boner5 = null
		Boner6 = null
	},
	function create()
	{
		this.m.ID = "event.vampire_recruits_legionaries";
		this.m.Title = "Забытый отряд";
		this.m.Cooldown = 85.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({ //-
			ID = "A",
			Text = "[img]gfx/ui/events/event_73.png[/img]К вам приближается небольшой отряд бойцов, явно измотанных множеством боёв и самой погодой. Слабый гул проникает в сознание, но в нынешнем состоянии вы не можете понять их намерения, пока не проходит несколько неловких минут.\n\nПохоже, эта группа, или то, что от неё осталось, потеряла своего командира. Более того — они приняли вас за своего пропавшего командира. Хотя общение работает только в одну сторону, троица, похоже, намерена следовать вашим приказам...",
			Image = "", 
			List = [],
			Characters = [],
			Options = [
				{ //take all (3)
					Text = "Я возьму вас всех — нужна любая помощь...",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Boner1);
						this.World.getPlayerRoster().add(_event.m.Boner2);
						this.World.getPlayerRoster().add(_event.m.Boner3);
						this.World.getTemporaryRoster().clear();
						_event.m.Boner1.onHired();
						_event.m.Boner2.onHired();
						_event.m.Boner3.onHired();
						// return "A";
						return 0;
					}
				},
				{ //take 2
					Text = "Есть место только для двух бойцов, третий пусть ищет удачи в другом месте.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Boner1);
						this.World.getPlayerRoster().add(_event.m.Boner2);
						this.World.getTemporaryRoster().clear();
						_event.m.Boner5.onHired();
						_event.m.Boner6.onHired();
						// return "B";
						return 0;
					}
				},
				{ //take 1
					Text = "Слабым здесь не место, лучший из вас выходит вперёд — остальные двое могут идти.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Boner4);
						this.World.getTemporaryRoster().clear();
						// _event.m.Boner4.onHired();
						return "C";
					}
				},
				{ //skip
					Text = "Сейчас бойцы не нужны.",
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
				//bro 1
				_event.m.Boner1 = roster.create("scripts/entity/tactical/player");
				_event.m.Boner1.getFlags().add("PlayerSkeleton");
				_event.m.Boner1.getFlags().add("undead");
				_event.m.Boner1.getFlags().add("skeleton");
				_event.m.Boner1.setStartValuesEx([
					"legend_legion_legionary_background"
				]);
				_event.m.Boner1.getSkills().add(this.new("scripts/skills/racial/skeleton_racial"));
				_event.m.Boner1.getSkills().add(this.new("scripts/skills/perks/perk_vampire_maintenance"));
				this.Characters.push(_event.m.Boner1.getImagePath());

				//bro 2
				_event.m.Boner2 = roster.create("scripts/entity/tactical/player");
				_event.m.Boner2.getFlags().add("PlayerSkeleton");
				_event.m.Boner2.getFlags().add("undead");
				_event.m.Boner2.getFlags().add("skeleton");
				_event.m.Boner2.setStartValuesEx([
					"legend_legion_legionary_background"
				]);
				_event.m.Boner2.getSkills().add(this.new("scripts/skills/racial/skeleton_racial"));
				_event.m.Boner2.getSkills().add(this.new("scripts/skills/perks/perk_vampire_maintenance"));

				//bro 3
				_event.m.Boner3 = roster.create("scripts/entity/tactical/player");
				_event.m.Boner3.getFlags().add("PlayerSkeleton");
				_event.m.Boner3.getFlags().add("undead");
				_event.m.Boner3.getFlags().add("skeleton");
				_event.m.Boner3.setStartValuesEx([
					"legend_legion_legionary_background"
				]);
				_event.m.Boner3.getSkills().add(this.new("scripts/skills/racial/skeleton_racial"));
				_event.m.Boner3.getSkills().add(this.new("scripts/skills/perks/perk_vampire_maintenance"));

				//bro 5 (late edition)
				_event.m.Boner5 = roster.create("scripts/entity/tactical/player");
				_event.m.Boner5.getFlags().add("PlayerSkeleton");
				_event.m.Boner5.getFlags().add("undead");
				_event.m.Boner5.getFlags().add("skeleton");
				_event.m.Boner5.setStartValuesEx([
					"legend_legion_gladiator_background"
				]);
				_event.m.Boner5.getSkills().add(this.new("scripts/skills/racial/skeleton_racial"));
				_event.m.Boner5.getSkills().add(this.new("scripts/skills/perks/perk_vampire_maintenance"));

				//bro 6 (late edition)
				_event.m.Boner6 = roster.create("scripts/entity/tactical/player");
				_event.m.Boner6.getFlags().add("PlayerSkeleton");
				_event.m.Boner6.getFlags().add("undead");
				_event.m.Boner6.getFlags().add("skeleton");
				_event.m.Boner6.setStartValuesEx([
					"legend_legion_gladiator_background"
				]);
				_event.m.Boner6.getSkills().add(this.new("scripts/skills/racial/skeleton_racial"));
				_event.m.Boner6.getSkills().add(this.new("scripts/skills/perks/perk_vampire_maintenance"));
			}
		});

		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_46.png[/img]Без малейшего колебания боец, стоящий дальше всех, выхватывает оружие с такой отточенной скоростью, что остальные двое, несмотря на отсутствие черт лица, реагируют с ужасом. Дальний боец разбивает черепа двух более слабых претендентов, пока те возятся с оружием, несколькими простыми прагматичными ударами.\n\nОн пристально смотрят на вас.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "В следующий раз мне стоит следить за словами...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				//bro 4 - hidden until player specifically picks it
				local roster = this.World.getTemporaryRoster();
				_event.m.Boner4 = roster.create("scripts/entity/tactical/player");
				_event.m.Boner4.getFlags().add("PlayerSkeleton");
				_event.m.Boner4.getFlags().add("undead");
				_event.m.Boner4.getFlags().add("skeleton");
				_event.m.Boner4.setStartValuesEx([
					"legend_legion_honour_guard_background"
				]);
				_event.m.Boner4.getSkills().add(this.new("scripts/skills/racial/skeleton_racial"));
				_event.m.Boner4.getSkills().add(this.new("scripts/skills/perks/perk_vampire_maintenance"));
				_event.m.Boner4.getSprite("miniboss").setBrush("bust_miniboss");
				_event.m.Boner4.getBaseProperties().Hitpoints += 5;
				_event.m.Boner4.getBaseProperties().Bravery += 10;
				_event.m.Boner4.getBaseProperties().Stamina += 7;
				_event.m.Boner4.getBaseProperties().MeleeSkill += 14;
				_event.m.Boner4.getBaseProperties().RangedSkill += 0;
				_event.m.Boner4.getBaseProperties().MeleeDefense += 5;
				_event.m.Boner4.getBaseProperties().RangedDefense += 5;
				_event.m.Boner4.getBaseProperties().Initiative += 8;
				_event.m.Boner4.onHired();
			}
		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() != "scenario.hemovores_avatar" && this.World.Assets.getOrigin().getID() != "scenario.hemovores") //only happens with these origins.
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		if (this.World.getPlayerRoster().getSize() + 3 >= this.World.Assets.getBrothersMax()) //checks for 3 slots empty in roster
		{
			return;
		}

		this.m.Score = 7;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Boner1 = null;
		this.m.Boner2 = null;
		this.m.Boner3 = null;
		this.m.Boner4 = null;
		this.m.Boner5 = null;
		this.m.Boner6 = null;
	}

});

