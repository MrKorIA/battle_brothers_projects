// Амбиция победы над кризисом «Нашествие Железной Орды» (TZ §8).
// Образец — data_014/scripts/ambitions/ambitions/defeat_undead_ambition.nut.
// Успех — ванильная концовка кризиса: сила GreaterEvil <= 0, Type сброшен в Random,
// LastType == Horde (тот же предикат, что у ванильных амбиций победы над кризисами).
this.defeat_horde_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_horde";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Чурчжэни и степняки Мгл объединились под знамёнами Железной Орды, сжигая поселения и угоняя людей в полон.\nМы должны сломить эту орду, пока она не стёрла человеческий мир с лица земли!";
		this.m.UIText = "Сломить Железную Орду";
		this.m.TooltipText = "Остановите нашествие Железной Орды! Каждый выполненный контракт против орды и каждый разрушенный её лагерь ослабят натиск врага.";
		this.m.SuccessText = "[img]gfx/ui/events/event_73.png[/img]Орда пришла с востока, как приходит пожар — сначала дым на горизонте, потом пепел на родных полях. Чурчжэни в железных ламеллярах, степняки Мгл с дальнобойными луками, обозы с чёрным порохом. Говорили, что такого не видели со времён Битвы Тысячи Имён, и весь человеческий мир приготовился к худшему. Но один наёмный отряд решил иначе.%SPEECH_ON%Железные всадники, пороховые обозы, полчища степняков — а мы всё стоим. Во имя древних богов, я думал, что писать об этом будут летописцы, а не мы сами!%SPEECH_OFF%Восклицает %bravest_brother%, вздымая на всеобщее обозрение изрядно истрёпанное знамя отряда.%SPEECH_ON%Отряд \'%companyname%\' сломил Железную Орду! Пусть теперь каждый, кто сомневался, сосёт свой меч!%SPEECH_OFF%И в самом деле — орда расколота, лагеря её сожжены, и степь снова принадлежит лишь ветру. Кто теперь посмеет противостоять вам?";
		this.m.SuccessButtonText = "Человеческий мир уцелел. Пока что.";
	}

	function getUIText()
	{
		local f = this.World.FactionManager.getGreaterEvil().Strength / this.Const.Factions.GreaterEvilStartStrength;
		local text;

		if (f >= 0.95)
		{
			text = "проигрыш";
		}
		else if (f >= 0.5)
		{
			text = "на равных";
		}
		else if (f >= 0.25)
		{
			text = "превосходство";
		}
		else
		{
			text = "победа";
		}

		return this.m.UIText + " (" + text + ")";
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isHordeInvasion())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 1500)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onCheckSuccess()
	{
		if (this.World.FactionManager.getGreaterEvil().Type == 0 && this.World.FactionManager.getGreaterEvil().LastType == this.Const.World.GreaterEvilType.Horde)
		{
			return true;
		}

		this.World.Ambitions.updateUI();
		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});
