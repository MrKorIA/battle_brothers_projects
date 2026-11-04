this.sbp_prudence_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_prudence_skill";
		this.m.Name = "101. Осторожность (пассивная)";
		this.m.Icon = "ui/xxp24.png";
		this.m.Description = "Этот персонаж тщательно обдумывает каждое свое действие и сохраняет хладнокровие..";
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
			id = 3,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=#135213]+12[/color] Защита в ближнем бою"
		});
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Когда [color=#8f1e1e]Fleeing[/color] состояние: [color=#135213]71%[/color] случайный [color=#135213]Разрушение[/color] состояние в начале хода"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=#8f1e1e]+1[/color] Дополнительный пункт действия за каждую перемещенную плитку"
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefense += 12;
		_properties.MovementAPCostAdditional += 1;
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		if (actor.getMoraleState() == this.Const.MoraleState.Fleeing && this.Math.rand(1, 100) <= 71)
		{
			actor.setMoraleState(this.Const.MoraleState.Breaking);
		}
	}

});

