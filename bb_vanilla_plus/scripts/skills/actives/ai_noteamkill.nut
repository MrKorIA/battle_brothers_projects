this.ai_noteamkill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.ai_noteamkill";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsHidden = true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.isAttack() && _targetEntity != null && this.getContainer().getActor().isPlacedOnMap())
		{
			local actor = this.getContainer().getActor();
			local targetTile = _targetEntity.getTile();
			local TeamKill = false;
			for( local i = 0; i < 6; i = ++i )
			{
				if (targetTile.hasNextTile(i))
				{
					local nextTile = targetTile.getNextTile(i);
					if (nextTile.IsOccupiedByActor)
					{
						local entityOnTile = nextTile.getEntity();
						if (entityOnTile.getID() != actor.getID() && entityOnTile.getFaction() == actor.getFaction())
						{
							TeamKill = true;
							break;
						}
					}
				}
			}
			if (TeamKill)
			{
				_properties.RangedAttackBlockedChanceMult *= 0;
			}
			if (_targetEntity.getID() != actor.getID() && actor.isAlliedWith(_targetEntity))
			{
				_properties.MeleeSkillMult *= 0;
				_properties.RangedSkillMult *= 0;
				_properties.DamageTotalMult *= 0;
			}
		}
	}

});

