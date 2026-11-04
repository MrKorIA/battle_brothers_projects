this.vampire_finds_weapon_event <- this.inherit("scripts/events/event", {
	m = {
	    Vampire = null
	},

	function create()
	{
		this.m.ID = "event.vampire_finds_weapon";
		this.m.Title = "Что-то древнее...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
            Text = "%terrainImage%{%vampire% останавливается у скального выступа. При ближайшем рассмотрении становится ясно, что когда-то это была крепостная стена древней империи - её выветренный камень до сих пор покрыт глубокими бороздами, сколами и следами былых сражений. Он подходит к кирпичу, который едва держится в кладке, и с ловкостью заправского каменщика аккуратно вытаскивает его целиком.\n\nИз открывшейся ниши вы достаёте оружие, бережно завёрнутое в дорогую ткань, которая уже давно успела превратиться в труху. Оружие сохранилось куда лучше своего савана, который %vampire% брезгливо отбрасывает в сторону.%SPEECH_ON%{Всё точно так, как я и оставлял! | Не в первый раз эти земли напоминают мне о доме... и уж точно не в последний. | Я приметил странный отблеск меж камней, и меня словно что-то потянуло внутрь. Сложно объяснить... | Столько веков пролежать во тьме...}%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [{
					Text = "Наверное, эта вещь старше всех нас вместе взятых.",
				getResult = @(_event) 0
			}],

			function start( _event )
			{
				local items = [
					this.new(::MSU.Class.WeightedContainer([
                                    [1, "scripts/items/weapons/ancient/legend_broad_warscythe"],
                                    [1, "scripts/items/weapons/ancient/legend_broadhead_spear"],
                                    [1, "scripts/items/weapons/ancient/legend_decorated_crypt_cleaver"],
                                    [1, "scripts/items/weapons/ancient/broken_bladed_pike"],
                                    [1, "scripts/items/weapons/ancient/legend_decorated_sword"],
                                    [1, "scripts/items/weapons/ancient/legend_honed_warscythe"],
                                    [1, "scripts/items/weapons/ancient/legend_oxtongue_spear"]
                                ]).roll()),
					this.new(::MSU.Class.WeightedContainer([
                                    [1, "scripts/items/shields/ancient/auxiliary_shield"],
                                    [1, "scripts/items/weapons/ancient/legend_military_crypt_cleaver"],
                                    [1, "scripts/items/weapons/ancient/legend_kopis"],
                                    [1, "scripts/items/weapons/ancient/legend_broken_decorated_sword"],
                                    [1, "scripts/items/weapons/ancient/legend_sica"],
                                    [1, "scripts/items/weapons/ancient/legend_gladius"],
                                    [1, "scripts/items/weapons/ancient/legend_spatha"]
                                ]).roll()),
					this.new(::MSU.Class.WeightedContainer([
                                    [1, "scripts/items/shields/ancient/tower_shield"],
                                    [1, "scripts/items/weapons/ancient/ancient_sword"],
                                    [1, "scripts/items/weapons/ancient/falx"],
                                    [1, "scripts/items/weapons/ancient/ancient_spear"],
                                    [1, "scripts/items/weapons/ancient/legend_broken_spatha"],
                                    [1, "scripts/items/weapons/ancient/bladed_pike"],
                                    [1, "scripts/items/weapons/ancient/legend_military_rhomphaia"]
                                ]).roll())
				];

				this.List.extend(::TheRedCourt.EventList.addItems(items, ::World.Assets.getStash()));
			}
		});
	}

	function onUpdateScore()
	{
		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.hemovores" && this.World.Assets.getOrigin().getID() != "scenario.hemovores_avatar") //THIS WORKS
		{
			return;
		}

		if (this.World.Assets.getStash().getNumberOfEmptySlots() < 3)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.hemovore"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Vampire = candidates[this.Math.rand(0, candidates.len() - 1)];

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"vampire",
			this.m.Vampire.getNameOnly()
		]);
	}

	function onClear()
	{
	    this.m.Vampire = null;
	}

});

