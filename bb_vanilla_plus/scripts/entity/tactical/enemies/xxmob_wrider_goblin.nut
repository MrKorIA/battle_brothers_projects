this.xxmob_wrider_goblin <- this.inherit("scripts/entity/tactical/goblin", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M80;
		this.m.Type = this.Const.EntityType.GoblinLeader;
		this.m.XP = this.Const.Tactical.Actor.GoblinLeader.XP;
		this.goblin.create();
		this.m.SoundPitch = this.Math.rand(85, 95) * 0.01;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/xxmonster_a_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.goblin.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.GoblinFighter);
		b.IsSpecializedInPolearms = true;
		b.Hitpoints += 40;
		b.Bravery += 20;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.getSprite("head").setBrush("bust_goblin_0"  + this.Math.rand(1, 3) + "_head_01");
		this.addSprite("arms_icon").Color = this.createColor("#e0e0e0");
		this.getSprite("arms_icon").Saturation = 0.3;
		this.getSprite("arms_icon").Scale = 0.95;
		this.addDefaultStatusSprites();
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.goblin.onDeath(_killer, _skill, _tile, _fatalityType);
	}

});

