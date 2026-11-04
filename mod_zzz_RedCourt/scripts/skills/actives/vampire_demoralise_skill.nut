this.vampire_demoralise_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.vampire_demoralise";
		this.m.Name = "Моральное разложение";
		this.m.Description = "Изолировать и атаковать разум одного персонажа, в попытке оглушить его на один ход. [color=" + this.Const.UI.Color.PositiveValue + "]Использует навык дальнего боя для попадания, не действует на цели, которые не убегают[/color].";
		this.m.Icon = "skills/active_102.png";
		this.m.IconDisabled = "skills/active_102.png";
		this.m.Overlay = "active_102";
		this.m.SoundOnUse = [
			"sounds/enemies/horror_spell_01.wav",
			"sounds/enemies/horror_spell_02.wav",
			"sounds/enemies/horror_spell_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.MaxLevelDifference = 4;
	}

	function onUse( _user, _targetTile )
	{
		local targets = [];
		foreach( target in targets )
		{
			local effect = this.Tactical.spawnSpriteEffect("effect_skull_03", this.createColor("#ffffff"), target.getTile(), 0, 40, 1.0, 0.25, 0, 400, 300);

			if (target.getCurrentProperties().MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] >= 1000.0)
			{
				continue;
			}

			target.checkMorale(-1, -15, this.Const.MoraleCheckType.MentalAttack);

			if (!target.checkMorale(0, -5, this.Const.MoraleCheckType.MentalAttack))
			{
				target.getSkills().add(this.new("scripts/skills/effects/horrified_effect")); //uses skeleton priest horrified effect from vanilla. May replace this later but I like how it works for now

				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " объят ужасом");
				}
			}
		}

		return true;
	}

});
