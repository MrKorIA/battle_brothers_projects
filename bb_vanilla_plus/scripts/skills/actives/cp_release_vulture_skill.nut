this.cp_release_vulture_skill <- this.inherit("scripts/skills/skill", {
	m = {
		// Config
		ConsumeSounds = [
			"sounds/enemies/gruesome_feast_01.wav",
			"sounds/enemies/gruesome_feast_02.wav",
			"sounds/enemies/gruesome_feast_03.wav"
		],

		// Const
		BloodSplatterSpawned = 2,
		FeastSfxVolumeMult = 0.6,

		// Private
		Item = null,
	},
	function create()
	{
		this.m.ID = "actives.cp_release_vulture";
		this.m.Name = "Выпустить стервятника";
		this.m.Description = "Выпустить своего стервятника, чтобы он полакомился трупом, не дав ему восстать из мертвых или быть поглощенным. Целевая клетка должна быть пуста.";
		this.m.Icon = "skills/cp_release_vulture.png";
		this.m.IconDisabled = "skills/cp_release_vulture_sw.png";
		this.m.Overlay = "cp_release_vulture";
		this.m.SoundOnUse = [
			"sounds/combat/cp_vulture_use_01.wav",
			"sounds/combat/cp_vulture_use_02.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.BeforeLast + 5;	// We want release-ables to be listed after break-free skills (which are BeforeLast)
		this.m.IsSerialized = false;

		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsTargetingActor = false;

		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 8;
		this.m.MaxLevelDifference = 4;
	}

	function setItem( _i )
	{
		this.m.Item = this.WeakTableRef(_i);
	}

	function getTooltip()
	{
		local tooltip = this.skill.getDefaultUtilityTooltip();

		tooltip.push({
			id = 8,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность в " + ::MSU.Text.colorPositive(this.getMaxRange()) + " клеток"
		});

		tooltip.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Уничтожает потребляемый труп"
		});

		return tooltip;
	}

	function isUsable()
	{
		if (this.getItem().isReleased() || !this.skill.isUsable())
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

		if (!_targetTile.IsCorpseSpawned)
		{
			return false;
		}

		if (!_targetTile.IsEmpty)	// Maybe remove?
		{
			return false;
		}

		local corpse = _targetTile.Properties.get("Corpse");
		if (!corpse.IsConsumable)	// Maybe Problem: Player can use this skill to check which zombie can/will still reanimate by itself?
		{
			return false;
		}

		return true;
	}

	function onUpdate( _properties )
	{
		this.m.IsHidden = this.getItem().isReleased();
	}

	function onUse( _user, _targetTile )
	{
		::Tactical.EventLog.log("Стервятник " + this.getItem().getName() + " персонажа " + ::Const.UI.getColorizedEntityName(_user) + " поедает труп");

		this.__consumeCorpse(_targetTile);

		this.getItem().setReleased(true);
		return true;
	}

// New Functions
	function getItem()
	{
		return this.m.Item;
	}

	// Mostly inspired by the vanilla gruesome_feast.nut
	function __consumeCorpse( _targetTile )
	{
		// Remove Corpse
		::Tactical.Entities.removeCorpse(_targetTile);
		_targetTile.clear(::Const.Tactical.DetailFlag.Corpse);
		_targetTile.Properties.remove("Corpse");
		_targetTile.Properties.remove("IsSpawningFlies");

		// Create CorpsePart
		for (local i = 0; i != ::Const.CorpsePart.len(); ++i)
		{
			_targetTile.spawnDetail(::Const.CorpsePart[i]);
		}

		// Create Bloodsplatter
		for (local i = 1; i <= this.m.BloodSplatterSpawned; ++i)
		{
			local decal = ::Const.BloodDecals[::Const.BloodType.Red][::Math.rand(0, ::Const.BloodDecals[::Const.BloodType.Red].len() - 1)];
			_targetTile.spawnDetail(decal);
		}

		if (_targetTile.IsVisibleForPlayer && this.m.ConsumeSounds.len() != 0)
		{
			::Sound.play(::MSU.Array.rand(this.m.ConsumeSounds), ::Const.Sound.Volume.Skill * this.m.SoundVolume * this.m.FeastSfxVolumeMult, _targetTile.Pos);
		}
	}
});

