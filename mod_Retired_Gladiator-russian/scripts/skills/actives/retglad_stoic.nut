this.retglad_stoic <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.retglad_stoic";
		this.m.Name = "Стоик";
		this.m.Description = "При использовании уменьшается получаемый урон и длительность отрицательных эффектов на 1 ход. Свежие повреждения не влияют на персонажа в течение одного хода.";
		this.m.Icon = "ui/perks/perk_stoic.png";
		this.m.IconDisabled = "ui/perks/perk_stoic_bw.png";
		this.m.Overlay = "perk_stoic_active";
		this.m.SoundOnUse = [
			"sounds/combat/indomitable_01.wav", //Change later?
			"sounds/combat/indomitable_02.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 2;
		this.m.FatigueCost = 20;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getTooltip()
	{
		return [
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
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Получает только [color=" + this.Const.UI.Color.PositiveValue + "]40%[/color] от любого урона"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]Не подвержен травмам[/color]"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]Длительность всех негативных эффектов снижена на 1 ход[/color]"
			}
		];
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().hasSkill("effects.retglad_stoic");
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onUse( _user, _targetTile )
	{
		if (!this.getContainer().hasSkill("effects.retglad_stoic"))
		{
			this.m.Container.add(this.new("scripts/skills/effects/retglad_stoic_effect"));
			return true;
		}

		return false;
	}

});

