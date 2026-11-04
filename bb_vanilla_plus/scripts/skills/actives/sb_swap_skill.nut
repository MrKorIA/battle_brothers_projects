this.sb_swap_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 1,
		Skillcool = 1
	},
	function create()
	{
		this.m.ID = "actives.sb_swap_skill";
		this.m.Name = "68. Быстрая Ротация";
		this.m.Description = "Поменяйтесь местами с противником. Наносит 15 единиц усталости. При использовании этого навыка привлекает внимание противника. Чтобы использовать этот навык, вы и цель должны быть свободны для движения.";
		this.m.Icon = "ui/xx2.png";
		this.m.IconDisabled = "ui/xx2_sw.png";
		this.m.SoundOnUse = [
			"sounds/enemies/vampire_takeoff_01.wav",
			"sounds/enemies/vampire_takeoff_02.wav",
			"sounds/enemies/vampire_takeoff_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Преимущество досягаемости (перк) : Увеличивает дальность действия этого навыка на +1. (Current range " + this.getMaxRange() + " плитка)"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Перезарядка: 1 ход \nПерезарядка: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] ход"
		});
		if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Не может использоваться при обездвиживание[/color]"
			});
		}
		return ret;
	}

	function getCursorForTile( _tile )
	{
		return this.Const.UI.Cursor.Rotation;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (target.isAlliedWith(this.getContainer().getActor()))
		{
			return false;
		}

		return this.skill.onVerifyTarget(_originTile, _targetTile) && !target.getCurrentProperties().IsImmuneToRotation && !target.getCurrentProperties().IsImmuneToKnockBackAndGrab && !target.getCurrentProperties().IsImmuneToRoot && !target.getCurrentProperties().IsRooted && target.getCurrentProperties().IsMovable;
	}

	function onAfterUpdate( _properties )
	{
		this.m.MaxRange = 2 + (this.getContainer().getActor().getSkills().hasSkill("perk.reach_advantage") ? 1 : 0);
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		local target = _targetTile.getEntity();
		this.applyFatigueDamage(target, 15);
		this.Tactical.getNavigator().switchEntities(_user, target, null, null, 1.0);
		this.getContainer().getActor().getSkills().add(this.new("scripts/skills/effects/taunt_effect"));
		return true;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else if (this.m.Skillcool < this.m.Cooldown)
		{
			return false;
		}
		else if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			return false;
		}
		return true;
	}

	function onTurnStart()
	{
		this.m.Skillcool = this.m.Skillcool + 1;
	}

	function onCombatFinished()
	{
		this.m.Skillcool = this.m.Cooldown;
	}

});

