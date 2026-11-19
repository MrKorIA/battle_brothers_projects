this.mod_mass_root_skill <- this.inherit("scripts/skills/skill", {
	m = {
		AffectedTiles = [],
		IsSpent = false
	},
	function isSpent()
	{
		return this.m.IsSpent;
	}

	function create()
	{
		this.m.ID = "actives.mass_root";
		this.m.Name = "Корни";
		this.m.Description = "";
		this.m.Icon = "";
		this.m.IconDisabled = "";
		this.m.Overlay = "active_70";
		this.m.SoundOnHit = [
			"sounds/combat/break_free_roots_00.wav",
			"sounds/combat/break_free_roots_01.wav",
			"sounds/combat/break_free_roots_02.wav",
			"sounds/combat/break_free_roots_03.wav"
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
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 99;
		this.m.MaxLevelDifference = 4;
	}

	function getAffectedTiles()
	{
		return this.m.AffectedTiles;
	}

	function addAffectedTiles( _array )
	{
		this.m.AffectedTiles = _array;
	}

	function clearAffectTiles()
	{
		this.m.AffectedTiles = [];
	}

	function isViableTarget( _user, _target )
	{
		if (_target.isAlliedWith(_user))
		{
			return false;
		}

		if (_target.getCurrentProperties().IsRooted)
		{
			return false;
		}

		if (_target.getCurrentProperties().IsImmuneToRoot)
		{
			return false;
		}

		return true;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

	function onUse( _user, _targetTile )
	{
		foreach( tile in this.m.AffectedTiles )
		{
			if (tile.IsOccupiedByActor)
			{
				local target = tile.getEntity();
				target.getSkills().add(::new("scripts/skills/effects/mod_strong_rooted_effect"));
				local breakFree = ::new("scripts/skills/actives/break_free_skill");
				breakFree.setDecal("roots_destroyed");
				breakFree.m.Icon = "skills/active_75.png";
				breakFree.m.IconDisabled = "skills/active_75_sw.png";
				breakFree.m.Overlay = "active_75";
				breakFree.m.SoundOnUse = this.m.SoundOnHit;
				breakFree.setChanceBonus(::Math.rand(-15, -5));
				target.getSkills().add(breakFree);
				target.raiseRootsFromGround("bust_roots", "bust_roots_back");
			}
		}

		if (this.m.AffectedTiles.len() > 0 && this.m.SoundOnHit.len() != 0)
		{
			::Sound.play(::MSU.Array.rand(this.m.SoundOnHit), ::Const.Sound.Volume.Skill, _targetTile.Pos);
		}

		this.m.IsSpent = true;
		this.clearAffectTiles();
		return true;
	}

});

