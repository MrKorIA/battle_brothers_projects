this.nggh_mod_horrific_scream <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.horrific_scream";
		this.m.Name = "Ужасающий крик";
		this.m.Description = "Издать пронзительный, потусторонний крик, повергающий в ужас любого, кому не повезло его услышать.";
		this.m.KilledString = "Напуган до смерти";
		this.m.Icon = "skills/active_41.png";
		this.m.IconDisabled = "skills/active_41_sw.png";
		this.m.Overlay = "active_41";
		this.m.SoundOnUse = [
			"sounds/enemies/horrific_scream_01.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsUsingHitchance = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность в [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] клеток"
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " использует умение 'Ужасающий крик'");
		}

		_targetTile.getEntity().checkMorale(-1, 0, ::Const.MoraleCheckType.MentalAttack);
		_targetTile.getEntity().checkMorale(-1, -10, ::Const.MoraleCheckType.MentalAttack);

		if (this.getContainer().hasSkill("racial.champion"))
		{
			_targetTile.getEntity().checkMorale(-1, 0, ::Const.MoraleCheckType.MentalAttack);
			_targetTile.getEntity().checkMorale(-1, -10, ::Const.MoraleCheckType.MentalAttack);
		}

		return true;
	}

});

