this.jinweapon07_01 <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.jinweapon07_01";
		this.m.Name = "Удар";
		this.m.Description = "Удар палицей, очень эффективный против тяжёлой брони.";
		this.m.KilledString = "Раздроблен";
		this.m.Icon = "skills/jinweapon07_01.png";
		this.m.IconDisabled = "skills/jinweapon07_01_sw.png";
		this.m.Overlay = "jinweapon07_01";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/crumble_01.wav",
			"sounds/combat/dlc6/crumble_02.wav",
			"sounds/combat/dlc6/crumble_03.wav",
			"sounds/combat/dlc6/crumble_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/dlc6/crumble_hit_01.wav",
			"sounds/combat/dlc6/crumble_hit_02.wav",
			"sounds/combat/dlc6/crumble_hit_03.wav",
			"sounds/combat/dlc6/crumble_hit_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsTooCloseShown = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.4;
		this.m.HitChanceBonus = 0;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 50;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Дальность [color=" + this.Const.UI.Color.PositiveValue + "]2" + "[/color] клетки"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Наносит [color=" + this.Const.UI.Color.DamageValue + "]" + this.Const.Combat.FatigueReceivedPerHit * 2 + "[/color] урона выносливости врага, истощая его"
		});

		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInMaces ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
		return this.attackEntity(_user, _targetTile.getEntity());
	}

});

