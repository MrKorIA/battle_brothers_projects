this.leper_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_leper";
		this.m.Name = "Прокажённый";
		this.m.Icon = "ui/backgrounds/background_leper.png";
		this.m.BackgroundDescription = "Здоровые люди сторонятся прокажённых из-за их жуткого облика, однако у этой страшной хвори есть и обратная сторона: прокажённые почти начисто лишены чувствительности к боли.";
        this.m.GoodEnding = "Покинув отряд \'%companyname%\', прокажённый %name% осел на окраине небольшого городка, где его никто не гнал, но и никто не навещал. В отряде он таскал воду и чинил сбрую, а наёмники держались от него на пару шагов, и, если разобраться, это было куда больше того, что он знал последние годы. Вы слышали, что умер он тихо, без свидетелей и без колокольного звона. На похороны пришли трое бывших товарищей по отряду, и, пожалуй, для человека в его положении это была целая толпа.";
        this.m.BadEnding = "Прокажённый %name% не покинул отряд \'%companyname%\' - он до конца шёл за обозом, где его и оставили в одну из особенно холодных зим. Говорят, он умер не от хвори, а от голода: обоз ушёл на день раньше, чем его успели разбудить, и догнать он не смог. Тело его нашли через несколько дней - целое, нетронутое зверьём, потому что даже вороны побрезговали его плотью. Рассказывают, что командир отряда, узнав об этом, долго молчал, а после велел впредь не брать в отряд людей, которых и без того уже похоронили все, кто знал их при жизни.";
		this.m.HiringCost = 30;
		this.m.DailyCost = 3;
		this.m.Excluded = [
			"trait.athletic",
			"trait.dexterous",
			"trait.disloyal",
			"trait.eagle_eyes",
			"trait.fat",
			"trait.gluttonous",
			"trait.greedy",
			"trait.impatient",
			"trait.iron_lungs",
		];
		// this.m.MoreLikely <- [
		// 	"trait.spartan"
		// ]
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints
		];
		this.m.Titles = [
			"Грязнуля",
			"Прокажённый",
			"Оборванец",
			"Больной",
			"Изгой",
			"Проклятый",
			"Неудачник",
			"Порченный"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
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
        return "{В юности %name% был обаятельным парнем, полным лихого задора, и пользовался успехом у каждой девицы в своей деревне. | Происходя из длинной династии мясников, %name% никогда не сомневался, что пойдёт по стопам семьи. | %name% всю жизнь оставался человеком ничем не примечательным - обычным тружеником, зарабатывающим на хлеб трудом на своём наделе.} {Но подхватив смертельную хворь, он потерял былой вид: кожа его начала шелушиться, а лицо оказалось изуродовано до неузнаваемости. | Но в тот злополучный день, вину за который он до сих пор возлагает на некую женщину, с которой возлёг, его настигла страшная болезнь, оставившая плоть гнить и неметь. | Казалось, жизнь его так и продолжится своим чередом, но однажды на коже проступили странные пятна, а плоть начала осыпаться - и все, кто знал его прежде, отвернулись от него, как от чудовища.} {Отвергнутый всеми прочими ремёслами, он выбрал ремесло наёмника - единственное, что ему осталось. Вы сомневаетесь, что здесь его ждёт успех, но хуже, чем было, вряд ли уже будет. | Он рассказывает, как однажды отбился от пары мальчишек, кидавших в него камнями - таким тоном, будто ждёт от вас восхищения этим подвигом. Глядя на его нынешнее состояние, вы, пожалуй, почти впечатлены. | Кожа скрыта под тряпьём, голос сиплый, руки едва держат оружие - непохоже, что перед вами наёмник, скорее уж ваша бабушка. Только чуть менее свирепая. | Вам почти совестно брать этого человека в свой отряд. Но кто ещё, если не он, будет ловить стрелы вместо вас? | Вы сомневаетесь, что %name% впишется в стену щитов или в пикинёрский строй. Разве что в качестве талисмана отряда.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [8, 13]
			Bravery = [0, 5]
			Stamina = [-8, -8]
			MeleeSkill = [-6, 0]
			RangedSkill = [-12, -12]
			MeleeDefense = [0, 2]
			RangedDefense = [0, 0]
			Initiative = [-10, -6]
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
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			local item = this.new("scripts/items/helmets/hood");
			item.setVariant(38);
			items.equip(item);
		}
	}

});

