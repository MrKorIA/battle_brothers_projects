this.mgl_khan_niche <- this.inherit("scripts/entity/tactical/actor", {
	m = {
	    Flip = false
	},
	function create()
	{
		this.m.IsActingEachTurn = false;
		this.m.IsNonCombatant = true;
		this.m.IsShakingOnHit = false;
		this.m.Type = this.Const.EntityType.Cunmin;
		this.m.BloodType = this.Const.BloodType.None;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.XP = 0;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.actor.create();
		this.m.Name = "Ниша из которой лезут эти существа";
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
            "sounds/combat/armor_leather_impact_01.wav",
            "sounds/combat/armor_leather_impact_02.wav",
            "sounds/combat/armor_leather_impact_03.wav"
		];
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/donkey_agent");
		this.m.AIAgent.setActor(this);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
//		local flip = this.Math.rand(0, 100) < 50;
		if (_tile != null)
		{
			_tile.spawnDetail(this.actor.getSprite("body").getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, this.m.Flip);
			this.spawnTerrainDropdownEffect(_tile);
		}
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		_hitInfo.BodyPart = this.Const.BodyPart.Body;
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}

	function getTooltip( _targetedWithSkill = null )
	{
		if (!this.isPlacedOnMap() || !this.isAlive() || this.isDying())
		{
			return [];
		}

		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName(),
				icon = this.getLevelImagePath()
			},
			{
                id = 2,
                type = "headerText",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]Из этой ниши доносятся гул десятков, а может и сотен голосов. К счастью проход узкий и из него может протиснуться максимум одно существо.[/color]"
            }
		];

		return tooltip;
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.SpiderEggs);
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToHeadshots = true;
		b.IsAffectedByNight = false;
		b.IsMovable = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToDisarm = true;
		b.TargetAttractionMult = 5.0;
		b.RangedDefense = 999;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.m.Flip = this.Math.rand(0, 1) == 1;

        local variants = ::MSU.Class.WeightedContainer([
            [1, "01"],
            [2, "02"],
            [1, "03"],
            [2, "04"]
        ]);
		local body = this.addSprite("body");
		body.setBrush("mgl_khan_niche_" + variants.roll());
		body.setHorizontalFlipping(this.m.Flip);
		this.addDefaultStatusSprites();
		this.m.Skills.add(this.new("scripts/skills/racial/skeleton_racial"));
		this.m.Skills.update();
	}

	function onPlacedOnMap()
	{
		this.actor.onPlacedOnMap();
		this.registerSpawnEvent();
	}

	// Ниша не иссякает и не разрушается со временем: событие перепланируется
	// каждый цикл, пока нишу не уничтожат или бой не закончится.
	function registerSpawnEvent()
	{
		this.Time.scheduleEvent(this.TimeUnit.Rounds, this.Math.rand(1, 2), this.onSpawn.bindenv(this), this.getTile());
	}

	function onSpawn( _tile )
	{

		if (_tile == null || _tile.IsEmpty || !_tile.IsOccupiedByActor || _tile.getEntity() != this)
		{
			return;
		}

		if (this.Tactical.Entities.isEnemyRetreating())
		{
			return;
		}

		// свободная соседняя клетка
		local tile;
		for (local i = 0; i < 6; i = ++i)
		{
			if (!_tile.hasNextTile(i)) continue;
			local nextTile = _tile.getNextTile(i);
			if (!nextTile.IsEmpty || this.Math.abs(nextTile.Level - _tile.Level) > 1) continue;
			tile = nextTile;
			break;
		}

		if (tile != null)
		{
			local roll = this.Math.rand(1, 100);
			local script;
			if (roll <= 20)
			{
				script = null; // никто не появляется
			}
			else if (roll <= 40)
			{
				script = "scripts/entity/tactical/humans/lingmujiangshi"; // воин степи
			}
			else if (roll <= 50)
			{
				script = "scripts/entity/tactical/humans/zibaogbl"; // берсерк
			}
			else
			{
				script = "scripts/entity/tactical/humans/cunmin"; // мясо
			}

			if (script != null && this.Time.getRound() != 1)
			{
				local spawn = this.Tactical.spawnEntity(script, tile.Coords);
				spawn.setFaction(this.getFaction());
			}
		}

		// никакого лимита и самоуничтожения — волна за волной
		this.registerSpawnEvent();
	}
});
