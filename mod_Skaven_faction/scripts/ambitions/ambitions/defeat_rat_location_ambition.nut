this.defeat_rat_location_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		Defeated = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_rat_location";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Лишь самые отчаянные в силах сражаться с ордами скавенов! Мы сравняем несколько\nих зловонных лагерей с землёй, а слава об этом деянии обойдёт весь свет!";
		this.m.RewardTooltip = "Вы получите уникальный аксессуар, позволяющий владельцу призывать крыс.";
		this.m.UIText = "Уничтожьте лагеря скавенов";
		this.m.TooltipText = "В рамках контракта или же по своей воле уничтожьте четыре лагеря скавенов, чтобы показать всем доблесть вашего отряда. Также вам понадобится место для нового предмета.";
		this.m.SuccessText = "[img]gfx/ui/events/rat_event_09.png[/img]Люди рассредоточены по полю боя, всё ещё тяжело дыша после жестокой схватки. Пока вы осматриваете поле, %randombrother% и %randombrother2% обыскивают его в поисках ценностей.%SPEECH_ON%Мы наступаем - они отступают. Мы отходим - они нас преследуют. Выпустишь залп стрел - они прячутся. Стену щитов пронзают отравленными клинками, а при атаке они разбегаются как клопы. Эти проклятые чумные бомбы, которыми они в тебя швыряют, будут являться мне в кошмарах ещё много ночей.%SPEECH_OFF%%randombrother2% тыкает оружием в мёртвую крысу и, убедившись, что она действительно мертва, встаёт на колено, чтобы лучше рассмотреть её пожитки.%SPEECH_ON%Но чем горше битва, тем слаще победа.%SPEECH_OFF%Он встаёт, и %randombrother% встречается с ним взглядом.%SPEECH_ON%Чем горше битва, тем живее я себя чувствую. Пошли.%SPEECH_OFF%Они медленно продолжают поиски, останавливаясь то тут, то там, в поисках вещей, которые можно было бы продать, когда остальные уже начинали выдвигаться в сторону города.";
		this.m.SuccessButtonText = "Победа!";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.m.Defeated + "/4)";
	}

	function onLocationDestroyed( _location )
	{
		if (this.World.FactionManager.getFaction(_location.getFaction()).getType() == this.Const.FactionType.Rat)
		{
			++this.m.Defeated;
			this.World.Ambitions.updateUI();
		}
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 20)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		this.m.Score = 2 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return false;
		}

		if (this.m.Defeated >= 4)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"recently_destroyed",
			this.World.Statistics.getFlags().get("LastLocationDestroyedName")
		]);
	}

	function onReward()
	{
		local item;
		local stash = this.World.Assets.getStash();
		item = this.new("scripts/items/accessory/rat_trophy_item");
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Вы получаете " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
	}

	function onClear()
	{
		this.m.Defeated = 0;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU8(this.m.Defeated);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.Defeated = _in.readU8();
	}

});

