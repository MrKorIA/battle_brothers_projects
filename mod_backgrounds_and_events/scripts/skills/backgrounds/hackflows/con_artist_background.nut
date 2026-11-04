this.con_artist_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_con_artist";
		this.m.Name = "Мошенник";
		this.m.Icon = "ui/backgrounds/background_con_artist.png";
		this.m.BackgroundDescription = "Мошенники зарабатывают обманом других людей. Те из них, кто достаточно смышлён, чтобы вовремя сделать ноги до прибытия городской стражи, часто скрываются в наёмных отрядах, чтобы начать всё с чистого листа.";
        this.m.GoodEnding = "Покинув отряд \'%companyname%\', мошенник %name% не пропал, а, напротив, неплохо устроился: выторговывает лишнюю монету и договаривается с теми, с кем честные люди говорить не умеют. Вы слышали, что он перестал бегать от своих кредиторов и даже понемногу им платит, ведь репутация в наёмном деле стоит дороже любых долгов. Впрочем, ходят слухи, что долги он выплачивает чужими деньгами. Жив ли он до сих пор и где именно - доподлинно неизвестно, и в этом, пожалуй, весь он.";
        this.m.BadEnding = "Покинув отряд \'%companyname%\', мошенник %name% прихватил с собой всё, что плохо лежало, а лежало плохо многое. Далее он пустился в бега и прятался по убежищам, в которых не оставался дольше месяца: слишком много людей по всей округе желало с ним поквитаться. Затем на {севере | юге | западе | востоке} нашли тело, которое опознали по перстню с крупным камнем. Камень, как водится, оказался поддельным, как и всё остальное, что у него было.";
		this.m.HiringCost = 90;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.asthmatic",
			"trait.bloodthirsty",
			"trait.brute",
			"trait.clubfooted",
			"trait.clumsy",
			"trait.craven",
			"trait.dastard",
			"trait.drunkard",
			"trait.dumb",
			"trait.fainthearted",
			"trait.hate_beasts",
			"trait.hate_greenskins",
			"trait.hate_undead",
			"trait.hesitant",
			"trait.huge",
			"trait.insecure",
			"trait.loyal",
			"trait.night_blind",
			"trait.short_sighted",
			"trait.spartan",
			"trait.strong",
			"trait.teamplayer",
			"trait.tiny",
			"trait.tough"
		];
		this.m.Titles = [
			"Мошенник",
			"Аферист",
			"Двуличный",
			"Обманщик",
			"Вор",
			"Неблагонадежный",
			"Плут",
			"Проныра"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsLowborn = true;
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
        return "{%name% нервно косится на вас, стоит вам подойти ближе, и, не дав вам и слова сказать, выпаливает, что не должен вам ни монеты и что все сделки, которые он когда-либо заключал, были окончательными. | Завидев вас, %name% тут же вскидывает руки и клянётся, что тот золотой перстень был настоящим, а если и нет - то он тут совершенно ни при чём. | %name% испуганно пятится назад и бормочет что-то про недопонимание, хотя вы ещё даже не открыли рот. | Едва вы приближаетесь, %name% начинает частить оправданиями, путаясь в собственных словах быстрее, чем вы успеваете разобрать хоть одно из них. | %name% выдавливает нервную улыбку и уверяет, что та лошадь была абсолютно здорова, когда он её продавал - по крайней мере, выглядела вполне бодро.} {Как оказалось, этот проходимец скрывается от стольких людей и уже так долго, что вы на мгновение и сами всерьёз задумываетесь: а вдруг он и правда вам что-то должен? | Судя по тому, как нервно он озирается по сторонам, список желающих с ним поквитаться явно длиннее, чем список его удачных сделок. | Он явно принял вас за одного из своих многочисленных кредиторов - и, судя по всему, у него были все основания этого опасаться. | Похоже, недовольных его услугами накопилось столько, что он давно сбился со счёта, кто именно и за что должен с ним разобраться. | Вы ещё толком ничего не сказали, а он уже перечислил три разных города, откуда якобы бежал не по своей вине.} {В его глазах читается что-то опасное и отчаянное одновременно, и совершенно ясно, что он ищет отряд наёмников исключительно ради защиты. О его прошлом вам известно немного, но так ли уж это важно? | Взгляд у него затравленный, как у человека, которому давно надоело оглядываться через плечо - защита ему нужна позарез, и он этого не скрывает. | Отчаяние в его взгляде выдаёт человека, который слишком долго бегал в одиночку - большего о его прошлом знать, пожалуй, и не требуется.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [0, 0]
			Bravery = [0, 0]
			Stamina = [0, 0]
			MeleeSkill = [4, 4]
			RangedSkill = [2, 2]
			MeleeDefense = [2, 2]
			RangedDefense = [2, 2]
			Initiative = [5, 5]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/noble_tunic"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

});

