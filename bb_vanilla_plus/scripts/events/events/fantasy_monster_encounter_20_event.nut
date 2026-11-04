this.fantasy_monster_encounter_20_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight1 = null,
		Mname = ""
	},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_20_event";
		this.m.Title = "Неожиданное событие...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]{Вы и несколько ваших товарищей сидели в таверне в повседневной одежде, когда услышали, как {сельский житель | бродяга | драчун | пьяница} за соседним столом упомянул название вашей наемнической группы.%SPEECH_ON%%companyname%? Что за {дерьмовое название | отребье}? Когда речь заходит о настоящих наемнических отрядах, то это, конечно же, %mname%!%SPEECH_OFF%Вы не собирались реагировать на такие пустые сплетни, но %hedgeknight1%, который всегда быстро выходит из себя, и на этот раз не смог сдержаться.%SPEECH_ON%{Эй, если будешь продолжать болтать свой чертов рот, то будешь просить, чтобы тебе врезали по лицу. Понял? | Продолжай так болтать, и окажешься лицом в грязи. | Чёрт возьми, ты что, хочешь, чтобы тебя ударили?}%SPEECH_OFF%В мгновение ока началась драка. К счастью, никто не погиб и это не привело к каким-либо серьезным проблемам, но ты устал от таких неожиданных ситуаций.}",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Черт, дайте мне просто спокойно отдохнуть.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					local injury = _event.m.HedgeKnight1.addInjury(this.Const.Injury.Brawl);
					this.List = [
						{
							id = 10,
							icon = injury.getIcon(),
							text = _event.m.HedgeKnight1.getName() + " страдает от " + injury.getNameOnly()
						}
					];
				}
				if (this.Math.rand(1, 100) <= 75)
				{
					local xxmoney = this.Math.rand(5, 500);
					this.World.Assets.addMoney(xxmoney);
					this.List.push({
						id = 11,
						icon = "ui/items/supplies/money.png",
						text = "Вы получаете " + xxmoney + " золота"
					});
				}
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
			}
		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 10)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();
		local nearTown = false;
		local towns = this.World.EntityManager.getSettlements();
		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 3)
			{
				nearTown = true;
				break;
			}
		}
		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.killer_on_the_run" || bro.getBackground().getID() == "background.thief" 
			|| bro.getBackground().getID() == "background.graverobber" || bro.getBackground().getID() == "background.raider" 
			|| bro.getBackground().getID() == "background.wildman" || bro.getBackground().getID() == "background.barbarian" 
			|| bro.getBackground().getID() == "background.brawler" || bro.getBackground().getID() == "background.nomad" 
			|| bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute") 
			|| bro.getBackground().getID() == "background.gambler")
			{
				candidates.push(bro);
			}
		}
		if (candidates.len() == 0)
		{
			return;
		}
		this.m.HedgeKnight1 = candidates[this.Math.rand(0, candidates.len() - 1)];
		local mname = this.Const.Strings.MercenaryCompanyNames;
		mname.push("Чёртовы Псы");
        mname.push("Боевые Свиньи");
        mname.push("Кровавый Ворон");
        mname.push("Отряд Сокола");
        mname.push("Стальные Волки");
        mname.push("Львиная Рота");
        mname.push("Отряд Химеры");
        mname.push("Кровавый Союз");
        mname.push("Гильдия Свободных Торговцев");
		this.m.Mname = mname[this.Math.rand(0, mname.len() - 1)];
		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hedgeknight1",
			this.m.HedgeKnight1.getName()
		]);
		_vars.push([
			"mname",
			this.m.Mname
		]);
	}

	function onClear()
	{
		this.m.HedgeKnight1 = null;
		this.m.Mname = null;
	}

});

