this.legend_command_legion_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.legend_command_legion";
		this.m.Name = "Приказ легионеру";
		this.m.Description = "Отдайте приказ бойцу ранга центуриона или ниже. Каждая цель может быть воодушевлена лишь раз за ход. Не действует на легатов.";
		this.m.Icon = "skills/legend_legion_command_square.png";
		this.m.IconDisabled = "skills/legend_legion_command_square_bw.png";
		this.m.IconMini = "legend_status_effect_legion_command_mini";
		this.m.Overlay = "legend_legion_command_square";
		this.m.SoundOnUse = [ //new sounds would be good
			"sounds/combat/inspire_01.wav",
			"sounds/combat/inspire_02.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsUsingHitchance = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 4;
		this.m.MaxLevelDifference = 4;
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
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
                id = 7,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Дарует цели [color=" + this.Const.UI.Color.PositiveValue + "]+4[/color] дополнительных очка действий на следующий ход."
            },
            {
                id = 7,
                type = "text",
                icon = "ui/icons/initiative.png",
                text = "Дарует цели [color=" + this.Const.UI.Color.PositiveValue + "]+50[/color] к инициативе на следующий ход."
            },
            {
                id = 7,
                type = "text",
                icon = "ui/icons/melee_skill.png",
                text = "Дарует цели [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] к мастерству ближнего боя на следующий ход."
            },
            {
                id = 7,
                type = "text",
                icon = "ui/icons/melee_defense.png",
                text = "Дарует цели [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] к защите в ближнем бою на следующий ход."
            },
            {
                id = 7,
                type = "text",
                icon = "ui/icons/ranged_skill.png",
                text = "Дарует цели [color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] к мастерству дальнего боя на следующий ход."
            },
            {
                id = 7,
                type = "text",
                icon = "ui/icons/ranged_defense.png",
                text = "Дарует цели [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] к защите от дальних атак на следующий ход."
            },
            {
                id = 7,
                type = "text",
                icon = "ui/icons/direct_damage.png",
                text = "Уменьшает получаемый урон на [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] на следующий ход."
            }
		];
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
			return false;

		if (_targetTile.getEntity() == null)
			return false;

		if (!_targetTile.getEntity().getFlags().has("legion_can_command"))
			return false;

		if (_targetTile.getEntity().getSkills().hasSkill("effects.legend_commanded"))
			return false;

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
        target.getSkills().add(this.new("scripts/skills/effects/legend_commanded_effect"));
		return true;
	}

});
