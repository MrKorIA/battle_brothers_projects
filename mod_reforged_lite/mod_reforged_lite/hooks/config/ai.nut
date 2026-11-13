::MSU.AI.addBehavior("RF_AncestralSummons", "RF.AncestralSummons", ::Const.AI.Behavior.Order.RaiseUndead, ::Const.AI.Behavior.Score.RaiseUndead);

::MSU.Table.merge(::Const.AI.Agent.ID, {
	RF_Draugr = "agent.rf_draugr",
	RF_DraugrBodyguard = "agent.rf_draugr.bodyguard"
});
