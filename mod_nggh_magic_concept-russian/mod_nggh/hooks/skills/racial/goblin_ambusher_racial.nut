::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/goblin_ambusher_racial", function(q) 
{
	//obj.m.Chance <- 0;
	q.m.IsPlayer <- false;

	q.getChance <- function()
	{
		return !m.IsPlayer || !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() ? 100 : 35;
	}

	q.create = @(__original) function()
	{
		__original();
		m.Name = "Ядовитое оружие";
		m.Description = "Гоблины любят использовать яд, чтобы ослабить свою добычу и врагов. Вместо того чтобы убить жертву, этот яд замедляет её, не давая ей уйти.";
		m.Icon = "skills/status_effect_00.png";
		m.IconMini = "status_effect_54_mini";
		//m.Chance = !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() ? 100 : 35;
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First + 1;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

	q.onAdded <- function()
	{
		m.IsPlayer = ::MSU.isKindOf(getContainer().getActor(), "player");
	}

	q.getTooltip <- function()
	{
		return [
			{
				id = 1,
				type = "title",
				text = getName()
			},
			{
				id = 2,
				type = "description",
				text = getDescription()
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]" + getChance() + "%[/color] к эффекту [color=" + ::Const.UI.Color.DamageValue + "]Яд гоблинов[/color] при каждой атаке оружием"
			}
		];
	}

	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == null || !_skill.m.IsWeaponSkill)
			return;

		if (::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() && m.IsPlayer && ::Math.rand(1, 100) > getChance())
			return;

		__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
	}

});
