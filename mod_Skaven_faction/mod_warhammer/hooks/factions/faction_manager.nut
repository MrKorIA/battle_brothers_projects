::TheSkaven.HooksMod.hook("scripts/factions/faction_manager", function (q) {
	q.Skaven <- { function Skaven()
	{
		local f = ::new("scripts/factions/rat_faction");
		f.setID(this.m.Factions.len());
		f.setName("Скавены");
		f.setDiscovered(true);
		f.addTrait(::Const.FactionTrait.Rat);
		this.m.Factions.push(f);
		f = ::new("scripts/factions/ratbeast_faction");
        f.setID(this.m.Factions.len());
        f.setName("Твари скавенов");
        f.setDiscovered(true);
        f.addTrait(::Const.FactionTrait.RatBeast);
        this.m.Factions.push(f);
	}}.Skaven;

	q.createAlliances = @(__original) { function createAlliances()
	{
		this.Skaven();

		__original();

	}}.createAlliances;

	q.runSimulation = @(__original) { function runSimulation()
	{
		local rat = this.getFactionOfType(::Const.FactionType.Rat);
		local ratbeast = this.getFactionOfType(::Const.FactionType.RatBeast);
		local ping = this.__ping;
		this.__ping = function()
		{
			rat.update(true, true);
			ratbeast.update(true, true);
			ping();
		}
		__original();
		this.__ping = ping;
	}}.runSimulation;
});
