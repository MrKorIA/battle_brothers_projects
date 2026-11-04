this.sbp_beater_skill <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false
	},
	function create()
	{
		this.m.ID = "actives.sbp_beater_skill";
		this.m.Name = "Месть";
		this.m.Icon = "ui/xxp25.png";
		this.m.Description = "Один раз за ход, когда этот персонаж успешно атакует или уклоняется, наносит 5 единиц урона. (Этот урон не может убить цель)";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast + 100;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
		this.m.IsHidden = true;
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

	function onMissed( _attacker, _skill )
	{
		if (this.m.IsSpent || !_skill.isAttack() || !_attacker.isAlive() || _attacker.isDying() || _attacker.getFaction() == this.Const.Faction.Player)
		{
			return false;
		}

		this.m.IsSpent = true;
		this.spawnIcon("status_effect_01", _attacker.getTile());
		_attacker.setHitpoints(this.Math.max(_attacker.getHitpoints() - 5, 1));
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_attacker) + " takes 5 damage");
		return true;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (this.m.IsSpent || !_skill.isAttack() || !_targetEntity.isAlive() || _targetEntity.isDying() || _targetEntity.getFaction() == this.Const.Faction.Player)
		{
			return false;
		}

		this.m.IsSpent = true;
		this.spawnIcon("status_effect_01", _targetEntity.getTile());
		_targetEntity.setHitpoints(this.Math.max(_targetEntity.getHitpoints() - 5, 1));
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_targetEntity) + " takes 5 damage");
		return true;
	}

	function onNewRound()
	{
		this.m.IsSpent = false;
	}

	function onUpdate( _properties )
	{
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			this.m.IsHidden = true;
			return;
		}
		this.m.IsHidden = false;
	}

});

