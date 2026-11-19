this.mod_hallucinate_skill <- ::inherit("scripts/skills/skill", {
	m = {
		IsSpent = false
	},
	function isSpent()
	{
		return this.m.IsSpent;
	}
	
	function create()
	{
		this.m.ID = "actives.mod_hallucinate";
		this.m.Name = "Галлюцинация";
		this.m.Description = "";
		this.m.Icon = "skills/active_102.png";
		this.m.IconDisabled = "skills/active_102.png";
		this.m.Overlay = "active_102";
		this.m.SoundOnUse = [
			"sounds/enemies/horror_spell_01.wav",
			"sounds/enemies/horror_spell_02.wav",
			"sounds/enemies/horror_spell_03.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;
		this.m.Delay = 500;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 99;
		this.m.MaxLevelDifference = 4;
	}

	function isViableTarget( _user, _target )
	{
		if (_target.isAlliedWith(_user))
		{
			return false;
		}

		if (_target.getMoraleState() == ::Const.MoraleState.Ignore || _target.getMoraleState() == ::Const.MoraleState.Fleeing)
		{
			return false;
		}

		if (_target.getCurrentProperties().IsStunned)
		{
			return false;
		}

		if (_target.getCurrentProperties().MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] >= 1000.0)
		{
			return false;
		}

		return true;
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.isSpent();
	}

	function onUse( _user, _targetTile )
	{	
		this.m.IsSpent = ::Math.rand(1, 2) == 2;
		local effect = ::Tactical.spawnSpriteEffect("effect_skull_03", ::createColor("#ffffff"), _targetTile, 0, 40, 1.0, 0.25, 0, 400, 300);

		if (!_targetTile.IsOccupiedByActor) return false;

		local target = _targetTile.getEntity();

		if (!this.isViableTarget(_user, target)) return false;

		target.getSkills().add(::new("scripts/skills/effects/mod_hallucinated_effect"));

		if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + " видит галлюцинацию");
		}

		return true;
	}

});

