this.bodyguard_southern_background <- this.inherit("scripts/skills/backgrounds/hackflows/bodyguard_background", {
	m = {},
	function create()
	{
		this.bodyguard_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernMale;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.ailing",
			"trait.asthmatic",
			"trait.bleeder",
			"trait.bloodthirsty",
			"trait.brute",
			"trait.clubfooted",
			"trait.clumsy",
			"trait.cocky",
			"trait.craven",
			"trait.dastard",
			"trait.disloyal",
			"trait.drunkard",
			"trait.dumb",
			"trait.eagle_eyes",
			"trait.fainthearted",
			"trait.fat",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.fragile",
			"trait.gluttonous",
			"trait.greedy",
			"trait.hate_beasts",
			"trait.hate_greenskins",
			"trait.hate_undead",
			"trait.hesitant",
			"trait.impatient",
			"trait.insecure",
			"trait.irrational",
			"trait.lucky",
			"trait.optimist",
			"trait.pessimist",
			"trait.quick",
			"trait.swift",
			"trait.tiny"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
    {
        return "{%name% родился рабом в доме богатого работорговца и с юных лет усмирял строптивых невольников голыми руками - когда он в одиночку остановил бунт на невольничьем рынке, надзиратель за его силу выкупил ему свободу и рекомендовал его визирю в личную охрану. | %name% с детства охранял караваны отца-торговца от пустынных кочевников, и когда однажды в одиночку отбил нападение на караван самого визиря, тот немедля предложил ему щедрое жалование за постоянную службу. | %name% зарабатывал на гладиаторской арене, укладывая противников одного за другим на потеху толпе, пока однажды на трибуне не оказался сам визирь - тот выкупил его контракт и сделал личным телохранителем. | %name% отслужил воинскую повинность в пехоте и выделялся среди новобранцев такой силой, что о нём донесли визирю, искавшему надёжного охранника взамен погибшего в стычке с разбойниками, - и вскоре %name% занял освободившееся место. | %name% работал надсмотрщиком на серебряных рудниках, где обращение с непокорными рабами требовало силы и хладнокровия - визирь, посетивший рудник с проверкой, счёл его как раз тем человеком, что ему нужен рядом. | %name% был уличным силачом, выступавшим на площадях за медяки - пока однажды не разогнал шайку грабителей, напавших на паланкин визиря, и не был вознаграждён постоянной службой и щедрым жалованием.} Служба его закончилась, {когда визиря обвинили в присвоении казённого золота и приговорили к позорной казни - должность охранника опального сановника скатилась вместе с его головой. | визирь проиграл выборы более богатому сопернику и в одночасье лишился и должности, и большей части состояния - жалования охране платить стало нечем. | соперники визиря подослали к нему отравителя, и хотя убийцу схватили на месте, самого визиря спасти не удалось - а его семья быстро распродала всё имущество покойного, включая контракты слуг. | караван визиря был разграблен во время Священной войны северянами, а сам визирь погиб - служить стало попросту некому. | визирь, которого он охранял, был публично уличён в связях с контрабандистами и с позором изгнан из городского совета - вместе с должностью исчезло и жалование. | новый закон обязал визирей сокращать личную охрану вдвое ради экономии казны - и его, несмотря на верную службу, отпустили одним из первых. | визирь неудачно вложился в караванную торговлю и обанкротился в считанные месяцы - платить наёмной охране ему было уже нечем.} {Теперь %name% ищет нового хозяина среди наёмников - человека, достаточно значимого, чтобы заслуживать такой же верной защиты. | Он не гонится за золотом - ему важнее вновь почувствовать, что кого-то стоит прикрывать собой. | %name% немногословен о прежнем визире, но по тому, как крепко он держит щит, ясно: службу свою он принимает всерьёз. | Ему уже доводилось охранять влиятельного человека - теперь он присматривается, найдётся ли среди наёмников хоть один, достойный такой же преданности. | Он немногословен, но стоит прикинуть на глаз ширину его плеч - и сомнений в его пригодности не остаётся. | %name% надеется, что среди наёмников он встретит таких же отчаявшихся людей, которые, как и он, потеряли всё, кроме умения держать щит и не отступать.}";
    }

	function onAddEquipment()
    {
        local items = this.getContainer().getActor().getItems();
        local r;
        items.equip(this.new("scripts/items/shields/oriental/metal_round_shield"));

        items.addToBag(this.new("scripts/items/accessory/bandage_item"));
        r = this.Math.rand(0, 1);

        if (r == 0)
        {
            items.equip(this.new("scripts/items/armor/oriental/southern_mail_shirt"));
        }
        else if (r == 1)
        {
            items.equip(this.new("scripts/items/armor/oriental/southern_long_mail_with_padding"));
        }

        r = this.Math.rand(0, 2);

        if (r == 0)
        {
            items.equip(this.new("scripts/items/helmets/oriental/southern_helmet_with_coif"));
        }
        else if (r == 1)
        {
            items.equip(this.new("scripts/items/helmets/oriental/spiked_skull_cap_with_mail"));
        }
        else if (r == 2)
        {
            items.equip(this.new("scripts/items/helmets/oriental/wrapped_southern_helmet"));
        }

        items.equip(this.new("scripts/items/weapons/oriental/heavy_southern_mace"));
    }

});


