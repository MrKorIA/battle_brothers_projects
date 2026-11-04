if (!("Rosetta" in getroottable())) return;

local rosetta = {
    mod = {id = "mod_", version = "..."}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: scripts/skills/backgrounds/hackflows/arbalester_background.nut
    {
        en = "Arbalester"
        ru = "Арбалетчик"
    }
    {
        en = "Arbalesters have served as professional crossbowmen at some point in their lives."
        ru = "Арбалетчики в какой-то момент своей жизни были профессиональными арбалетчиками."
    }
    {
        en = "Having enough of all the fighting, %name% the once-beggar retired from the %companyname%. You know the man made a pretty crown in his time with the mercenary company, yet the other day you saw him out begging again. You asked if he'd wasted all his money and he laughed. He said he'd purchased land and was doing just fine. Then he held out his little tin and asked for a crown. You gave him two."
        ru = "Устав от всех этих сражений, %name%, некогда нищий, уволился из %companyname%. Вы знаете, что этот человек заработал неплохую корону за время службы в компании наемников, но на днях вы снова увидели его попрошайничающим. Вы спросили, не потратил ли он впустую все свои деньги, и он рассмеялся. Он сказал, что купил землю и у него все хорошо. Затем он протянул свою маленькую жестянку и попросил крону. Вы дали ему две."
    }
    {
        en = "Жизнь наемника сурова, и %name%, бывший нищий, счел за благо уйти из нее, пока она не стала смертельной. К сожалению, он вернулся к попрошайничеству. Говорят, какой-то дворянин очистил город от отбросов и отправил их на север, несмотря на зиму. Замерзший и голодный, %name% умер на обочине дороги, с примерзшей к пальцу жестяной кружкой."
        ru = "Военная жизнь - тяжелая штука, и %name%, который когда-то был нищим, счел нужным уйти из нее, пока она не стала смертельно опасной. К сожалению, он вернулся к попрошайничеству. Ходят слухи, что один дворянин очистил город от всякого сброда и отправил их маршем на север, несмотря на то, что была зима. Замерзший и голодный, %name% умер на обочине дороги, оловянная кружка примерзла к его пальцу."
    }
    {
        en = "the Arbalester"
        ru = "Арбалетчик"
    }
    {
        en = "the Crossbowman"
        ru = "Арбалетчик"
    }
    {
        en = "Снайпер"
        ru = "снайпер"
    }
    {
        en = "Меткий"
        ru = "точный"
    }
    {
        en = "{%name%'s father was a bowyer of significant repute, as far as lowly bowmakers could go. In his youth, %name% never doubted that one day he would take up the craft to continue the family's legacy. Sadly, this future was not be. His father was brutally murdered by a nobleman, who upon discovering the superior quality of his order, sought to keep a similar weapon out of his enemy's hands. Seeking revenge, %name% took up the crossbow, swearing an oath that one day he would humiliate the offender by ending him with a crossbow bolt between the eyes. He returns your gaze with a fiery expression, stating that he would never fulfill this aim by keeping watch atop fortress battlements. You silently agree.}"
        ru = "Отец {%name% был известным лучником, насколько могли судить простые лучники. В юности %name% никогда не сомневался, что однажды он займется этим ремеслом, чтобы продолжить семейное наследие. К сожалению, этому будущему не суждено было сбыться. Его отец был зверски убит дворянином, который, узнав о превосходстве своего ордена, стремился уберечь подобное оружие от попадания в руки своего врага. Стремясь отомстить, %name% взял в руки арбалет, поклявшись, что однажды он унизит обидчика, всадив ему арбалетную стрелу между глаз. Он отвечает вам яростным взглядом, заявляя, что никогда не достиг бы этой цели, стоя на страже на вершине крепостной стены. Вы молча соглашаетесь.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/atilliator_background.nut
    {
        en = "Atilliator"
        ru = "Посредник"
    }
    {
        en = "Atilliators tend to have some knowledge about how to use the ranged weaponry they used to craft."
        ru = "Штурмовики, как правило, обладают некоторыми знаниями о том, как использовать дальнобойное оружие, которое они использовали для создания."
    }
    {
        en = "While at a jousting tournament, a young boy was using an oddly shaped, yet perfectly crafted bow. His aiming hand was shaky, yet the arrows did not wobble upon being loosed. After he won the competition, you inquired about where the boy had gotten such an incredible bow. He stated that a bowyer by the name of %name% had crafted it. Apparently, he's known for making the finest bows in all the land!"
        ru = "Во время рыцарского турнира мальчик использовал лук странной формы, но прекрасно сделанный. Его рука, которой он целился, дрожала, но стрелы не дрожали при спуске. После того, как он выиграл соревнование, вы спросили, где мальчик раздобыл такой потрясающий лук. Он заявил, что его изготовил мастер по изготовлению луков по имени %name%. Очевидно, он известен тем, что делает самые прекрасные луки во всей стране!"
    }
    {
        en = "After you left the %companyname%, you sent a letter inquiring about the status of %name% the bowyer. You got word that he had discovered a way to craft the finest bow possible and, instead of giving this secret to the company, he departed to start his own business. He did not get far: whatever he had learned about his trade died with him on a muddy road out {north | south | west | east} of here, his body ironically skewered with what is said to have been a dozen arrows."
        ru = "После того, как вы покинули %companyname%, вы отправили письмо с запросом о статусе %name% изготовителя лука. Вы узнали, что он открыл способ изготовления самого лучшего лука из всех возможных, но вместо того, чтобы поделиться этим секретом с компанией, он ушел, чтобы начать собственное дело. Далеко ему уйти не удалось: все, что он узнал о своем ремесле, умерло вместе с ним на грязной дороге к северу |югу|западу|востоку отсюда, а его тело, по иронии судьбы, было пронзено, как говорят, дюжиной стрел."
    }
    {
        en = "the Crossbow Crafter"
        ru = "мастер по изготовлению арбалетов"
    }
    {
        en = "the Atilliator"
        ru = "посредник"
    }
    {
        en = "the Crafter"
        ru = "ремесленник"
    }
    {
        en = "the Patient"
        ru = "пациент"
    }
    {
        en = "{With deft fingers and a gift for linking together machinery, %name% actually began his career as an architect for siege engines. However, after his lord's castle was assailed by catapaults and trebuchets of %name%'s own design, %name% was forced to flee for his life and undergo a hasty career change. Fortunately for him his gift with machines applies just as well to crossbows as it does rockslingers. Having recently caught wind that his original lord has been on the hunt for him, %name% now seeks a more mobile occupation.}"
        ru = "{Обладая ловкими пальцами и даром собирать механизмы воедино, %name% фактически начал свою карьеру в качестве архитектора осадных машин. Однако после того, как замок его лорда подвергся обстрелу из катапульт и требушетов собственной конструкции, %name% был вынужден спасаться бегством и поспешно сменить профессию. К счастью для него, его умение обращаться с машинами применимо как к арбалетам, так и к стрелкам из камня. Недавно пронюхав, что его прежний лорд охотится за ним, %name% теперь ищет более мобильное занятие.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/barkeep_background.nut
    {
        en = "Barkeep"
        ru = "Бармен"
    }
    {
        en = "Barkeeps have some brawling experience from breaking up fights at the taverns they work in."
        ru = "У барменов есть некоторый опыт в драках, поскольку они разгоняют драки в тавернах, в которых они работают."
    }
    {
        en = "the Bartender"
        ru = "бармен"
    }
    {
        en = "the Barkeep"
        ru = "бармен"
    }
    {
        en = "the Brewer"
        ru = "пивовар"
    }
    {
        en = "the Burly"
        ru = "дородный"
    }
    {
        en = "the Tapmaster"
        ru = "хозяин пивной"
    }
    {
        en = "the Hopper"
        ru = "бункер"
    }
    {
        en = "the Beer Brewer"
        ru = "пивовар"
    }
    {
        en = "{A lifetime in the tavern has shaped %name% the barkeep into a hardy, burly, muscular man. In troubled times, %name% often had had to 'resolve disagreements', 'escort patrons to the door', or 'ensure that customers paid fairly' on his own. Having heard his share of tales of heroic deeds, violent clashes, and exciting treasure hunts, %name% is more than ready to see the wide world for himself. He has a solid build; he might make a name for himself yet!"
        ru = "{Жизнь в таверне сделала из %name% бармена выносливого, крепкого, мускулистого мужчину. В трудные времена %name% часто приходилось \"разрешать разногласия\", \"провожать посетителей до двери\" или \"следить за тем, чтобы клиенты платили честно\" в одиночку. Наслушавшись историй о героических деяниях, жестоких столкновениях и захватывающих поисках сокровищ, %name% более чем готов увидеть мир своими глазами. У него крепкое телосложение; он еще может сделать себе имя!"
    }
    // FILE: scripts/skills/backgrounds/hackflows/berserker_background.nut
    {
        en = "Berserker"
        ru = "Берсерк"
    }
    {
        en = "Kill or be killed. Berserkers are men who have been forged by cruel hardship since birth, and as a result are naturally fearless combatants."
        ru = "Убивай или будешь убит. Берсерки - это люди, которых с рождения закаляли жестокие испытания, и в результате они от природы бесстрашные бойцы."
    }
    {
        en = "While the %companyname% visited a town for rest and recuperation, a local princess took a shine to %name% the wildman. He was 'purchased' for a large sum of gold and given to the noblewoman. You went and visited the man recently. For dinner, he sat at a kingly table, grinning goofily and mimicking the nobles around him as best he could. His new and inexplicable wife adored him, and him her. When you said your goodbyes, he offered you a heavy golden crown off the top of his head. It weighed heavy with traditions and ancient histories. You said it'd be best if he kept it. The wildman shrugged and walked off, spinning the circlet around a finger."
        ru = "В то время как %companyname% посещал город для отдыха и восстановления сил, местная принцесса запала на %name% дикаря. Он был \"куплен\" за крупную сумму золота и подарен знатной даме. Недавно вы навестили этого человека. За ужином он сидел за королевским столом, глупо улыбаясь и, как мог, подражая окружающим его аристократам. Его новая и необъяснимая жена обожала его, а он - ее. Когда вы прощались, он подарил вам тяжелую золотую корону, которую снял со своей головы. Оно было наполнено традициями и древней историей. Ты сказал, что было бы лучше, если бы он сохранил его. Дикарь пожал плечами и ушел, наматывая кольцо на палец."
    }
    {
        en = "%name% the wildman stayed with the fragmenting %companyname% for a time and then, just like that, he was gone. The company went out looking for him in a forest, eventually finding some sort of crude note: an enormous pile of crowns next to a dirt-drawing of the %companyname% and some of its members, all of them being hugged by a big, literal stick figure with a goofy smile on its face. There was also an offering of a dead, half-eaten rabbit."
        ru = "%name% дикарь какое-то время оставался с распадающейся %companyname% компанией, а затем, вот так просто, исчез. Компания отправилась на его поиски в лес и в конце концов нашла какую-то грубую записку: огромную кучу крон рядом с нарисованным на земле названием компании и некоторыми из ее членов, причем всех их обнимала большая фигурка из палочек с глупой улыбкой на лице. Кроме того, в качестве подношения был подан мертвый, наполовину съеденный кролик."
    }
    {
        en = "the Berserker"
        ru = "берсеркер"
    }
    {
        en = "the Crazed"
        ru = "обезумевший"
    }
    {
        en = "the Bloodthirsty"
        ru = "Кровожадный"
    }
    {
        en = "the Feral"
        ru = "дикий"
    }
    {
        en = "the Wild"
        ru = "дикий"
    }
    {
        en = "the Battleforged"
        ru = "закаленный в битве"
    }
    {
        en = "{It is said that man is born with the wilderness in him, and that he does wrong by turning his back on it. This is a mantra esteemed by those that find refuge in the forests, spurning the filth of civilization and returning to the old ways. However, between the men of the wilderness and the men of civilization, there exists a third class of men that dare to live at the fringes of both. They are called berserkers. %name% is one such man. He is so immense that lesser men appear almost as children; his body is covered in scars and his hair grows unimpeded in every which way. At a quick glance he appears to be a conventional wildman, if indeed there exists such a thing. However, his piercing, intelligent gaze shows that though his body was honed by the cruelties of nature, so too has his mind been honed by the cruelties of man.}"
        ru = "{Говорят, что человек рождается с природой в душе и что он поступает неправильно, поворачиваясь к ней спиной. Это мантра, которую почитают те, кто находит убежище в лесах, отвергая грязь цивилизации и возвращаясь к старым обычаям. Однако между людьми дикой природы и цивилизованными людьми существует третий класс людей, которые осмеливаются жить на грани и того, и другого. Их называют берсеркерами. %name% - один из таких людей. Он настолько огромен, что мужчины меньшего роста кажутся почти детьми; его тело покрыто шрамами, а волосы растут беспрепятственно во все стороны. На первый взгляд он кажется обычным дикарем, если такое вообще существует. Однако его пронзительный, умный взгляд показывает, что, хотя его тело было отточено жестокостью природы, жестокость человека отточила и его разум.}"
    }
    {
        en = "dirt"
        ru = "грязь"
    }
    {
        en = "body"
        ru = "тело"
    }
    // FILE: scripts/skills/backgrounds/hackflows/blacksmith_background.nut
    {
        en = "Blacksmith"
        ru = "Кузнец"
    }
    {
        en = "The endurance and precision needed to forge weapons of war gives blacksmiths a head start in becoming combat ready."
        ru = "Выносливость и точность, необходимые для создания боевого оружия, дают кузнецам преимущество в подготовке к бою."
    }
    {
        en = "the Smith"
        ru = "кузнец"
    }
    {
        en = "the Smithy"
        ru = "кузница"
    }
    {
        en = "the Blacksmith"
        ru = "кузнец"
    }
    {
        en = "the Metalworker"
        ru = "рабочий по металлу"
    }
    {
        en = "the Forgemaster"
        ru = "Мастер-кузнец"
    }
    {
        en = "the Swordmaker"
        ru = "мастер меча"
    }
    {
        en = "the Hammerer"
        ru = "Молотобоец"
    }
    {
        en = "the Furnacemaster"
        ru = "мастер по изготовлению печей"
    }
    {
        en = "the Metalcaster"
        ru = "Металлистка"
    }
    {
        en = "{%name%’s father was a smith, and that man’s father before him as well, so naturally, he was quick to pick up the trade. | When his father passed at a young age, %name% was forced to start providing for the family, taking up smithing to keep mouths fed. | %name%’s family sword was a priceless heirloom passed down from generations, but after it disappeared in a break-in, %name% turned to smithing to forge a new blade for his family to take pride in.} {But when a local nobleman was unhappy with a dagger he commissioned, he sent his men to put the smith’s shop to the torch. | Filled with wanderlust, he set out to join a mercenary company, determined not to wither away in the shop he’s spent his whole life in. | Yet when his father rose from the grave and the rest of the cemetery with him, %name% vowed to put his hammer to a more righteous cause.}  {He tells you he can forge a blade so sharp it can cut through stone. You don’t know about that, but a blacksmith of his experience would be a fit for any company. | The man’s muscled arms are proof enough that he’s no stranger to the hammer - perhaps you can help him put it to a new use. | It’s doubtful the man has swung a sword in his life. But he has a soldier’s build, and with the proper training, you think you can mold him into a true fighter. | While he may not be a fearsome warrior, a smith like him is always handy to have around. You just hope he’s as good at striking foes as he is at striking nails. | He figured a band a of mercenaries would suit him, and while he’s no swordmaster, the might of his hammer arm suggests he might be right.}"
        ru = "Его отец был кузнецом, как и отец этого человека до него, поэтому, естественно, он быстро освоил это ремесло. | Когда его отец скончался в юном возрасте, %имя% был вынужден начать обеспечивать семью, занявшись кузнечным делом, чтобы прокормить рты.  Фамильный меч %name% был бесценной реликвией, передававшейся из поколения в поколение, но после того, как он исчез во время взлома, %name% занялся кузнечным делом, чтобы выковать новый клинок, которым могла бы гордиться его семья.} {Но когда местный дворянин остался недоволен кинжалом, который он заказал, он послал своих людей сжечь мастерскую кузнеца. | Охваченный жаждой странствий, он решил присоединиться к компании наемников, решив не чахнуть в магазине, в котором провел всю свою жизнь. | И все же, когда его отец восстал из могилы, а вместе с ним и все остальные жители кладбища, %имя% поклялся направить свой молот на более праведное дело.}  {Он говорит вам, что может выковать такой острый клинок, что он может разрезать камень. Вы не знаете об этом, но кузнец с его опытом подойдет для любой компании. | Мускулистые руки этого человека являются достаточным доказательством того, что он не новичок в обращении с молотом - возможно, вы сможете помочь ему найти ему новое применение. | Сомнительно, что этот человек в своей жизни держал в руках меч. Но у него телосложение солдата, и при должной подготовке, как вы думаете, из него можно сделать настоящего бойца. | Пусть он и не является грозным воином, но такого кузнеца, как он, всегда удобно иметь рядом. Остается только надеяться, что он так же хорош в сражении с врагами, как и в забивании гвоздей. | Он решил, что банда наемников \"а\" ему подойдет, и хотя он не мастер меча, мощь его руки-молота говорит о том, что он, возможно, прав.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/bodyguard_background.nut
    {
        en = "Bodyguard"
        ru = "Телохранитель"
    }
    {
        en = "Bodyguards are burly men that specialize in keeping people of interest from being killed."
        ru = "Телохранители - это крепкие мужчины, которые специализируются на том, чтобы уберечь от гибели представляющих интерес людей."
    }
    {
        en = "the Bodyguard"
        ru = "телохранитель"
    }
    {
        en = "the Shield"
        ru = "щит"
    }
    {
        en = "the Meatshield"
        ru = "мясной щит"
    }
    {
        en = "the Giant"
        ru = "великан"
    }
    {
        en = "the Enforcer"
        ru = "исполнитель"
    }
    {
        en = "the Guard"
        ru = "охранник"
    }
    {
        en = "the Watchdog"
        ru = "сторожевой пес"
    }
    {
        en = "Часовой"
        ru = "часовой"
    }
    {
        en = "the Invincible"
        ru = "Непобедимый"
    }
    {
        en = "the Impenetrable"
        ru = "непроницаемый"
    }
    {
        en = "the Steadfast"
        ru = "непоколебимый"
    }
    {
        en = "the Stalwart"
        ru = "стойкий"
    }
    {
        en = "the Impregnable"
        ru = "Неприступный"
    }
    {
        en = "{The illegitimate son of a hedge knight, %name% was disowned by his father early in life for failing to inherit his 'killer's disposition'. What %name% did inherit, however, was his father's towering physical build. He attracted the attention of a local lord after hearing news of a bear of a man singlehandedly repelling a bandit attack, and was hired on as a personal bodyguard. %name% served him faithfully for many years, until the lord eventually passed peacefully of old age. Because the lord lacked an heir, the succession struggle was messy, and soon %name% turned to mercenary work, in search of other great men to shield from evil.}"
        ru = "{Незаконнорожденный сын межевого рыцаря, %name% в раннем возрасте был отвергнут своим отцом за то, что не смог унаследовать его \"характер убийцы\". Однако, %name% унаследовал от своего отца высокое телосложение. Он привлек внимание местного лорда, услышав новость о том, что человек-медведь в одиночку отразил нападение бандитов, и был нанят им в качестве личного телохранителя. %имя% служил ему верой и правдой много лет, пока лорд в конце концов мирно не скончался от старости. Поскольку у лорда не было наследника, борьба за престолонаследие была беспорядочной, и вскоре %name% обратился к наемничеству в поисках других великих людей, которые могли бы защитить его от зла.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/bounty_hunter_background.nut
    {
        en = "Bounty Hunter"
        ru = "охотник за головами"
    }
    {
        en = "Persistence is key. Bounty hunters are paid good coin to recover any human target, dead or alive."
        ru = "Упорство - это ключ к успеху. Охотникам за головами платят хорошие деньги за то, что они находят любую цель, живую или мертвую."
    }
    {
        en = "the Hunter"
        ru = "охотник"
    }
    {
        en = "the Bounty Hunter"
        ru = "охотник за головами"
    }
    {
        en = "the Relentless"
        ru = "безжалостный"
    }
    {
        en = "the Hound"
        ru = "гончая"
    }
    {
        en = "the Dog"
        ru = "собака"
    }
    {
        en = "the Eagle"
        ru = "орел"
    }
    {
        en = "the Reaper"
        ru = "Жнец"
    }
    {
        en = "the Persistent"
        ru = "настойчивый"
    }
    {
        en = "the Tracker"
        ru = "следопыт"
    }
    {
        en = "{%name%'s past is a mystery, as even those that have worked with him the past have seldom heard more than a few sentences unrelated to the task at hand. What is abundantly clear though, is that just as beast slayers specialize in eliminating the monstrosities of the world, so too does %name% the bounty hunter hunt monstrosities, specializing particularly in those that hide behind the mask of man. His line of work is already quite similar to a mercenary's; forking over the coin for a man like %name% would certainly be worthwhile for any reputable outfit.}"
        ru = "Прошлое {%name% - загадка, поскольку даже те, кто работал с ним в прошлом, редко слышали больше нескольких фраз, не имеющих отношения к текущей задаче. Однако совершенно очевидно, что точно так же, как убийцы зверей специализируются на уничтожении чудовищ этого мира, так и охотники за головами охотятся на чудовищ, особенно специализируясь на тех, кто скрывается под маской человека. Его работа и так очень похожа на работу наемника; раскошелиться на такого человека, как %name%, безусловно, стоило бы любой уважающей себя организации.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/carpenter_background.nut
    {
        en = "Carpenter"
        ru = "Плотник"
    }
    {
        en = "Carpenters can often be found in forest settlements, doing the critical work of converting logs to high quality planks."
        ru = "В лесных поселках часто можно встретить плотников, выполняющих важную работу по превращению бревен в высококачественные доски."
    }
    {
        en = "the Craftsman"
        ru = "мастер своего дела"
    }
    {
        en = "the Carpenter"
        ru = "плотник"
    }
    {
        en = "the Woodworker"
        ru = "столяр"
    }
    {
        en = "{From humble beginnings was raised a humble man. %name% the carpenter lived simply, taking up the fine work that his father and his grandfather had before. He and his older brother had made a great team. His brother had a much stronger build, and so chopped the wood that %name% would then cut into workable construction materials. One day %name%'s brother ventured into the forests to chop wood, but never returned in the evening. %name%, seeking answers, small in stature but not in bravery, now seeks to solve the mystery of his older brother once and for all.}"
        ru = "{Из скромного человека вырос скромный человек. %имя% плотник жил просто, занимаясь тонкой работой, которой раньше занимались его отец и дед. Он и его старший брат были отличной командой. У его брата было гораздо более крепкое телосложение, и он так умело рубил дрова, что их потом можно было использовать для изготовления строительных материалов. Однажды брат %name% отправился в лес нарубить дров, но вечером так и не вернулся. %имя%, ищущий ответы, маленький ростом, но не храбрый, теперь стремится раз и навсегда разгадать тайну своего старшего брата.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/cartographer_background.nut
    {
        en = "Cartographer"
        ru = "Картограф"
    }
    {
        en = "Cartographers specialize in the creation of accurate maps. Unlike historians, they have modest experience outdoors from their time spent travelling with supply caravans to map the landscape."
        ru = "Картографы специализируются на создании точных карт. В отличие от историков, у них есть небольшой опыт работы на открытом воздухе, поскольку они путешествовали с караванами продовольствия и составляли карты местности."
    }
    {
        en = "the Studious"
        ru = "прилежный"
    }
    {
        en = "the Cartographer"
        ru = "картограф"
    }
    {
        en = "the Mapmaker"
        ru = "Картограф"
    }
    {
        en = "the Sketcher"
        ru = "Рисовальщик"
    }
    {
        en = "the Observant"
        ru = "наблюдательный"
    }
    {
        en = "{Plagued by a chronic illness since birth, %name% was never able to grow to the health and constitution of even an average man. Unable to help his hometown defend itself by joining the militia, %name% was scorned by his peers. Aghast at the shame he felt he was bringing upon his family, he one day risked life and limb by charting the local area and discovering locations of bandit hideouts. This information proved critical in repelling the next raid, and jeers turned quickly to praise for %name%'s ability. Now he seeks to map places uncharted by man. He would be better suited to hire a mercenary band than join one; but nevertheless you muse that it would be nice to have another man with brains in the outfit.}"
        ru = "{Страдающий от хронической болезни с рождения, %name% так и не смог развить здоровье и телосложение обычного человека. Не имея возможности помочь своему родному городу защитить себя, вступив в ополчение, %name% подвергся презрению со стороны сверстников. Ошеломленный позором, который, по его мнению, он навлекал на свою семью, он однажды рисковал жизнью и здоровьем, составляя карту местности и обнаруживая места укрытий бандитов. Эта информация оказалась важной при отражении следующего набега, и насмешки быстро сменились похвалами за способности %name%. Теперь он стремится нанести на карту места, неизведанные человеком. Ему больше подошло бы нанять банду наемников, чем присоединиться к ней; но, тем не менее, вы думаете, что было бы неплохо иметь в команде еще одного человека с мозгами.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/champion_background.nut
    {
        en = "Champion"
        ru = "Чемпион"
    }
    {
        en = "Champions are knights that have gained renown as one on one fighters. Men of such repute are usually in the employ of noble houses and as such not typically in the market for mercenary work."
        ru = "Чемпионы - это рыцари, получившие известность как бойцы один на один. Люди с такой репутацией обычно работают в благородных домах и, как правило, не являются наемниками."
    }
    {
        en = "A man like %name% would always find a way. The hedge knight eventually, if not inevitably, left the company and set out on his own. Unlike many other brothers, he did not spend his crowns on land or ladders with which to climb the noble life. Instead, he bought himself the finest war horses and the talents of armorers. The behemoth of a man rode from one jousting tournament to the next, winning them all with ease. He's still at it to this day, and you think he won't stop until he's dead. The hedge knight simply knows no other life."
        ru = "Такой человек, как %name%, всегда найдет выход. Межевой рыцарь в конце концов, если не неизбежно, покинул компанию и начал самостоятельную жизнь. В отличие от многих других братьев, он не тратил свои кроны на земли или лестницы, по которым можно было бы подняться по карьерной лестнице. Вместо этого он купил себе лучших боевых коней и талантливых оружейников. Этот человек-гигант скакал от одного рыцарского турнира к другому, с легкостью выигрывая их все. Он продолжает это делать и по сей день, и вы думаете, что он не остановится, пока не умрет. Межевой рыцарь просто не знает другой жизни."
    }
    {
        en = "%name% the hedge knight eventually left the company. He traveled the lands, returning to his favorite past time of jousting, which was really a cover for his real favorite past time of lancing men off horses in a shower of splinters and glory. At some point, he was ordered to 'throw' a match against a pitiful and gangly prince to earn the nobleman some prestige. Instead, the hedge knight drove his lance through the man's skull. Furious, the lord of the land ordered the hedge knight killed. They say over a hundred soldiers took to his home and only half returned alive."
        ru = "%имя% межевой рыцарь в конце концов покинул компанию. Он путешествовал по землям, возвращаясь к своему любимому прошлому - рыцарским поединкам, которые на самом деле были прикрытием для его настоящего любимого прошлого, когда он сбрасывал людей с лошадей под градом осколков и славы. В какой-то момент ему было приказано \"устроить\" поединок с жалким и долговязым принцем, чтобы повысить престиж дворянина. Вместо этого межевой рыцарь пронзил своим копьем череп этого человека. Разъяренный лорд страны приказал убить межевого рыцаря. Говорят, более сотни солдат отправились к нему домой, и только половина вернулась живыми."
    }
    {
        en = "the Legendary"
        ru = "легендарный"
    }
    {
        en = "the Mighty"
        ru = "могущественный"
    }
    {
        en = "the Unbeatable"
        ru = "Непревзойденный"
    }
    {
        en = "the Undefeated"
        ru = "Непобедимый"
    }
    {
        en = "the Favorite"
        ru = "самый любимый"
    }
    {
        en = "the Champion"
        ru = "чемпион"
    }
    {
        en = "the Steady"
        ru = "устойчивый"
    }
    {
        en = "the Mountain"
        ru = "гора"
    }
    {
        en = "Strongface"
        ru = "Сильное лицо"
    }
    {
        en = "the Unbreakable"
        ru = "нерушимый"
    }
    {
        en = "the Knightslayer"
        ru = "рыцарь-истребитель"
    }
    {
        en = "{Some say that there are but two types of men: those that know no defeat whose deeds invariably become the stuff of legends, and completely irrelevant milkdrinkers. Regardless of the veracity of this little idiom, one look at %name% and it is abundantly clear which class he would fall into. Despite his relative youth, %name% has already spent several years as a combat instructor at the local training hall. Why he wants to join a mercenary company now is unclear. You look at his desired wages and almost burst out laughing. All %name% has to say is that he is willing to take a pay cut if it means experiencing adventure again.}"
        ru = "{Некоторые говорят, что есть только два типа людей: те, кто не знает поражений, чьи деяния неизменно становятся легендами, и совершенно неуместные любители молока. Независимо от правдивости этой маленькой идиомы, достаточно взглянуть на %name%, и становится совершенно ясно, к какому классу он относится. Несмотря на свою относительную молодость, %name% уже несколько лет работает инструктором по боевым искусствам в местном тренировочном зале. Непонятно, почему он хочет присоединиться к компании наемников именно сейчас. Вы смотрите на его желаемую зарплату и чуть не лопаетесь от смеха. Все, что %name% может сказать, это то, что он готов пойти на сокращение зарплаты, если это позволит ему снова испытать приключения.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/cobbler_background.nut
    {
        en = "Cobbler"
        ru = "Сапожник"
    }
    {
        en = "Cobblers are humble folk making a living by crafting footwear of all kinds."
        ru = "Сапожники - это скромные люди, зарабатывающие на жизнь изготовлением всевозможной обуви."
    }
    {
        en = "the Shoemaker"
        ru = "сапожник"
    }
    {
        en = "the Cobbler"
        ru = "сапожник"
    }
    {
        en = "the Shoemender"
        ru = "сапожник"
    }
    {
        en = "the Cordwainer"
        ru = "мастер по изготовлению шнуров"
    }
    {
        en = "Bootsmith"
        ru = "Сапожный мастер"
    }
    {
        en = "Shoesmith"
        ru = "Сапожник"
    }
    {
        en = "{%name% the cobbler, much like the vast majority of peasants, has no interesting backstory. When you ask why he wishes to become a mercenary, he simply shrugs his shoulders, and mumbles something to the effect of shoemaking not making enough coin. Your eyebrows raise in surprise; his asking salary is pretty low as it is, so you accurately surmise that shoemaking is not the best craft to invest into.}"
        ru = "{%имя% у сапожника, как и у подавляющего большинства крестьян, нет интересной предыстории. Когда вы спрашиваете, почему он хочет стать наемником, он просто пожимает плечами и бормочет что-то вроде того, что сапожничество не приносит достаточно денег. Ваши брови удивленно поднимаются; его зарплата и так довольно низкая, так что вы безошибочно догадываетесь, что сапожное дело - не лучшее ремесло для инвестиций.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/con_artist_background.nut
    {
        en = "Con Artist"
        ru = "Мошенник"
    }
    {
        en = "Con artists make their living by swindling other folks. Those astute enough to realize when they are pressing their luck often turn to mercenary work to begin anew."
        ru = "Мошенники зарабатывают на жизнь, обманывая других людей. Те, кто достаточно проницателен, чтобы понять, что им не везет, часто прибегают к наемничеству, чтобы начать все сначала."
    }
    {
        en = "the Con Artist"
        ru = "мошенник"
    }
    {
        en = "the Scammer"
        ru = "мошенник"
    }
    {
        en = "Two Face"
        ru = "Двуликий"
    }
    {
        en = "the Trickster"
        ru = "обманщик"
    }
    {
        en = "the Thief"
        ru = "вор"
    }
    {
        en = "the Untrustworthy"
        ru = "ненадежные"
    }
    {
        en = "the Cheat"
        ru = "мошенник"
    }
    {
        en = "the Hustler"
        ru = "мошенник"
    }
    {
        en = "{%name% the con artist eyes you nervously as you approach. Before you can a word out he exclaims that he doesn't owe you any money and that any purchases made were final. As it turns out, the scammer has been on the run for so long and from so many people that for a moment you begin to wonder if he really DOES owe you cash. He has a dangerous, desperate look in his eyes, and is undoubtedly looking for a mercenary crew for some protection. You know little else of his background, but what else is even relevant to know?"
        ru = "{%имя% мошенник нервно смотрит на вас, когда вы приближаетесь. Прежде чем вы успеваете произнести хоть слово, он восклицает, что не должен вам никаких денег и что все сделанные покупки являются окончательными. Как выясняется, мошенник скрывался так долго и от стольких людей, что на мгновение вы начинаете сомневаться, действительно ли он должен вам наличные. У него опасный, отчаянный взгляд, и он, несомненно, ищет команду наемников для защиты. Вы мало что еще знаете о его прошлом, но что еще стоит знать?"
    }
    // FILE: scripts/skills/backgrounds/hackflows/cook_background.nut
    {
        en = "Cook"
        ru = "Готовить"
    }
    {
        en = "Cooks have little combat or travel experience, having spent most of their careers indoors preparing delicious meals for the local nobility."
        ru = "У поваров мало боевого опыта или опыта путешествий, поскольку большую часть своей карьеры они провели в помещении, готовя вкусные блюда для местной знати."
    }
    {
        en = "the Cook"
        ru = "повар"
    }
    {
        en = "the Chef"
        ru = "шеф-повар"
    }
    {
        en = "the Fat"
        ru = "жирный"
    }
    {
        en = "the Jolly"
        ru = "веселый"
    }
    {
        en = "{%name% the cook has always liked food. Once, during better times, a local lord contributed several delicacies to a peasant holiday. Upon sampling the baked treats, %name% was so overcome with emotion that he begged the lord to allow his chef to accept him as an understudy, so that he may bring smiles to other poor folk in the future. The gracious nobleman accepted, and for a time %name% spent happy years honing his craft. Sadly, after being caught sampling food from the larder during times of hardship, %name% has been kicked to the curb. Oddly enough, this hasn't seemed to bother the cook very much. He now seeks mercenary work so that he 'doesn't have to be so damn hungry all the time.'}"
        ru = "{%имя% повар всегда любил вкусно поесть. Однажды, в лучшие времена, местный лорд принес несколько деликатесов на крестьянский праздник. Попробовав испеченные угощения, %name% был настолько переполнен эмоциями, что молил господа позволить своему шеф-повару взять его в качестве дублера, чтобы в будущем он мог дарить улыбки другим беднякам. Милостивый вельможа согласился, и какое-то время он провел, оттачивая свое мастерство. К сожалению, после того, как его застукали за дегустацией продуктов из кладовой в трудные времена, он был отправлен на тот свет. Как ни странно, это, похоже, не слишком обеспокоило повара. Теперь он ищет работу наемника, чтобы \"не быть все время таким чертовски голодным\".}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/dissenter_background.nut
    {
        en = "Dissenter"
        ru = "Несогласный"
    }
    {
        en = "Dissenters have trouble keeping their mouths shut, seeking mercenary work as a means to escape a grisly end at the hands of goons hired by the targets of their denunciations."
        ru = "Несогласным трудно держать язык за зубами, они ищут работу наемника, чтобы избежать ужасного конца от рук головорезов, нанятых теми, на кого они доносят."
    }
    {
        en = "the Dissenter"
        ru = "несогласный"
    }
    {
        en = "the Loudmouth"
        ru = "этот крикун"
    }
    {
        en = "the Disagreeable"
        ru = "неприятный"
    }
    {
        en = "Sharptongue"
        ru = "Острый язык"
    }
    {
        en = "Справедливый"
        ru = "справедливый"
    }
    {
        en = "{After watching his father executed without trial for a crime he didn't commit and his mother burned at the stake because of a bogus accusation, %name% the dissenter's heart has been filled with nothing but absolute hatred for nobility. Lacking the strength or skill to kill kings himself, his spends his time shouting for the peasantry to rise up and overthrow the existing political order. However, his vocalizations have largely fallen on deaf ears. You surmise that the reason %name% yet lives is that no one important takes him as a serious threat. As if reading your mind, the dissenter tells you that THAT is the exact reason he is looking to join a mercenary band.}"
        ru = "{После того, как его отца казнили без суда и следствия за преступление, которого он не совершал, а мать сожгли на костре по ложному обвинению, %имя% сердце диссидента наполнилось абсолютной ненавистью к знати. Не имея сил или навыков, чтобы самому убивать королей, он проводит время, призывая крестьян восстать и свергнуть существующий политический порядок. Однако его выступления в основном остаются без внимания. Вы предполагаете, что причина, по которой %name% все еще жив, заключается в том, что никто из важных персон не воспринимает его как серьезную угрозу. Словно читая ваши мысли, несогласный говорит вам, что именно по этой причине он хочет присоединиться к банде наемников.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/drifter_background.nut
    {
        en = "Drifter"
        ru = "Бродяга"
    }
    {
        en = "For one reason or another, drifters lack any city to call home, finding themselves wandering from place to place and doing odd jobs to keep themselves fed."
        ru = "По той или иной причине у бродяг нет города, который они могли бы назвать своим домом, и они скитаются с места на место, занимаясь случайными заработками, чтобы прокормиться."
    }
    {
        en = "Having enough of all the fighting, %name% the once-drifter retired from the %companyname%. You know the man made a pretty crown in his time with the mercenary company, yet the other day you saw him out begging again. You asked if he'd wasted all his money and he laughed. He said he'd purchased land and was doing just fine. Then he held out his little tin and asked for a crown. You gave him two."
        ru = "Вдоволь натерпевшись от всех этих сражений, %name%, бывший бродяга, уволился из %companyname%. Вы знаете, что этот человек неплохо заработал за время службы в компании наемников, но на днях вы снова увидели его попрошайничающим. Вы спросили, не растратил ли он все свои деньги, и он рассмеялся. Он сказал, что купил землю и у него все хорошо. Затем он протянул свою маленькую жестянку и попросил крону. Вы дали ему две."
    }
    {
        en = "the Drifter"
        ru = "бродяга"
    }
    {
        en = "the Dirty"
        ru = "грязный"
    }
    {
        en = "Изгой"
        ru = "Изгой"
    }
    {
        en = "Fleetfoot"
        ru = "Быстроногий"
    }
    {
        en = "the Wanderer"
        ru = "странник"
    }
    {
        en = "the Homeless"
        ru = "бездомные"
    }
    {
        en = "{The third child born to a modest merchant family, %name% spent much of his early life idly wasting time with trivial pursuits. When his father died, %name%'s older brother took over the family business, leaving %name% with a chunk of change to spend. Lacking direction in his life, %name% has since been wandering around in search of purpose. The man has a bit of an empty gaze. No matter. Your band has seen less able men join the shield wall.}"
        ru = "{Третий ребенок, родившийся в скромной семье торговца, %name% провел большую часть своей ранней жизни, праздно тратя время на тривиальные занятия. Когда его отец умер, старший брат %name% возглавил семейный бизнес, оставив %name% немного мелочи на расходы. Не имея направления в своей жизни, %name% с тех пор бродит в поисках цели. У этого человека немного пустой взгляд. Неважно. Ваша группа видела, как менее способные люди присоединялись к стене щитов.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/druid_background.nut
    {
        en = "Druid"
        ru = "Друид"
    }
    {
        en = "Druids are men that are more in tune with mystic forces than the average layman."
        ru = "Друиды - это люди, которые больше ориентируются в мистических силах, чем среднестатистический обыватель."
    }
    {
        en = "the Druid"
        ru = "друид"
    }
    {
        en = "the Mystic"
        ru = "мистик"
    }
    {
        en = "the Mysterious"
        ru = "таинственный"
    }
    {
        en = "the Nature Spirit"
        ru = "дух природы"
    }
    {
        en = "the Channeler"
        ru = "направляющий"
    }
    {
        en = "the Arcane"
        ru = "тайный"
    }
    {
        en = "{The tattoos and runes printed upon %name% the druid's body make him quite a sight to behold in town. Raised in the wild from birth, yet not entirely lacking the mannerisms of civilized man, %name%'s past is shrouded in mystery. The man informs you of that he is seeking mercenary work, for a druidic prophecy foretold that a band of brothers would one day face hordes of untold horrors. You aren't sure if you should hire him or not; either way his message is deeply unsettling.}"
        ru = "{Татуировки и руны, нанесенные на тело %name% друида, делают его настоящим зрелищем в городе. Выросший в дикой природе с рождения, но не лишенный манер цивилизованного человека, %name% в прошлом окутан тайной. Этот человек сообщает вам, что ищет работу наемника, поскольку пророчество друидов предсказывало, что однажды группа братьев столкнется с полчищами неописуемых ужасов. Вы не уверены, стоит ли вам нанимать его или нет; в любом случае его сообщение вызывает глубокое беспокойство.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/falconer_background.nut
    {
        en = "Falconer"
        ru = "Сокольничий"
    }
    {
        en = "Falconers, as the name suggests, have mastery of falcons."
        ru = "Сокольничие, как следует из названия, в совершенстве владеют соколами."
    }
    {
        en = "While the %companyname% continued on with great success, %name% the falconer eventually saw fit to leave it all behind. He returned to the forests, starting an aviary of trained falcons. All told, his experience as a mercenary didn't change his demeanor; %name% and his falcons transitioned smoothly from hunting men back to hunting beasts."
        ru = "В то время как %companyname% продолжала работать с большим успехом, %name% сокольничий в конце концов счел нужным оставить все это позади. Он вернулся в леса и завел вольер с дрессированными соколами. В целом, его опыт наемника не изменил его поведения; %name% и его соколы плавно перешли от охоты на людей к охоте на зверей."
    }
    {
        en = "With the decline of the %companyname% readily obvious, %name% the falconer departed from the company and returned to falconry. Unfortunately, he fell upon hard times and was forced to sell his prized birds to make ends meet. Last you heard, the decision drove him mad and he wandered off into the forest, never to be seen again."
        ru = "С приходом %companyname% в упадок, %name% сокольничий ушел из компании и вернулся к соколиной охоте. К сожалению, для него настали трудные времена, и он был вынужден продать своих ценных птиц, чтобы свести концы с концами. Последнее, что вы слышали, это решение свело его с ума, и он ушел в лес, и больше его никто не видел."
    }
    {
        en = "the Falconer"
        ru = "Сокольничий"
    }
    {
        en = "the Birdmaster"
        ru = "Повелитель птиц"
    }
    {
        en = "the Falconmaster"
        ru = "Соколиный мастер"
    }
    {
        en = "the Woodsman"
        ru = "лесник"
    }
    {
        en = "Eagle Eye"
        ru = "Орлиный глаз"
    }
    {
        en = "the Scoutmaster"
        ru = "вожатый скаутов"
    }
    {
        en = "Наблюдатель"
        ru = "наблюдатель"
    }
    {
        en = "Can release falcons for no AP cost"
        ru = "Может выпускать соколов бесплатно."
    }
    {
        en = "Falcons released by the falconer reveal 16 tiles distance instead of 12"
        ru = "Соколы, выпущенные сокольничим, показывают расстояние в 16 плиток вместо 12"
    }
    {
        en = "{%name% always had a fascination with avian creatures. Little did he know, this fascination would one day become his niche on the battlefield. | %name%'s father was a skilled hunter. Though %name% didn't share quite the same aptitude with the bow, his skill with birds made him an invaluable hunting companion. | Early in his life, %name% liked to traipse about the forests. Once, he chanced upon an injured falcon and took it under his wing. Since then, %name% has become a master of dealing with avian creatures.} {The falconer eventually realized that his knack for scouting for beasts in the forests could be just as easily applied to scouting enemy formations. | When a misplaced target callout led to a fellow woodsman being shot in the neck, %name% knew his career as a conventional falconer was over. | Sadly, a bad hunting season forced the birdmaster into seeking other means of income. | War drove the game out of the forests, and with them, %name%. Now he seeks another line of work.} {Any outfit could use an eagle eye such as this man. | Despite his humble backgrounds, %name% has already proven to be a valuable scout in many a noble war. | %name%'s falcon is perched majestically atop his shoulder. It is clear that the two are extensions of each other. | %name% looks like he has something to prove - his sharp eyes and nimble movements may prove useful on the battlefield yet. | The falcon atop his shoulder has steely eyes; you suspect that it has seen many more battles from above than the average wannabe mercenary.}"
        ru = "{%name% всегда увлекался птицами. Он и не подозревал, что однажды это увлечение займет его нишу на поле боя. | %name% его отец был опытным охотником. Хотя %name% не обладал такими же способностями к стрельбе из лука, его умение обращаться с птицами сделало его бесценным спутником на охоте. | В начале своей жизни %name% любил бродить по лесам. Однажды он случайно увидел раненого сокола и взял его под свое крыло. С тех пор %name% стал мастером обращения с птицами.} {Сокольничий в конце концов понял, что его умение выслеживать зверей в лесах можно с таким же успехом применить для разведки вражеских формирований. | Когда неудачный выбор цели привел к тому, что его коллега-лесник был ранен в шею, %name% понял, что его карьере обычного сокольничего пришел конец. | К сожалению, неудачный сезон охоты вынудил птицелова искать другие источники дохода. | Война вытеснила дичь из лесов, а вместе с ней и %name%. Теперь он ищет другую работу.} {Такому орлиному взгляду, как у этого человека, не помешал бы любой наряд. | Несмотря на свое скромное происхождение, %name% уже зарекомендовал себя как ценный разведчик во многих благородных войнах. | Сокол %name% величественно восседает у него на плече. Очевидно, что эти двое являются продолжением друг друга. | %имя% похоже, ему есть что доказывать - его острый взгляд и ловкие движения еще могут пригодиться на поле боя. | У сокола на его плече стальные глаза; вы подозреваете, что он повидал гораздо больше сражений сверху, чем обычный наемник-подражатель.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/fletcher_background.nut
    {
        en = "Fletcher"
        ru = "Флетчер"
    }
    {
        en = "Fletchers are the counterpart of bowyers, specializing in making and selling arrows."
        ru = "Флетчеры - это аналог лучников, специализирующихся на изготовлении и продаже стрел."
    }
    {
        en = "the Arrowmaker"
        ru = "мастер по изготовлению стрел"
    }
    {
        en = "the Arrow Seller"
        ru = "продавец стрел"
    }
    {
        en = "{A man of humble origins, %name% found a talent early on for crafting ammunition and has been at it ever since. Fortunately for him, the war and strife in the world had hitherto given him plenty of work. Despite this, %name% always felt that there was more to see in the world. You aren't sure if the man will be able to make a name for himself in the history books, but he should know his way around a bow, at the very least.}"
        ru = "{Человек скромного происхождения, %имя% рано обнаружил в себе талант к изготовлению боеприпасов и с тех пор занимается этим делом. К счастью для него, война и раздоры в мире до сих пор давали ему много работы. Несмотря на это, %name% всегда считал, что в мире есть на что посмотреть. Вы не уверены, сможет ли этот человек сделать себе имя в учебниках истории, но, по крайней мере, он должен уметь обращаться с луком.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/folk_hero_background.nut
    {
        en = "Folk Hero"
        ru = "Народный герой"
    }
    {
        en = "Folk heroes are commoners that have achieved great heights, earning the admiration of the peasantry and begrudging respect of knights with their mythical deeds."
        ru = "Народные герои - это простолюдины, которые достигли больших высот, заслужив восхищение крестьянства и уважение рыцарей своими мифическими подвигами."
    }
    {
        en = "Герой"
        ru = "герой"
    }
    {
        en = "Легенда"
        ru = "легенда"
    }
    {
        en = "the Folk Hero"
        ru = "народный герой"
    }
    {
        en = "Львиное сердце"
        ru = "Львиное сердце"
    }
    {
        en = "the Magnanimous"
        ru = "великодушный"
    }
    {
        en = "the Storied"
        ru = "легендарный"
    }
    {
        en = "the Humble"
        ru = "скромный"
    }
    {
        en = "{Some say that men are born into their stations, destined either for great things or utter medocrity by the circumstances of their birth. %name% is a picture perfect contradiction of this mantra. Towering well over six feet tall, %name% exudes an aura of pure strength, but carries himself with a dignified reserve. Nearby peasants whisper amongst themselves in excited tones. Evidently, despite being born in abject poverty and orphaned early in life, %name% eventually became something of a folk hero, with feats including but not limited to facing a band of 20 brigands on his own and emerging victorious. As you ask him to separate the fact from fiction of this paricular myth, without looking up from his mug, he merely replies, '25'.}"
        ru = "{Некоторые говорят, что люди рождаются в соответствии со своим положением, и обстоятельства их рождения предопределяют их либо к великим свершениям, либо к полной бездарности. %имя% - идеальное противоречие этой мантре. Возвышаясь более чем на шесть футов, %name% излучает ауру чистой силы, но держится с достоинством. Крестьяне поблизости возбужденно перешептываются между собой. Очевидно, что, несмотря на то, что %name% родился в крайней нищете и рано осиротел, он со временем стал кем-то вроде народного героя, совершив подвиги, в том числе, в одиночку столкнулся с бандой из 20 разбойников и вышел победителем. Когда вы просите его отделить факты от вымысла в этом конкретном мифе, он, не отрываясь от своей кружки, просто отвечает: \"25\".}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/gardener_background.nut
    {
        en = "Gardener"
        ru = "Садовник"
    }
    {
        en = "Gardeners are men with green thumbs often hired by noblemen to maintain extravant gardens as status symbols."
        ru = "Садовники - это люди с большими пальцами на руках, которых аристократы часто нанимают для ухода за экстравагантными садами в качестве символов статуса."
    }
    {
        en = "the Gardener"
        ru = "садовник"
    }
    {
        en = "Green Thumbed"
        ru = "Зеленый палец"
    }
    {
        en = "the Caretaker"
        ru = "смотритель"
    }
    {
        en = "{A somewhat meek individual by nature, %name% spent much of his life tending to the gardens in the lavish castles of higher nobility. When the lord's wife became pregnant while he was out on campagin, the household required a scapegoat. Poor %name% drew the short straw, and lacking the courage to prove his innocence, fled the estate. He does seem a bit more timid to you than normal, but nonetheless carries himself like an outdoorsman.}"
        ru = "{Скромный по натуре, %имя% провел большую часть своей жизни, ухаживая за садами в роскошных замках высшей знати. Когда жена лорда забеременела, когда он был в походе, домочадцам потребовался козел отпущения. Бедняга %имя% вытянул короткую соломинку и, не имея мужества доказать свою невиновность, сбежал из поместья. Он действительно кажется вам немного более робким, чем обычно, но, тем не менее, ведет себя как настоящий турист.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/hangman_background.nut
    {
        en = "Hangman"
        ru = "Палач"
    }
    {
        en = "Hangmen are no strangers to death, but also have not seen it dealt in the myriad of sloppy methods out on the battlefield."
        ru = "Палачи не понаслышке знакомы со смертью, но и не видели, как с ней расправляются множеством небрежных методов на поле боя."
    }
    {
        en = "A former militiaman such as %name% eventually left the %companyname%. He traveled the lands, visiting villages and helping them establish credible militias with which to defend themselves. Finding success in an increasingly dangerous world, %name% eventually came to be a known name, called upon as a sort of 'fixer' to come and ensure these villages would remain safe. Last you heard, he's purchased a plot of land and was raising a family far from the strife of the world."
        ru = "Бывший ополченец, такой как %name%, в конце концов покинул %companyname%. Он путешествовал по стране, посещая деревни и помогая им создавать надежные ополчения, с помощью которых они могли бы защитить себя. Добившись успеха во все более опасном мире, %name% в конце концов стал известным человеком, которого призвали в качестве своего рода \"посредника\", который должен был прийти и обеспечить безопасность этих деревень. Последнее, что вы слышали, - он купил участок земли и растит семью вдали от мирской суеты."
    }
    {
        en = "%name% left the collapsing company and returned to his village. Back in the militia, it wasn't long until {greenskins | raiders} attacked and he was called to action. It's said that he stood tall, rallying the defense as he slew through countless enemies before succumbing to mortal wounds. When you visited the village, you found children playfighting beneath a statue made in the militiaman's image."
        ru = "%имя% покинул разваливающуюся компанию и вернулся в свою деревню. Вернувшись в ополчение, он вскоре был атакован {зеленокожими | рейдерами}, и его призвали к действию. Говорят, что он стоял во весь рост, сплачивая оборону, убивая бесчисленных врагов, прежде чем погибнуть от смертельных ран. Когда вы посетили деревню, вы увидели, как дети играют в драку под статуей, выполненной в виде ополченца."
    }
    {
        en = "the Hangman"
        ru = "палач"
    }
    {
        en = "the Executioner"
        ru = "палач"
    }
    {
        en = "the Lever Arm"
        ru = "рычаг рычага"
    }
    {
        en = "the Last Word"
        ru = "последнее слово"
    }
    {
        en = "the Cold"
        ru = "холод"
    }
    {
        en = "{With a past as a coroner, %name% is and always has been unperturbed by the sight of death. Once, when in his town the local peasantry were looking to lynch a grave robber, %name% volunteered to pull the lever. Transitioning from examining dead bodies to creating them didn't weight heavily on %name%'s conscience, and soon enough he became the town hangman. %name% returns your gaze with a cold expression and the eyes of a dead fish, stating simply that if acting the executioner could not stir his emotions, perhaps the heat of battle would.}"
        ru = "{В прошлом коронер, %name% всегда был невозмутим при виде смерти. Однажды, когда в его городе местные крестьяне хотели линчевать грабителя могил, %name% вызвался потянуть за рычаг. Переход от изучения мертвых тел к их созданию не сильно повлиял на совесть %name%, и довольно скоро он стал городским палачом. %name% возвращает вашему взгляду холодное выражение и глаза мертвой рыбы, просто заявляя, что если игра палача не смогла пробудить в нем эмоции, то, возможно, это сделает пылкость битвы.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/herbalist_background.nut
    {
        en = "Herbalist"
        ru = "Травник"
    }
    {
        en = "Herbalists are capable of recognizing the medicinal properties of a plethora of plant life. They produce salves and creams that relieve pain and discomfort."
        ru = "Травники способны распознать целебные свойства множества растений. Они производят мази и кремы, которые снимают боль и дискомфорт."
    }
    {
        en = "Perhaps one of the sharpest men you've ever met, %name% the apprentice was the quickest learner in the %companyname%. With plenty of crowns stored, he retired from fighting to take his talents to the business world. Last you heard he was doing very well for himself across multiple trades. If you ever have a son, this is the man you'll send him to for apprenticeship."
        ru = "Возможно, один из самых сообразительных людей, которых вы когда-либо встречали, %name% подмастерье был самым способным учеником в %companyname%. Накопив достаточно денег, он отошел от боевых действий, чтобы проявить свои таланты в мире бизнеса. Последнее, что вы слышали, - это то, что он преуспевает в нескольких профессиях. Если у вас когда-нибудь будет сын, отдайте его в ученики к этому человеку."
    }
    {
        en = "%name% the apprentice was, by far, the quickest learner in the %companyname%. Little surprise then that he was also one of the quickest to recognize its inevitable downfall and leave while he still could. Had he been born in a different time he would have gone on to do great things. Instead, many wars, invasions, and plagues spreading across the land ultimately ensured %name% and many other talented men went to total waste."
        ru = "%name% ученик, безусловно, был самым способным учеником в %companyname%. Неудивительно, что он также одним из первых осознал неизбежный крах компании и ушел, пока еще мог. Родись он в другое время, он бы продолжал творить великие дела. Вместо этого многочисленные войны, нашествия и эпидемии, распространившиеся по стране, в конечном итоге привели к тому, что %name% и многие другие талантливые люди были полностью уничтожены."
    }
    {
        en = "the Herbalist"
        ru = "травник"
    }
    {
        en = "the Apothecary"
        ru = "аптекарь"
    }
    {
        en = "the Naturalist"
        ru = "натуралист"
    }
    {
        en = "the Medicine Man"
        ru = "Знахарь"
    }
    {
        en = "the Healer"
        ru = "Целитель"
    }
    {
        mode = "pattern"
        en = "[color=<this.Const.UI.Color.PositiveValue>]+10%[/color] Experience Gain"
        ru = "[color=<это.Const.UI.Color.Положительное значение>][/color] Прибавка к опыту на 10%."
    }
    {
        en = "{The natural world hides incredible bounties, if one just knows where to look. %name% is one such man. His father was a soldier purported to survive wounds accrued over a hundred battles. This legend sprouted from the effective healing ointments and disinfecting salves produced by %name%'s mother. With both his parents having since died of old age, %name% hopes to use the secret remedies passed down to him to spark tales of an invincible mercenary company.}"
        ru = "{Мир природы таит в себе невероятные богатства, если только знать, где искать. %имя% - один из таких людей. Его отец был солдатом, который, как утверждалось, выжил после ранений, полученных в сотнях сражений. Эта легенда возникла из-за эффективных заживляющих и дезинфицирующих мазей, изготовленных матерью %name%. Поскольку оба его родителя умерли от старости, %name% надеется использовать секретные средства, переданные ему по наследству, чтобы возродить легенды о непобедимом отряде наемников.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/lancer_background.nut
    {
        en = "Lancer"
        ru = "Улан"
    }
    {
        en = "Lancers, true to their namesake, are extremely proficient with lances and polearms. Though they perfom well in jousting tournaments, in terms of general combat hardiness they fall short of true knights."
        ru = "Копьеносцы, как и их тезки, чрезвычайно искусно владеют копьями и древковым оружием. Хотя они хорошо выступают на рыцарских турнирах, в плане общей боевой выносливости они уступают настоящим рыцарям."
    }
    {
        en = "the Lancer"
        ru = "Копьеносец"
    }
    {
        en = "the Lance"
        ru = "копье"
    }
    {
        en = "the Jouster"
        ru = "рыцарь"
    }
    {
        en = "the Spearman"
        ru = "Копейщик"
    }
    {
        en = "the Child of Light"
        ru = "дитя света"
    }
    {
        en = "the Stabber"
        ru = "тот, кто нанес удар ножом"
    }
    {
        en = "{Having received special combat training in his youth, %name% used his spear proficiency to earn his living by entering and winning jousting tournaments. Yet as time went on the lancer felt the glory in the jousting ring to be incomplete. Now he seeks to make a name for himself in no holds barred combat.}"
        ru = "{Получив в юности специальную боевую подготовку, %имя% использовал свое мастерство владения копьем, чтобы зарабатывать себе на жизнь, участвуя в рыцарских турнирах и побеждая в них. Однако со временем копьеносец почувствовал, что слава на рыцарском ринге была неполной. Теперь он стремится сделать себе имя в бескомпромиссных боях.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/leper_background.nut
    {
        en = "Leper"
        ru = "Прокаженный"
    }
    {
        en = "Lepers are shunned from society for their ghastly appearance, but also benefit from a general lack of sensation."
        ru = "Прокаженных избегают в обществе из-за их ужасного внешнего вида, но они также выигрывают от общего отсутствия чувствительности."
    }
    {
        en = "the Leper"
        ru = "прокаженный"
    }
    {
        en = "the Ragged"
        ru = "оборванный"
    }
    {
        en = "the Sick"
        ru = "больные"
    }
    {
        en = "the Damned"
        ru = "проклятый"
    }
    {
        en = "the Unlucky"
        ru = "невезучие"
    }
    {
        en = "the Blighted"
        ru = "опустошенный"
    }
    {
        en = "{In his youth, %name% was a charmer full of panache, popular with every maiden in his village. | Coming from a long line of butchers, %name% never doubted that he would follow in his family's footsteps. | %name%’s life was an uneventful one - he was a simple man, making a modest living as a subsistence farmer.} {But after contracting a deadly plague, the man’s skin was left peeling and his face deformed. | Yet after a fateful day he blames on some woman he lay with, a horrible illness befell him, leaving his flesh decayed and numb. | It seemed his life would continue that way, but after mysterious symptoms started sprouting and his skin began to crumble, the people he once knew rejected him as a freak.} {Spurned from every other profession, the life of a mercenary was the only one left for him to turn to. You doubt it’ll be a successful life path for him, but it can’t be much worse than before. | He tells you he once fought off two children who pelted rocks at him as if you’ll be in respect of the feat. Considering the state he’s in now, you almost are. | Skin covered, voice hoarse, and arms weak, the man looks about as much of a mercenary as your grandmother. Just a bit less fierce. | You almost don’t feel right bringing the man into your ranks. But, who else to catch the arrows? | You doubt %name% will fit in a shieldwall, nor a pike line. Maybe he can be your mascot.}"
        ru = "{В юности %name% был очаровательным человеком, полным щегольства, и нравился каждой девушке в своей деревне. | Происходя из длинного рода мясников, %name% никогда не сомневался, что пойдет по стопам своей семьи.  Жизнь | %name% была небогата событиями - он был простым человеком, скромно зарабатывавшим на жизнь, занимаясь натуральным хозяйством.} {Но после заражения смертельной чумой кожа мужчины начала шелушиться, а его лицо исказилось. | И все же после рокового дня, в котором он винит какую-то женщину, с которой спал, его постигла ужасная болезнь, в результате чего его плоть истлела и онемела.  Казалось, что так и будет продолжаться, но после того, как у него появились загадочные симптомы и кожа начала осыпаться, люди, которых он когда-то знал, отвергли его как ненормального.} {Отвергнутый всеми остальными профессиями, он остался жить только в качестве наемника. Вы сомневаетесь, что это будет успешный жизненный путь для него, но он не может быть намного хуже, чем раньше. | Он рассказывает вам, что однажды отбился от двух детей, которые бросали в него камни, как будто вы будете уважать его подвиг. Учитывая, в каком состоянии он сейчас, ты почти такой же. | Покрытый испариной, с хриплым голосом и слабыми руками, этот человек выглядит таким же наемником, как и твоя бабушка. Только чуть менее свирепым. | Ты почти не чувствуешь себя вправе принимать этого человека в свои ряды. Но кто еще сможет ловить стрелы? | Ты сомневаешься, что %имя% поместится ни в стене щитов, ни в леске для ловли щуки. Возможно, он может стать твоим талисманом.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/locksmith_background.nut
    {
        en = "Locksmith"
        ru = "Слесарь"
    }
    {
        en = "Locksmiths are men handy to have around when brute force isn't enough to crack open a door, catacomb, or treasure chest."
        ru = "Слесари - это люди, которых удобно иметь рядом, когда грубой силы недостаточно, чтобы взломать дверь, катакомбы или сундук с сокровищами."
    }
    {
        en = "the Keymaster"
        ru = "ключник"
    }
    {
        en = "the Locksmith"
        ru = "слесарь"
    }
    {
        en = "the Keymaker"
        ru = "создатель ключей"
    }
    {
        en = "Lightfingered"
        ru = "Легким движением пальцев"
    }
    {
        en = "the Lockpicker"
        ru = "взломщик замков"
    }
    {
        en = "the Nimble"
        ru = "проворный"
    }
    {
        en = "{As a locksmith by trade, %name% has always had a knack for breaking open hard to open doors, chests, or vaults to reveal the hidden treasures inside. However, when hard times struck his hometown %name% found a shortage of things worth cracking open. Now he seeks to join a mercenary troop, seeking to use his skills to uncover undiscovered riches hidden away in the wilderness.}"
        ru = "{Будучи по профессии слесарем, %name% всегда умел взламывать двери, сундуки или хранилища, чтобы обнаружить спрятанные внутри сокровища. Однако, когда в его родном городе настали трудные времена, %name% обнаружил нехватку вещей, которые стоило бы вскрыть. Теперь он стремится присоединиться к отряду наемников, стремясь использовать свои навыки для поиска нераскрытых богатств, спрятанных в дикой местности.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/master_archer_background.nut
    {
        en = "Master Archer"
        ru = "Мастер-лучник"
    }
    {
        en = "Master archers have spent their lives honing their abilities. Though they are extremely talented marksmen, they are incompetent melee fighters."
        ru = "Лучники-мастера всю свою жизнь оттачивали свои способности. Хотя они чрезвычайно талантливые стрелки, в ближнем бою они некомпетентны."
    }
    {
        en = "the Master Marksman"
        ru = "мастер-стрелок"
    }
    {
        en = "Без промаха"
        ru = "Верный выстрел"
    }
    {
        en = "the Headhunter"
        ru = "охотник за головами"
    }
    {
        en = "the Longbowman"
        ru = "стрелок из длинного лука"
    }
    {
        en = "the Peerless"
        ru = "несравненный"
    }
    {
        en = "{%name% is considered to be one of the most dangerous bowmen to walk the earth. Legends say that once, he slew 20 men at range in as many seconds, and that subdivisions of noble spy networks would be dedicated to tracking his movements. Sadly, as time went on his old age has deteriorated the most important sense for an archer: sight. Suspecting that if he settled down eventually someone would seek to kill him, %name% now seeks to keep his skills sharp out on the battlefield.}"
        ru = "{%имя% считается одним из самых опасных лучников, когда-либо живших на земле. Легенды гласят, что однажды он убил 20 человек с близкого расстояния за несколько секунд, и что подразделения шпионских сетей нобл были посвящены отслеживанию его передвижений. К сожалению, с течением времени его старость ухудшила самое важное для лучника чувство - зрение. Подозревая, что, если он остепенится, кто-нибудь в конце концов попытается его убить, %name% теперь стремится отточить свои навыки на поле боя.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/myrmidon_background.nut
    {
        en = "Myrmidon"
        ru = "Мирмидон"
    }
    {
        en = "Not quite strong enough to be raiders, not quite sneaky enough to be thieves, myrmidons nevertheless make up for their lack of standout talents with their eagerness to commit unscrupulous acts."
        ru = "Недостаточно сильные, чтобы быть налетчиками, и недостаточно хитрые, чтобы быть ворами, мирмидонцы, тем не менее, компенсируют отсутствие выдающихся талантов своим стремлением совершать беспринципные поступки."
    }
    {
        en = "the Rat"
        ru = "крыса"
    }
    {
        en = "the Scummy"
        ru = "мерзкий"
    }
    {
        en = "the Brutal"
        ru = "жестокий"
    }
    {
        en = "the Criminal"
        ru = "преступник"
    }
    {
        en = "the Highwayman"
        ru = "разбойник с большой дороги"
    }
    {
        en = "{Tough enough to be a bandit, but not tough enough to be a bandit leader, %name% the myrmidon spent much of his time as the right hand man of a notorious brigand leader. This came to an abrupt end when a fellow bandit betrayed the location of their base camp and the group was ambushed by a large noble force and cohort of mercenaries. With his leader and most of his comrades killed, %name% has decided that it is time for a career change.}"
        ru = "{Достаточно крепкий, чтобы быть бандитом, но недостаточно крепкий, чтобы быть главарем бандитов, %имя% мирмидонец провел большую часть своего времени в качестве правой руки печально известного главаря бандитов. Этому пришел неожиданный конец, когда один из бандитов выдал местонахождение их базового лагеря, и группа попала в засаду, устроенную большим отрядом благородных и когортой наемников. После того, как его лидер и большинство его товарищей были убиты, %name% решил, что пришло время сменить профессию.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/outlander_background.nut
    {
        en = "Outlander"
        ru = "Чужестранец"
    }
    {
        en = "Outlanders come from faraway lands that take months or even years to reach by ship. They are hard to read at the best of times, but especially so in combat."
        ru = "Чужеземцы прибывают из далеких земель, до которых на корабле добираются месяцами или даже годами. Их трудно читать и в лучшие времена, но особенно в бою."
    }
    {
        en = "the Outsider"
        ru = "посторонний"
    }
    {
        en = "the Outlander"
        ru = "Чужеземец"
    }
    {
        en = "the Stranger"
        ru = "незнакомец"
    }
    {
        en = "the Foreigner"
        ru = "иностранец"
    }
    {
        en = "the Silent"
        ru = "безмолвный"
    }
    {
        en = "the Unfamiliar"
        ru = "незнакомый"
    }
    {
        en = "Dimitri"
        ru = "Дмитрий"
    }
    {
        en = "Alexander"
        ru = "Александр"
    }
    {
        en = "Maksim"
        ru = "Максим"
    }
    {
        en = "Ivan"
        ru = "Иван"
    }
    {
        en = "Vladislav"
        ru = "Владислав"
    }
    {
        en = "Vladmir"
        ru = "Владмир"
    }
    {
        en = "Yaroslav"
        ru = "Ярослав"
    }
    {
        en = "Bogdan"
        ru = "Богдан"
    }
    {
        en = "Miroslav"
        ru = "Мирослав"
    }
    {
        en = "Mihai"
        ru = "Михай"
    }
    {
        en = "Dorin"
        ru = "Дорин"
    }
    {
        en = "Irinel"
        ru = "Иринель"
    }
    {
        en = "Iskander"
        ru = "Искандер"
    }
    {
        en = "Benjamin"
        ru = "Бенджамин"
    }
    {
        en = "Noah"
        ru = "Ной"
    }
    {
        en = "Samuel"
        ru = "Сэмюэл"
    }
    {
        en = "Raphael"
        ru = "Рафаэль"
    }
    {
        en = "Jean"
        ru = "Джинса"
    }
    {
        en = "Simon"
        ru = "Саймон"
    }
    {
        en = "Arthur"
        ru = "Артур"
    }
    {
        en = "Tristan"
        ru = "Тристан"
    }
    {
        en = "Gaston"
        ru = "Гастон"
    }
    {
        en = "Yves"
        ru = "Ив"
    }
    {
        en = "Brice"
        ru = "Брайс"
    }
    {
        en = "Etienne"
        ru = "Этьен"
    }
    {
        en = "Louis"
        ru = "Льюис"
    }
    {
        en = "Henri"
        ru = "Генри"
    }
    {
        en = "Victor"
        ru = "Виктор"
    }
    {
        en = "Luc"
        ru = "Люк"
    }
    {
        en = "Leo"
        ru = "Лео"
    }
    {
        en = "Marcel"
        ru = "Марсель"
    }
    {
        en = "Guy"
        ru = "Парень"
    }
    {
        en = "Alexei"
        ru = "Алексей"
    }
    {
        en = "Artyom"
        ru = "Артем"
    }
    {
        en = "Igor"
        ru = "Игорь"
    }
    {
        en = "Kirill"
        ru = "Кирилл"
    }
    {
        en = "Lev"
        ru = "Лев"
    }
    {
        en = "Mikhail"
        ru = "Михаил"
    }
    {
        en = "Oleg"
        ru = "Олег"
    }
    {
        en = "Rolan"
        ru = "Ролан"
    }
    {
        en = "Sacha"
        ru = "Саша"
    }
    {
        en = "Vasili"
        ru = "Василий"
    }
    {
        en = "Viktor"
        ru = "Виктор"
    }
    {
        en = "Yuri"
        ru = "Юрий"
    }
    {
        en = "Conor"
        ru = "Конор"
    }
    {
        en = "Liam"
        ru = "Лиам"
    }
    {
        en = "Cillian"
        ru = "Киллиан"
    }
    {
        en = "Fionn"
        ru = "Финн"
    }
    {
        en = "Finn"
        ru = "Финн"
    }
    {
        en = "Eoin"
        ru = "Эоин"
    }
    {
        en = "Oscar"
        ru = "Оскар"
    }
    {
        en = "Aidan"
        ru = "Эйдан"
    }
    {
        en = "Shane"
        ru = "Шейн"
    }
    {
        en = "Cormac"
        ru = "Кормак"
    }
    {
        en = "Colm"
        ru = "Кольм"
    }
    {
        en = "Lorcan"
        ru = "Лоркан"
    }
    {
        en = "{%name%'s past is shrouded in mystery. There is only one thing for sure; the man is definitely not from here. How or why he ended up in this gods forsaken place, you do not know, and you have the distinct feeling you won't be finding out anytime soon.}"
        ru = "Прошлое {%name% окутано тайной. Точно можно сказать только одно: этот человек определенно не отсюда. Как и почему он оказался в этом забытом богами месте, вы не знаете, и у вас есть отчетливое ощущение, что в ближайшее время вы этого не узнаете.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/painter_background.nut
    {
        en = "Painter"
        ru = "Художник"
    }
    {
        en = "Unsuited to the hardships of both combat and reality as a whole, painters nevertheless create beautiful artwork capable of briefly staving off the bleakness of life."
        ru = "Неприспособленные к тяготам как боевых действий, так и реальности в целом, художники, тем не менее, создают прекрасные произведения искусства, способные ненадолго скрасить унылость жизни."
    }
    {
        en = "the Artist"
        ru = "художник"
    }
    {
        en = "the Painter"
        ru = "художник"
    }
    {
        en = "the Creator"
        ru = "создатель"
    }
    {
        en = "the Artisan"
        ru = "ремесленник"
    }
    {
        en = "{In better days, %name% the painter spent his time painting beautiful landscapes and selling them to rich art collectors. Sadly, in these difficult times demand for such artwork has dried up. Lacking much in the way of other worldly skills, the hapless painter has been forced to turn to mercenary work. Though he certainly looks a little frail, he appears to be able to know his way around a sword about as well as any other man.}"
        ru = "{В лучшие времена художник писал прекрасные пейзажи и продавал их богатым коллекционерам. К сожалению, в нынешние трудные времена спрос на подобные произведения искусства иссяк. Не имея большого опыта в других областях, незадачливый художник был вынужден заняться наемничеством. Хотя он, безусловно, выглядит немного хрупким, он, похоже, умеет обращаться с мечом не хуже любого другого мужчины.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/paladin_commander_background.nut
    {
        en = "Paladin"
        ru = "Паладин"
    }
    {
        en = "Paladins are men whose deeds have achieved legendary status. It is a rare sight to see one for hire, and rarer still for a mercenary group to be able to afford one."
        ru = "Паладины - это люди, чьи деяния приобрели легендарный статус. Редко можно увидеть, как их нанимают, и еще реже группа наемников может себе это позволить."
    }
    {
        en = "the Paladin"
        ru = "Паладин"
    }
    {
        en = "the Smiter"
        ru = "сокрушитель"
    }
    {
        en = "the Blessed"
        ru = "благословенный"
    }
    {
        en = "the Heroic"
        ru = "героический"
    }
    {
        en = "Lightsworn"
        ru = "Измученный светом"
    }
    {
        en = "Darkslayer"
        ru = "Убийца тьмы"
    }
    {
        en = "Lightbringer"
        ru = "Светоносец"
    }
    {
        en = "the Knight"
        ru = "рыцарь"
    }
    {
        en = "{A popular saying states, there are two types of men: good men, and powerful ones. %name% is a true diamond in the rough, his very existence perfectly contradicting the idiom. Peasants herald the man as a hero, for wherever he goes monster attacks invariably lessen, and then disappear, in intensity. You ask why he is even looking for a mercenary company. He merely tells you that he knows of dens of monsters that even he cannot handle alone. His exhorbitant asking salary is simply to cover his services for non monster related contracts in the meantime.}"
        ru = "{Популярная поговорка гласит, что есть два типа мужчин: хорошие и могущественные. %name% - настоящий неограненный алмаз, само его существование полностью противоречит этой идиоме. Крестьяне превозносят этого человека как героя, потому что, куда бы он ни пошел, нападения монстров неизменно ослабевают, а затем и вовсе исчезают. Вы спрашиваете, почему он вообще ищет компанию наемников. Он просто говорит вам, что знает о логовах монстров, с которыми даже он не может справиться в одиночку. Его непомерно высокая зарплата нужна просто для того, чтобы покрыть его услуги по контрактам, не связанным с монстрами, в то же время.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/pirate_background.nut
    {
        en = "Pirate"
        ru = "Пират"
    }
    {
        en = "Though sailing skills aren't applicable on dry land, fighting skills are. Pirates are used to the savagery of combat."
        ru = "Хотя навыки плавания под парусом неприменимы на суше, боевые навыки вполне применимы. Пираты привыкли к жестокости боя."
    }
    {
        en = "A former raider, %name% fit in well with the %companyname% and proved himself an excellent fighter. Having saved a veritable mountain of crowns, he retired from the company and returned from whence he came. He was last seen sailing a riverboat toward a small village."
        ru = "Бывший рейдер, %name% хорошо вписался в состав %companyname% и показал себя отличным бойцом. Скопив целую гору крон, он уволился из компании и вернулся туда, откуда пришел. В последний раз его видели плывущим на речном судне в сторону небольшой деревни."
    }
    {
        en = "As the %companyname% speedily declined, %name% the raider departed from the company and went on his own way again. He returned to raiding, taking his greedy violence along the shorelines of river villages. You're not sure if it's true, but word has it that he was impaled with a pitchfork by a stable boy. Word has it that the town hoisted his body parts along the outer walls as a warning to future would-be raiders."
        ru = "Поскольку %companyname% быстро пришел в упадок, %name% рейдер покинул компанию и снова пошел своим путем. Он вернулся к рейдерству, проявляя свою жадную жестокость вдоль береговых линий речных деревень. Вы не уверены, правда ли это, но ходят слухи, что мальчик с конюшни проткнул его вилами. Ходят слухи, что жители города развесили части его тела вдоль внешних стен в качестве предупреждения будущим потенциальным захватчикам."
    }
    {
        en = "the Cutthroat"
        ru = "Головорез"
    }
    {
        en = "the Marauder"
        ru = "Мародер"
    }
    {
        en = "the Pirate"
        ru = "пират"
    }
    {
        en = "Pegleg"
        ru = "Колышек"
    }
    {
        en = "the Albatross"
        ru = "Альбатрос"
    }
    {
        en = "the Toothless"
        ru = "беззубый"
    }
    {
        en = "{Instilled with a love for the sea as a child, %name% started his life as a sailor aboard a merchant vessel. However, though the seas proved to be safe from monsters, it was unsafe from the greed and ambitions of man. Once while his ship was transporting some particularly valuable spices, it was boarded by pirates. His fellow crewmates were cut down almost to a man. %name% alone was spared because he provided the location of another treasure fleet. This second round of piracy was so successful that %name% was invited to join the pirate crew. Since then, merchant ships have become few and far between, and now %name% seeks to find his land legs again. He figures that mercenary work and piracy align well; you aren't entirely sure if you agree.}"
        ru = "{В детстве ему привили любовь к морю, и он начал свою жизнь моряком на борту торгового судна. Однако, несмотря на то, что в морях не было чудовищ, они были небезопасны из-за жадности и амбиций человека. Однажды, когда его корабль перевозил особо ценные специи, на него напали пираты. Его товарищи по команде были убиты почти до одного человека. Только %name% остался в живых, потому что он указал местонахождение другого флота с сокровищами. Этот второй раунд пиратства был настолько успешным, что %name% был приглашен присоединиться к пиратской команде. С тех пор торговые суда стали появляться все реже, и теперь %name% стремится вернуться на сушу. Он считает, что наемничество и пиратство хорошо сочетаются; вы не совсем уверены, согласны ли вы с этим.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/roofer_background.nut
    {
        en = "Roofer"
        ru = "Кровельщик"
    }
    {
        en = "Due to the time spent atop ladders and in high places for their profession, roofers are sure-footed and have no issue maintaining their balance."
        ru = "Благодаря тому, что кровельщики в силу своей профессии проводят много времени на лестницах и на высоких должностях, они твердо стоят на ногах и без проблем сохраняют равновесие."
    }
    {
        en = "the Roofer"
        ru = "кровельщик"
    }
    {
        en = "the Sure-footed"
        ru = "уверенный в себе"
    }
    {
        en = "the Tiler"
        ru = "плиточник"
    }
    {
        en = "the Shingle Layer"
        ru = "слой гальки"
    }
    {
        en = "{%name% spent much of his life following the same trade as his father, inspecting, installing, and replacing roof materials to ensure that the buildings stayed upright and kept the cold out. Sadly, in recent times people have been much more concerned with getting food in their mouths instead of home maintenance. The roofer grumbles that winter will always come and that one day people will regret putting him out of work, but nonetheless until that day arrives he must find a way to get food in HIS mouth.}"
        ru = "{%name% большую часть своей жизни он занимался тем же ремеслом, что и его отец, проверяя, устанавливая и заменяя кровельные материалы, чтобы здания оставались в вертикальном положении и не пропускали холод. К сожалению, в последнее время люди гораздо больше заботятся о том, чтобы прокормить себя, чем об уходе за домом. Кровельщик ворчит, что зима всегда будет приходить и что однажды люди пожалеют, что оставили его без работы, но, тем не менее, пока этот день не настал, он должен найти способ прокормить себя.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/skirmisher_background.nut
    {
        en = "Skirmisher"
        ru = "Стрелок"
    }
    {
        en = "Skirmishers are light combatants that specialize in harassing larger groups of heavily armored soldiers. They can do a surprising amount of damage, but are unsuited to direct confrontation."
        ru = "Застрельщики - это легкие бойцы, которые специализируются на преследовании больших групп солдат в тяжелой броне. Они могут нанести неожиданно большой урон, но не подходят для прямого столкновения."
    }
    {
        en = "the Skirmisher"
        ru = "Застрельщик"
    }
    {
        en = "the Lightfooted"
        ru = "Легконогий"
    }
    {
        en = "the Ambusher"
        ru = "тот, кто устроил засаду"
    }
    {
        en = "{%name% the skirmisher is a member of an emerging class of fighters specializing in midranged combat. Armed only with several packs of throwing weapons, and light armor, %name% has dedicated his life to dealing maximum damage to the enemy while skirting the edge of disaster. You ask %name% how he summons the courage to pursue such an aggressive fighting style. He merely shrugs and tells you that becoming a frontliner wasn't likely to earn him any heavier defensive gear anyway.}"
        ru = "{%name% стрелок - представитель нового класса бойцов, специализирующихся на ближнем бою. Вооруженный лишь несколькими комплектами метательного оружия и легкой броней, %name% посвятил свою жизнь нанесению максимального урона врагу, оставаясь при этом на грани поражения. Вы спрашиваете, как ему удается набираться смелости, чтобы придерживаться такого агрессивного стиля ведения боя. Он просто пожимает плечами и говорит вам, что, став бойцом на передовой, он вряд ли заработал бы более тяжелую защитную экипировку.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/surgeon_background.nut
    {
        en = "Surgeon"
        ru = "Хирург"
    }
    {
        en = "Capable surgeons are a rare find, and often have their hands full with patching up wounded soldiers and villagers alike. They are used to the sight of blood and have operated in high stress situations, but are below average combatants."
        ru = "Квалифицированные хирурги - редкая находка, и у них часто полно работы по оказанию помощи раненым солдатам и сельским жителям. Они привыкли к виду крови и оперировали в стрессовых ситуациях, но их уровень подготовки ниже среднего."
    }
    {
        en = "the Surgeon"
        ru = "хирург"
    }
    {
        en = "the Doc"
        ru = "доктор"
    }
    {
        en = "the Doctor"
        ru = "доктор"
    }
    {
        en = "the Medic"
        ru = "врач"
    }
    {
        en = "{Learned medical men are a treasured rarity in these troubled times. Nonetheless, %name% is one such man, serving for years as a medic for noble armies and saving the lives of countless soldiers. However, when he failed to save an important nobleman's son, he was dishonorably discharged. Lacking the resources and assistants to work his previous miracles, %name% now seeks a much humbler life as a medic for a merceary group, stating that he has been due for some real adventure.}"
        ru = "{Образованные медики - большая редкость в наши неспокойные времена. Тем не менее, %name% - один из таких людей, долгие годы служивший медиком в благородных армиях и спасший жизни бесчисленного количества солдат. Однако, когда ему не удалось спасти сына важного дворянина, он был с позором уволен. Испытывая недостаток в ресурсах и помощниках, чтобы творить свои прежние чудеса, %name% теперь ищет гораздо более скромную жизнь в качестве медика в группе милосердия, заявляя, что его ждет настоящее приключение.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/torturer_background.nut
    {
        en = "Torturer"
        ru = "Мучитель"
    }
    {
        en = "All noblemen employ torturers, though few would admit it openly. Torturers' personalities vary wildly from cruel detachment to psychotic malice. Nevertheless, they are all brutally efficient at inflcting pain and permanent damage."
        ru = "Все аристократы нанимают палачей, хотя немногие признаются в этом открыто. Характеры палачей сильно различаются - от жестокой отстраненности до психопатической злобы. Тем не менее, все они зверски эффективны в причинении боли и необратимых повреждений."
    }
    {
        en = "the Psychotic"
        ru = "психопат"
    }
    {
        en = "the Malicious"
        ru = "злонамеренный"
    }
    {
        en = "the Torturer"
        ru = "мучитель"
    }
    {
        en = "the Bloodletter"
        ru = "Кровопускатель"
    }
    {
        en = "the Cruel"
        ru = "жестокий"
    }
    {
        en = "{Even in his youth, it was clear that %name%'s mind was wired in a sinister way. He reveled in the suffering of the weak, torturing frogs, rabbits, and even cats with perverse glee. It wasn't long before his father begged the local lord to either cure the lad or lock him away. The lord however, sensed talent and did neither; opting instead to hire him as a torturer. You don't know why he is looking for mercenary work now...but you get the feeling that you don't want to know.}"
        ru = "{Даже в юности было ясно, что разум %name% устроен зловещим образом. Он наслаждался страданиями слабых, мучая лягушек, кроликов и даже кошек с извращенным ликованием. Вскоре его отец умолил местного лорда либо вылечить мальчика, либо посадить его за решетку. Лорд, однако, почувствовал в нем талант и не сделал ни того, ни другого, решив вместо этого нанять его в качестве палача. Вы не знаете, почему он сейчас ищет работу наемника... но у вас возникает ощущение, что вы не хотите этого знать.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/town_watchman_background.nut
    {
        en = "Town Watchman"
        ru = "Городской сторож"
    }
    {
        en = "Town Watchmen are hired by burgomeisters to keep the peace and identify early threats to a town."
        ru = "Городские сторожа нанимаются бургомистрами для поддержания мира и выявления ранних угроз городу."
    }
    {
        en = "the Overseer"
        ru = "надзиратель"
    }
    {
        en = "the Town Watchman"
        ru = "городской сторож"
    }
    {
        en = "the Night Owl"
        ru = "ночная сова"
    }
    {
        en = "the Patrolman"
        ru = "патрульный"
    }
    {
        en = "{To be able to combat a threat, one must first know of its existence. %name% the town watchman was responsible for just that, able to spot threats at a distance and rouse the town militia whenever enemies were on the approach. However, one night after a town festival %name% was too plastered to notice brigands creeping up for a raid, and the resulting losses weighed too heavily on his conscience for him to continue serving at his post. Now he seeks to join a mercenary crew, knowing fully well that they go after bandits at the source on a regular basis.}"
        ru = "{Чтобы иметь возможность противостоять угрозе, нужно сначала узнать о ее существовании. %имя% именно за это отвечал городской страж, способный распознавать угрозы на расстоянии и поднимать городскую милицию, когда враги приближались. Однако однажды ночью после городского фестиваля %name% был слишком пьян, чтобы заметить разбойников, готовящихся к налету, и понесенные в результате потери слишком тяжелым грузом легли на его совесть, чтобы он мог продолжать службу на своем посту. Теперь он стремится присоединиться к команде наемников, прекрасно зная, что они регулярно охотятся на бандитов в источнике.}"
    }
]
::Rosetta.add(rosetta, pairs);
