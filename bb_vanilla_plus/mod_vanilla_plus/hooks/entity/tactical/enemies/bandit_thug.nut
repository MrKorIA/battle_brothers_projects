::VanillaPlus.HooksMod.hook("scripts/entity/tactical/enemies/bandit_thug", function(q) {

	q.assignRandomEquipment = @(__original) function()
	{
		__original();
		if (this.Math.rand(1, 100) <= 10)
		{
		    this.getItems().addToBag(this.new("scripts/items/tools/bear_trap_item"));
		}
	}
});
