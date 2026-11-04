this.xxzzvoice_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.xxzzvoice_skill";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsAttack = false,
		this.m.IsWeaponSkill = false,
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
		this.m.IsHidden = true;
	}

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();
	     if (actor.getFlags().has("xxzzvoice_girl"))
	     {
		actor.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/fantasyfemale/fantasyfemale_light_01.wav",
			"sounds/fantasyfemale/fantasyfemale_light_02.wav",
			"sounds/fantasyfemale/fantasyfemale_light_03.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/fantasyfemale/fantasyfemale_injury_01.wav",
			"sounds/fantasyfemale/fantasyfemale_injury_02.wav",
			"sounds/fantasyfemale/fantasyfemale_injury_03.wav",
			"sounds/fantasyfemale/fantasyfemale_injury_04.wav",
			"sounds/fantasyfemale/fantasyfemale_injury_05.wav",
			"sounds/fantasyfemale/fantasyfemale_injury_06.wav",
			"sounds/fantasyfemale/fantasyfemale_injury_07.wav",
			"sounds/fantasyfemale/fantasyfemale_injury_08.wav",
			"sounds/fantasyfemale/fantasyfemale_injury_09.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/fantasyfemale/fantasyfemale_death_01.wav",
			"sounds/fantasyfemale/fantasyfemale_death_02.wav",
			"sounds/fantasyfemale/fantasyfemale_death_03.wav",
			"sounds/fantasyfemale/fantasyfemale_death_04.wav",
			"sounds/fantasyfemale/fantasyfemale_death_05.wav",
			"sounds/fantasyfemale/fantasyfemale_death_06.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/fantasyfemale/fantasyfemale_fatigue_01.wav",
			"sounds/fantasyfemale/fantasyfemale_fatigue_02.wav",
			"sounds/fantasyfemale/fantasyfemale_fatigue_03.wav",
			"sounds/fantasyfemale/fantasyfemale_fatigue_04.wav",
			"sounds/fantasyfemale/fantasyfemale_fatigue_05.wav",
			"sounds/fantasyfemale/fantasyfemale_fatigue_06.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/fantasyfemale/fantasyfemale_flee_01.wav",
			"sounds/fantasyfemale/fantasyfemale_flee_02.wav",
			"sounds/fantasyfemale/fantasyfemale_flee_03.wav",
			"sounds/fantasyfemale/fantasyfemale_flee_04.wav"
		];
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 1.0;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.NoDamageReceived] = 1.0;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 1.0;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Fatigue] = 1.0;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Flee] = 1.0;
	     }
	     else if (actor.getFlags().has("xxzzvoice_goblin"))
	     {
		actor.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/goblin_hurt_00.wav",
			"sounds/enemies/goblin_hurt_01.wav",
			"sounds/enemies/goblin_hurt_02.wav",
			"sounds/enemies/goblin_hurt_03.wav",
			"sounds/enemies/goblin_hurt_04.wav",
			"sounds/enemies/goblin_hurt_05.wav",
			"sounds/enemies/goblin_hurt_06.wav",
			"sounds/enemies/goblin_hurt_07.wav",
			"sounds/enemies/goblin_hurt_08.wav",
			"sounds/enemies/goblin_hurt_09.wav",
			"sounds/enemies/goblin_hurt_10.wav",
			"sounds/enemies/goblin_hurt_11.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/goblin_death_00.wav",
			"sounds/enemies/goblin_death_01.wav",
			"sounds/enemies/goblin_death_02.wav",
			"sounds/enemies/goblin_death_03.wav",
			"sounds/enemies/goblin_death_04.wav",
			"sounds/enemies/goblin_death_05.wav",
			"sounds/enemies/goblin_death_06.wav",
			"sounds/enemies/goblin_death_07.wav",
			"sounds/enemies/goblin_death_08.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/goblin_flee_00.wav",
			"sounds/enemies/goblin_flee_01.wav",
			"sounds/enemies/goblin_flee_02.wav",
			"sounds/enemies/goblin_flee_03.wav",
			"sounds/enemies/goblin_flee_04.wav",
			"sounds/enemies/goblin_flee_05.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/goblin_idle_00.wav",
			"sounds/enemies/goblin_idle_01.wav",
			"sounds/enemies/goblin_idle_02.wav",
			"sounds/enemies/goblin_idle_03.wav",
			"sounds/enemies/goblin_idle_04.wav",
			"sounds/enemies/goblin_idle_05.wav",
			"sounds/enemies/goblin_idle_06.wav",
			"sounds/enemies/goblin_idle_07.wav",
			"sounds/enemies/goblin_idle_08.wav",
			"sounds/enemies/goblin_idle_09.wav",
			"sounds/enemies/goblin_idle_10.wav",
			"sounds/enemies/goblin_idle_11.wav",
			"sounds/enemies/goblin_idle_12.wav",
			"sounds/enemies/goblin_idle_13.wav",
			"sounds/enemies/goblin_idle_14.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = actor.m.Sound[this.Const.Sound.ActorEvent.DamageReceived];
		actor.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = actor.m.Sound[this.Const.Sound.ActorEvent.Idle];
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Move] = 0.7;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 0.3;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.NoDamageReceived] = 0.3;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 0.5;
	     }
	     else if (actor.getFlags().has("xxzzvoice_orc"))
	     {
		actor.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/orc_hurt_01.wav",
			"sounds/enemies/orc_hurt_02.wav",
			"sounds/enemies/orc_hurt_03.wav",
			"sounds/enemies/orc_hurt_04.wav",
			"sounds/enemies/orc_hurt_05.wav",
			"sounds/enemies/orc_hurt_06.wav",
			"sounds/enemies/orc_hurt_07.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/orc_death_01.wav",
			"sounds/enemies/orc_death_02.wav",
			"sounds/enemies/orc_death_03.wav",
			"sounds/enemies/orc_death_04.wav",
			"sounds/enemies/orc_death_05.wav",
			"sounds/enemies/orc_death_06.wav",
			"sounds/enemies/orc_death_07.wav",
			"sounds/enemies/orc_death_08.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/orc_fatigue_01.wav",
			"sounds/enemies/orc_fatigue_02.wav",
			"sounds/enemies/orc_fatigue_03.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/orc_flee_01.wav",
			"sounds/enemies/orc_flee_02.wav",
			"sounds/enemies/orc_flee_03.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/orc_idle_01.wav",
			"sounds/enemies/orc_idle_02.wav",
			"sounds/enemies/orc_idle_03.wav",
			"sounds/enemies/orc_idle_04.wav",
			"sounds/enemies/orc_idle_05.wav",
			"sounds/enemies/orc_idle_06.wav",
			"sounds/enemies/orc_idle_07.wav",
			"sounds/enemies/orc_idle_08.wav",
			"sounds/enemies/orc_idle_09.wav",
			"sounds/enemies/orc_idle_10.wav",
			"sounds/enemies/orc_idle_11.wav",
			"sounds/enemies/orc_idle_12.wav",
			"sounds/enemies/orc_idle_13.wav",
			"sounds/enemies/orc_idle_14.wav",
			"sounds/enemies/orc_idle_15.wav",
			"sounds/enemies/orc_idle_16.wav",
			"sounds/enemies/orc_idle_17.wav",
			"sounds/enemies/orc_idle_18.wav",
			"sounds/enemies/orc_idle_19.wav",
			"sounds/enemies/orc_idle_20.wav",
			"sounds/enemies/orc_idle_21.wav",
			"sounds/enemies/orc_idle_22.wav",
			"sounds/enemies/orc_idle_23.wav",
			"sounds/enemies/orc_idle_24.wav",
			"sounds/enemies/orc_idle_25.wav",
			"sounds/enemies/orc_idle_26.wav",
			"sounds/enemies/orc_idle_27.wav",
			"sounds/enemies/orc_idle_28.wav",
			"sounds/enemies/orc_idle_29.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Move] = actor.m.Sound[this.Const.Sound.ActorEvent.Idle];
		actor.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = actor.m.Sound[this.Const.Sound.ActorEvent.DamageReceived];
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Move] = 0.8;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 0.8;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.NoDamageReceived] = 0.8;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 0.8;
	     }
	     else if (actor.getFlags().has("xxzzvoice_undead"))
	     {
		actor.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/vampire_hurt_01.wav",
			"sounds/enemies/vampire_hurt_02.wav",
			"sounds/enemies/vampire_hurt_03.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/vampire_death_01.wav",
			"sounds/enemies/vampire_death_02.wav",
			"sounds/enemies/vampire_death_03.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/vampire_idle_01.wav",
			"sounds/enemies/vampire_idle_02.wav",
			"sounds/enemies/vampire_idle_03.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/skeleton_idle_01.wav",
			"sounds/enemies/skeleton_idle_04.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = actor.m.Sound[this.Const.Sound.ActorEvent.DamageReceived];
		actor.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = actor.m.Sound[this.Const.Sound.ActorEvent.DamageReceived];
		actor.m.Sound[this.Const.Sound.ActorEvent.Flee] = actor.m.Sound[this.Const.Sound.ActorEvent.DamageReceived];
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 1.5;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.NoDamageReceived] = 1.5;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Fatigue] = 1.5;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Flee] = 1.5;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 1.1;
	     }
	}
});

