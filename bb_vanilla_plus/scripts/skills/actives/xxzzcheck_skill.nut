this.xxzzcheck_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.xxzzcheck_skill";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsAttack = false,
		this.m.IsWeaponSkill = false,
		this.m.IsStacking = false;
		this.m.IsSerialized = false;
		this.m.IsHidden = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function onCombatStarted()
	{
		this.removeSelf();
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

	function onTurnEnd()
	{
		this.removeSelf();
	}

});

