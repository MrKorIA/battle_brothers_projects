::JinMod <- {
	ID = "mod_jin",
	Name = "Чжурчжэни",
	Version = "1.0.0"
}
::JinMod.HooksMod <- ::Hooks.register(::JinMod.ID, ::JinMod.Version, ::JinMod.Name);
::JinMod.HooksMod.require(["mod_msu"]);

::JinMod.HooksMod.queue(">mod_msu", function() {
	::JinMod.Mod <- ::MSU.Class.Mod(::JinMod.ID, ::JinMod.Version, ::JinMod.Name);

	::JinMod.HooksMod.hook("scripts/factions/faction_manager", function(q) {
    	q.createJinModFaction <- { function createJinModFaction()
    	{
    		local jin_faction = ::new("scripts/factions/jin_faction");
    		jin_faction.setID(this.m.Factions.len());
    		jin_faction.setName("Чжурчжэни");
    		jin_faction.setDiscovered(true);
    		jin_faction.addTrait(::Const.FactionTrait.Jurchen);
    		this.m.Factions.push(jin_faction);
    	}}.createJinModFaction;

    	q.createAlliances = @(__original) { function createAlliances()
    	{
    		this.createJinModFaction();

    		__original();

    	}}.createAlliances;

    	q.runSimulation = @(__original) { function runSimulation()
    	{
    		local jin_faction = this.getFactionOfType(::Const.FactionType.Jurchen);
    		local ping = this.__ping;
    		this.__ping = function()
    		{
    			jin_faction.update(true, true);
    			ping();
    		}
    		__original();
    		this.__ping = ping;
    	}}.runSimulation;

    });

    ::MSU.Table.merge(::Const.Music, {
        JinTracks = [
            "music/jin.ogg"
        ]
    });

    ::JinMod.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_swing", function(q) {
		q.m.PossibleSkills.push("actives.jinweapon12_02");
		q.m.PossibleSkills.push("actives.jinweapon18_02");
		q.m.PossibleSkills.push("actives.jinweapon20_02");
		q.m.PossibleSkills.push("actives.jinweapon15_02");
		q.m.PossibleSkills.push("actives.jinweapon04_02");
		q.m.PossibleSkills.push("actives.jinweapon13_02");
		q.m.PossibleSkills.push("actives.jinweapon09_02");
		q.m.PossibleSkills.push("actives.jinweapon08_02");
    });

    ::JinMod.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_default", function(q) {
		q.m.PossibleSkills.push("actives.jinweapon15_01");
		q.m.PossibleSkills.push("actives.jinweapon12_01");
		q.m.PossibleSkills.push("actives.jinweapon18_01");
		q.m.PossibleSkills.push("actives.jinweapon19_01");
		q.m.PossibleSkills.push("actives.jinweapon19_02");
		q.m.PossibleSkills.push("actives.jinweapon20_01");
		q.m.PossibleSkills.push("actives.jinweapon99_01");
		q.m.PossibleSkills.push("actives.jinweapon13_01");
		q.m.PossibleSkills.push("actives.jinweapon01_01");
		q.m.PossibleSkills.push("actives.jinweapon05_01");
		q.m.PossibleSkills.push("actives.jinweapon03_01");
		q.m.PossibleSkills.push("actives.jinweapon04_01");
		q.m.PossibleSkills.push("actives.jinweapon03_02");
		q.m.PossibleSkills.push("actives.jinweapon02_01");
		q.m.PossibleSkills.push("actives.jinweapon11_01");
		q.m.PossibleSkills.push("actives.jinweapon06_01");
		q.m.PossibleSkills.push("actives.jinweapon07_01");
		q.m.PossibleSkills.push("actives.jinweapon08_01");
		q.m.PossibleSkills.push("actives.jinweapon09_01");
		q.m.PossibleSkills.push("actives.jinweapon14_01");
    });

    ::JinMod.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_reap", function(q) {
		q.m.PossibleSkills.push("actives.jinweapon15_02");
		q.m.PossibleSkills.push("actives.jinweapon02_02");
    });

    ::JinMod.HooksMod.hook("scripts/ai/tactical/behaviors/ai_line_breaker", function(q) {
		q.m.PossibleSkills.push("actives.jinweapon99_02");
    });

    ::JinMod.HooksMod.hook("scripts/events/event_manager", function(q) {
    	q.create = @(__original) { function create()
    	{
    		__original();
    		this.addSpecialEvent("event.jin_warning_on_road");
    	}}.create;
    });

    ::JinMod.HooksMod.hook("scripts/entity/tactical/entity", function(q) {
    	q.isAttackable = @(__original) { function isAttackable()
    	{
            if (!("ClassName" in this) || this.ClassName != "barrel_of_gunpowder")
            {
                return __original();
            }
            try {
                for (local i = 1; i <= 3; i++)
                {
                    local stack = getstackinfos(i);
                    if (stack != null && "src" in stack && stack.src != null)
                    {
//                            if (this.String.contains(stack.src, "ai/") || this.String.contains(stack.src, "agents/"))
                        if (this.String.contains(stack.src, "skills/"))
                        {
                            return true;
                        }
                    }
                }
            } catch (exception) {
                ::logError("[JinMod] barrel_of_gunpowder exception:\n" + exception);
            }

            return __original();

    	}}.isAttackable;

    });

});
