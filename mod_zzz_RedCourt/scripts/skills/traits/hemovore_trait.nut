this.hemovore_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
		InjuryType = this.Math.rand(1, 4)
	},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.hemovore";
		this.m.Name = "Кровокрад";
		this.m.Icon = "ui/traits/hemovore_trait.png";
		this.m.Description = "Находясь на грани между жизнью и смертью, этот персонаж часто пользуется преимуществами обоих состояний. Но в последнее время что-то заставляет его чувствовать себя... не в своей тарелке.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
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
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Восстанавливает ОЗ в два раза быстрее обычного. Не требует пищи и невосприимчив к яду."
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "Не происходит проверки боевого духа при потере ОЗ, бегства или смерти союзников и не применяются ночные штрафы."
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "Штраф защиты из-за окружения [color=" + this.Const.UI.Color.NegativeValue + "]увеличен[/color] на [color=" + this.Const.UI.Color.NegativeValue + "]5[/color]."
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]33%[/color] нанесённого урона по ОЗ, будет возвращено в виде здоровья."
			}
		];
	}

	function onUpdate( _properties )
	{
		// _properties.IsImmuneToBleeding = true;
		_properties.IsImmuneToPoison = true;
		_properties.IsAffectedByNight = false;
		_properties.IsAffectedByFreshInjuries = true;
		_properties.MoraleEffectMult *= 1.0;
		_properties.HitpointsRecoveryRateMult *= 0.5;
		_properties.XPGainMult *= 1.0;
		_properties.DailyFood *= 0;
		_properties.IsAffectedByLosingHitpoints = false;
		// _properties.DamageReceivedRegularMult *= 0.60; //40% reduction
		_properties.SurroundedDefense -= 5;

		// _properties.HitpointsMult *= 1.30; //+30%
		// _properties.ThresholdToReceiveInjuryMult *= 1.50; //+50%
		_properties.IsAffectedByFleeingAllies = false;
		_properties.IsAffectedByDyingAllies = false;
	}

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();
		actor.m.BloodType = this.Const.BloodType.Red;
		actor.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/vampire_idle_01.wav",
			"sounds/enemies/vampire_idle_02.wav",
			"sounds/enemies/vampire_idle_03.wav"
		];
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
		actor.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/vampire_hurt_01.wav",
			"sounds/enemies/vampire_hurt_02.wav",
			"sounds/enemies/vampire_idle_02.wav",
			"sounds/enemies/vampire_idle_03.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/vampire_idle_01.wav",
			"sounds/enemies/vampire_idle_02.wav",
			"sounds/enemies/vampire_idle_03.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/vampire_idle_01.wav",
			"sounds/enemies/vampire_idle_02.wav",
			"sounds/enemies/vampire_idle_03.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Move] = [
			"sounds/enemies/vampire_hurt_01.wav",
			"sounds/enemies/vampire_hurt_02.wav",
			"sounds/enemies/vampire_hurt_03.wav"
		];
	}
		//health leech
	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_damageInflictedHitpoints <= 0)
		{
			return;
		}

		local actor = this.m.Container.getActor();

		if (actor.getHitpoints() == actor.getHitpointsMax())
		{
			return;
		}

		this.spawnIcon("status_effect_09", actor.getTile());

		if (!actor.isHiddenToPlayer())
		{
			if (this.m.SoundOnUse.len() != 0)
			{
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect, actor.getPos());
			}

			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " восстанавливает" + this.Math.min(actor.getHitpointsMax() - actor.getHitpoints(), this.Math.round(_damageInflictedHitpoints * 0.33)) + " ОЗ");
		}

		actor.setHitpoints(this.Math.min(actor.getHitpointsMax(), actor.getHitpoints() + this.Math.round(_damageInflictedHitpoints * 0.33)));
	}

	function onAdded()
	{
		local items = this.getContainer().getActor().getItems();
		items.getData()[this.Const.ItemSlot.Head][0] = -1;
		items.getData()[this.Const.ItemSlot.Body][0] = -1;
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		actor.m.BloodType = this.Const.BloodType.Red;
		actor.m.MoraleState = this.Const.MoraleState.Steady;
		// ::Legends.Traits.remove(actor, ::Legends.Trait.RacialVampire);
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU8(this.m.InjuryType);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.InjuryType = _in.readU8();
	}

});

