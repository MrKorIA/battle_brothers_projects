this.perk_vampire_vile_weaponry <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.vampire_vile_weaponry";
		this.m.Name = this.Const.Strings.PerkName.VampireVileWeaponry;
		this.m.Description = this.Const.Strings.PerkDescription.VampireVileWeaponry;
		this.m.Icon = "ui/perks/perk_vile_weaponry.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsHidden = false;
	}

   function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_targetEntity == null || !_targetEntity.isAlive() || _targetEntity.getCurrentProperties().IsImmuneToPoison == true || !_targetEntity.getSkills().hasSkill("effects.bleeding") || _targetEntity.getSkills().hasSkill("effects.legend_grazed_effect"))
		{
			return;
		}

		local actor = this.getContainer().getActor();
		local item = actor.getMainhandItem();

		if (item == null) return;

		_targetEntity.getSkills().add(this.new("scripts/skills/effects/hemovore_poison_effect"));
	}

	function onUpdate( _properties )
	{
		// _properties.DamageReceivedRegularMult *= 0.95; //5% reduction
	}

});
