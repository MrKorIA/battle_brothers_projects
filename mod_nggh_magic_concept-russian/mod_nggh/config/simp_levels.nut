if (!("Simp" in ::Const))
{
	::Const.Simp <- {};
}

::Const.Simp.MaximumLevel <- 10;
::Const.Simp.DefaultBonusValue <- 0.05;
::Const.Simp.DefaultBonusTooltipValue <- 5;

::Const.Simp.Bonuses <- [
	[/* Property */"",   /* Property Name */"",  /* Icon */"" ],
	["BraveryMult",          "Решимость",         "bravery"     ],
	["XPGainMult",           "Получение опыта", "xp_received" ],
	["InitiativeMult",       "Инициатива",      "initiative"  ],
	["StaminaMult",          "Максимальная выносливость",     "fatigue"     ],
	["BraveryMult",          "Решимость",         "bravery"     ],
	["HitpointsMult",        "ОЗ",       "health"      ],
	["TotalAttackToHitMult", "Шанс на попадание",      "hitchance"   ],
	["DamageTotalMult",      "Наносимый урон",   "damage_dealt"],
	["BraveryMult",          "Решимость",         "bravery"     ],
	["InitiativeMult",       "Инициатива",      "initiative"  ],
];

::Const.Simp.SpecialBonuses <- [
	["DamageTotalMult",      "Наносимый урон",   "damage_dealt",  5],
	[  "HitpointsMult",          "ОЗ",         "health", 10]
]
