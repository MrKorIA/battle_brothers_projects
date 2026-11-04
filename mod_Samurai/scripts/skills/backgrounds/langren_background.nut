this.langren_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = { Tattoo = 0 },
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.langren";
		this.m.Name = "Ронин";
		this.m.Icon = "ui/backgrounds/background_langren.png";
		this.m.BackgroundDescription = "Ронин превосходит всех в ближнем бою, но может быть уязвим на расстоянии. Возраст мог сказаться на его физических характеристиках и может продолжать сказываться.";
		this.m.GoodEnding = "Лучший мечник, которого ты когда-либо видел, %name% ронин, был естественным дополнением %companyname%. Но человек не может сражаться вечно. Несмотря на растущий успех отряда, становилось очевидно, что ронин просто не может больше физически. Он ушел на покой, купив хороший участок земли, и наслаждается уединением. По крайней мере, так ты думал. Ты отправился навестить его и обнаружил, что он тайно обучает дочь одного дворянина. Ты пообещал сохранить это в тайне.";
		this.m.BadEnding = "Жаль, что %name% ронину пришлось провести свои последние годы в приходящей в упадок наемной компании. Он ушел, заявив, что больше не может физически. Ты думаешь, он просто хотел смягчить удар для %companyname%, потому что через неделю он без труда убил десятерых разбойников на обочине дороги. Последнее, что ты слышал, он обучал неблагодарных принцев искусству фехтования.";
		this.m.HiringCost = 200;
		this.m.DailyCost = 25;
		this.m.Excluded = [
			"trait.huge",
			"trait.weasel",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.paranoid",
			"trait.impatient",
			"trait.clubfooted",
			"trait.irrational",
			"trait.athletic",
			"trait.gluttonous",
			"trait.dumb",
			"trait.bright",
			"trait.clumsy",
			"trait.tiny",
			"trait.insecure",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.hesitant",
			"trait.fragile",
			"trait.iron_lungs",
			"trait.tough",
			"trait.strong",
			"trait.bloodthirsty"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.RangedSkill
		];
		this.m.Titles = [
			"Ронин"
		];
		this.m.Names = this.Const.Strings.WushiNames;
		this.m.Faces = this.Const.Faces.WushiMale;
		this.m.Hairs = this.Const.Hair.WushiMaleOnly;
		this.m.HairColors = this.Const.HairColors.Wushi;
		this.m.Beards = this.Const.Beards.All;
		this.m.BeardChance = 0;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(1, 3);
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
			},
			{
				id = 3,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+30[/color] к инициативе если держит в руках катану со способностью \'[color=" + this.Const.UI.Color.PositiveValue + "]Быстрая цель[/color]\'."
			},
		];
	}

	function getGenericTooltip()
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
			},
			{
				id = 3,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+30[/color] к инициативе если держит в руках катану со способностью \'[color=" + this.Const.UI.Color.PositiveValue + "]Быстрая цель[/color]\'."
			},
		];
	}

	function onBuildDescription()
	{
		return "{%name% рос с мечом в руке и присягой на устах: господину он служил с юных лет и ни разу не задумывался о том, что может быть иначе. | Потомок семьи, веками служившей одному дому, он получил клинок раньше, чем научился грамоте. Верность господину давалась ему так же естественно, как дыхание. | Заметив в мальчишке редкий дар, старый мечник взял его в ученики, а затем представил своему господину. Так %name% стал личным клинком человека, о котором простые люди говорили вполголоса. | Безродный боец, одолевший на турнире всех, кого ему выставили, был замечен знатным господином и взят на службу. Он принял это с достоинством человека, получившего нечто большее, чем плата. | Во дворе своего господина %name% считался лучшим клинком. Издалека приезжали те, кто хотел своими глазами увидеть, как должен двигаться мечник. | Он служил господину клинком не ради жалованья, а ради чести, и говорил об этом без пафоса, как о погоде.} {Но однажды господин пал от руки убийцы, а он, стоявший рядом, не успел или не смог помешать. Родня покойного назвала его виновным, и ему пришлось уйти раньше, чем клинки обернулись против него. | Но господин умер своей смертью, и наследники, которым не нужен был ни сторож, ни его жалованье, избавились от него, не сказав ему ни слова благодарности. | Но однажды господин приказал ему обнажить меч против безоружных. Он отказался. В его мире такой отказ стоит дороже предательства: его прогнали со двора, и с тех пор ему закрыт путь в любой дом, где знают эту историю. | Но однажды дом господина рухнул в междоусобице. Самого господина казнили, а всех, кто присягал ему, объявили изменниками. Ему удалось уйти, но не удалось унести с собой доброе имя. | Но единственный проигранный им поединок дорого обошёлся господину. Тот не гневался вслух, и всё же %name% сам спорол с плаща герб и ушёл, не прося прощения. | Но завистники оговорили его перед господином, и тот, не желая выяснять правду, указал ему на дверь. %name% не стал оправдываться.} {Теперь он не носит гербов и не называет имени того, кому служил. Меч за поясом - единственное, что осталось от прежней жизни. | Теперь %name% говорит мало, зато каждый жест выверен: даже садясь, он словно занимает позицию. | Он держит ладонь на рукояти так, как другие держат её на сердце. | Вы пытаетесь понять, чего в его взгляде больше - гордости или усталости. Кажется, он и сам давно в этом не разбирается. | На его плаще заметен след там, где когда-то красовался герб. Он не пытается его скрыть, но и не объясняет. | Теперь он не просит о найме. Он стоит в стороне, пока его не позовут, и выглядит так, будто умеет ждать очень долго. | Вы замечаете, что %name% ни разу не взглянул на ваш кошель. Для наёмного клинка это либо очень хороший знак, либо очень плохой.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				5,
				5
			],
			Stamina = [
				-10,
				-10
			],
			MeleeSkill = [
				10,
				10
			],
			RangedSkill = [
				-10,
				-10
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				20,
				20
			]
		};
		return c;
	}


	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Const.DLC.Unhold)
		{
			r = this.Math.rand(0, 2);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon37"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon37"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon37"));
			}
		}
		else
		{
			r = this.Math.rand(0, 1);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon37"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon37"));
			}
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/wushi_armor15"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/wushi_armor15"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/wushi_armor15"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/wushi_armor15"));
		}
        if (this.Math.rand(1, 100) <= 99)
		{
			items.equip(this.new("scripts/items/helmets/wushi_helmet24"));
		}
	}
    
	function onAfterUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local item = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null)
		{
			if (this.getContainer().getActor().getSkills().hasSkill("actives.wushiweapon32_01"))
			{
				_properties.Initiative += 30;
			}			
		}
	}

	function onSerialize( _out )
	{
		this.character_background.onSerialize(_out);
		_out.writeU8(this.m.Tattoo);
	}

	function onDeserialize( _in )
	{
		this.character_background.onDeserialize(_in);
		this.m.Tattoo = _in.readU8();
	}
});

