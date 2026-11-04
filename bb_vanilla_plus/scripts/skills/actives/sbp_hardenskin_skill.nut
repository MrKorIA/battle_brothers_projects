this.sbp_hardenskin_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_hardenskin_skill";
		this.m.Name = "90. Закаленная кожа (пассивная способность)";
		this.m.Icon = "ui/xxp8.png";
		this.m.Description = "Тренируя тело до предела, можно стать настолько непобедимым, что даже доспехи не понадобятся.";
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
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Когда слот для головы пуст: +12 к навыку ближнего боя, +12 к навыку дальнего боя, +12 к защите в ближнем бою"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Когда слот для тела пуст: +120 HP"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Когда слоты для головы и тела пусты: при потере очков здоровья не срабатывает проверка морального духа."
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local bodyt = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		local headt = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		if (bodyt == null)
		{
			_properties.Hitpoints += 120;
		}
		if (headt == null)
		{
			_properties.MeleeDefense += 12;
			_properties.MeleeSkill += 12;
			_properties.RangedSkill += 12;
		}
		if (bodyt == null && headt == null)
		{
			_properties.IsAffectedByLosingHitpoints = false;
		}
	}

});

