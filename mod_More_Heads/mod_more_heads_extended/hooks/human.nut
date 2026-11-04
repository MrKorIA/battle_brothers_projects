// More Heads Extended - hook for scripts/entity/tactical/human
// Two small fixes the original More Heads mod made to human.nut; both wrapped
// in try/catch so save-deserialization never breaks because of us.

::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/human", function(q) {
	q.onInit = @(__original) { function onInit()
	{
		try {
			// Bounds-check m.Body before the original onInit reads it.
			if (this.m.Bodies != null && this.m.Bodies.len() > 0
				&& this.m.Body >= this.m.Bodies.len())
			{
				this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
			}
		} catch (e) {
			::logError("[mod_more_heads_extended] human.nut preInit: " + e);
		}

		__original();

		try {
			// Replace the injury sprite with one based on the body brush name
			// (vanilla derives it from numeric index, which breaks new bodies).
			if (this.hasSprite("injury_body") && this.m.Bodies != null
				&& this.m.Body < this.m.Bodies.len())
			{
				local bodyName = this.m.Bodies[this.m.Body];
				local injuryName = bodyName + "_injured";
				if (this.doesBrushExist(injuryName))
				{
					this.getSprite("injury_body").setBrush(injuryName);
				}
			}
		} catch (e) {
			::logError("[mod_more_heads_extended] human.nut postInit: " + e);
		}
	}}.onInit;
});
