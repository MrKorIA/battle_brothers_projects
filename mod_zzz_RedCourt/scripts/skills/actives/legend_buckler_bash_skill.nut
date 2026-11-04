this.legend_buckler_bash_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.legend_buckler_bash";
		this.m.Name = "Удар щитом"
        this.m.Description = "Стремительный удар щитом. Тот, кого настигнет подобный удар, будет ошеломлён и начнет хватать ртом воздух, не в силах вложить полную силу в свои удары в течение двух ходов.";
        this.m.KilledString = "Забит до смерти";
		this.m.Icon = "skills/buckler_bash_square.png";
		this.m.IconDisabled = "skills/buckler_bash_square_bw.png";
		this.m.Overlay = "active_133";
		this.m.SoundOnUse = [
			"sounds/combat/cudgel_01.wav",
			"sounds/combat/cudgel_02.wav",
			"sounds/combat/cudgel_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/cudgel_hit_01.wav",
			"sounds/combat/cudgel_hit_02.wav",
			"sounds/combat/cudgel_hit_03.wav",
			"sounds/combat/cudgel_hit_04.wav"
		];
		this.m.SoundVolume = 1.25;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 33;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		local fatPerHit = (this.getContainer().getActor().getCurrentProperties().FatigueDealtPerHitMult + 1) * this.Const.Combat.FatigueReceivedPerHit;
        ret.push({
            id = 6,
            type = "text",
            icon = "ui/icons/special.png",
            text = "Наносит дополнительно [color=" + this.Const.UI.Color.DamageValue + "]" + fatPerHit + "[/color] урона по выносливости"
        });
        ret.push({
            id = 7,
            type = "text",
            icon = "ui/icons/special.png",
            text = "С [color=" + this.Const.UI.Color.PositiveValue + "]100%[/color] вероятностью ошеломляет при попадании"
        });
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInShields ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
		local success = this.attackEntity(_user, target);

		if (!_user.isAlive() || _user.isDying())
		{
			return success;
		}

		if (success && target.isAlive())
		{
			target.getSkills().add(this.new("scripts/skills/effects/legend_baffled_effect"));

			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " выбивает дух из " + this.Const.UI.getColorizedEntityName(target));
			}
		}

		return success;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 5;
			_properties.DamageRegularMax = 10;
			_properties.FatigueDealtPerHitMult += 1.0;
		}
	}

});

