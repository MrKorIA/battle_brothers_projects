this.xxitem_xxuquiveraa_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.xxitem_xxuquiveraa_skill";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsHidden = true;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_targetEntity.isAlive() && !_targetEntity.isDying() && _targetEntity.getFlags().has("undead"))
		{
			if (_skill.getID() == "actives.aimed_shot" || _skill.getID() == "actives.quick_shot" || _skill.getID() == "actives.shoot_bolt" || _skill.getID() == "actives.shoot_stake" || _skill.getID() == "actives.fire_handgonne" || _skill.getID() == "actives.xxitem_rifleaa_skill" ||
			_skill.getID() == "actives.sb_multishot_skill" || _skill.getID() == "actives.sb_penshot_skill" || _skill.getID() == "sb_zeroshot_skill")
			{
				local effect = this.new("scripts/skills/effects/ai_pain_effect");
				effect.setDamage(10);
				_targetEntity.getSkills().add(effect);
			}
		}
	}

	function onUpdate( _properties )
	{
		local a = this.getContainer().getActor();
		local ak = a.getSkills();
		local mm = a.getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);
		if (ak.hasSkill("actives.fire_handgonne") || ak.hasSkill("actives.xxitem_rifleaa_skill"))
		{
			mm.m.Name = "Nightshade Quiver (Powder)";
			mm.m.ID = "ammo.powder";
			mm.m.AmmoType = this.Const.Items.AmmoType.Powder;
		}
		else if (ak.hasSkill("actives.shoot_bolt") || ak.hasSkill("actives.shoot_stake"))
		{
			mm.m.Name = "Nightshade Quiver (Bolts)";
			mm.m.ID = "ammo.bolts";
			mm.m.AmmoType = this.Const.Items.AmmoType.Bolts;
		}
		else
		{
			mm.m.Name = "Nightshade Quiver (Arrows)";
			mm.m.ID = "ammo.arrows";
			mm.m.AmmoType = this.Const.Items.AmmoType.Arrows;
		}
		_properties.RangedSkill += 7;
	}

});

