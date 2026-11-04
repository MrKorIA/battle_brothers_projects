this.ret_gladiator_fan_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
	},
	function create()
	{
		this.m.ID = "event.ret_gladiator_fan";
		this.m.Title = "Ещё один поклонник...";
		this.m.Cooldown = 26.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_76.png[/img]Во время путешествия вы заметили, человека, следующего за вами в отдалении - гораздо дольше, чем вам бы хотелось. В недавно посещённом городе он то появлялся в поле зрения, то исчезал, да и вообще уже долго следует за вами. Вы присаживаетесь чтобы немного отдохнуть.%SPEECH_ON%Можешь выйти, я не кусаюсь!%SPEECH_OFF%Сбоку появляется человек, медленно приближающаяся к вам, словно ребёнок подкрадывающийся к умирающему животному. Он не делает резких движений, лишь неотрывно смотрит на вас.%SPEECH_ON%Слава Златоликому, это действительно ты... наконец-то, я нашёл тебя!%SPEECH_OFF%Вы готовитесь к худшему. Вы уже встречали нескольких поклонников, но ни один из них не согласился бы проделать столь долгий путь.\nНезнакомец продолжает.%SPEECH_ON%Могу ли я последовать за тобой? Я обещаю, что не буду мешать и сделаю всё, о чем ты меня попросишь.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Держись рядом и не отставай.",
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

			function start( _event ) // no alchemist. //1 = least likely to generate. //// 1 = high tier melee fighter. // 2 = mid & high tier specialists. // 3 = midtier fighters. // 4 = lowtier.
			{
				local backgrounds = [
					// high tier melee fighter
					[1,	"gladiator_background"],
					// mid & high tier specialists
					[2, "assassin_southern_background"],
//					[2, "legend_muladi_background"],
					// midtier fighters
					[3, "nomad_background"],
					[3, "nomad_ranged_background"],
					[3, "caravan_hand_southern_background"],
					// lowtier
					[4, "belly_dancer_background"],
					[4, "legend_qiyan_background"],
					[4, "thief_southern_background"],
					[4, "slave_southern_background"],
					[4, "peddler_southern_background"]		
				];
				if (::mods_getRegisteredMod("mod_backgrounds_and_events") != null)
				{
                    backgrounds.extend([
                        [1, "hackflows/bodyguard_southern_background"],
                        [1, "hackflows/master_southern_archer_background"],
                        [2, "hackflows/bounty_hunter_southern_background"],
                        [3, "hackflows/myrmidon_southern_background"],
                        [4, "hackflows/cobbler_southern_background"],
                        [4, "hackflows/herbalist_southern_background"],
                        [4, "hackflows/cook_southern_background"]
                    ]);
				}
				local totalWeight = 0;
				local result = [];
				foreach (background in backgrounds)
				{
				    totalWeight += background[0];
				}
				local r = this.Math.rand(0, totalWeight);
				foreach (background in backgrounds)
				{
				    r = r - background[0];
				    if (r <= 0)
				    {
				       result.push(background[1])
				      break;
				    }
				}
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				//_event.m.Dude.setStartValuesEx([
				_event.m.Dude.setStartValuesEx(result);
				_event.m.Dude.getBackground().m.RawDescription = "{%name%, подобно прочим южанам, рассказывает о цепях, песке, золоте и крови. | До сих пор %name% вёл скучную жизнь, испорченную праведными делами. | Услышав о вашем возвращении и восхождении к славе, он захотел сражаться бок о бок со 'странствующим гладиатором', исполнив наконец мечту, появившуюся ещё в детстве, когда он увидел вас на арене. | %name% и его лицо кажутся вам знакомым - хотя с годами все лица начинают сливаться в одно.} {Родившись в одном из отдалённых уголков южных земель, он присоединился к своему племени в нелёгком деле разбоя, как только стал в силах держать в руках копьё. Но однажды удача обошла их племя стороной, и всё закончилось резнёй, устроенной вражеским отрядом кочевников. Потерянный и одинокий %name% сбежал и жил в уединении до тех пор, пока не появились вы. | %name% хвастается тем, что является внебрачным отпрыском самого визиря... а может, другого знаменитого гладиатора? История меняется с каждом следующим рассказом. | С самого детства %name% был нарушителем спокойствия, он постоянно воровал, продавал и торговался - лишь бы заплатить за вход на арену. Он говорит, что наблюдать за вами в ранние годы было незабываемым зрелищем, но теперь он гораздо счастливее, обретя бесплатное место в первом ряду на сражения с одним из величайших воинов юга. | %name% когда-то был рабом, которого должны были продать на север как мишень для обучения воинов благородного дома, возжелавших получше обучить своих новобранцев - и решивших, что лучше всего для обучения подойдут убийства беззащитных рабов. | %name% когда-то был верным слугой визиря, внимая всем его нуждам. Однажды его использовали в качестве приманки для неудачного покушения.} {Вы клянётесь, что видели его раньше - быть может, в тюремных камерах, в которых провели немало времени? | %name% имеет следы от кандалов на руках и ногах, а тело его покрыто шрамами от ударов кнута. Изредка он бормочет что-то о козе и масле, когда вы находитесь вне пределов слышимости. | Сейчас %name% живёт остатками своей прежней жизни. Быть может, доверить свою жизнь вам было для него последним шансом выжить? | Преследуемый и осрамлённый, долго %name% искал вас, чтобы попытаться возродить подобие жизни, коей должно жить...}";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getSkills().add(this.new("scripts/skills/perks/perk_retglad_path"));
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.ret_gladiator")
		{
			return;
		}

		this.m.Score = 6;
	}

	// function onBuildPerkTree( _background )
	// {		
	// 	this.addScenarioPerk(_background, this.Const.Perks.PerkDefs.RetGladMentor);
	// }

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

