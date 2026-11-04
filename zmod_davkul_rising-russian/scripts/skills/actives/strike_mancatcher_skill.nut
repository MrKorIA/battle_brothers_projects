this.strike_mancatcher_skill <- this.inherit("scripts/skills/skill", {
	m = {
		ApplyAxeMastery = false
	},
	function isAxeMasteryApplied()
	{
		return this.m.ApplyAxeMastery;
	}

	function setApplyAxeMastery( _f )
	{
		this.m.ApplyAxeMastery = _f;
		this.m.HitChanceBonus = _f ? 0 : 5;
	}

	function create()
	{
		this.m.ID = "actives.strike";
		this.m.Name = "Рывок";
		this.m.Description = "Размашистый удар, который работает на расстоянии в 2 клетки. Может быть использован из-за линии фронта, за пределами действия большинства оружия ближнего боя.";
		this.m.Icon = "skills/active_66.png";
		this.m.IconDisabled = "skills/active_66_sw.png";
		this.m.Overlay = "active_66";
		this.m.SoundOnUse = [
			"sounds/combat/strike_01.wav",
			"sounds/combat/strike_02.wav",
			"sounds/combat/strike_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/strike_hit_01.wav",
			"sounds/combat/strike_hit_02.wav",
			"sounds/combat/strike_hit_03.wav"
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
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.2;
		this.m.HitChanceBonus = 0;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.ChanceDecapitate = 50;
		this.m.ChanceDisembowel = 33;
		this.m.ChanceSmash = 0;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность в [color=" + this.Const.UI.Color.PositiveValue + "]2" + "[/color] клетки"
		});

		if (this.m.ApplyAxeMastery)
		{
			if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInAxes)
			{
				ret.push({
					id = 6,
					type = "text",
					icon = "ui/icons/hitchance.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] к шансу на попадание при атаке целей, стоящих рядом"
				});
			}
		}
		else
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]-5%[/color] к шансу на попадание"
			});

			if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInPolearms)
			{
				ret.push({
					id = 6,
					type = "text",
					icon = "ui/icons/hitchance.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] к шансу на попадание при атаке целей, стоящих рядом, из-за большой длины оружия"
				});
			}
		}

		return ret;
	}
	function isUsable(){
		return this.skill.isUsable() && !this.getContainer().hasSkill("effects.catching_enemy");
	}

	function onAfterUpdate( _properties )
	{
		if (this.m.ApplyAxeMastery)
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInAxes ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		}
		else
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInPolearms ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
			this.m.ActionPointCost = _properties.IsSpecializedInPolearms ? 5 : 6;
		}
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSplitShield);
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.MeleeSkill -= 5;
			this.m.HitChanceBonus += -10;

			if (_targetEntity != null && !this.getContainer().getActor().getCurrentProperties().IsSpecializedInPolearms && this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile()) == 1)
			{
				_properties.MeleeSkill += -15;
				this.m.HitChanceBonus += -15;
			}
		}
	}

});

