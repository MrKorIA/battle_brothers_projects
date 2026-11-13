// Катапульта Железной Орды — осадный объектив (контракт «Прорвать осаду»).
// Образец — data_014/scripts/entity/tactical/objective/greenskin_catapult.nut.
// Отличие: один спрайт вместо пары top/bottom — живая «horde_catapult» (кисть
// horde_invasion_tactical), после уничтожения на тайле ставится обломок
// (scripts/entity/tactical/objects/horde_catapult_broken.nut).
this.horde_catapult <- this.inherit("scripts/entity/tactical/actor", {
	m = {},
	function create()
	{
		this.m.IsActingEachTurn = false;
		this.m.IsNonCombatant = true;
		this.m.IsShakingOnHit = false;
		this.m.Type = this.Const.EntityType.HordeCatapult;
		this.m.BloodType = this.Const.BloodType.None;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.XP = this.Const.Tactical.Actor.Donkey.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/catapult_hurt_01.wav",
			"sounds/enemies/catapult_hurt_02.wav",
			"sounds/enemies/catapult_hurt_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/catapult_death_02.wav"
		];
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/donkey_agent");
		this.m.AIAgent.setActor(this);
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		_hitInfo.BodyPart = this.Const.BodyPart.Body;
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}

	function setFlipped( _f )
	{
		this.getSprite("body").setHorizontalFlipping(_f);
	}

	function onAfterDeath( _tile )
	{
		_tile.spawnObject("entity/tactical/objects/horde_catapult_broken");
		local offset = this.createVec(0, -10);

		for( local i = 0; i < this.Const.Tactical.BurnParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, _tile, this.Const.Tactical.BurnParticles[i].Delay, this.Math.max(1, this.Const.Tactical.BurnParticles[i].Quantity), this.Math.max(1, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity), this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, offset);
		}
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.GreenskinCatapult);
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToRoot = true;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToHeadshots = true;
		b.IsAffectedByNight = false;
		b.IsMovable = false;
		b.TargetAttractionMult = 1.5;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		local body = this.addSprite("body");
		body.setBrush("horde_catapult");
		body.varySaturation(0.1);
		this.addDefaultStatusSprites();
		this.m.Skills.update();
	}

});
