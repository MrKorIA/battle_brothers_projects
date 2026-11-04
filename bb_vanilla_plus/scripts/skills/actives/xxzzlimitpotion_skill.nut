this.xxzzlimitpotion_skill <- this.inherit("scripts/skills/skill", {
	m = {	},
	function create()
	{
		this.m.ID = "effects.xxzzlimitpotion_skill";
		this.m.Name = "Зелье преодоления пределов";
		this.m.Description = "Максимальное количество навыков, которые этот персонаж может изучить с помощью книг навыков, составляет 3.";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Icon = "ui/perks/perk_56.png";
		this.m.IsActive = false;
		this.m.IsStacking = false;
	}

});

