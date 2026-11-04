this.sbp_drunk_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_drunk_skill";
		this.m.Name = "88. Пьяный мастер (пассивный)";
		this.m.Icon = "ui/xxp5.png";
		this.m.Description = "Повышенные боевые навыки в состоянии алкогольного опьянения.";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast + 100;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
		this.m.IsHidden = false;
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
			}
		];
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "В начале боя: если у вас нет оружия, вы будете пьяны."
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "В состоянии опьянения или с похмельем: +55% к урону. На 55% меньше получаемого урона."
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getActor().getSkills().hasSkill("effects.drunk") || this.getContainer().getActor().getSkills().hasSkill("effects.hangover"))
		{
			_properties.DamageReceivedTotalMult *= 0.45;
			_properties.DamageTotalMult += 0.55;
			_properties.TargetAttractionMult *= 1.2;
		}
	}

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();
		if (actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
		{
			if (!actor.getSkills().hasSkill("effects.drunk") && !actor.getSkills().hasSkill("effects.hangover"))
			{
				actor.getSkills().add(this.new("scripts/skills/effects_world/drunk_effect"));
			}
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.Sound.play("sounds/combat/taunt_0" + this.Math.rand(1, 5) + ".wav", 2.5, this.getContainer().getActor().getPos(), this.Math.rand(80, 90) * 0.01);
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		this.Sound.play("sounds/combat/taunt_0" + this.Math.rand(1, 5) + ".wav", 1.7, this.getContainer().getActor().getPos(), 0.8);
	}

});

