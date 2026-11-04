::VanillaPlus.HooksMod.hook("scripts/ai/tactical/agents/bandit_ranged_agent", function(q) {
    q.onAddBehaviors = @(__original) function()
    {
        __original();
        this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_set_bear_trap"));
    }
});