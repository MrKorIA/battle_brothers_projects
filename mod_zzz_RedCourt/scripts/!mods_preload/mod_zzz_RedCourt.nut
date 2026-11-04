::TheRedCourt <- {
	ID = "mod_zzz_RedCourt",
	Name = "Багряный двор",
	Version = "3.8.3",
	GitHubURL = "",
}

::TheRedCourt.HooksMod <- ::Hooks.register(::TheRedCourt.ID, ::TheRedCourt.Version, ::TheRedCourt.Name);

::TheRedCourt.HooksMod.require("mod_msu >= 1.8.0", "stdlib >= 2.1");
::TheRedCourt.HooksMod.queue(">stdlib", ">mod_msu", function() {
	::TheRedCourt.Mod <- ::MSU.Class.Mod(::TheRedCourt.ID, ::TheRedCourt.Version, ::TheRedCourt.Name);

	::include("mod_zzz_RedCourt/load");

	::TheRedCourt.FemaleSpawn <- true;

//===================================================================

    ::TheRedCourt.AddRedCourtTalents <- function (_actor) {
        ::std.Player.clearTalents(_actor);
        local talents = _actor.getTalents();
        if (_actor.getSkills().hasSkill("background.hemovore_avatar"))
        {
            talents[this.Const.Attributes.MeleeSkill] = 2;
            talents[this.Const.Attributes.MeleeDefense] = 2;
            talents[this.Const.Attributes.Initiative] = 3;
            ::std.Player.addTalents(_actor, 2);
        }
        else if (_actor.getSkills().hasSkill("background.hemovore_HIGH"))
        {
            talents[this.Const.Attributes.Hitpoints] = 2;
            talents[this.Const.Attributes.MeleeSkill] = 2;
            talents[this.Const.Attributes.Initiative] = 2;
            ::std.Player.addTalents(_actor, 2);
        }
        else if (_actor.getSkills().hasSkill("background.hemovore_MED"))
        {
            talents[this.Const.Attributes.Hitpoints] = 1;
            talents[this.Const.Attributes.Initiative] = 2;
            ::std.Player.addTalents(_actor, 2);
        }
        else if (_actor.getSkills().hasSkill("background.hemovore_LOW"))
        {
            talents[this.Const.Attributes.Initiative] = 2;
            ::std.Player.addTalents(_actor, 2);
        }
        else if (_actor.getSkills().hasSkill("background.hemovore_magic"))
        {
            talents[this.Const.Attributes.Hitpoints] = 2;
            talents[this.Const.Attributes.Initiative] = 1;
            ::std.Player.addTalents(_actor, 2);
        }
        else if (_actor.getSkills().hasSkill("background.hemovore_praetorian"))
        {
            talents[this.Const.Attributes.MeleeSkill] = 2;
            talents[this.Const.Attributes.RangedSkill] = 1;
            talents[this.Const.Attributes.MeleeDefense] = 2;
            ::std.Player.addTalents(_actor, 2);
        }
    }

});