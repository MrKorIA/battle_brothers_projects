this.sbp_headcollector_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_headcollector_skill";
		this.m.Name = "91. Охотник за головами (пассивный)";
		this.m.Icon = "ui/xxp13.png";
		this.m.Description = "+15% Chance to hit head. When attacking, hitting the head restores 10 fatigue.";
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
			text = "When you have Skull Surgery(105) skill : +10% Melee Damage."
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		local r = this.getContainer().getActor().getSkills().hasSkill("actives.sbp_skullsurgery_skill") ? 0.1 : 0;
		_properties.MeleeDamageMult += r;
		_properties.HitChance[this.Const.BodyPart.Head] += 15;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_targetEntity == null || _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
		{
			return;
		}
		if (_bodyPart == this.Const.BodyPart.Head)
		{
			local actor = this.getContainer().getActor();
			actor.setFatigue(this.Math.max(0, actor.getFatigue() - 10));
			actor.setDirty(true);
		}
	}

});

