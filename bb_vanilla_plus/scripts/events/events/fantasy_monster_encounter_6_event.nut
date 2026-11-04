this.fantasy_monster_encounter_6_event <- this.inherit("scripts/events/event", {
	m = {
		Champion = null
	},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_6_event";
		this.m.Title = "По пути...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Ваш отряд наткнулся на небольшую хижину, расположенную в уединенном месте. Интерьер хижины был старым и запыленным, обмотанным паутиной и заполненным чучелами различных растений и животных. Исследуя дом, вы нашли скелет, лежащий на кровати. Вероятно, это был владелец хижины. Рядом с ним лежал неизвестный флакон с лекарством и лист бумаги, который оказался написанной им запиской.%SPEECH_ON% Я посвятил свою жизнь поиску способа выйти за пределы слабого человеческого тела. Препарируя и экспериментируя с различными растениями и животными, я наконец добыл эссенцию, которая могла бы превратить человека в существо, находящееся за пределами тела. Однако зелье оказалось слишком токсичным для употребления человеком. Если его выдержать несколько веков, его токсичность уменьшится. Надеюсь, кто-то осуществит мою давнюю мечту и станет свидетелем его действия.%SPEECH_OFF%Вы пытались не обращать внимания на абсурдное содержание записки, но один из ваших спутников уже поднял бутылку с зельем, готовый употребить ее содержимое.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Позвольте %chosen% выпить это зелье",
					function getResult( _event )
					{
						return "B";
					}
				},
				{
					Text = "Прекрати, %chosen%!",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Champion.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_115.png[/img]{%SPEECH_ON%Ааа! Я чувствую, что мое тело горит, спасите меня!%SPEECH_OFF% %chosen% некоторое время корчился в агонии, стонал, пока в конце концов не потерял сознание. Вы подумали, что он умер, но он еще дышал. Через некоторое время %chosen% пришел в себя. Он утверждал, что в его теле произошли большие изменения. На самом деле его тело претерпело гротескные преобразования. Если бы он посмотрел в зеркало, то был бы шокирован.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Тебе повезло, что ты еще жив.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				local actor = _event.m.Champion;
				local body = actor.getSprite("body");
				local head = actor.getSprite("head");
				local tattoo_head = actor.getSprite("tattoo_head");
				if (this.Math.rand(1, 2) == 2)
				{
					body.Saturation = 0.5;
					body.varySaturation(0.2);
					body.Color = this.createColor("#c1ddaa");
					body.varyColor(0.05, 0.05, 0.05);
					head.Saturation = body.Saturation;
					head.Color = body.Color;
					tattoo_head.setBrush("zombify_0" + this.Math.rand(1, 4));
					tattoo_head.setBrightness(0.9);
				}
				else
				{
					body.Saturation = 0.5;
					body.varySaturation(0.2);
					body.Color = this.createColor("#ddd2aa");
					body.varyColor(0.05, 0.05, 0.05);
					head.Saturation = body.Saturation;
					head.Color = body.Color;
					tattoo_head.setBrush("bust_skeleton_face_0" + this.Math.rand(1, 6));
					tattoo_head.setBrightness(0.9);
				}
				local r = this.Math.rand(1, 4);
				if (r == 1)
				{
					r = 7;
					_event.m.Champion.getBaseProperties().MeleeSkill += r;
					_event.m.Champion.getBaseProperties().RangedSkill += r;
					_event.m.Champion.getBaseProperties().MeleeDefense += r;
					_event.m.Champion.getBaseProperties().RangedDefense += r;
					_event.m.Champion.getBaseProperties().Hitpoints += r;
					_event.m.Champion.getBaseProperties().Stamina += r;
					_event.m.Champion.getBaseProperties().Initiative += r;
					_event.m.Champion.getBaseProperties().Bravery += r;
				}
				else if (r == 2)
				{
					r = 5;
					_event.m.Champion.getBaseProperties().MeleeSkill = r;
					_event.m.Champion.getBaseProperties().RangedSkill = r;
					_event.m.Champion.getBaseProperties().MeleeDefense = r;
					_event.m.Champion.getBaseProperties().RangedDefense = r;
					_event.m.Champion.getBaseProperties().Hitpoints = r;
					_event.m.Champion.getBaseProperties().Stamina = r;
					_event.m.Champion.getBaseProperties().Initiative = r;
					_event.m.Champion.getBaseProperties().Bravery = r;
				}
				else
				{
					_event.m.Champion.getBaseProperties().Hitpoints += 10;
					_event.m.Champion.getBaseProperties().Stamina += 10;
				}
				_event.m.Champion.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/special.png",
					text = "Изменения произошли в теле" + _event.m.Champion.getName() + "а!"
				});
				this.Characters.push(_event.m.Champion.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Вам удалось удержать %chosen% от выпивания зелья, но оно выскользнуло у него из рук и разбилось о пол. Место, где упало зелье, испускало пары, как будто оно было растворено в соляной кислоте, оставляя глубокую выеденную коррозией выемку.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ты только что был в мгновении от смерти, идиот!",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Champion.getImagePath());
			}
		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 100)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkill("trait.player"))
			{
				candidates.push(bro);
			}
		}
		if (candidates.len() > 0)
		{
			this.m.Champion = candidates[this.Math.rand(0, candidates.len() - 1)];
		}
		else
		{
			return;
		}
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"chosen",
			this.m.Champion != null ? this.m.Champion.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Champion = null;
	}

});

