::Const.Perks.Hexe_BDSM_Tree <- {
	ID = "Hexe_BDSM_Tree",
	Name = "Мамочка",
	Descriptions = ["извращённые штучки"],
	Tree = [
		[
			::Const.Perks.PerkDefs.NggH_BDSM_WhipLash,
		],
		[
			::Const.Perks.PerkDefs.NggH_BDSM_MaskOn,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggH_BDSM_WhipMastery,
			::Const.Perks.PerkDefs.NggH_BDSM_Bondage,
		],
		[
			::Const.Perks.PerkDefs.NggH_BDSM_WhipPunish,
		],
		[
			::Const.Perks.PerkDefs.NggH_BDSM_DommyMommy,
			::Const.Perks.PerkDefs.NggH_BDSM_WhipLove,
		],
		[],
	]
};

::Const.Perks.HexeBeastCharmAdvancedTree <- {
	ID = "HexeBeastCharmAdvancedTree",
	Name = "Продвинутый очарованный зверь",
	Descriptions = ["продвинутый очарованный зверь"],
	Tree = [
		[],
		[],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHCharmEnemyGhoul,
			::Const.Perks.PerkDefs.NggHCharmEnemyOrk
		],
		[
			::Const.Perks.PerkDefs.NggHCharmEnemyUnhold,
			::Const.Perks.PerkDefs.NggHCharmEnemySchrat
		],
		[
			::Const.Perks.PerkDefs.NggHCharmEnemyLindwurm
		],
	]
};

::Const.Perks.HexeBeastCharmTree <- {
	ID = "HexeBeastCharmTree",
	Name = "Основной очарованный зверь",
	Descriptions = ["основной очарованный зверь"],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.NggHCharmEnemySpider
		],
		[
			::Const.Perks.PerkDefs.NggHCharmEnemyAlp
			::Const.Perks.PerkDefs.NggHCharmEnemyDirewolf
		],
		[
			::Const.Perks.PerkDefs.NggHCharmEnemyGoblin
		],
		[],
		[],
		[],
	]
};

::Const.Perks.HexeBasicTree <- {
	ID = "HexeBasicTree",
	Name = "Основное очарование",
	Descriptions = ["базовое проклятие"],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.NggHCharmBasic,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHCharmWords
		],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHCharmAppearance,
			::Const.Perks.PerkDefs.NggHCharmSpec,
			::Const.Perks.PerkDefs.NggHCharmNudist,
		],
	]
};

::Const.Perks.HexeHexTree <- {
	ID = "HexeHexTree",
	Name = "Проклятие",
	Descriptions = ["проклятие"],
	Tree = [
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHHexHexer,
		],
		[
			::Const.Perks.PerkDefs.NggHHexMastery,
		],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHHexSharePain,
		],
	]
};

::Const.Perks.HexeSpecializedHexTree <- {
	ID = "HexeSpecializedHexTree",
	Name = "Специализированное проклятие",
	Descriptions = ["специализированное проклятие"],
	Tree = [
		[],
		[],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHHexSuffering,
			::Const.Perks.PerkDefs.NggHHexWeakening,
			::Const.Perks.PerkDefs.NggHHexVulnerability,
			::Const.Perks.PerkDefs.NggHHexMisfortune,
		],
		[],
		[],
	]
};

::Const.Perks.LuftTree <- {
	ID = "LuftTree",
	Name = "Трюки Люфта",
	Descriptions = ["Люфт"],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.NggHLuftUnholyFruits,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHLuftPattingSpec,
			::Const.Perks.PerkDefs.NggHLuftInnocentLook
		],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHLuftGhoulBeauty,
		],
	]
};


////////////////////////////////////////////////////
::Const.Perks.CharmArtTrees <- [
	::Const.Perks.HexeBasicTree,
	::Const.Perks.HexeBeastCharmTree,
	::Const.Perks.HexeBeastCharmAdvancedTree,
	::Const.Perks.Hexe_BDSM_Tree,
	//::Const.Perks.LuftTree,
];

::Const.Perks.HexArtTrees <- [
	::Const.Perks.HexeHexTree,
	::Const.Perks.HexeSpecializedHexTree,
];
////////////////////////////////////////////////////

::Const.Perks.NggH_SimpTree <- {
	ID = "NggH_SimpTree",
	Name = "Простак",
	Descriptions = ["Не-а! Ты простак."],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.NggH_Simp_NoFoodOnlyLove,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggH_Simp_UndyingLove,
		],
		[
			::Const.Perks.PerkDefs.NggH_Simp_Bodyguard,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggH_Simp_LevelUp
		],
	]
};

