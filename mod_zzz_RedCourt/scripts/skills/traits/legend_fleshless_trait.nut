this.legend_fleshless_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.legend_fleshless";
        this.m.Name = "Бесплотный";
        this.m.Description = "Лишь кости остались от некогда живого существа - вся плоть сгнила или была сорвана.";
		this.m.Icon = "ui/traits/fleshless_trait.png";
	}

	function getTooltip()
	{
		local ret = [
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
                id = 7,
                type = "text",
                icon = "ui/icons/damage_received.png",
                text = "Не подвержен кровотечению, отравлению и большинству свежих ран."
            },
            {
                id = 7,
                type = "text",
                icon = "ui/icons/days_wounded.png",
                text = "Восстанавливает здоровье лишь на 20% от обычной скорости. Не нуждается в пище. Устойчив к колющим атакам."
            },
            {
                id = 7,
                type = "text",
                icon = "ui/icons/fatigue.png",
                text = "Утомляется лишь на 10% от обычной нормы."
            },
            {
                id = 7,
                type = "text",
                icon = "ui/icons/morale.png",
                text = "Не подвержен проверкам боевого духа и не реагирует на бегство или гибель союзников."
            },
            {
                id = 7,
                type = "text",
                icon = "ui/icons/vision.png",
                text = "Не получает штрафов в ночное время."
            }
		];
		return ret;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor().get();

		if (::MSU.isKindOf(actor, "player"))
		{
			actor.improveMood = function ( _change, _text = "" )
			{
			};
			actor.worsenMood = function ( _change, _text = "" )
			{
			};
		}

		if (!actor.getSkills().hasSkill("racial.skeleton"))
		{
			actor.m.Flags.add("PlayerSkeleton");
			actor.m.Flags.add("skeleton");
			actor.m.Flags.add("undead");
            actor.getSkills().add(this.new("scripts/skills/racial/skeleton_racial"));
		}

		actor.m.MoraleState = this.Const.MoraleState.Ignore;
		actor.m.ExcludedInjuries = [
			"injury.collapsed_lung_part",
			"injury.cut_artery",
			"injury.cut_throat",
			"injury.deep_abdominal_cut",
			"injury.deep_chest_cut",
			"injury.exposed_ribs",
			"injury.grazed_kidney",
			"injury.grazed_neck",
			"injury.infected_wound",
			"injury.sickness",
			"injury.stabbed_guts",
			"injury.broken_nose",
			"injury.crushed_windpipe",
			"injury.inhaled_flames",
			"injury.pierced_chest",
			"injury.pierced_lung",
			"injury.pierced_side"
		];

		actor.onFactionChanged();
		actor.onUpdateInjuryLayer();
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		actor.m.MoraleState = this.Const.MoraleState.Ignore;
		_properties.IsImmuneToBleeding = true;
		_properties.IsImmuneToPoison = true;
		_properties.IsAffectedByNight = false;
		_properties.IsAffectedByFleeingAllies = false;
		_properties.IsAffectedByDyingAllies = false;
		_properties.IsAffectedByFreshInjuries = false;
		_properties.MoraleEffectMult = 0.1;
		_properties.FatigueEffectMult = 0.1;
		_properties.HitpointsRecoveryRateMult = 0.2;
		_properties.MovementFatigueCostMult = 0.1;
		_properties.DailyWageMult *= 0;
		_properties.XPGainMult *= 1.0;
		_properties.DailyFood = 0;
		// _properties.HitpointsMult *= 0.5; //best decided in bg/summon files from now on - Luft
	}

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();
		actor.m.MoraleState = this.Const.MoraleState.Ignore;
		actor.m.BloodType = this.Const.BloodType.Bones;
		actor.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/skeleton_idle_06.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/skeleton_hurt_01.wav",
			"sounds/enemies/skeleton_hurt_02.wav",
			"sounds/enemies/skeleton_hurt_03.wav",
			"sounds/enemies/skeleton_hurt_04.wav",
			"sounds/enemies/skeleton_hurt_06.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/skeleton_death_01.wav",
			"sounds/enemies/skeleton_death_02.wav",
			"sounds/enemies/skeleton_death_03.wav",
			"sounds/enemies/skeleton_death_04.wav",
			"sounds/enemies/skeleton_death_05.wav",
			"sounds/enemies/skeleton_death_06.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/skeleton_idle_06.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/skeleton_idle_06.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/skeleton_idle_01.wav",
			"sounds/enemies/skeleton_idle_02.wav",
			"sounds/enemies/skeleton_idle_03.wav",
			"sounds/enemies/skeleton_idle_04.wav",
			"sounds/enemies/skeleton_idle_05.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Move] = [
			"sounds/enemies/skeleton_idle_06.wav"
		];
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		actor.m.BloodType = this.Const.BloodType.Bones;
		actor.m.MoraleState = this.Const.MoraleState.Steady;
        actor.getSkills().removeByID("racial.skeleton");

		actor.getFlags().remove("undead");
		actor.getFlags().remove("skeleton");
		actor.getFlags().remove("PlayerSkeleton");
		// Clear excluded injuries list
		actor.m.ExcludedInjuries = [];
		// Restore appearance
		local background = actor.getBackground();
		if (background != null) {
			background.setAppearance();
		}
		actor.getItems().updateAppearance();
		actor.setDirty(true);
	}

});
