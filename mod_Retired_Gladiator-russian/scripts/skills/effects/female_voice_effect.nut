this.female_voice_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.female_voice";
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
		actor.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/humans/legends/woman_light_01.wav",
			"sounds/humans/legends/woman_light_02.wav",
			"sounds/humans/legends/woman_light_03.wav",
			"sounds/humans/legends/woman_light_04.wav",
			"sounds/humans/legends/woman_light_05.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/humans/legends/woman_injury_01.wav",
			"sounds/humans/legends/woman_injury_02.wav",
			"sounds/humans/legends/woman_injury_03.wav",
			"sounds/humans/legends/woman_injury_04.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/humans/legends/woman_death_01.wav",
			"sounds/humans/legends/woman_death_02.wav",
			"sounds/humans/legends/woman_death_03.wav",
			"sounds/humans/legends/woman_death_04.wav",
			"sounds/humans/legends/woman_death_05.wav",
			"sounds/humans/legends/woman_death_06.wav",
			"sounds/humans/legends/woman_death_07.wav",
			"sounds/humans/legends/woman_death_08.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/humans/legends/woman_fatigue_01.wav",
			"sounds/humans/legends/woman_fatigue_02.wav",
			"sounds/humans/legends/woman_fatigue_03.wav",
			"sounds/humans/legends/woman_fatigue_04.wav",
			"sounds/humans/legends/woman_fatigue_05.wav",
			"sounds/humans/legends/woman_fatigue_06.wav",
			"sounds/humans/legends/woman_fatigue_07.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/humans/legends/woman_flee_01.wav",
			"sounds/humans/legends/woman_flee_02.wav",
			"sounds/humans/legends/woman_flee_03.wav",
			"sounds/humans/legends/woman_flee_04.wav",
			"sounds/humans/legends/woman_flee_05.wav",
			"sounds/humans/legends/woman_flee_06.wav"
		];
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 1.0;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.NoDamageReceived] = 1.0;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 1.0;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Fatigue] = 1.0;
		actor.m.SoundVolume[this.Const.Sound.ActorEvent.Flee] = 1.0;
	}
});

