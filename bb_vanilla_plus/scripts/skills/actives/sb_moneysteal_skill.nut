this.sb_moneysteal_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 1
	},
	function create()
	{
		this.m.ID = "actives.sb_moneysteal_skill";
		this.m.Name = "44. Воровство";
		this.m.Description = "Похищает короны у цели. Чем сильнее противник, тем больше корон вы можете украсть. Можно использовать только против людей и гоблинов.";
		this.m.Icon = "ui/xx50.png";
		this.m.IconDisabled = "ui/xx50_sw.png";
		this.m.SoundOnUse = [
			"sounds/coins_01.wav",
			"sounds/coins_02.wav",
			"sounds/coins_03.wav"
		];
		this.m.SoundVolume = 2.1;
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
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Можно использовать только против людей и гоблинов. Нельзя использовать против ранее обворованих целей."
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Можно использовать [color=#8f1e1e]" + this.m.Skillcharge + "[/color] еще раз в этом бою."
		});
		return ret;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else if (this.m.Skillcharge <= 0)
		{
			return false;
		}

		return true;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}
		if (target.isAlliedWith(this.getContainer().getActor()))
		{
			return false;
		}
		if (!target.getFlags().has("human") && !target.getFlags().has("goblin"))
		{
			return false;
		}
		if (target.getFlags().has("nomoney_target"))
		{
			return false;
		}
		return true;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcharge = this.m.Skillcharge - 1;
		local target = _targetTile.getEntity();
		local rr = this.Math.rand(0, target.getXPValue() * 0.3);
		if (this.Math.rand(1, 100) <= 30)
		{
			rr = 0;
		}
		target.getFlags().add("nomoney_target");
		this.World.Assets.addMoney(rr);
		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " stole " + rr + " crowns");
		}
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSlash);
		this.Tactical.getShaker().shake(target, _user.getTile(), 4);
		return true;
	}

	function isHidden()
	{
		if (this.m.Skillcharge > 0)
		{
			return false;
		}

		return true;
	}

	function onCombatFinished()
	{
		this.m.Skillcharge = 1;
	}

});