::Const.Perks.NggH_MiscTree <- {
	ID = "NggH_MiscTree",
	Name = "Всякое",
	Descriptions = ["всякое"],
	Tree = [
		[
			::Const.Perks.PerkDefs.LegendBoondockBlade,
			::Const.Perks.PerkDefs.NggHMiscDaytime
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHMiscNighttime,
			::Const.Perks.PerkDefs.NggHMiscFairGame
		],
		[],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHMiscChampion
		],
	]
};

::Const.Perks.NggH_GoblinMountTree <- {     
	ID = "NggH_GoblinMountTree",
	Name = "всадник",
	Descriptions = ["гоблин всадник"],
	WeightMultipliers = [
		{Multiplier = 0.0, Tree = ::Const.Perks.DaggerTree},
		{Multiplier = 0.0, Tree = ::Const.Perks.CrossbowTree},
		{Multiplier = 0.0, Tree = ::Const.Perks.PolearmTree},
	],
	Tree = [
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHGoblinMountTraining
		],
		[
			::Const.Perks.PerkDefs.LegendHorseLiberty
		],
		[
			::Const.Perks.PerkDefs.NggHGoblinMountedCharge
		],
		[
			::Const.Perks.PerkDefs.NggHGoblinMountedArchery
		],
		[],
	]
};

::Const.Perks.NggH_AlpTree <- {
	ID = "NggH_AlpTree",
	Name = "Альп",
	Descriptions = ["альп"],
	Tree = [
		[
			::Const.Perks.PerkDefs.NggHMiscDaytime,
		],
		[
			::Const.Perks.PerkDefs.NggHAlpMindBreak,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHAlpAfterimage,
			::Const.Perks.PerkDefs.NggHAlpSleepSpec,
		],
		[
			::Const.Perks.PerkDefs.NggHAlpAfterWake,
		],
		[
			::Const.Perks.PerkDefs.NggHAlpLivingNightmare,
		],
		[
			::Const.Perks.PerkDefs.NggHAlpNightmareSpec,
		],
	]
};

::Const.Perks.NggH_DemonAlpTree <- {
	ID = "NggH_DemonAlpTree",
	Name = "Демонология",
	Descriptions = ["демон Альп"],
	Tree = [
		[
			::Const.Perks.PerkDefs.NggHAlpFieceFlame,
		],
		[
			::Const.Perks.PerkDefs.NggHAlpMindBreak,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHAlpControlFlame,
		],
		[
			::Const.Perks.PerkDefs.NggHAlpHellishFlame,
		],
		[
			::Const.Perks.PerkDefs.NggHAlpShadowCopy,
		],
		[],
	]
};

::Const.Perks.NggH_WolfTree <- {
	ID = "NggH_WolfTree",
	Name = "Собака",
	Descriptions = ["волк"],
	Tree = [
		[],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHWolfBite,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHWolfThickHide,
			::Const.Perks.PerkDefs.NggHWolfEnrage,
		],
		[
			::Const.Perks.PerkDefs.NggHWolfRabies
		],
	]
};

::Const.Perks.NggH_HyenaTree <- {
	ID = "NggH_HyenaTree",
	Name = "Собака",
	Descriptions = ["гиена"],
	Tree = [
		[],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHHyenaBite,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHWolfThickHide,
			::Const.Perks.PerkDefs.NggHWolfEnrage,
		],
		[
			::Const.Perks.PerkDefs.NggHWolfRabies
		],
	]
};

::Const.Perks.NggH_NachoTree <- {
	ID = "NggH_NachoTree",
	Name = "Упырь",
	Descriptions = ["начо"],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.NggHNachoFrenzy,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHNacho,
		],
		[
			::Const.Perks.PerkDefs.NggHNachoEat,
			::Const.Perks.PerkDefs.NggHMiscLineBreaker,
		],
		[
			::Const.Perks.PerkDefs.NggHNachoBigTummy,
		],
		[
			//::Const.Perks.PerkDefs.NggHNachoVomit,
			::Const.Perks.PerkDefs.NggHNachoScavenger,
		],
	]
};

::Const.Perks.NggH_LindwurmTree <- {
	ID = "NggH_LindwurmTree",
	Name = "Линдвурм",
	Descriptions = ["линдвурм"],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.NggHLindwurmIntimidate
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHLindwurmBody,
		],
		[
			::Const.Perks.PerkDefs.NggHMiscLineBreaker,
		],
		[
			::Const.Perks.PerkDefs.NggHLindwurmAcid,
		],
		[],
	]
};

::Const.Perks.NggH_SchratTree <- {
	ID = "NggH_SchratTree",
	Name = "Леший",
	Descriptions = ["леший"],
	Tree = [
		[
			::Const.Perks.PerkDefs.NggHSchratUprootAoE,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHSchratShield,
			::Const.Perks.PerkDefs.NggHMiscLineBreaker,
		],
		[
			::Const.Perks.PerkDefs.NggHSchratUproot,
		],
		[
			::Const.Perks.PerkDefs.NggHSchratSapling,
		],
		[],
		[
			::Const.Perks.PerkDefs.LegendRoots,
		],
	]
};

