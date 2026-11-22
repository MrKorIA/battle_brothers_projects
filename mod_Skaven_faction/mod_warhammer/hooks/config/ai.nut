::MSU.Table.merge(::Const.AI.Agent.ID, {
	Hellpit = "agent.hellpit",
	RatAssassin = "agent.rat.assassin",
	Ratbeast = "agent.rat.beast",
	RatEngineer = "agent.rat.engineer",
	RatGod = "agent.rat.god",
	RatGreyseer = "agent.rat.greyseer",
	RatMelee = "agent.rat.melee",
	RatPackmaster = "agent.rat.packmaster"
});

::MSU.AI.addBehavior("RatAttackWarpfire", "Rat.AttackWarpfire", ::Const.AI.Behavior.Order.AttackHandgonne, ::Const.AI.Behavior.Score.Attack);
