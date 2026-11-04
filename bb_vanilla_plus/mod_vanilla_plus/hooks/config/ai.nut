//::MSU.AI.addBehavior("RF_AncestralSummons", "RF.AncestralSummons", ::Const.AI.Behavior.Order.RaiseUndead, ::Const.AI.Behavior.Score.RaiseUndead);
//addAIBehaviour("SetBearTrap", "set trap in tile", 20, 100);
::MSU.AI.addBehavior("RF_AncestralSummons", "RF.AncestralSummons", ::Const.AI.Behavior.Order.RaiseUndead, ::Const.AI.Behavior.Score.RaiseUndead);
::MSU.AI.addBehavior("RF_PassingStep", "RF.PassingStep", ::Const.AI.Behavior.Order.Disengage, ::Const.AI.Behavior.Score.Disengage);
::MSU.AI.addBehavior("SetBearTrap", "set trap in tile", 20, 100);

::MSU.Table.merge(::Const.AI.Agent.ID, {
	RF_Draugr = "agent.rf_draugr",
	RF_DraugrBodyguard = "agent.rf_draugr.bodyguard"
});
