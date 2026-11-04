this.sbp_sharpshooter_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_sharpshooter_skill";
		this.m.Name = "104. Снайпер (пассивный)";
		this.m.Icon = "ui/xxp27.png";
		this.m.Description = "+5 урона за каждую клетку расстояния до цели при использовании навыка Лук или Арбалет. Перк В яблочко увеличивает этот урон.";
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
		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.getID() == "actives.quick_shot" || _skill.getID() == "actives.aimed_shot"
		|| _skill.getID() == "actives.shoot_bolt" || _skill.getID() == "actives.shoot_stake" 
		|| _skill.getID() == "actives.sb_multishot_skill" || _skill.getID() == "actives.sb_penshot_skill")
		{
			local r = 5;
			if (this.getContainer().getActor().getSkills().hasSkill("perk.bullseye"))
			{
				r = r + 3;
			}
			_properties.DamageAdditionalWithEachTile += r;
		}
	}

});

