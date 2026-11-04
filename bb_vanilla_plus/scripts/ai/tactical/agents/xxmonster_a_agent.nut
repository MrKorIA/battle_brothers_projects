this.xxmonster_a_agent <- this.inherit("scripts/ai/tactical/agent", {
	//arcane, bat, cosmictail, cultchamp, fungalAB, goblin, horsemanAB, hunscaptain, jinn, kraken, orclong, syndicate, toad, vamp, spider, spiderdemon, wrider_wolf+goblin, fiend
	m = {},
	function create()
	{
		this.agent.create();
		this.m.ID = this.Const.AI.Agent.ID.Direwolf;
		this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Split] = 4;
		this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Lash] = 4;
		this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Reap] = 4;
		this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Swing] = 4;
		this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Darkflight] = 3;
		this.m.Properties.IgnoreTargetValueOnEngage = true;
		this.m.Properties.PreferCarefulEngage = false;
	}

	function onAddBehaviors()
	{
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_flee"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_engage_melee"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_defend"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_break_free"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_wake_up_ally"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_default"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_puncture"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_splitshield"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_swing"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_split"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_thresh"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_crush_armor"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_decapitate"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_gash"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_reap"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_knock_out"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_throw_net"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_lash"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_defend_spearwall"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_defend_shieldwall"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_defend_knock_back"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_defend_riposte"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_charge"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_line_breaker"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_warcry"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_rally"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_adrenaline"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_distract"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_defend_rotation"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_recover"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_darkflight"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_bow"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_disengage"));
	}

	function onUpdate()
	{
		this.setEngageRangeBasedOnWeapon();
	}

});

