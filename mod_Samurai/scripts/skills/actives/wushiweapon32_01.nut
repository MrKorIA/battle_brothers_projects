this.wushiweapon32_01 <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.wushiweapon32_01";
		this.m.Name = "Быстрая цель";
		this.m.Description = "Быстрая рубящая атака со средним уроном.";
		this.m.KilledString = "Сражён";
		this.m.Icon = "skills/wushiweapon32_01.png";
		this.m.IconDisabled = "skills/wushiweapon32_01_sw.png";
		this.m.Overlay = "wushiweapon32_01";
		this.m.SoundOnUse = [
			"sounds/combat/slash_01.wav",
			"sounds/combat/slash_02.wav",
			"sounds/combat/slash_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/slash_hit_01.wav",
			"sounds/combat/slash_hit_02.wav",
			"sounds/combat/slash_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.HitChanceBonus = 10;
		this.m.DirectDamageMult = 0.2;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 50;
		this.m.ChanceDisembowel = 33;
		this.m.ChanceSmash = 0;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит дополнительный урон, зависящий от текущей инициативы владельца"
			}
		]);
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInSwords ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectZhanji02);
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local a = this.getContainer().getActor();
			local s = this.Math.minf(2.0, 2.0 * (this.Math.max(0, a.getInitiative() + (_targetEntity != null ? this.getFatigueCost() * a.getCurrentProperties().FatigueToInitiativeRate : 0)) / 175.0));
			_properties.DamageTotalMult *= s;
		}
	}

});

