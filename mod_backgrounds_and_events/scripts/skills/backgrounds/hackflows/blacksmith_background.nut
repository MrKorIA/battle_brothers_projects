this.blacksmith_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_blacksmith";
		this.m.Name = "Кузнец";
		this.m.Icon = "ui/backgrounds/background_blacksmith.png";
		this.m.BackgroundDescription = "Недюжинная сила и бритвенная точность, необходимые для ковки стали, дают кузнецам огромное преимущество в освоении ратного дела и обращении с тяжёлым оружием.";
        this.m.GoodEnding = "Покинув отряд \'%companyname%\', %name% открыл кузницу в портовом городе и вскоре обзавёлся клиентами, которые не скупятся на кроны. Вы слышали, что капитан городской стражи теперь носит меч его работы и уверяет, что лучшего клинка в жизни не видывал. Сам кузнец, говорят, больше не берёт заказов от знати: слишком хорошо знает, чем это может кончиться. Зато каждый подмастерье в округе мечтает попасть к нему в ученики, и он никому не отказывает, словно надеется найти среди них того, кому можно будет оставить кузницу.";
        this.m.BadEnding = "Покинув отряд \'%companyname%\', %name% вернулся к наковальне и выковал клинок, равных которому не было. Из полученного вами письма следовало, что заказал его местный барон и расплатился, как водится, не кронами, а обещаниями. Когда кузнец явился за деньгами, барон велел стражникам проверить остроту клинка на самом мастере. Меч, к слову, оказался превосходным: по слухам, он без малейшего труда разделил кузница на две половины.";
		this.m.HiringCost = 1000;
		this.m.DailyCost = 11;
		this.m.Excluded = [
			"trait.ailing",
			"trait.asthmatic",
			"trait.bleeder",
			"trait.clumsy",
			"trait.craven",
			"trait.dastard",
			"trait.dumb",
			"trait.fainthearted",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.fragile",
			"trait.hesitant",
			"trait.insecure",
			"trait.irrational",
			"trait.swift",
			"trait.tiny",
			"trait.weasel"
		];
		this.m.Titles = [
			"Кузнец",
			"Металлург",
			"Мастер-кузнец",
			"Мечник",
			"Самодельщик",
			"Молотобоец",
			"Литейщик"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
        return "{%name% был сыном кузнеца, как и тот в своё время был сыном кузнеца, так что ремесло досталось ему будто само собой. | %name% рано лишился отца и, чтобы никто в семье не остался голодным, сам взялся за кузнечное дело. | Родовой меч семьи, бесценная реликвия, передававшаяся из поколения в поколение, пропал во время ограбления - и %name% решил выковать новый клинок, которым его семья могла бы гордиться. | %name% с детства мечтал не о мече, а о молоте - его отдали в подмастерья к кузнецу ещё мальчишкой, и с тех пор он не расстаётся с наковальней. | %name% выучился кузнечному делу самостоятельно, по обрывкам записей давно умершего мастера, найденным на чердаке заброшенной мастерской. | Проведя молодость в рудниках, %name% решил, что лучше ковать железо, чем добывать его, и выучился на кузнеца уже будучи взрослым. | %name% получил в наследство кузницу разорившегося соседа, задолжавшего его отцу крупную сумму - так, толком не желая того, он стал кузнецом.} {Но когда местный дворянин остался недоволен заказанным кинжалом, он послал своих людей сжечь кузницу дотла. | Но одолеваемый жаждой странствий, он решил податься в наёмники, не желая всю жизнь провести в мастерской, где провёл много лет. | Но когда мертвецы окрестного кладбища поднялись из могил, он поклялся обратить свой молот на дело более праведное, чем ковка подков. | Заказ на партию мечей для войны так и остался неоплаченным - казна лорда опустела быстрее, чем успела остыть кузница. | Но пожар, вспыхнувший по соседству, не пощадил и его мастерскую вместе со всем инструментом, что он годами собирал. | Однако устав от бесконечных придирок капризных заказчиков, он решил, что скрестить меч с врагом будет проще, чем привыкнуть к нравам очередного дворянина.} {Он говорит, что способен выковать клинок, острый настолько, что тот режет камень. Верится с трудом, но кузнец с таким опытом пригодится любому отряду. | Его мускулистые руки - достаточное доказательство того, что молот ему не в новинку. Возможно, вы поможете ему найти для этой силы новое применение. | Едва ли этот человек хоть раз держал в руках меч. Но телосложением он вышел не хуже иного солдата, и при должной подготовке из него вполне может выйти неплохой боец. | Грозным воином он вряд ли станет, но такой мастер на все руки всегда пригодится в отряде. Остаётся надеяться, что бить врагов у него получается не хуже, чем по наковальне. | Он поглядывает на ваше снаряжение чуть дольше, чем требуется - похоже, уже прикидывает, что бы он сам сделал иначе.}";


	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [4, 4]
			Bravery = [0, 0]
			Stamina = [4, 4]
			MeleeSkill = [2, 2]
			RangedSkill = [0, 0]
			MeleeDefense = [0, 0]
			RangedDefense = [0, 0]
			Initiative = [0, 0]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local dirt = actor.getSprite("dirt");
		dirt.Visible = true;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 6);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/polehammer"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/warbrand"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/arming_sword"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/winged_mace"));
		}
		else
		{
			items.equip(this.new("scripts/items/weapons/warhammer"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/mail_hauberk"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/mail_shirt"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/kettle_hat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/closed_flat_top_helmet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/padded_kettle_hat"));
		}
	}

});

