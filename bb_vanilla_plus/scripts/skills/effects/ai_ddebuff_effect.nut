this.ai_ddebuff_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Count = 1
	},
	function create()
	{
		this.m.ID = "effects.ai_ddebuff_effect";
		this.m.Name = "Бесконечное и непрекращающееся ослабление";
		this.m.Description = "Этот персонаж получает больше урона от врагов и имеет уменьшенный шанс попадания и уклонения.";
		this.m.Icon = "skills/status_effect_52.png";
		this.m.IconMini = "status_effect_52_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsHidden = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getName()
	{
		if (this.m.Count <= 1)
		{
			return this.m.Name;
		}
		else
		{
			return this.m.Name + " (x" + this.m.Count + ")";
		}
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
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.Count * 1 + "[/color] Melee and Ranged Skill"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.Count * 1 + "[/color] Melee and Ranged Defense"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.Count * 0.01 * 100 + "%[/color] More Damage Taken"
			}
		];
	}

	function setTurns( _t )
	{
		if (this.getContainer() != null)
		{
			this.m.Count = this.Math.max(1, _t);
		}
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkill += -1 * this.m.Count;
		_properties.RangedSkill += -1 * this.m.Count;
		_properties.MeleeDefense += -1 * this.m.Count;
		_properties.RangedDefense += -1 * this.m.Count;
		_properties.DamageReceivedTotalMult *= (this.m.Count * 0.01) + 1;
	}

});

