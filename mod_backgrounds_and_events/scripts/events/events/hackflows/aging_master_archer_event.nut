this.aging_master_archer_event <- this.inherit("scripts/events/event", {
	m = {
		Master_Archer = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_aging_master_archer";
		this.m.Title = "По пути...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img][M] Вы выходите на поляну, где %master_archer% сгорбившись сидит на пне, небрежно перебросив лук через плечо. Наёмник, прищурившись, вглядывается в туманную даль, с гнетущей медлительностью сжимая и разжимая пальцы вытянутых рук. Кажется, его невидящий взор устремлён вовсе не на земную цель, а на призрачные тени давно минувших дней - на ускользающую награду, ценность которой осознаёшь лишь тогда, когда она становится недосягаемой. %master_archer% закрывает глаза и тяжело вздыхает. Он подносит мозолистую левую ладонь к векам, мягко массируя их.\n\n%SPEECH_ON%Мне даже не нужно смотреть, чтобы почуять ваш взгляд, капитан. По крайней мере, это чутьё меня пока ещё не покинуло.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Как ты?",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Master_Archer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_17.png[/img][M] %master_archer% медленно поворачивается к вам. %SPEECH_ON%Человек и зверь не так уж и отличаются. Мы рождаемся в этом мире, живём свои короткие жизни и, через некоторое время, обращаемся в прах.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ты не ответил на мой вопрос.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Master_Archer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_17.png[/img][M] Мужчина продолжает. %SPEECH_ON%Ты никогда не задумывался, каким зверем ты родился бы, не будь ты человеком, капитан?%SPEECH_OFF%%master_archer% не ждёт вашего ответа. %SPEECH_ON%В молодости я всегда представлял себя орлом. Парить в небе, простирая крылья и тень над всем, имея возможность поразить любую цель с полной безнаказанностью...%SPEECH_OFF%На его лице мелькает тень улыбки, прежде чем уголки рта снова опускаются вниз. %SPEECH_ON%В этом-то и проблема. Я лучник, и я старею. Моё зрение уже точно не то, что раньше. А слепой лучник - как орёл без крыльев. Совершенно бесполезен.%SPEECH_OFF%Он вздыхает. %SPEECH_ON%Впрочем, я справлюсь. По крайней мере, я стою не в первом ряду. Пускай вдали всё плывёт, но тех подонков, которых я ещё способен РАЗГЛЯДЕТЬ, всё равно ждёт скорая и очень паршивая смерть.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Время не стоит на месте.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Master_Archer.getImagePath());
				local old_trait = this.new("scripts/skills/traits/old_trait");
				_event.m.Master_Archer.getSkills().add(old_trait);
				_event.m.Master_Archer.setHitpoints(this.Math.min(_event.m.Master_Archer.getHitpoints(), _event.m.Master_Archer.getHitpointsMax()));
				this.List = [
					{
						id = 13,
						icon = old_trait.getIcon(),
						text = _event.m.Master_Archer.getName() + " постарел"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 9
				&& bro.getBackground().getID() == "background.hackflows_master_archer"
				&& !bro.getSkills().hasSkill("trait.old")
				&& !bro.getFlags().has("IsRejuvinated"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Master_Archer = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = this.m.Master_Archer.getLevel() - 5;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"master_archer",
			this.m.Master_Archer.getName()
		]);
	}

	function onClear()
	{
		this.m.Master_Archer = null;
	}

});

