::ReforgedLite.HooksMod.hook("scripts/skills/effects/swallowed_whole_effect", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Name = "Полный живот";	 // New more descriptive Name
		this.m.Description = "Этот персонаж только что сожрал другое существо. Единственный способ освободить его - убить этого персонажа и вспороть ему живот.";
	}}.create;

	q.getName = @() { function getName()
	{
		return this.m.Name + " (" + this.m.Name + ")";
	}}.getName;
});
