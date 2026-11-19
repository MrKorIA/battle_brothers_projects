::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/serpent_bite_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Укус гигантской змеи может быть болезненным в течение некоторого времени.";
		m.KilledString = "Разорван в клочья";
		m.Icon = "skills/active_196.png";
		m.IconDisabled = "skills/active_196_sw.png";
		m.ChanceDisembowel = 25;
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultTooltip();

		if (getMaxRange() > 1)
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Имеет дальность в [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] клетки"
			});

		return ret;
	}

	q.onAfterUpdate <- function( _properties )
	{
		if (_properties.IsSpecializedInShields)
			m.MaxRange += 1;
		
		if (_properties.IsSpecializedInPolearms)
			m.ActionPointCost -= 1;
	}

	q.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
	    if (_skill == this && _targetEntity != null)
	    {
	    	local d = getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile());
	    	
	    	if (d <= 1) return;
	    	
    		_properties.MeleeSkill -= 5 * (d - 1);
    		_properties.MeleeDamageMult *= 0.85; // deal less damage when is not in melee range
	    }
	}
});
