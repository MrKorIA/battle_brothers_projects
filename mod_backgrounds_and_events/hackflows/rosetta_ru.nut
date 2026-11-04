if (!("Rosetta" in getroottable())) return;

local rosetta = {
    version = "0.1.1"
    mod = {id = "mod_backgrounds_and_events", version = 0.8}
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
        ru = "Арбалетчики служили профессиональными стрелками из арбалета в прошлом."
    }
    {
        en = "Having enough of all the fighting, %name% the once-beggar retired from the %companyname%. You know the man made a pretty crown in his time with the mercenary company, yet the other day you saw him out begging again. You asked if he'd wasted all his money and he laughed. He said he'd purchased land and was doing just fine. Then he held out his little tin and asked for a crown. You gave him two."
        ru = ""
    }
    {
        en = "Жизнь наемника сурова, и %name%, бывший нищий, счел за благо уйти из нее, пока она не стала смертельной. К сожалению, он вернулся к попрошайничеству. Говорят, какой-то дворянин очистил город от отбросов и отправил их на север, несмотря на зиму. Замерзший и голодный, %name% умер на обочине дороги, с примерзшей к пальцу жестяной кружкой."
        ru = ""
    }
    {
        en = "the Arbalester"
        ru = "Арбалетчик"
    }
    {
        en = "the Crossbowman"
        ru = "Стрелок"
    }
    {
        en = "Снайпер"
        ru = "Снайпер"
    }
    {
        en = "Меткий"
        ru = "Меткий"
    }
    {
        en = "{%name%'s father was a bowyer of significant repute, as far as lowly bowmakers could go. In his youth, %name% never doubted that one day he would take up the craft to continue the family's legacy. Sadly, this future was not be. His father was brutally murdered by a nobleman, who upon discovering the superior quality of his order, sought to keep a similar weapon out of his enemy's hands. Seeking revenge, %name% took up the crossbow, swearing an oath that one day he would humiliate the offender by ending him with a crossbow bolt between the eyes. He returns your gaze with a fiery expression, stating that he would never fulfill this aim by keeping watch atop fortress battlements. You silently agree.}"
        ru = "{Отец %name% был известным мастером-лучником, насколько вообще могли быть известны простые изготовители луков. В юности %name% не сомневался, что однажды продолжит семейное дело. Увы, этому не суждено было сбыться. Его отца жестоко убил дворянин, который, обнаружив превосходное качество своего заказа, решил не допустить появления подобного оружия у врагов. Жаждая мести, %name% взял в руки арбалет, поклявшись однажды унизить обидчика, всадив ему болт между глаз. Он смотрит на тебя пылающим взором, заявляя, что никогда не достигнет этой цели, сторожа на крепостных стенах. Ты молча соглашаешься.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/atilliator_background.nut
    {
        en = "Atilliator"
        ru = "Оружейник"
    }
    {
        en = "Atilliators tend to have some knowledge about how to use the ranged weaponry they used to craft."
        ru = ""
    }
    {
        en = "While at a jousting tournament, a young boy was using an oddly shaped, yet perfectly crafted bow. His aiming hand was shaky, yet the arrows did not wobble upon being loosed. After he won the competition, you inquired about where the boy had gotten such an incredible bow. He stated that a bowyer by the name of %name% had crafted it. Apparently, he's known for making the finest bows in all the land!"
        ru = ""
    }
    {
        en = "After you left the %companyname%, you sent a letter inquiring about the status of %name% the bowyer. You got word that he had discovered a way to craft the finest bow possible and, instead of giving this secret to the company, he departed to start his own business. He did not get far: whatever he had learned about his trade died with him on a muddy road out {north | south | west | east} of here, his body ironically skewered with what is said to have been a dozen arrows."
        ru = ""
    }
    {
        en = "the Crossbow Crafter"
        ru = "Самострелодел"
    }
    {
        en = "the Atilliator"
        ru = "Самострельщик"
    }
    {
        en = "the Crafter"
        ru = "Ремесленник"
    }
    {
        en = "the Patient"
        ru = "Терпеливый"
    }
    {
        en = "{With deft fingers and a gift for linking together machinery, %name% actually began his career as an architect for siege engines. However, after his lord's castle was assailed by catapaults and trebuchets of %name%'s own design, %name% was forced to flee for his life and undergo a hasty career change. Fortunately for him his gift with machines applies just as well to crossbows as it does rockslingers. Having recently caught wind that his original lord has been on the hunt for him, %name% now seeks a more mobile occupation.}"
        ru = "{Благодаря ловким рукам и таланту к механизмам, %name% начал карьеру как строитель осадных орудий. Однако после того, как замок его лорда был разрушен катапультами и требушетами собственной конструкции %name%, ему пришлось спасаться бегством и спешно менять профессию. К счастью, его дар к механизмам оказался столь же полезен для арбалетов, как и для камнемётов. Недавно прослышав, что его бывший лорд начал охоту за ним, %name% теперь ищет более подвижную работу.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/barkeep_background.nut
    {
        en = "Barkeep"
        ru = "Трактирщик"
    }
    {
        en = "Barkeeps have some brawling experience from breaking up fights at the taverns they work in."
        ru = "Трактирщики имеют опыт в драках, ведь им часто приходится разнимать потасовки в своих заведениях."
    }
    {
        en = "the Bartender"
        ru = "Бармен"
    }
    {
        en = "the Barkeep"
        ru = "Трактирщик"
    }
    {
        en = "the Brewer"
        ru = "Самогонщик"
    }
    {
        en = "the Burly"
        ru = "Здоровяк"
    }
    {
        en = "the Tapmaster"
        ru = "Разливала"
    }
    {
        en = "the Hopper"
        ru = "Хмельной"
    }
    {
        en = "the Beer Brewer"
        ru = "Пивовар"
    }
    {
        en = "{A lifetime in the tavern has shaped %name% the barkeep into a hardy, burly, muscular man. In troubled times, %name% often had had to 'resolve disagreements', 'escort patrons to the door', or 'ensure that customers paid fairly' on his own. Having heard his share of tales of heroic deeds, violent clashes, and exciting treasure hunts, %name% is more than ready to see the wide world for himself. He has a solid build; he might make a name for himself yet!"
        ru = "{Годы работы в таверне превратили трактирщика %name% в крепкого, коренастого мужика. В неспокойные времена %name% частенько приходилось 'улаживать разногласия', 'провожать гостей до дверей' и 'следить за честной оплатой' своими силами. Наслушавшись историй о подвигах, жестоких схватках и поисках сокровищ, %name% готов сам повидать большой мир. У него крепкое телосложение - глядишь, и прославится!"
    }
    // FILE: scripts/skills/backgrounds/hackflows/berserker_background.nut
    {
        en = "Berserker"
        ru = "Берсерк"
    }
    {
        en = "Kill or be killed. Berserkers are men who have been forged by cruel hardship since birth, and as a result are naturally fearless combatants."
        ru = "Убей или умри. Берсерки - люди, закалённые жестокими испытаниями с рождения, и потому являются бесстрашными воинами от природы."
    }
    {
        en = "While the %companyname% visited a town for rest and recuperation, a local princess took a shine to %name% the wildman. He was 'purchased' for a large sum of gold and given to the noblewoman. You went and visited the man recently. For dinner, he sat at a kingly table, grinning goofily and mimicking the nobles around him as best he could. His new and inexplicable wife adored him, and him her. When you said your goodbyes, he offered you a heavy golden crown off the top of his head. It weighed heavy with traditions and ancient histories. You said it'd be best if he kept it. The wildman shrugged and walked off, spinning the circlet around a finger."
        ru = "Когда %companyname% остановилась в городе для отдыха, местная принцесса положила глаз на %name% дикаря. Его 'купили' за кругленькую сумму и отдали знатной даме. Недавно вы навестили его. За королевским столом он сидел с глуповатой улыбкой, изо всех сил подражая окружающим дворянам. Его новая и неожиданная жена обожала его, а он её. Прощаясь, он предложил вам тяжёлую золотую корону со своей головы. Она была полна традиций и древней истории. Вы сказали, что ему лучше оставить её себе. Дикарь пожал плечами и ушёл, крутя венец на пальце."
    }
    {
        en = "%name% the wildman stayed with the fragmenting %companyname% for a time and then, just like that, he was gone. The company went out looking for him in a forest, eventually finding some sort of crude note: an enormous pile of crowns next to a dirt-drawing of the %companyname% and some of its members, all of them being hugged by a big, literal stick figure with a goofy smile on its face. There was also an offering of a dead, half-eaten rabbit."
        ru = "%name% дикарь пробыл с разваливающейся %companyname% некоторое время, а потом просто исчез. Отряд отправился искать его в лесу и в итоге нашёл странную записку: огромную кучу корон рядом с рисунком на земле, изображавшим %companyname% и некоторых её членов, которых обнимала большая, буквально палочная фигура с глуповатой улыбкой. Рядом также лежал подарок - мёртвый, наполовину съеденный кролик."
    }
    {
        en = "the Berserker"
        ru = "Берсерк"
    }
    {
        en = "the Crazed"
        ru = "Безумный"
    }
    {
        en = "the Bloodthirsty"
        ru = "Кровожадный"
    }
    {
        en = "the Feral"
        ru = "Зверьё"
    }
    {
        en = "the Wild"
        ru = "Дикарь"
    }
    {
        en = "the Battleforged"
        ru = "Закалённый"
    }
    {
        en = "{It is said that man is born with the wilderness in him, and that he does wrong by turning his back on it. This is a mantra esteemed by those that find refuge in the forests, spurning the filth of civilization and returning to the old ways. However, between the men of the wilderness and the men of civilization, there exists a third class of men that dare to live at the fringes of both. They are called berserkers. %name% is one such man. He is so immense that lesser men appear almost as children; his body is covered in scars and his hair grows unimpeded in every which way. At a quick glance he appears to be a conventional wildman, if indeed there exists such a thing. However, his piercing, intelligent gaze shows that though his body was honed by the cruelties of nature, so too has his mind been honed by the cruelties of man.}"
        ru = "{Говорят, что человек рождается с дикостью внутри, и что он поступает неправильно, отворачиваясь от неё. Это мантра тех, кто находит убежище в лесах, отвергая грязь цивилизации и возвращаясь к старым путям. Однако между людьми дикими и цивилизованными существует третий род - те, кто осмеливается жить на грани обоих миров. Их называют берсерками. %name% - один из таких. Он настолько огромен, что прочие люди кажутся детьми рядом с ним; его тело покрыто шрамами, а волосы беспорядочно растут во все стороны. На первый взгляд он кажется обычным дикарём, если такое вообще возможно. Однако его пронзительный, умный взгляд показывает, что хоть его тело и закалила жестокость природы, разум его отточила жестокость людей.}"
    }
    {
        en = "dirt"
        ru = ""
    }
    {
        en = "body"
        ru = ""
    }

    // FILE: scripts/skills/backgrounds/hackflows/blacksmith_background.nut
    {
        en = "Blacksmith"
        ru = "Кузнец"
    }
    {
        en = "The endurance and precision needed to forge weapons of war gives blacksmiths a head start in becoming combat ready."
        ru = "Выносливость и точность, необходимые для ковки боевого оружия, дают кузнецам преимущество в освоении боевых искусств."
    }
    {
        en = "the Smith"
        ru = "Кузнец"
    }
    {
        en = "the Smithy"
        ru = "Наковальня"
    }
    {
        en = "the Blacksmith"
        ru = "Ковач"
    }
    {
        en = "the Metalworker"
        ru = "Слесарь"
    }
    {
        en = "the Forgemaster"
        ru = "Штамповщик"
    }
    {
        en = "the Swordmaker"
        ru = "Клинковар"
    }
    {
        en = "the Hammerer"
        ru = "Молотобоец"
    }
    {
        en = "the Furnacemaster"
        ru = "Горновой"
    }
    {
        en = "the Metalcaster"
        ru = "Литейщик"
    }
    {
        en = "{%name%’s father was a smith, and that man’s father before him as well, so naturally, he was quick to pick up the trade. | When his father passed at a young age, %name% was forced to start providing for the family, taking up smithing to keep mouths fed. | %name%’s family sword was a priceless heirloom passed down from generations, but after it disappeared in a break-in, %name% turned to smithing to forge a new blade for his family to take pride in.} {But when a local nobleman was unhappy with a dagger he commissioned, he sent his men to put the smith’s shop to the torch. | Filled with wanderlust, he set out to join a mercenary company, determined not to wither away in the shop he’s spent his whole life in. | Yet when his father rose from the grave and the rest of the cemetery with him, %name% vowed to put his hammer to a more righteous cause.}  {He tells you he can forge a blade so sharp it can cut through stone. You don’t know about that, but a blacksmith of his experience would be a fit for any company. | The man’s muscled arms are proof enough that he’s no stranger to the hammer - perhaps you can help him put it to a new use. | It’s doubtful the man has swung a sword in his life. But he has a soldier’s build, and with the proper training, you think you can mold him into a true fighter. | While he may not be a fearsome warrior, a smith like him is always handy to have around. You just hope he’s as good at striking foes as he is at striking nails. | He figured a band a of mercenaries would suit him, and while he’s no swordmaster, the might of his hammer arm suggests he might be right.}"
        ru = "{Отец %name% был кузнецом, как и его отец до него, так что ремесло далось ему легко. | Когда отец умер, юному %name% пришлось кормить семью, взявшись за кузнечное дело. | Фамильный меч %name% был бесценной реликвией, передававшейся из поколения в поколение, но после того как его украли воры, %name% занялся кузнечным делом, чтобы выковать новый клинок, которым семья могла бы гордиться.} {Но когда местный дворянин остался недоволен заказанным кинжалом, он послал людей спалить кузницу дотла. | Одержимый жаждой странствий, он отправился в наёмники, не желая зачахнуть в мастерской, где провёл всю жизнь. | Но когда его отец восстал из могилы вместе со всем кладбищем, %name% поклялся направить свой молот на правое дело.} {Он говорит, что может выковать клинок, способный разрубить камень. Вы в этом сомневаетесь, но кузнец с таким опытом пригодится в любом отряде. | Мускулистые руки выдают в нём человека, привычного к молоту - возможно, вы поможете ему найти молоту новое применение. | Вряд ли он когда-либо держал в руках меч. Но телосложение у него воинское, и с должной подготовкой из него выйдет настоящий боец. | Хоть он и не грозный воин, такой кузнец всегда пригодится. Остаётся надеяться, что он так же хорошо бьёт врагов, как и по наковальне. | Он решил, что ему самое место среди наёмников, и хоть он не мастер меча, сила его молота говорит, что он может быть прав.}"
    }

    // FILE: scripts/skills/backgrounds/hackflows/bodyguard_background.nut
    {
        en = "Bodyguard"
        ru = "Телохранитель"
    }
    {
        en = "Bodyguards are burly men that specialize in keeping people of interest from being killed."
        ru = "Телохранители - крепкие мужчины, которые специализируются на защите важных персон от смерти."
    }
    {
        en = "the Bodyguard"
        ru = "Телохранитель"
    }
    {
        en = "the Shield"
        ru = "Щит"
    }
    {
        en = "the Meatshield"
        ru = "Живой Щит"
    }
    {
        en = "the Giant"
        ru = "Великан"
    }
    {
        en = "the Enforcer"
        ru = "Мордоворот"
    }
    {
        en = "the Guard"
        ru = "Вахтёр"
    }
    {
        en = "the Watchdog"
        ru = "Барбос"
    }
    {
        en = "Часовой"
        ru = "Часовой"
    }
    {
        en = "the Invincible"
        ru = "Неуязвимый"
    }
    {
        en = "the Impenetrable"
        ru = "Непробей"
    }
    {
        en = "the Steadfast"
        ru = "Верный"
    }
    {
        en = "the Stalwart"
        ru = "Крепыш"
    }
    {
        en = "the Impregnable"
        ru = "Стойкий"
    }
    {
        en = "{The illegitimate son of a hedge knight, %name% was disowned by his father early in life for failing to inherit his 'killer's disposition'. What %name% did inherit, however, was his father's towering physical build. He attracted the attention of a local lord after hearing news of a bear of a man singlehandedly repelling a bandit attack, and was hired on as a personal bodyguard. %name% served him faithfully for many years, until the lord eventually passed peacefully of old age. Because the lord lacked an heir, the succession struggle was messy, and soon %name% turned to mercenary work, in search of other great men to shield from evil.}"
        ru = "{Будучи незаконным сыном странствующего рыцаря, %name% был рано отвергнут отцом за то, что не унаследовал его 'убийственный нрав'. Зато %name% унаследовал богатырское телосложение отца. Он привлёк внимание местного лорда, когда тот прослышал о медведе-человеке, в одиночку отбившем нападение бандитов. Лорд нанял его личным телохранителем. %name% верно служил ему долгие годы, пока тот не скончался мирно от старости. Поскольку у лорда не было наследника, борьба за престол вышла грязной, и вскоре %name% подался в наёмники, в поисках других великих людей, которых можно защищать от зла.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/bounty_hunter_background.nut
    {
        en = "Bounty Hunter"
        ru = "Охотник за головами"
    }
    {
        en = "Persistence is key. Bounty hunters are paid good coin to recover any human target, dead or alive."
        ru = "Главное - упорство. Охотникам за головами хорошо платят за поимку любого человека, живым или мертвым."
    }
    {
        en = "the Hunter"
        ru = "Охотник"
    }
    {
        en = "the Bounty Hunter"
        ru = "Ловчий"
    }
    {
        en = "the Relentless"
        ru = "Неутомимый"
    }
    {
        en = "the Hound"
        ru = "Ищейка"
    }
    {
        en = "the Dog"
        ru = "Пёс"
    }
    {
        en = "the Eagle"
        ru = "Орёл"
    }
    {
        en = "the Reaper"
        ru = "Жнец"
    }
    {
        en = "the Persistent"
        ru = "Упорный"
    }
    {
        en = "the Tracker"
        ru = "Следопыт"
    }
    {
        en = "{%name%'s past is a mystery, as even those that have worked with him the past have seldom heard more than a few sentences unrelated to the task at hand. What is abundantly clear though, is that just as beast slayers specialize in eliminating the monstrosities of the world, so too does %name% the bounty hunter hunt monstrosities, specializing particularly in those that hide behind the mask of man. His line of work is already quite similar to a mercenary's; forking over the coin for a man like %name% would certainly be worthwhile for any reputable outfit.}"
        ru = "{О прошлом %name% ничего не известно - даже те, кто работал с ним бок о бок, слышали от него лишь пару фраз о текущем деле. Ясно одно: как истребители чудовищ специализируются на уничтожении монстров, так и %name% охотится за извергами, что прячутся под маской человека. Его ремесло мало чем отличается от работы наемника - такой человек, как %name%, определенно станет ценным приобретением для любой уважающей себя компании.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/carpenter_background.nut
    {
        en = "Carpenter"
        ru = "Плотник"
    }
    {
        en = "Carpenters can often be found in forest settlements, doing the critical work of converting logs to high quality planks."
        ru = "Плотников часто можно встретить в лесных поселениях, где они занимаются важным делом превращения бревен в качественные доски."
    }
    {
        en = "the Craftsman"
        ru = "Мастеровой"
    }
    {
        en = "the Carpenter"
        ru = "Плотник"
    }
    {
        en = "the Woodworker"
        ru = "Деревщик"
    }
    {
        en = "{From humble beginnings was raised a humble man. %name% the carpenter lived simply, taking up the fine work that his father and his grandfather had before. He and his older brother had made a great team. His brother had a much stronger build, and so chopped the wood that %name% would then cut into workable construction materials. One day %name%'s brother ventured into the forests to chop wood, but never returned in the evening. %name%, seeking answers, small in stature but not in bravery, now seeks to solve the mystery of his older brother once and for all.}"
        ru = "{Из простых корней вырос простой человек. %name% плотник жил скромно, продолжая благородное дело своего отца и деда. Они со старшим братом составляли отличную команду. Брат был крепче телом и рубил деревья, которые %name% затем превращал в годный строительный материал. Однажды брат %name% отправился в лес за древесиной, но так и не вернулся вечером. %name%, невеликий статью, но не храбростью, теперь ищет разгадку тайны исчезновения старшего брата.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/cartographer_background.nut
    {
        en = "Cartographer"
        ru = "Картограф"
    }
    {
        en = "Cartographers specialize in the creation of accurate maps. Unlike historians, they have modest experience outdoors from their time spent travelling with supply caravans to map the landscape."
        ru = "Картографы специализируются на создании точных карт. В отличие от историков, они имеют некоторый опыт походной жизни, полученный во время путешествий с торговыми караванами для составления карт местности."
    }
    {
        en = "the Studious"
        ru = "Заучка"
    }
    {
        en = "the Cartographer"
        ru = "Картограф"
    }
    {
        en = "the Mapmaker"
        ru = "Чертёжник"
    }
    {
        en = "the Sketcher"
        ru = "Рисовальщик"
    }
    {
        en = "the Observant"
        ru = "Заметливый"
    }
    {
        en = "{Plagued by a chronic illness since birth, %name% was never able to grow to the health and constitution of even an average man. Unable to help his hometown defend itself by joining the militia, %name% was scorned by his peers. Aghast at the shame he felt he was bringing upon his family, he one day risked life and limb by charting the local area and discovering locations of bandit hideouts. This information proved critical in repelling the next raid, and jeers turned quickly to praise for %name%'s ability. Now he seeks to map places uncharted by man. He would be better suited to hire a mercenary band than join one; but nevertheless you muse that it would be nice to have another man with brains in the outfit.}"
        ru = "{С самого рождения %name% страдал от хронической болезни и никогда не мог достичь здоровья и силы даже обычного человека. Не в силах помочь родному городу, вступив в ополчение, %name% стал объектом насмешек. Измученный стыдом, который он, как ему казалось, навлёк на свою семью, однажды он рискнул жизнью, составив карту окрестностей и обнаружив места бандитских логовищ. Эти сведения оказались решающими при отражении следующего набега, и насмешки быстро сменились похвалой способностям %name%. Теперь он стремится наносить на карты неизведанные земли. Ему больше подошло бы нанять отряд наёмников, чем присоединиться к нему, но всё же вы думаете, что ещё один умный человек в отряде не помешает.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/champion_background.nut
    {
        en = "Champion"
        ru = "Чемпион"
    }
    {
        en = "Champions are knights that have gained renown as one on one fighters. Men of such repute are usually in the employ of noble houses and as such not typically in the market for mercenary work."
        ru = "Чемпионы - это рыцари, прославившиеся как бойцы один на один. Такие именитые воины обычно служат знатным домам и редко ищут работу наёмника."
    }
    {
        en = "A man like %name% would always find a way. The hedge knight eventually, if not inevitably, left the company and set out on his own. Unlike many other brothers, he did not spend his crowns on land or ladders with which to climb the noble life. Instead, he bought himself the finest war horses and the talents of armorers. The behemoth of a man rode from one jousting tournament to the next, winning them all with ease. He's still at it to this day, and you think he won't stop until he's dead. The hedge knight simply knows no other life."
        ru = ""
    }
    {
        en = "%name% the hedge knight eventually left the company. He traveled the lands, returning to his favorite past time of jousting, which was really a cover for his real favorite past time of lancing men off horses in a shower of splinters and glory. At some point, he was ordered to 'throw' a match against a pitiful and gangly prince to earn the nobleman some prestige. Instead, the hedge knight drove his lance through the man's skull. Furious, the lord of the land ordered the hedge knight killed. They say over a hundred soldiers took to his home and only half returned alive."
        ru = ""
    }
    {
        en = "the Legendary"
        ru = "Легенда"
    }
    {
        en = "the Mighty"
        ru = "Могучий"
    }
    {
        en = "the Unbeatable"
        ru = "Непобедимый"
    }
    {
        en = "the Undefeated"
        ru = "Непобеждённый"
    }
    {
        en = "the Favorite"
        ru = "Любимчик"
    }
    {
        en = "the Champion"
        ru = "Чемпион"
    }
    {
        en = "the Steady"
        ru = "Незыблемый"
    }
    {
        en = "the Mountain"
        ru = "Гора"
    }
    {
        en = "Strongface"
        ru = "Рожа кирпичом"
    }
    {
        en = "the Unbreakable"
        ru = "Несокрушимый"
    }
    {
        en = "the Knightslayer"
        ru = "Убийца рыцарей"
    }
    {
        en = "{Some say that there are but two types of men: those that know no defeat whose deeds invariably become the stuff of legends, and completely irrelevant milkdrinkers. Regardless of the veracity of this little idiom, one look at %name% and it is abundantly clear which class he would fall into. Despite his relative youth, %name% has already spent several years as a combat instructor at the local training hall. Why he wants to join a mercenary company now is unclear. You look at his desired wages and almost burst out laughing. All %name% has to say is that he is willing to take a pay cut if it means experiencing adventure again.}"
        ru = "{Говорят, есть лишь два типа мужчин: те, кто не знает поражений и чьи подвиги неизбежно становятся легендами, и полные ничтожества-молокососы. Вне зависимости от правдивости этой поговорки, одного взгляда на %name% достаточно, чтобы понять, к какому типу он относится. Несмотря на юный возраст, %name% уже несколько лет преподаёт боевое искусство в местной школе. Неясно, почему он хочет присоединиться к отряду наёмников. Вы смотрите на его желаемую плату и чуть не прыскаете со смеху. %name% лишь говорит, что готов согласиться на меньшие деньги, если это значит снова почувствовать вкус приключений.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/cobbler_background.nut
    {
        en = "Cobbler"
        ru = "Сапожник"
    }
    {
        en = "Cobblers are humble folk making a living by crafting footwear of all kinds."
        ru = "Сапожники - скромные люди, зарабатывающие на жизнь изготовлением обуви всех видов."
    }
    {
        en = "the Shoemaker"
        ru = "Башмачник"
    }
    {
        en = "the Cobbler"
        ru = "Сапожник"
    }
    {
        en = "the Shoemender"
        ru = "Ремонт обуви"
    }
    {
        en = "the Cordwainer"
        ru = "Шнур"
    }
    {
        en = "Bootsmith"
        ru = "Ботинщик"
    }
    {
        en = "Shoesmith"
        ru = "Обуварь"
    }
    {
        en = "{%name% the cobbler, much like the vast majority of peasants, has no interesting backstory. When you ask why he wishes to become a mercenary, he simply shrugs his shoulders, and mumbles something to the effect of shoemaking not making enough coin. Your eyebrows raise in surprise; his asking salary is pretty low as it is, so you accurately surmise that shoemaking is not the best craft to invest into.}"
        ru = "{%name% сапожник, как и большинство крестьян, не может похвастаться интересной историей. Когда вы спрашиваете, почему он хочет стать наёмником, он просто пожимает плечами и бормочет что-то о том, что сапожное дело приносит мало монет. Ваши брови удивлённо поднимаются; его запрошенное жалование и так довольно низкое, так что вы верно догадываетесь - сапожное ремесло не лучшее дело для вложений.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/con_artist_background.nut
    {
        en = "Con Artist"
        ru = "Мошенник"
    }
    {
        en = "Con artists make their living by swindling other folks. Those astute enough to realize when they are pressing their luck often turn to mercenary work to begin anew."
        ru = "Мошенники зарабатывают на обмане других людей. Те из них, кто достаточно смышлен, чтобы понять, когда пора делать ноги, часто подаются в наемники, чтобы начать всё с чистого листа."
    }
    {
        en = "the Con Artist"
        ru = "Мошенник"
    }
    {
        en = "the Scammer"
        ru = "Пройдоха"
    }
    {
        en = "Two Face"
        ru = "Двуличный"
    }
    {
        en = "the Trickster"
        ru = "Ловкач"
    }
    {
        en = "the Thief"
        ru = "Вор"
    }
    {
        en = "the Untrustworthy"
        ru = "Скользкий"
    }
    {
        en = "the Cheat"
        ru = "Туфтогон"
    }
    {
        en = "the Hustler"
        ru = "Шаромыжник"
    }
    {
        en = "{%name% the con artist eyes you nervously as you approach. Before you can a word out he exclaims that he doesn't owe you any money and that any purchases made were final. As it turns out, the scammer has been on the run for so long and from so many people that for a moment you begin to wonder if he really DOES owe you cash. He has a dangerous, desperate look in his eyes, and is undoubtedly looking for a mercenary crew for some protection. You know little else of his background, but what else is even relevant to know?"
        ru = "{%name% нервно смотрит на вас, когда вы подходите. Не дав вам и слова сказать, он восклицает, что ничего вам не должен, и все сделки окончательны. Похоже, аферист так долго бегал от стольких людей, что на миг вы сами задумались - а может, он и правда вам что-то должен? В его глазах читается опасное отчаяние, и он явно ищет наемников для защиты. О его прошлом вы знаете мало, но разве это имеет значение?"
    }
    // FILE: scripts/skills/backgrounds/hackflows/cook_background.nut
    {
        en = "Cook"
        ru = "Повар"
    }
    {
        en = "Cooks have little combat or travel experience, having spent most of their careers indoors preparing delicious meals for the local nobility."
        ru = "Повара редко имеют боевой опыт или опыт путешествий, проведя большую часть карьеры на кухне, готовя изысканные блюда для местной знати."
    }
    {
        en = "the Cook"
        ru = "Повар"
    }
    {
        en = "the Chef"
        ru = "Шеф"
    }
    {
        en = "the Fat"
        ru = "Жирдяй"
    }
    {
        en = "the Jolly"
        ru = "Весельчак"
    }
    {
        en = "{%name% the cook has always liked food. Once, during better times, a local lord contributed several delicacies to a peasant holiday. Upon sampling the baked treats, %name% was so overcome with emotion that he begged the lord to allow his chef to accept him as an understudy, so that he may bring smiles to other poor folk in the future. The gracious nobleman accepted, and for a time %name% spent happy years honing his craft. Sadly, after being caught sampling food from the larder during times of hardship, %name% has been kicked to the curb. Oddly enough, this hasn't seemed to bother the cook very much. He now seeks mercenary work so that he 'doesn't have to be so damn hungry all the time.'}"
        ru = "{%name% всегда любил поесть. Однажды, в лучшие времена, местный лорд прислал несколько деликатесов на крестьянский праздник. Отведав печёные угощения, %name% был настолько восхищён, что упросил лорда позволить его шефу взять его в подмастерья - чтобы и он мог приносить радость бедным людям. Милостивый дворянин согласился, и %name% провёл несколько счастливых лет, оттачивая своё мастерство. Увы, после того как его поймали на воровстве еды из кладовой в тяжёлые времена, %name% вышвырнули на улицу. Как ни странно, повара это особо не расстроило. Теперь он ищет работу наёмником, чтобы 'не шляться вечно голодным'.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/dissenter_background.nut
    {
        en = "Dissenter"
        ru = "Смутьян"
    }
    {
        en = "Dissenters have trouble keeping their mouths shut, seeking mercenary work as a means to escape a grisly end at the hands of goons hired by the targets of their denunciations."
        ru = "Смутьяны не держат язык за зубами и ищут работу наёмника, чтобы избежать жестокой расправы от головорезов, нанятых теми, кого они обличают."
    }
    {
        en = "the Dissenter"
        ru = "Раскольник"
    }
    {
        en = "the Loudmouth"
        ru = "Горлопан"
    }
    {
        en = "the Disagreeable"
        ru = "Несносный"
    }
    {
        en = "Sharptongue"
        ru = "Острослов"
    }
    {
        en = "Справедливый"
        ru = "Правдоруб"
    }
    {
        en = "{After watching his father executed without trial for a crime he didn't commit and his mother burned at the stake because of a bogus accusation, %name% the dissenter's heart has been filled with nothing but absolute hatred for nobility. Lacking the strength or skill to kill kings himself, his spends his time shouting for the peasantry to rise up and overthrow the existing political order. However, his vocalizations have largely fallen on deaf ears. You surmise that the reason %name% yet lives is that no one important takes him as a serious threat. As if reading your mind, the dissenter tells you that THAT is the exact reason he is looking to join a mercenary band.}"
        ru = "{После того как его отца казнили без суда за преступление, которого он не совершал, а мать сожгли на костре по ложному обвинению, сердце смутьяна %name% наполнилось лишь ненавистью к знати. Не имея сил или умения убивать королей самому, он тратит время на призывы к крестьянам восстать и свергнуть существующий порядок. Однако его речи в основном пропадают впустую. Вы полагаете, что %name% до сих пор жив лишь потому, что власть имущие не считают его серьёзной угрозой. Словно прочитав ваши мысли, смутьян говорит, что ИМЕННО поэтому он и хочет вступить в отряд наёмников.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/drifter_background.nut
    {
        en = "Drifter"
        ru = "Бездомный"
    }
    {
        en = "For one reason or another, drifters lack any city to call home, finding themselves wandering from place to place and doing odd jobs to keep themselves fed."
        ru = "По разным причинам бродяги не имеют города, который могли бы назвать домом, скитаясь от места к месту и берясь за случайную работу, чтобы не умереть с голоду."
    }
    {
        en = "Having enough of all the fighting, %name% the once-drifter retired from the %companyname%. You know the man made a pretty crown in his time with the mercenary company, yet the other day you saw him out begging again. You asked if he'd wasted all his money and he laughed. He said he'd purchased land and was doing just fine. Then he held out his little tin and asked for a crown. You gave him two."
        ru = "Устав от всех сражений, %name% бывший бродяга покинул %companyname%. Ты знаешь, что он неплохо заработал в отряде наёмников, но на днях видел его снова просящим милостыню. Ты спросил, не растратил ли он все деньги, а он рассмеялся. Сказал, что купил земли и у него всё в порядке. Затем протянул свою жестянку и попросил крону. Ты дал ему две."
    }
    {
        en = "the Drifter"
        ru = "Бродяга"
    }
    {
        en = "the Dirty"
        ru = "Чумазый"
    }
    {
        en = "Изгой"
        ru = "Изгой"
    }
    {
        en = "Fleetfoot"
        ru = "Шатун"
    }
    {
        en = "the Wanderer"
        ru = "Скиталец"
    }
    {
        en = "the Homeless"
        ru = "Бомжара"
    }
    {
        en = "{The third child born to a modest merchant family, %name% spent much of his early life idly wasting time with trivial pursuits. When his father died, %name%'s older brother took over the family business, leaving %name% with a chunk of change to spend. Lacking direction in his life, %name% has since been wandering around in search of purpose. The man has a bit of an empty gaze. No matter. Your band has seen less able men join the shield wall.}"
        ru = "{Третий ребёнок в семье небогатого торговца, %name% провёл юность праздно растрачивая время на пустяки. Когда его отец умер, старший брат %name% унаследовал семейное дело, оставив %name% с горстью монет на руках. Не имея цели в жизни, %name% с тех пор скитается в поисках предназначения. У мужчины немного отсутствующий взгляд. Неважно. Ваш отряд видел и менее способных бойцов в строю щитов.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/druid_background.nut
    {
        en = "Druid"
        ru = "Друид"
    }
    {
        en = "Druids are men that are more in tune with mystic forces than the average layman."
        ru = "Друиды - это люди, более чуткие к мистическим силам, чем обычные смертные."
    }
    {
        en = "the Druid"
        ru = "Друид"
    }
    {
        en = "the Mystic"
        ru = "Мистик"
    }
    {
        en = "the Mysterious"
        ru = "Загадочный"
    }
    {
        en = "the Nature Spirit"
        ru = "Дух природы"
    }
    {
        en = "the Channeler"
        ru = "Чародей"
    }
    {
        en = "the Arcane"
        ru = "Мудрец"
    }
    {
        en = "{The tattoos and runes printed upon %name% the druid's body make him quite a sight to behold in town. Raised in the wild from birth, yet not entirely lacking the mannerisms of civilized man, %name%'s past is shrouded in mystery. The man informs you of that he is seeking mercenary work, for a druidic prophecy foretold that a band of brothers would one day face hordes of untold horrors. You aren't sure if you should hire him or not; either way his message is deeply unsettling.}"
        ru = "{Татуировки и руны, покрывающие тело друида %name%, делают его весьма примечательным в городе. Выросший в диких землях, но не чуждый манерам цивилизованного человека, %name% хранит своё прошлое в тайне. Он рассказывает, что ищет работу наёмника, поскольку друидическое пророчество предрекло, что однажды братство воинов встретится с полчищами невиданных ужасов. Вы не уверены, стоит ли его нанимать; в любом случае, его слова глубоко тревожат.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/falconer_background.nut
    {
        en = "Falconer"
        ru = "Сокольничий"
    }
    {
        en = "Falconers, as the name suggests, have mastery of falcons."
        ru = "Сокольничие, как следует из названия, в совершенстве владеют искусством соколиной охоты."
    }
    {
        en = "While the %companyname% continued on with great success, %name% the falconer eventually saw fit to leave it all behind. He returned to the forests, starting an aviary of trained falcons. All told, his experience as a mercenary didn't change his demeanor; %name% and his falcons transitioned smoothly from hunting men back to hunting beasts."
        ru = "Пока %companyname% продолжала преуспевать, сокольничий %name% решил оставить всё позади. Он вернулся в леса и основал питомник для обученных соколов. В целом, опыт наёмника не изменил его характер - %name% и его соколы легко перешли от охоты на людей обратно к охоте на зверей."
    }
    {
        en = "With the decline of the %companyname% readily obvious, %name% the falconer departed from the company and returned to falconry. Unfortunately, he fell upon hard times and was forced to sell his prized birds to make ends meet. Last you heard, the decision drove him mad and he wandered off into the forest, never to be seen again."
        ru = "Видя явный упадок %companyname%, сокольничий %name% покинул отряд и вернулся к соколиной охоте. К несчастью, он попал в трудные времена и был вынужден продать своих драгоценных птиц, чтобы свести концы с концами. По последним слухам, это решение свело его с ума, и он ушёл в лес, где его больше никто не видел."
    }
    {
        en = "the Falconer"
        ru = "Сокольничий"
    }
    {
        en = "the Birdmaster"
        ru = "Птицелов"
    }
    {
        en = "the Falconmaster"
        ru = "Соколиный Мастер"
    }
    {
        en = "the Woodsman"
        ru = "Лесник"
    }
    {
        en = "Eagle Eye"
        ru = "Орлиный Глаз"
    }
    {
        en = "the Scoutmaster"
        ru = "Следопыт"
    }
    {
        en = "Наблюдатель"
        ru = "Дозорный"
    }
    {
        en = "Can release falcons for no AP cost"
        ru = "Может выпускать соколов без затрат ОД"
    }
    {
        en = "Falcons released by the falconer reveal 16 tiles distance instead of 12"
        ru = "Соколы, выпущенные сокольничим, открывают обзор на 16 клеток вместо 12"
    }
    {
        en = "{%name% always had a fascination with avian creatures. Little did he know, this fascination would one day become his niche on the battlefield. | %name%'s father was a skilled hunter. Though %name% didn't share quite the same aptitude with the bow, his skill with birds made him an invaluable hunting companion. | Early in his life, %name% liked to traipse about the forests. Once, he chanced upon an injured falcon and took it under his wing. Since then, %name% has become a master of dealing with avian creatures.} {The falconer eventually realized that his knack for scouting for beasts in the forests could be just as easily applied to scouting enemy formations. | When a misplaced target callout led to a fellow woodsman being shot in the neck, %name% knew his career as a conventional falconer was over. | Sadly, a bad hunting season forced the birdmaster into seeking other means of income. | War drove the game out of the forests, and with them, %name%. Now he seeks another line of work.} {Any outfit could use an eagle eye such as this man. | Despite his humble backgrounds, %name% has already proven to be a valuable scout in many a noble war. | %name%'s falcon is perched majestically atop his shoulder. It is clear that the two are extensions of each other. | %name% looks like he has something to prove - his sharp eyes and nimble movements may prove useful on the battlefield yet. | The falcon atop his shoulder has steely eyes; you suspect that it has seen many more battles from above than the average wannabe mercenary.}"
        ru = "{%name% всегда был очарован пернатыми созданиями. Он и не подозревал, что это увлечение однажды станет его козырем на поле боя. | Отец %name% был умелым охотником. Хоть %name% и не унаследовал его талант к стрельбе из лука, его мастерство обращения с птицами сделало его незаменимым спутником на охоте. | В юности %name% любил бродить по лесам. Однажды он наткнулся на раненого сокола и взял его под своё крыло. С тех пор %name% стал мастером в обращении с пернатыми.} {Со временем сокольничий понял, что его умение выслеживать зверей в лесу можно с тем же успехом применять для разведки вражеских построений. | Когда из-за неверного целеуказания стрела попала в шею другому леснику, %name% понял, что с обычной соколиной охотой покончено. | К сожалению, неудачный охотничий сезон вынудил птицелова искать другие источники дохода. | Война выгнала дичь из лесов, а вместе с ней и %name%. Теперь он ищет другое занятие.} {Такой зоркий глаз пригодится любому отряду. | Несмотря на скромное происхождение, %name% уже проявил себя как ценный разведчик во многих благородных войнах. | Сокол %name% величественно восседает на его плече. Видно, что они с хозяином - единое целое. | %name% выглядит так, будто ему есть что доказать - его острый взгляд и ловкие движения ещё пригодятся на поле боя. | У сокола на его плече стальной взгляд; похоже, он видел сверху куда больше битв, чем среднестатистический новоиспеч"
    }
    // FILE: scripts/skills/backgrounds/hackflows/fletcher_background.nut
    {
        en = "Fletcher"
        ru = "Стрелодел"
    }
    {
        en = "Fletchers are the counterpart of bowyers, specializing in making and selling arrows."
        ru = "Стрелоделы - это мастера вроде лучников, но специализирующиеся на изготовлении и продаже стрел."
    }
    {
        en = "the Arrowmaker"
        ru = "Стрелодел"
    }
    {
        en = "the Arrow Seller"
        ru = "Стрелоторговец"
    }
    {
        en = "{A man of humble origins, %name% found a talent early on for crafting ammunition and has been at it ever since. Fortunately for him, the war and strife in the world had hitherto given him plenty of work. Despite this, %name% always felt that there was more to see in the world. You aren't sure if the man will be able to make a name for himself in the history books, but he should know his way around a bow, at the very least.}"
        ru = "{Выходец из простой семьи, %name% рано обнаружил в себе талант к изготовлению боеприпасов и с тех пор этим и занимается. К его счастью, войны и раздоры в мире до сих пор обеспечивали его работой. Несмотря на это, %name% всегда чувствовал, что в мире есть что повидать. Вы не уверены, сможет ли он вписать своё имя в историю, но уж с луком-то он точно управится.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/folk_hero_background.nut
    {
        en = "Folk Hero"
        ru = "Народный Герой"
    }
    {
        en = "Folk heroes are commoners that have achieved great heights, earning the admiration of the peasantry and begrudging respect of knights with their mythical deeds."
        ru = "Народные герои - простолюдины, достигшие небывалых высот, заслужившие восхищение крестьян и неохотное уважение рыцарей своими легендарными подвигами."
    }
    {
        en = "Герой"
        ru = "Герой"
    }
    {
        en = "Легенда"
        ru = "Легенда"
    }
    {
        en = "the Folk Hero"
        ru = "Народный Герой"
    }
    {
        en = "Львиное сердце"
        ru = "Львиное Сердце"
    }
    {
        en = "the Magnanimous"
        ru = "Великодушный"
    }
    {
        en = "the Storied"
        ru = "Прославленный"
    }
    {
        en = "the Humble"
        ru = "Скромный"
    }
    {
        en = "{Some say that men are born into their stations, destined either for great things or utter medocrity by the circumstances of their birth. %name% is a picture perfect contradiction of this mantra. Towering well over six feet tall, %name% exudes an aura of pure strength, but carries himself with a dignified reserve. Nearby peasants whisper amongst themselves in excited tones. Evidently, despite being born in abject poverty and orphaned early in life, %name% eventually became something of a folk hero, with feats including but not limited to facing a band of 20 brigands on his own and emerging victorious. As you ask him to separate the fact from fiction of this paricular myth, without looking up from his mug, he merely replies, '25'.}"
        ru = "{Говорят, что люди рождаются каждый в своём положении, и обстоятельства рождения предопределяют их судьбу - быть великими или прозябать в посредственности. %name% - живое опровержение этой мантры. Возвышаясь далеко за шесть футов, %name% излучает ауру чистой силы, но держится с достойной сдержанностью. Крестьяне вокруг взволнованно перешёптываются. Очевидно, что несмотря на рождение в крайней нищете и раннее сиротство, %name% со временем стал народным героем, чьи подвиги включают, помимо прочего, победу над бандой из 20 разбойников в одиночку. Когда вы просите его отделить правду от вымысла в этом конкретном мифе, он, не поднимая глаз от кружки, лишь отвечает: '25'.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/gardener_background.nut
    {
        en = "Gardener"
        ru = "Садовник"
    }
    {
        en = "Gardeners are men with green thumbs often hired by noblemen to maintain extravant gardens as status symbols."
        ru = "Садовники - это люди с врождённым талантом к растениям, которых часто нанимают дворяне для ухода за роскошными садами - символами статуса."
    }
    {
        en = "the Gardener"
        ru = "Садовник"
    }
    {
        en = "Green Thumbed"
        ru = "Зелёная Рука"
    }
    {
        en = "the Caretaker"
        ru = "Смотритель"
    }
    {
        en = "{A somewhat meek individual by nature, %name% spent much of his life tending to the gardens in the lavish castles of higher nobility. When the lord's wife became pregnant while he was out on campagin, the household required a scapegoat. Poor %name% drew the short straw, and lacking the courage to prove his innocence, fled the estate. He does seem a bit more timid to you than normal, but nonetheless carries himself like an outdoorsman.}"
        ru = "{%name%, будучи от природы довольно кротким человеком, большую часть жизни провёл ухаживая за садами в роскошных замках высшей знати. Когда жена лорда забеременела, пока тот был в походе, дому потребовался козёл отпущения. Бедняге %name% не повезло, и, не найдя в себе смелости доказать невиновность, он сбежал из поместья. Он кажется вам немного более пугливым, чем обычные люди, но всё же держится как настоящий человек природы.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/hangman_background.nut
    {
        en = "Hangman"
        ru = "Палач"
    }
    {
        en = "Hangmen are no strangers to death, but also have not seen it dealt in the myriad of sloppy methods out on the battlefield."
        ru = "Палачи не понаслышке знакомы со смертью, но не видали её во всём многообразии неуклюжих способов, что встречаются на поле боя."
    }
    {
        en = "A former militiaman such as %name% eventually left the %companyname%. He traveled the lands, visiting villages and helping them establish credible militias with which to defend themselves. Finding success in an increasingly dangerous world, %name% eventually came to be a known name, called upon as a sort of 'fixer' to come and ensure these villages would remain safe. Last you heard, he's purchased a plot of land and was raising a family far from the strife of the world."
        ru = ""
    }
    {
        en = "%name% left the collapsing company and returned to his village. Back in the militia, it wasn't long until {greenskins | raiders} attacked and he was called to action. It's said that he stood tall, rallying the defense as he slew through countless enemies before succumbing to mortal wounds. When you visited the village, you found children playfighting beneath a statue made in the militiaman's image."
        ru = ""
    }
    {
        en = "the Hangman"
        ru = "Вешатель"
    }
    {
        en = "the Executioner"
        ru = "Каратель"
    }
    {
        en = "the Lever Arm"
        ru = "Рычаг"
    }
    {
        en = "the Last Word"
        ru = "Последнее Слово"
    }
    {
        en = "the Cold"
        ru = "Холодный"
    }
    {
        en = "{With a past as a coroner, %name% is and always has been unperturbed by the sight of death. Once, when in his town the local peasantry were looking to lynch a grave robber, %name% volunteered to pull the lever. Transitioning from examining dead bodies to creating them didn't weight heavily on %name%'s conscience, and soon enough he became the town hangman. %name% returns your gaze with a cold expression and the eyes of a dead fish, stating simply that if acting the executioner could not stir his emotions, perhaps the heat of battle would.}"
        ru = "{Будучи в прошлом коронером, %name% всегда был равнодушен к виду смерти. Однажды, когда местные крестьяне хотели линчевать осквернителя могил, %name% сам вызвался дёрнуть рычаг. Переход от осмотра трупов к их созданию не тяготил совесть %name%, и вскоре он стал городским палачом. %name% смотрит на вас холодным взглядом мёртвой рыбы и просто говорит, что раз роль палача не всколыхнула его чувства, возможно, это сделает пыл битвы.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/herbalist_background.nut
    {
        en = "Herbalist"
        ru = "Травник"
    }
    {
        en = "Herbalists are capable of recognizing the medicinal properties of a plethora of plant life. They produce salves and creams that relieve pain and discomfort."
        ru = "Травники способны распознавать целебные свойства многочисленных растений. Они создают мази и кремы, облегчающие боль и дискомфорт."
    }
    {
        en = "Perhaps one of the sharpest men you've ever met, %name% the apprentice was the quickest learner in the %companyname%. With plenty of crowns stored, he retired from fighting to take his talents to the business world. Last you heard he was doing very well for himself across multiple trades. If you ever have a son, this is the man you'll send him to for apprenticeship."
        ru = ""
    }
    {
        en = "%name% the apprentice was, by far, the quickest learner in the %companyname%. Little surprise then that he was also one of the quickest to recognize its inevitable downfall and leave while he still could. Had he been born in a different time he would have gone on to do great things. Instead, many wars, invasions, and plagues spreading across the land ultimately ensured %name% and many other talented men went to total waste."
        ru = ""
    }
    {
        en = "the Herbalist"
        ru = "Травник"
    }
    {
        en = "the Apothecary"
        ru = "Аптекарь"
    }
    {
        en = "the Naturalist"
        ru = "Натуралист"
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
        en = "<exp:str_tag> Experience Gain"
        ru = "<exp> к получаемому опыту"
    }
    {
        en = "{The natural world hides incredible bounties, if one just knows where to look. %name% is one such man. His father was a soldier purported to survive wounds accrued over a hundred battles. This legend sprouted from the effective healing ointments and disinfecting salves produced by %name%'s mother. With both his parents having since died of old age, %name% hopes to use the secret remedies passed down to him to spark tales of an invincible mercenary company.}"
        ru = "{Природа скрывает невероятные сокровища, нужно лишь знать, где искать. %name% как раз из таких знатоков. Его отец был солдатом, который, как говорят, пережил раны от сотни битв. Эта легенда выросла из действенных целебных мазей и дезинфицирующих притираний, что готовила мать %name%. Теперь, когда оба родителя умерли от старости, %name% надеется использовать переданные ему тайные снадобья, чтобы породить легенды о неуязвимой наёмничьей компании.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/lancer_background.nut
    {
        en = "Lancer"
        ru = "Копейщик"
    }
    {
        en = "Lancers, true to their namesake, are extremely proficient with lances and polearms. Though they perfom well in jousting tournaments, in terms of general combat hardiness they fall short of true knights."
        ru = "Копейщики, верные своему призванию, чрезвычайно умелы в обращении с копьями и древковым оружием. Хоть они и преуспевают на рыцарских турнирах, в плане боевой выносливости они уступают истинным рыцарям."
    }
    {
        en = "the Lancer"
        ru = "Копейщик"
    }
    {
        en = "the Lance"
        ru = "Копьё"
    }
    {
        en = "the Jouster"
        ru = "Турнирщик"
    }
    {
        en = "the Spearman"
        ru = "Копьеносец"
    }
    {
        en = "the Child of Light"
        ru = "Дитя Света"
    }
    {
        en = "the Stabber"
        ru = "Протыкатель"
    }
    {
        en = "{Having received special combat training in his youth, %name% used his spear proficiency to earn his living by entering and winning jousting tournaments. Yet as time went on the lancer felt the glory in the jousting ring to be incomplete. Now he seeks to make a name for himself in no holds barred combat.}"
        ru = "{Получив особую боевую подготовку в юности, %name% использовал своё мастерство владения копьём, чтобы зарабатывать на жизнь участием и победами в рыцарских турнирах. Но со временем копейщик почувствовал, что славы на турнирной арене недостаточно. Теперь он стремится сделать себе имя в настоящих боях без правил.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/leper_background.nut
    {
        en = "Leper"
        ru = "Прокажённый"
    }
    {
        en = "Lepers are shunned from society for their ghastly appearance, but also benefit from a general lack of sensation."
        ru = "Прокажённых сторонится общество из-за их жуткого вида, но они также имеют преимущество в виде общего отсутствия чувствительности."
    }
    {
        en = "the Leper"
        ru = "Прокажённый"
    }
    {
        en = "the Ragged"
        ru = "Рванина"
    }
    {
        en = "the Sick"
        ru = "Болезный"
    }
    {
        en = "the Damned"
        ru = "Клятый"
    }
    {
        en = "the Unlucky"
        ru = "Невезучий"
    }
    {
        en = "the Blighted"
        ru = "Порченый"
    }
    {
        en = "{In his youth, %name% was a charmer full of panache, popular with every maiden in his village. | Coming from a long line of butchers, %name% never doubted that he would follow in his family's footsteps. | %name%’s life was an uneventful one - he was a simple man, making a modest living as a subsistence farmer.} {But after contracting a deadly plague, the man’s skin was left peeling and his face deformed. | Yet after a fateful day he blames on some woman he lay with, a horrible illness befell him, leaving his flesh decayed and numb. | It seemed his life would continue that way, but after mysterious symptoms started sprouting and his skin began to crumble, the people he once knew rejected him as a freak.} {Spurned from every other profession, the life of a mercenary was the only one left for him to turn to. You doubt it’ll be a successful life path for him, but it can’t be much worse than before. | He tells you he once fought off two children who pelted rocks at him as if you’ll be in respect of the feat. Considering the state he’s in now, you almost are. | Skin covered, voice hoarse, and arms weak, the man looks about as much of a mercenary as your grandmother. Just a bit less fierce. | You almost don’t feel right bringing the man into your ranks. But, who else to catch the arrows? | You doubt %name% will fit in a shieldwall, nor a pike line. Maybe he can be your mascot.}"
        ru = "{В юности %name% был обаятельным щёголем, любимцем всех деревенских девиц. | Происходя из длинной череды мясников, %name% никогда не сомневался, что пойдёт по стопам семьи. | Жизнь %name% была непримечательной - простой человек, едва сводивший концы с концами крестьянин.} {Но после того как он подхватил смертельную чуму, его кожа начала облезать, а лицо исказилось. | Но после рокового дня, в котором он винит некую женщину, с которой переспал, его поразила ужасная болезнь, оставившая его плоть гниющей и онемевшей. | Казалось, что так и будет продолжаться его жизнь, но после того как появились загадочные симптомы и кожа начала отваливаться, люди, которых он когда-то знал, отвергли его как урода.} {Отвергнутый всеми другими профессиями, жизнь наёмника осталась единственным доступным путём. Вы сомневаетесь, что это будет успешный выбор, но хуже уже точно не будет. | Он рассказывает вам, как однажды отбился от двух детей, кидавших в него камни, будто это какой-то подвиг. Учитывая его нынешнее состояние, почти что и правда подвиг. | С закрытой кожей, хриплым голосом и слабыми руками этот человек похож на наёмника не больше, чем ваша бабушка. Разве что чуть менее свирепый. | Вы почти чувствуете себя неправильно, беря его в отряд. Но кому ещё ловить стрелы? | Вы сомневаетесь, что %name% впишется в строй щитов или копейщиков. Может, сделать его талисманом отряда?}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/locksmith_background.nut
    {
        en = "Locksmith"
        ru = "Взломщик"
    }
    {
        en = "Locksmiths are men handy to have around when brute force isn't enough to crack open a door, catacomb, or treasure chest."
        ru = "Взломщики - полезные ребята, когда одной грубой силы не хватает, чтобы вскрыть дверь, катакомбы или сундук с сокровищами."
    }
    {
        en = "the Keymaster"
        ru = "Ключник"
    }
    {
        en = "the Locksmith"
        ru = "Слесарь"
    }
    {
        en = "the Keymaker"
        ru = "Мастер Ключей"
    }
    {
        en = "Lightfingered"
        ru = "Пальчики"
    }
    {
        en = "the Lockpicker"
        ru = "Медвежатник"
    }
    {
        en = "the Nimble"
        ru = "Проворный"
    }
    {
        en = "{As a locksmith by trade, %name% has always had a knack for breaking open hard to open doors, chests, or vaults to reveal the hidden treasures inside. However, when hard times struck his hometown %name% found a shortage of things worth cracking open. Now he seeks to join a mercenary troop, seeking to use his skills to uncover undiscovered riches hidden away in the wilderness.}"
        ru = "{Будучи взломщиком по ремеслу, %name% всегда имел особый талант к вскрытию неприступных дверей, сундуков и хранилищ, чтобы добраться до спрятанных внутри сокровищ. Однако когда в родном городе настали тяжёлые времена, %name% обнаружил, что взламывать стало особо нечего. Теперь он хочет примкнуть к отряду наёмников, чтобы применить свои навыки в поисках несметных богатств, сокрытых в диких землях.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/master_archer_background.nut
    {
        en = "Master Archer"
        ru = "Мастер-лучник"
    }
    {
        en = "Master archers have spent their lives honing their abilities. Though they are extremely talented marksmen, they are incompetent melee fighters."
        ru = "Мастера-лучники посвятили жизнь оттачиванию своего мастерства. Хоть они и невероятно метко стреляют, в ближнем бою от них толку мало."
    }
    {
        en = "the Master Marksman"
        ru = "Меткий Стрелок"
    }
    {
        en = "Без промаха"
        ru = "Верняк"
    }
    {
        en = "the Headhunter"
        ru = "Охотник за Головами"
    }
    {
        en = "the Longbowman"
        ru = "Длинный лук"
    }
    {
        en = "the Peerless"
        ru = "Несравненный"
    }
    {
        en = "{%name% is considered to be one of the most dangerous bowmen to walk the earth. Legends say that once, he slew 20 men at range in as many seconds, and that subdivisions of noble spy networks would be dedicated to tracking his movements. Sadly, as time went on his old age has deteriorated the most important sense for an archer: sight. Suspecting that if he settled down eventually someone would seek to kill him, %name% now seeks to keep his skills sharp out on the battlefield.}"
        ru = "{%name% считается одним из самых опасных лучников на земле. Легенды гласят, что однажды он уложил 20 человек за столько же секунд, а благородные шпионские сети выделяли целые подразделения, чтобы следить за его перемещениями. К несчастью, время взяло своё, и старость ослабила самое важное для лучника чувство: зрение. Подозревая, что оседлая жизнь рано или поздно приведёт убийц к его порогу, %name% теперь поддерживает свои навыки острыми на поле боя.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/myrmidon_background.nut
    {
        en = "Myrmidon"
        ru = "Мирмидон"
    }
    {
        en = "Not quite strong enough to be raiders, not quite sneaky enough to be thieves, myrmidons nevertheless make up for their lack of standout talents with their eagerness to commit unscrupulous acts."
        ru = "Недостаточно сильны, чтобы быть разбойниками, недостаточно хитры, чтобы быть ворами - мирмидоны компенсируют отсутствие выдающихся талантов готовностью на любые бесчестные поступки."
    }
    {
        en = "the Rat"
        ru = "Крыса"
    }
    {
        en = "the Scummy"
        ru = "Мерзкий"
    }
    {
        en = "the Brutal"
        ru = "Жестокий"
    }
    {
        en = "the Criminal"
        ru = "Преступник"
    }
    {
        en = "the Highwayman"
        ru = "Разбойник"
    }
    {
        en = "{Tough enough to be a bandit, but not tough enough to be a bandit leader, %name% the myrmidon spent much of his time as the right hand man of a notorious brigand leader. This came to an abrupt end when a fellow bandit betrayed the location of their base camp and the group was ambushed by a large noble force and cohort of mercenaries. With his leader and most of his comrades killed, %name% has decided that it is time for a career change.}"
        ru = "{Достаточно крепкий для бандита, но недостаточно для главаря, мирмидон %name% долгое время был правой рукой известного атамана разбойников. Всё резко оборвалось, когда один из бандитов выдал расположение их лагеря, и на группу напал большой отряд дворянского войска с наёмниками. После гибели главаря и большинства товарищей %name% решил, что пора сменить род занятий.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/outlander_background.nut
    {
        en = "Outlander"
        ru = "Чужеземец"
    }
    {
        en = "Outlanders come from faraway lands that take months or even years to reach by ship. They are hard to read at the best of times, but especially so in combat."
        ru = "Чужеземцы прибывают из далёких краёв, до которых месяцы или даже годы пути по морю. Их трудно понять в обычной жизни, а уж в бою и подавно."
    }
    {
        en = "the Outsider"
        ru = "Чужак"
    }
    {
        en = "the Outlander"
        ru = "Чужеземец"
    }
    {
        en = "the Stranger"
        ru = "Странник"
    }
    {
        en = "the Foreigner"
        ru = "Иноземец"
    }
    {
        en = "the Silent"
        ru = "Молчаливый"
    }
    {
        en = "the Unfamiliar"
        ru = "Незнакомец"
    }
    {
        en = "Dimitri"
        ru = "Димитрий"
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
        ru = "Владимир"
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
        ru = "Иринел"
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
        ru = "Самуэль"
    }
    {
        en = "Raphael"
        ru = "Рафаэль"
    }
    {
        en = "Jean"
        ru = "Жан"
    }
    {
        en = "Simon"
        ru = "Симон"
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
        ru = "Брис"
    }
    {
        en = "Etienne"
        ru = "Этьен"
    }
    {
        en = "Louis"
        ru = "Луи"
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
        ru = "Гай"
    }
    {
        en = "Alexei"
        ru = "Алексей"
    }
    {
        en = "Artyom"
        ru = "Артём"
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
        ru = "Фионн"
    }
    {
        en = "Finn"
        ru = "Финн"
    }
    {
        en = "Eoin"
        ru = "Эойн"
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
        ru = "Колм"
    }
    {
        en = "Lorcan"
        ru = "Лоркан"
    }
    {
        en = "{%name%'s past is shrouded in mystery. There is only one thing for sure; the man is definitely not from here. How or why he ended up in this gods forsaken place, you do not know, and you have the distinct feeling you won't be finding out anytime soon.}"
        ru = "{Прошлое %name% окутано тайной. Ясно лишь одно - этот человек определённо не местный. Как и почему он оказался в этой забытой богами дыре, вы не знаете, и у вас стойкое чувство, что в ближайшее время не узнаете.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/painter_background.nut
    {
        en = "Painter"
        ru = "Художник"
    }
    {
        en = "Unsuited to the hardships of both combat and reality as a whole, painters nevertheless create beautiful artwork capable of briefly staving off the bleakness of life."
        ru = "Не приспособленные к тяготам боя и реальности в целом, художники всё же создают прекрасные произведения, способные ненадолго отогнать мрачность жизни."
    }
    {
        en = "the Artist"
        ru = "Артист"
    }
    {
        en = "the Painter"
        ru = "Живописец"
    }
    {
        en = "the Creator"
        ru = "Творец"
    }
    {
        en = "the Artisan"
        ru = "Рукодельник"
    }
    {
        en = "{In better days, %name% the painter spent his time painting beautiful landscapes and selling them to rich art collectors. Sadly, in these difficult times demand for such artwork has dried up. Lacking much in the way of other worldly skills, the hapless painter has been forced to turn to mercenary work. Though he certainly looks a little frail, he appears to be able to know his way around a sword about as well as any other man.}"
        ru = "{В лучшие времена художник %name% проводил дни, рисуя прекрасные пейзажи и продавая их богатым коллекционерам. Увы, в нынешние тяжёлые времена спрос на такое искусство иссяк. Не имея особых житейских навыков, незадачливому художнику пришлось податься в наёмники. Хоть он и выглядит немного хилым, похоже, что с мечом он управляется не хуже прочих.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/paladin_commander_background.nut
    {
        en = "Paladin"
        ru = "Паладин"
    }
    {
        en = "Paladins are men whose deeds have achieved legendary status. It is a rare sight to see one for hire, and rarer still for a mercenary group to be able to afford one."
        ru = "Паладины - люди, чьи подвиги стали легендарными. Редко встретишь такого наёмника, и ещё реже найдётся отряд, способный его нанять."
    }
    {
        en = "the Paladin"
        ru = "Паладин"
    }
    {
        en = "the Smiter"
        ru = "Сокрушитель"
    }
    {
        en = "the Blessed"
        ru = "Благословенный"
    }
    {
        en = "the Heroic"
        ru = "Героический"
    }
    {
        en = "Lightsworn"
        ru = "Светоносный"
    }
    {
        en = "Darkslayer"
        ru = "Истребитель Тьмы"
    }
    {
        en = "Lightbringer"
        ru = "Светоч"
    }
    {
        en = "the Knight"
        ru = "Рыцарь"
    }
    {
        en = "{A popular saying states, there are two types of men: good men, and powerful ones. %name% is a true diamond in the rough, his very existence perfectly contradicting the idiom. Peasants herald the man as a hero, for wherever he goes monster attacks invariably lessen, and then disappear, in intensity. You ask why he is even looking for a mercenary company. He merely tells you that he knows of dens of monsters that even he cannot handle alone. His exhorbitant asking salary is simply to cover his services for non monster related contracts in the meantime.}"
        ru = "{Есть такая поговорка: бывают люди хорошие и люди могущественные. %name% - настоящий самородок, само существование которого противоречит этой присказке. Крестьяне славят его как героя, ведь где бы он ни появился, нападения чудовищ неизменно становятся реже, а потом и вовсе прекращаются. На вопрос, зачем ему наниматься в отряд наёмников, он отвечает лишь, что знает о логовах монстров, с которыми даже ему не справиться в одиночку. А его баснословное жалование - всего лишь плата за участие в обычных походах между делом.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/pirate_background.nut
    {
        en = "Pirate"
        ru = "Пират"
    }
    {
        en = "Though sailing skills aren't applicable on dry land, fighting skills are. Pirates are used to the savagery of combat."
        ru = "Хоть навыки мореплавания и бесполезны на суше, боевые умения всегда при деле. Пираты привычны к жестокости битвы."
    }
    {
        en = "A former raider, %name% fit in well with the %companyname% and proved himself an excellent fighter. Having saved a veritable mountain of crowns, he retired from the company and returned from whence he came. He was last seen sailing a riverboat toward a small village."
        ru = ""
    }
    {
        en = "As the %companyname% speedily declined, %name% the raider departed from the company and went on his own way again. He returned to raiding, taking his greedy violence along the shorelines of river villages. You're not sure if it's true, but word has it that he was impaled with a pitchfork by a stable boy. Word has it that the town hoisted his body parts along the outer walls as a warning to future would-be raiders."
        ru = ""
    }
    {
        en = "the Cutthroat"
        ru = "Головорез"
    }
    {
        en = "the Marauder"
        ru = "Мародёр"
    }
    {
        en = "the Pirate"
        ru = "Пират"
    }
    {
        en = "Pegleg"
        ru = "Деревяшка"
    }
    {
        en = "the Albatross"
        ru = "Альбатрос"
    }
    {
        en = "the Toothless"
        ru = "Беззубый"
    }
    {
        en = "{Instilled with a love for the sea as a child, %name% started his life as a sailor aboard a merchant vessel. However, though the seas proved to be safe from monsters, it was unsafe from the greed and ambitions of man. Once while his ship was transporting some particularly valuable spices, it was boarded by pirates. His fellow crewmates were cut down almost to a man. %name% alone was spared because he provided the location of another treasure fleet. This second round of piracy was so successful that %name% was invited to join the pirate crew. Since then, merchant ships have become few and far between, and now %name% seeks to find his land legs again. He figures that mercenary work and piracy align well; you aren't entirely sure if you agree.}"
        ru = "{С детства влюблённый в море, %name% начал свой путь матросом на торговом судне. Но хоть море и оказалось безопасным от чудовищ, оно не защитило от жадности и амбиций людей. Однажды, когда его корабль перевозил особо ценные специи, на них напали пираты. Почти всю команду перебили. %name% пощадили лишь потому, что он выдал местонахождение другого торгового флота. Второй набег оказался настолько удачным, что %name% пригласили в пиратскую команду. С тех пор торговых судов стало меньше, и теперь %name% ищет работу на суше. Он считает, что ремесло наёмника мало чем отличается от пиратства. Вы не совсем уверены, что согласны с этим.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/roofer_background.nut
    {
        en = "Roofer"
        ru = "Кровельщик"
    }
    {
        en = "Due to the time spent atop ladders and in high places for their profession, roofers are sure-footed and have no issue maintaining their balance."
        ru = "Благодаря времени, проведённому на лестницах и высоте по долгу службы, кровельщики уверенно держат равновесие и не боятся высоты."
    }
    {
        en = "the Roofer"
        ru = "Кровельщик"
    }
    {
        en = "the Sure-footed"
        ru = "Верхолаз"
    }
    {
        en = "the Tiler"
        ru = "Черепица"
    }
    {
        en = "the Shingle Layer"
        ru = "Кровелье"
    }
    {
        en = "{%name% spent much of his life following the same trade as his father, inspecting, installing, and replacing roof materials to ensure that the buildings stayed upright and kept the cold out. Sadly, in recent times people have been much more concerned with getting food in their mouths instead of home maintenance. The roofer grumbles that winter will always come and that one day people will regret putting him out of work, but nonetheless until that day arrives he must find a way to get food in HIS mouth.}"
        ru = "{%name% большую часть жизни продолжал дело отца: осматривал, ставил и чинил крыши, чтобы здания стояли прочно и не пускали холод. Увы, в последнее время людей больше волнует, как прокормиться, чем поддержание домов. Кровельщик ворчит, что зима всё равно придёт и люди ещё пожалеют, что оставили его без работы, но пока этот день не настал, ему самому нужно как-то добывать себе пропитание.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/skirmisher_background.nut
    {
        en = "Skirmisher"
        ru = "Налётчик"
    }
    {
        en = "Skirmishers are light combatants that specialize in harassing larger groups of heavily armored soldiers. They can do a surprising amount of damage, but are unsuited to direct confrontation."
        ru = "Налётчики - лёгкие бойцы, специализирующиеся на изматывании больших групп хорошо бронированных солдат. Они способны нанести неожиданно большой урон, но не подходят для прямого столкновения."
    }
    {
        en = "the Skirmisher"
        ru = "Налётчик"
    }
    {
        en = "the Lightfooted"
        ru = "Легконогий"
    }
    {
        en = "the Ambusher"
        ru = "Засадник"
    }
    {
        en = "{%name% the skirmisher is a member of an emerging class of fighters specializing in midranged combat. Armed only with several packs of throwing weapons, and light armor, %name% has dedicated his life to dealing maximum damage to the enemy while skirting the edge of disaster. You ask %name% how he summons the courage to pursue such an aggressive fighting style. He merely shrugs and tells you that becoming a frontliner wasn't likely to earn him any heavier defensive gear anyway.}"
        ru = "{%name% налётчик принадлежит к новому поколению бойцов, что специализируются на бое со средней дистанции. Вооружённый лишь парой связок метательного оружия и одетый в лёгкую броню, %name% посвятил жизнь нанесению максимального урона врагу, балансируя на грани катастрофы. Ты спрашиваешь %name%, откуда у него смелость драться в таком агрессивном стиле. Он лишь пожимает плечами и отвечает, что сражаясь в первых рядах он всё равно не разжился бы более крепкой броней.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/surgeon_background.nut
    {
        en = "Surgeon"
        ru = "Лекарь"
    }
    {
        en = "Capable surgeons are a rare find, and often have their hands full with patching up wounded soldiers and villagers alike. They are used to the sight of blood and have operated in high stress situations, but are below average combatants."
        ru = "Умелые лекари - редкая находка, и они обычно по горло заняты, латая как раненых солдат, так и крестьян. Они привыкли к виду крови и умеют работать в стрессовых ситуациях, но не очень хороши в бою."
    }
    {
        en = "the Surgeon"
        ru = "Резака"
    }
    {
        en = "the Doc"
        ru = "Док"
    }
    {
        en = "the Doctor"
        ru = "Доктор"
    }
    {
        en = "the Medic"
        ru = "Медик"
    }
    {
        en = "{Learned medical men are a treasured rarity in these troubled times. Nonetheless, %name% is one such man, serving for years as a medic for noble armies and saving the lives of countless soldiers. However, when he failed to save an important nobleman's son, he was dishonorably discharged. Lacking the resources and assistants to work his previous miracles, %name% now seeks a much humbler life as a medic for a merceary group, stating that he has been due for some real adventure.}"
        ru = "{В эти неспокойные времена учёные лекари - редкое сокровище. %name% как раз из таких - годами он служил полковым медиком в армиях знати, спасая жизни бесчисленных солдат. Однако после того, как ему не удалось спасти сына важного дворянина, его с позором уволили. Лишившись ресурсов и помощников для совершения прежних чудес, %name% теперь ищет куда более скромной жизни медика в отряде наёмников, говоря, что давно пора попробовать настоящих приключений.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/torturer_background.nut
    {
        en = "Torturer"
        ru = "Истязатель"
    }
    {
        en = "All noblemen employ torturers, though few would admit it openly. Torturers' personalities vary wildly from cruel detachment to psychotic malice. Nevertheless, they are all brutally efficient at inflcting pain and permanent damage."
        ru = "Все дворяне держат заплечных дел мастеров, хоть мало кто признается в этом открыто. Характеры у палачей разные: от хладнокровной отрешённости до психотической злобы. Тем не менее, все они чрезвычайно искусны в причинении боли и увечий."
    }
    {
        en = "the Psychotic"
        ru = "Психопат"
    }
    {
        en = "the Malicious"
        ru = "Злобный"
    }
    {
        en = "the Torturer"
        ru = "Мучитель"
    }
    {
        en = "the Bloodletter"
        ru = "Кровопускатель"
    }
    {
        en = "the Cruel"
        ru = "Жестокий"
    }
    {
        en = "{Even in his youth, it was clear that %name%'s mind was wired in a sinister way. He reveled in the suffering of the weak, torturing frogs, rabbits, and even cats with perverse glee. It wasn't long before his father begged the local lord to either cure the lad or lock him away. The lord however, sensed talent and did neither; opting instead to hire him as a torturer. You don't know why he is looking for mercenary work now...but you get the feeling that you don't want to know.}"
        ru = "{Ещё в юности было ясно, что с головой у %name% не всё в порядке. Он упивался страданиями слабых, с извращённым удовольствием мучая лягушек, кроликов и даже кошек. Вскоре его отец умолял местного лорда либо вылечить парня, либо запереть. Но лорд, почуяв талант, не сделал ни того, ни другого, а нанял его палачом. Вы не знаете, почему он теперь ищет работу наёмника... но чувствуете, что лучше вам этого и не знать.}"
    }
    // FILE: scripts/skills/backgrounds/hackflows/town_watchman_background.nut
    {
        en = "Town Watchman"
        ru = "Стражник"
    }
    {
        en = "Town Watchmen are hired by burgomeisters to keep the peace and identify early threats to a town."
        ru = "Стражники нанимаются бургомистрами для поддержания порядка и раннего выявления угроз городу."
    }
    {
        en = "the Overseer"
        ru = "Надзиратель"
    }
    {
        en = "the Town Watchman"
        ru = "Страж"
    }
    {
        en = "the Night Owl"
        ru = "Сова"
    }
    {
        en = "the Patrolman"
        ru = "Патрульный"
    }
    {
        en = "{To be able to combat a threat, one must first know of its existence. %name% the town watchman was responsible for just that, able to spot threats at a distance and rouse the town militia whenever enemies were on the approach. However, one night after a town festival %name% was too plastered to notice brigands creeping up for a raid, and the resulting losses weighed too heavily on his conscience for him to continue serving at his post. Now he seeks to join a mercenary crew, knowing fully well that they go after bandits at the source on a regular basis.}"
        ru = "{Чтобы противостоять угрозе, нужно сначала узнать о её существовании. %name% служил городским стражем именно для этого - высматривал угрозы издалека и поднимал ополчение, когда враги приближались к городу. Однако после одного городского праздника %name% был слишком пьян, чтобы заметить бандитов, подкрадывающихся для набега. Понесённые потери слишком тяжело легли на его совесть, и он не смог продолжать службу. Теперь он хочет присоединиться к отряду наёмников, прекрасно зная, что они регулярно бьют разбойников в их логове.}"
    }
]
::Rosetta.add(rosetta, pairs);
