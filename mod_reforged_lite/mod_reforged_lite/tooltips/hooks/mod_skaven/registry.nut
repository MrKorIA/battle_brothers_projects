// Тултип-хуки mod_Skaven_faction — активы, эффекты, расовые навыки скавенов.
local scope = "mod_skaven";

::ReforgedLite.ModSkillTooltips.addSkills([
	// Активные
	"scripts/skills/actives/drink_plague_cured_skill",
	"scripts/skills/actives/hellpit_gorge_skill",
	"scripts/skills/actives/hellpit_move_tail_skill",
	"scripts/skills/actives/hellpit_tail_slam_big_skill",
	"scripts/skills/actives/hellpit_tail_slam_skill",
	"scripts/skills/actives/hellpit_tail_slam_split_skill",
	"scripts/skills/actives/hellpit_tail_slam_zoc_skill",
	"scripts/skills/actives/player_summon_rat_skill",
	"scripts/skills/actives/rally_rat_troops_skill",
	"scripts/skills/actives/rat_gore_skill",
	"scripts/skills/actives/rat_pound",
	"scripts/skills/actives/rat_warpfire_throw_skill",
	"scripts/skills/actives/ratbeast_disarm_skill",
	"scripts/skills/actives/ratbeast_whip_skill",
	"scripts/skills/actives/ratswarm_bite",
	"scripts/skills/actives/summon_rat_skill",
	"scripts/skills/actives/throw_plague_bomb_skill",
	"scripts/skills/actives/wolfrat_bite",

	// Эффекты
	"scripts/skills/effects/plague_cured_effect",
	"scripts/skills/effects/player_summon_rat_effect",
	"scripts/skills/effects/rally_rat_effect",
	"scripts/skills/effects/rat_god_reincarnation_effect",
	"scripts/skills/effects/rat_plague_effect",
	"scripts/skills/effects/summon_rat_effect",
	"scripts/skills/effects/warp_shard_upgrade_effect",

	// Расовые
	"scripts/skills/racial/hellpit_racial",
	"scripts/skills/racial/rat_racial",
], scope);

// Чума — ключевой эффект фракции: все упоминания чумы в текстах скавенов — ссылки на эффект.
::ReforgedLite.ModSkillTooltips.addTerms([
	{ Term = "Чумой", Link = "Skill+rat_plague_effect" },
	{ Term = "Чуме", Link = "Skill+rat_plague_effect" },
	{ Term = "Чума", Link = "Skill+rat_plague_effect" },
	{ Term = "Чуму", Link = "Skill+rat_plague_effect" },
	{ Term = "Чумные", Link = "Skill+rat_plague_effect" },
	{ Term = "чумные", Link = "Skill+rat_plague_effect" },
	{ Term = "чумной", Link = "Skill+rat_plague_effect" },
	{ Term = "чумного", Link = "Skill+rat_plague_effect" },
	{ Term = "чумная", Link = "Skill+rat_plague_effect" },
	{ Term = "чумное", Link = "Skill+rat_plague_effect" },
	{ Term = "чумы", Link = "Skill+rat_plague_effect" },
	{ Term = "чуму", Link = "Skill+rat_plague_effect" },
	{ Term = "чумой", Link = "Skill+rat_plague_effect" },
], scope);
