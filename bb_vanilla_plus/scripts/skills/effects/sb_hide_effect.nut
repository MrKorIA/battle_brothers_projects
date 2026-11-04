this.sb_hide_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.sb_hide_effect";
		this.m.Name = "Скрытый";
		this.m.Description = "Этот персонаж скрыт и привлекает меньше внимания со стороны врагов. +12 к защите в ближнем и дальнем бою. Перемещение стоит на 1 AP меньше. Игнорировать ZOC";
		this.m.Icon = "skills/status_effect_08.png";
		this.m.IconMini = "status_effect_08_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		actor.setAlpha(141);
		actor.setDirty(true);
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		actor.setAlpha(111);
		actor.setDirty(true);
		_properties.TargetAttractionMult *= 0.1;
		_properties.MeleeDefense += 12;
		_properties.RangedDefense += 12;
		_properties.MovementAPCostAdditional -= 1;
		_properties.IsImmuneToZoneOfControl = true;
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		actor.setAlpha(255);
		actor.setDirty(true);
		foreach( i in actor.getItems().getAllItems() )
		{
			i.updateAppearance();
		}
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

});