::Const.Perks.NggH_SmallSchratTree <- {
	ID = "NggH_SmallSchratTree",
	Name = "Саженец",
	Descriptions = ["малый леший"],
	Tree = [
		[],
		[],
		[],
		[],
		[],
		[],
		[
			::Const.Perks.PerkDefs.LegendRoots,
		],
	]
};

::Const.Perks.NggH_SerpentTree <- {
	ID = "NggH_SerpentTree",
	Name = "Аспид",
	Descriptions = ["аспид"],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.LegendEntice,
		],
		[
			::Const.Perks.PerkDefs.NggHSerpentVenom,
		],
		[
			::Const.Perks.PerkDefs.NggHSerpentDrag,
			::Const.Perks.PerkDefs.NggHSerpentGiant,
		],
		[],
		[],
		[	
			::Const.Perks.PerkDefs.NggHSerpentBite,
		],
	]
};

::Const.Perks.NggH_SpiderTree <- {
	ID = "NggH_SpiderTree",
	Name = "Арахнид",
	Descriptions = ["паук"],
	Tree = [
		[
			::Const.Perks.PerkDefs.LegendBoondockBlade,
		],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggH_Spider_Venom,
		],
		[
			::Const.Perks.PerkDefs.NggH_Spider_Web,
		],
		[
			::Const.Perks.PerkDefs.NggH_Spider_ToughCarapace,
		],
		[
			::Const.Perks.PerkDefs.NggH_Spider_Bite,
		],
	]
};

::Const.Perks.NggH_UnholdTree <- {
	ID = "NggH_UnholdTree",
	Name = "Тролль",
	Descriptions = ["тролль"],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.NggH_Unhold_UnarmedAttack,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggH_Unhold_Fling,
			::Const.Perks.PerkDefs.NggHMiscLineBreaker,
		],
		[],
		[],
		[],
	]
};

::Const.Perks.NggH_SpiderHiveTree <- {
	ID = "NggH_SpiderHiveTree",
	Name = "???",
	Descriptions = ["паучий улей"],
	Tree = [
		[],
		[],
		[],
		[
			::Const.Perks.PerkDefs.NggHEggBreedingMachine, 
			::Const.Perks.PerkDefs.NggHEggAttachSpider
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHEggNaturalSelection
		],
		[
			::Const.Perks.PerkDefs.NggHEggInherit
		]
	]			
};

::Const.Perks.NggH_KrakenTree <- {
	ID = "NggH_KrakenTree",
	Name = "Зверь из зверей",
	Descriptions = ["зверь из зверей"],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.NggHKrakenDevour, 
		],
		[
			::Const.Perks.PerkDefs.NggHKrakenMove, 
		],
		[
			::Const.Perks.PerkDefs.NggHKrakenBite,
		],
		[
			::Const.Perks.PerkDefs.NggHKrakenSwing,
		],
		[ 
			::Const.Perks.PerkDefs.NggHKrakenEnsnare,
		],
		[
			::Const.Perks.PerkDefs.NggHKrakenTentacle,
		]
	]
};

//------------------------------
// undead perk group
::Const.Perks.GhostClassTree <- {
	ID = "GhostClassTree",
	Name = "Мстительный дух",
	Descriptions = ["ужасающие способности"],
	Tree = [
		[],
		[
			::Const.Perks.PerkDefs.NggHGhostSpectralBody,
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHGhostPhase,
			::Const.Perks.PerkDefs.NggHGhostGhastlyTouch,
		],
		[
			::Const.Perks.PerkDefs.NggHGhostVanish
		],
		[],
		[
			::Const.Perks.PerkDefs.NggHGhostSoulEater,
		]
	]
};

////////////////////////////////////////////////////
::Const.Perks.HexenBeastTrees <- [
	::Const.Perks.NggH_NachoTree,
	::Const.Perks.NggH_UnholdTree,
	::Const.Perks.NggH_SchratTree,
	::Const.Perks.NggH_SerpentTree,
	::Const.Perks.NggH_LindwurmTree,
	::Const.Perks.NggH_WolfTree,
	::Const.Perks.NggH_HyenaTree,
	::Const.Perks.NggH_AlpTree,
	::Const.Perks.NggH_DemonAlpTree,
	::Const.Perks.NggH_SpiderTree,
	::Const.Perks.NggH_SpiderHiveTree,
	::Const.Perks.NggH_GoblinMountTree,
	::Const.Perks.NggH_KrakenTree,
	::Const.Perks.NggH_MiscTree,
];
////////////////////////////////////////////////////
::Const.Perks.NggH_UndeadTrees <- [
	::Const.Perks.GhostClassTree,
];
////////////////////////////////////////////////////



