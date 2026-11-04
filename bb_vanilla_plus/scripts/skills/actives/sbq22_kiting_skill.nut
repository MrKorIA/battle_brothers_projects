this.sbq22_kiting_skill <- this.inherit("scripts/skills/skill", {
	m = {
		CanUsed = false,
		Cooldown = 1,
		Skillcool = 1
	},
	function create()
	{
		this.m.ID = "actives.sbq22_kiting_skill";
		this.m.Name = "129. Kiting";
		this.m.Description = "If you are not engaged in melee (ZOC) after attacking, you can move 1 tile at no AP cost.";
		this.m.Icon = "ui/xx87.png";
		this.m.IconDisabled = "ui/xx87_sw.png";
		this.m.Overlay = "perk_25_active";
		this.m.SoundOnUse = [
			"sounds/combat/footwork_01.wav"
		];
		this.m.SoundVolume = 1.1;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsDisengagement = true;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 8;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.MaxLevelDifference = 1;
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
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			}
		];
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Cooldown: 1 turn \nCooldown left: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] turn"
		});
		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used because this character is engaged in melee[/color]"
			});
		}
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.m.CanUsed = false;
		this.m.Skillcool = 0;
		this.Tactical.getNavigator().teleport(_user, _targetTile, null, null, false);
		this.Sound.play("sounds/humans/5/human_fatigue_02.wav", this.Const.Sound.Volume.Skill * 1.2, this.getContainer().getActor().getPos());
		return true;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill.isAttack() && !this.m.CanUsed)
		{
			this.m.CanUsed = true;
		}
	}

	function onTargetMiss( _skill, _targetEntity )
	{
		if (_skill.isAttack() && !this.m.CanUsed)
		{
			this.m.CanUsed = true;
		}
	}

	function isUsable()
	{
		if (!this.Tactical.isActive())
		{
			return false;
		}

		if (!this.skill.isUsable())
		{
			return false;
		}

		if (!this.m.CanUsed)
		{
			return false;
		}

		if (this.m.Skillcool < this.m.Cooldown)
		{
			return false;
		}

		if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			return false;
		}

		if (this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			return false;
		}
		return true;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (!_targetTile.IsEmpty)
		{
			return false;
		}

		return true;
	}

	function onTurnStart()
	{
		this.m.CanUsed = false;
		this.m.Skillcool = this.m.Skillcool + 1;
	}

	function onCombatFinished()
	{
		this.m.CanUsed = false;
		this.m.Skillcool = this.m.Cooldown;
	}

});

