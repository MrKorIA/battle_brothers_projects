this.renzhe_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = { Tattoo = 0 },
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.renzhe";
		this.m.Name = "Ниндзя";
		this.m.Icon = "ui/backgrounds/background_renzhe.png";
		this.m.BackgroundDescription = "Ниндзя превосходит всех в ближнем бою, но может быть уязвим на расстоянии. Возраст мог сказаться на его физических характеристиках и может продолжать сказываться.";
		this.m.GoodEnding = "Лучший мечник, которого ты когда-либо видел, %name% старый ниндзя, был естественным дополнением %companyname%. Но человек не может сражаться вечно. Несмотря на растущий успех отряда, становилось очевидно, что ниндзя просто не может больше физически. Он ушел на покой, купив хороший участок земли, и наслаждается уединением. По крайней мере, так ты думал. Ты отправился навестить его и обнаружил, что он тайно обучает дочь одного дворянина. Ты пообещал сохранить это в тайне.";
		this.m.BadEnding = "Жаль, что %name% ниндзя пришлось провести свои последние годы в приходящей в упадок наемной компании. Он ушел, заявив, что больше не может физически. Ты думаешь, он просто хотел смягчить удар для %companyname%, потому что через неделю он без труда убил десятерых разбойников на обочине дороги. Последнее, что ты слышал, он обучал неблагодарных принцев искусству фехтования.";
		this.m.HiringCost = 400;
		this.m.DailyCost = 15;
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
			this.Const.Attributes.Hitpoints
		];
		this.m.Titles = [
			"Ниндзя"
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] к максимальному урону при метании кунаи или сюрикенов."
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] к максимальному урону при метании кунаи или сюрикенов."
			},
		];
	}

	function onBuildDescription()
	{
		return "{Его с детства растили в тайной школе ордена убийц за далёкими морями, где мальчиков учат не драться, а исчезать. | %name% был продан ордену убийц ещё ребёнком, и первым делом его научили молчать. | Сирота, подобранный странствующим убийцей и приведённый в орден, получил ремесло, которого не выбирал, и имя, которого уже не помнит. | Орден принимал лишь тех, кто мог сутками лежать неподвижно под крышей, пока внизу пируют гости. Он был лучшим в своём выпуске. | Говорят, в его родном ордене ядам учили раньше, чем грамоте, а ходить по сухим листьям так, чтобы не хрустнул ни один, заставляли до кровавых мозолей. | Рассказывают, что в тех краях, откуда он родом, орден отдавал таких людей на службу знатным домам, и никто из хозяев не знал их в лицо.} {Но однажды заказчик отправил его за море убить одного человека. Цель осталась жива, а он очутился на чужом берегу без денег и связей. | Но однажды заказ в чужих землях был выполнен наполовину: убит оказался не тот человек. Орден не присылает за такими ошибками гонцов, он просто перестаёт знать неудачника. | Но в чужих землях его выдали ещё до удара: кто-то продал и его, и заказ. С тех пор у него нет ни дома, ни ордена, ни дороги назад. | Но, проникнув в дом цели на чужбине, он увидел там спящих детей, и рука не поднялась. Орден назвал это изменой, и возвращаться ему некуда. | Но цель он убил, а уйти не успел: стража подняла тревогу раньше, чем он рассчитывал, а корабль, что должен был его забрать, уже ушёл. | Но дело пошло не так, и орден, отправивший его в чужие земли, поспешил о нём забыть.} {Он ходит так тихо, что вы замечаете его, лишь когда он уже стоит рядом. | %name% говорит на вашем языке с таким акцентом, что половина слов теряется. Другая половина звучит то ли как вежливость, то ли как угроза, не разберёшь. | Одежда на нём простая, тёмная, без гербов и знаков, зато в рукавах и за поясом что-то тихо позвякивает при каждом движении. | Он замер у стены с закрытыми глазами, но стоит кому-то подойти ближе, как оказывается, что он давно смотрит на этого человека. | Он улыбается редко и вежливо, как улыбаются люди, у которых в этом краю нет ни друга, ни дела. | Лицо скрыто тряпицей по самые глаза, и никто в округе не берётся сказать, что под ней. | Прохожие на площади обходят его стороной, сами не понимая почему, а голуби не садятся ближе чем на несколько шагов.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
			    -10,
				-10
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				-10,
				-10
			],
			MeleeSkill = [
				5,
				5
			],
			RangedSkill = [
				10,
				10
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
		local f = ::mods_getRegisteredMod("mod_fantasybro") == null ? 0 : 1;

		if (this.Const.DLC.Unhold)
		{
			r = this.Math.rand(0, 2 + f);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon03"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon04"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon05"));
			}
			else if (r == 3)
			{
				items.equip(this.new("scripts/items/weapons/xxmeteor"));
			}
			else if (r == 4)
			{
				items.equip(this.new("scripts/items/weapons/xxkusarigama"));
			}
		}
		else
		{
			r = this.Math.rand(0, 1 + f);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon08"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon03"));
			}
			else if (r == 3)
			{
				items.equip(this.new("scripts/items/weapons/xxmeteor"));
			}
			else if (r == 4)
			{
				items.equip(this.new("scripts/items/weapons/xxkusarigama"));
			}
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/wushi_armor04"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/wushi_armor04"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/wushi_armor04"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/wushi_armor04"));
		}
        if (this.Math.rand(1, 100) <= 99)
		{
			items.equip(this.new("scripts/items/helmets/wushi_helmet03"));
		}
	}
    
	function onAfterUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local item = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null)
		{
			if (this.getContainer().getActor().getSkills().hasSkill("actives.wushiweapon03_01"))
			{
				_properties.DamageRegularMax += 20;
			}
			if (this.getContainer().getActor().getSkills().hasSkill("actives.wushiweapon04_01"))
			{
				_properties.DamageRegularMax += 20;
			}
			if (this.getContainer().getActor().getSkills().hasSkill("actives.wushiweapon21_01"))
			{
				_properties.DamageRegularMax += 20;
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

