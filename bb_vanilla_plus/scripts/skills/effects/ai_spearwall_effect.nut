this.ai_spearwall_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.spearwall";
		this.m.Name = "Стена из копий";
		this.m.Icon = "skills/status_effect_04.png";
		this.m.IconMini = "status_effect_04_mini";
		this.m.Overlay = "status_effect_04";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Подготовив копье, этот персонаж получает автоматическую бесплатную атаку на любого противника, пытающегося войти в его зону контроля.";
	}

	function onUpdate( _properties )
	{
		_properties.IsAttackingOnZoneOfControlEnter = true;

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInSpears)
		{
			_properties.IsAttackingOnZoneOfControlAlways = true;
		}
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.Tactical.TurnSequenceBar.getActiveEntity() == null || this.Tactical.TurnSequenceBar.getActiveEntity().getID() != this.getContainer().getActor().getID())
		{
			_properties.DamageTotalMult *= 0.5;
		}
	}

});

