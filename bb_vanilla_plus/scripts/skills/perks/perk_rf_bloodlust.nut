this.perk_rf_bloodlust <- ::inherit("scripts/skills/skill", {
	m = {
		RequiredWeaponType = ::Const.Items.WeaponType.Cleaver,
		Stacks = 0,
		MaxStacks = 2,
		StacksPerTrigger = 2,
		MultPerStack = 0.15
	},
	function create()
	{
		this.m.ID = "perk.rf_bloodlust";
		this.m.Name = ::Const.Strings.PerkName.RF_Bloodlust;
		this.m.Description = "Этот персонаж чувствует себя по-настоящему живым, нанося смертельные удары.";
		this.m.Icon = "ui/perks/perk_rf_bloodlust.png";
		this.m.IconMini = "perk_rf_bloodlust_mini";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
	}

	function isHidden()
	{
		return this.m.Stacks == 0;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		local mult = 1.0 + (this.m.Stacks * this.m.MultPerStack);
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = ::MSU.Text.colorizeMult(mult) + " к решимости"
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = ::MSU.Text.colorizeMult(mult) + " к инициативе"
		});
		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = ::MSU.Text.colorizeMult(mult) + " к восстановлению выносливости в следующий ход"
		});
		ret.push({
			id = 13,
			type = "text",
			icon = "ui/tooltips/warning.png",
			text = "Эти эффекты уменьшаются на " + ::MSU.Text.colorNegative("-" + (this.m.MultPerStack * 100) + "%") + " каждый ход, пока персонаж не нанесёт новый смертельный удар"
		});
		return ret;
	}

	function onOtherActorDeath( _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType )
	{
		if (_fatalityType != ::Const.FatalityType.None && _killer != null && _killer.getID() == this.getContainer().getActor().getID() && _skill != null && this.isSkillValid(_skill))
		{
			this.m.Stacks = ::Math.min(this.m.MaxStacks, this.m.Stacks + this.m.StacksPerTrigger);
		}
	}

	function onUpdate( _properties )
	{
		if (this.m.Stacks == 0)
			return;

		local mult = 1.0 + this.m.MultPerStack * this.m.Stacks;
		_properties.BraveryMult *= mult;
		_properties.InitiativeMult *= mult;
		_properties.FatigueRecoveryRateMult *= mult;
	}

	function onTurnStart()
	{
		this.m.Stacks = ::Math.max(0, this.m.Stacks - 1);
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.Stacks = 0;
	}

	function isSkillValid( _skill )
	{
		if (_skill.isRanged() || !_skill.isAttack())
			return false;

		if (this.m.RequiredWeaponType == null)
			return true;

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(this.m.RequiredWeaponType);
	}
});
