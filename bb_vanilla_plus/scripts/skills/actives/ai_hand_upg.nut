this.ai_hand_upg <- this.inherit("scripts/skills/skill", {
	//clone9
	m = {
		Damage = 2
	},
	function getDamage()
	{
		return this.m.Damage;
	}

	function setDamage( _d )
	{
		this.m.Damage = _d;
	}

	function create()
	{
		this.m.ID = "effects.ai_hand_upg";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsStacking = false;
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		if (actor.getFlags().has("clone"))
		{
			local bodyt = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
			local headt = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
			if (bodyt == null)
			{
				_properties.MeleeDefense += 3;
				_properties.Hitpoints += 100;
			}
			if (headt == null)
			{
				_properties.MeleeDefense += 3;
				_properties.Hitpoints += 100;
			}
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.getID() == "actives.hand_to_hand")
		{
			local offh = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
			if (offh != null)
			{
				_properties.DamageTotalMult *= this.m.Damage * 0.75;
			}
			else
			{
				_properties.DamageTotalMult *= this.m.Damage;
			}
		}
	}

});

