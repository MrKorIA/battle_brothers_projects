this.nggh_mod_favoured_night_effect <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effect.favoured_night";
		this.m.Name = "Лунатик";
		this.m.Description = "Этому персонажу комфортно в темноте. Имеет лучшую боеспособность в ночное время.";
		this.m.Icon = "skills/status_effect_35.png";
		this.m.IconMini = "status_effect_35_mini";
		this.m.Type = ::Const.SkillType.StatusEffect | ::Const.SkillType.Special;
		this.m.IsActive = false;
		this.m.IsSerialized = false;
		this.m.IsRemovedAfterBattle = true;
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
				id = 11,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+5%[/color] к наносимому урону"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+10%[/color] к защите в ближнем бою"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+10%[/color] к защите в дальнем бою"
			}
		];
		
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.DamageTotalMult *= 1.05; 
		_properties.MeleeDefenseMult *= 1.1;
		_properties.RangedDefenseMult *= 1.1;
	}

});

