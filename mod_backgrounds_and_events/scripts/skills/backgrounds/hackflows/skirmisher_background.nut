this.skirmisher_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_skirmisher";
		this.m.Name = "Застрельщик";
		this.m.Icon = "ui/backgrounds/background_skirmisher.png";
		this.m.BackgroundDescription = "Застрельщики - это лёгкие и подвижные бойцы, мастера изматывать неповоротливые отряды тяжело бронированных солдат. Они способны наносить стремительные и неожиданно болезненные удары, однако в затяжной лобовой сече от них мало толку.";
		this.m.GoodEnding = "Покинув отряд \'%companyname%\', %name% не бросил своё ремесло. Торговец, проезжавший мимо вашего лагеря, рассказал, что на осаде одного пограничного замка бывший наёмник метал дротики так споро, что защитники не смели высунуться из-за зубцов. Лорд одарил его столь щедро, что теперь он нанимает других застрельщиков и учит их своему делу. Вам остаётся лишь гадать, сколько учеников доживёт до его лет, но удача, похоже, пока не изменила наставнику.";
        this.m.BadEnding = "Удача не могла длиться вечно, и однажды она кончилась на дороге {северного | южного | западного | восточного} тракта. Застрельщик %name% вышел на бой против копейщика в тяжёлом доспехе, метнул с десяток копий - и ни одно не нашло щели. Ответный удар он не успел увидеть. Тело, лёгкое и почти невесомое при жизни, почему-то оказалось на диво тяжёлым, когда его пришлось тащить на щите до ближайшего погоста, - и над свежей могилой долго шутили, что лишь в смерти застрельщик наконец сравнялся весом с теми, кого всю жизнь избегал.";
		this.m.HiringCost = 330;
		this.m.DailyCost = 10;
		this.m.Excluded = [
			"trait.brave",
			"trait.clubfooted",
			"trait.fat",
			"trait.fearless",
			"trait.hate_undead",
			"trait.loyal",
			"trait.night_blind",
			"trait.short_sighted"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Bravery
		];
		this.m.Titles = [
			"Налётчик",
			"Легконогий",
			"Засадник"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.IsCombatBackground = true;
		this.m.IsLowborn = true;
		this.m.Level = this.Math.rand(1, 2);
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
	}

	function onBuildDescription()
	{
        return "{Вооружённый лишь связками метательного оружия да лёгкой бронёй, %name% посвятил себя новому военному ремеслу - наносить врагу как можно больше урона, вечно балансируя на грани катастрофы. | %name% не носит тяжёлых доспехов и не держит строй - его оружие и защита одинаково легки, и оба рассчитаны на то, чтобы бить первым и не оказаться рядом, когда прилетит ответ. | Пока другие копят кроны на тяжёлые латы, %name% предпочитает копить арсенал - расчёт простой: убить врага раньше, чем он успеет размахнуться в ответ.} На ваш вопрос, откуда у него смелость на столь рискованный стиль боя, {он лишь пожимает плечами: становиться в первую шеренгу всё равно не сулило ему брони потяжелее. | он невозмутимо поясняет, что не видит смысла бояться удара, которого противник, если повезёт, попросту не успеет нанести. | он смеётся и говорит, что риск - не такая уж высокая цена за возможность бить издалека, а не подставлять грудь под чужой клинок. | он признаётся, что смелость здесь ни при чём - просто тяжёлая броня всё равно была ему не по карману, вот и пришлось делать ставку на скорость и меткость. | он пожимает плечами и замечает, что мёртвые в тяжёлых доспехах ничуть не более живы, чем мёртвые в лёгких - так к чему переплачивать за иллюзию защиты?}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [-5, 0]
			Bravery = [-4, 0]
			Stamina = [6, 8]
			MeleeSkill = [5, 5]
			RangedSkill = [15, 7]
			MeleeDefense = [0, 2]
			RangedDefense = [0, 3]
			Initiative = [10, 10]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0 && this.Const.DLC.Wildmen)
		{
			items.equip(this.new("scripts/items/weapons/barbarians/heavy_javelin"));
			items.addToBag(this.new("scripts/items/weapons/javelin"));
		}
		else if (r == 1 || r == 0)
		{
			items.equip(this.new("scripts/items/weapons/javelin"));
			items.addToBag(this.new("scripts/items/weapons/javelin"));
		}
		else
		{
			items.equip(this.new("scripts/items/weapons/throwing_axe"));
			items.addToBag(this.new("scripts/items/weapons/throwing_axe"));
		}

		items.equip(this.new("scripts/items/shields/heater_shield"));
		items.equip(this.new("scripts/items/armor/padded_surcoat"));
	}

});

