// More Heads Extended - hooks for scripts/skills/backgrounds/*
// Each hook runs AFTER the original create() (vanilla + Reforged + Hardened),
// then re-applies More Heads' appearance choices INSIDE a try/catch so any
// missing Const key or unexpected error during save-deserialization leaves
// the original create() output intact and just logs the error.

::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/assassin_southern_background", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		try {
			if (this.Math.rand(1, 100) <= 15)
			{
                this.m.Bodies = this.Const.Bodies.African;
                this.m.Faces = this.Const.Faces.African;
                this.m.Hairs = this.Const.Hair.African;
                this.m.HairColors = this.Const.HairColors.SouthernYoung;
                this.m.Beards = this.Const.Beards.Southern;
                this.m.Names = this.Const.Strings.AfricanNames;
                this.m.LastNames = this.Const.Strings.AfricanLastNames;
			}
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/skills/backgrounds/assassin_southern_background: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/belly_dancer_background", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		try {
			if (this.Math.rand(1, 100) <= 15)
			{
                this.m.Bodies = this.Const.Bodies.African;
                this.m.Faces = this.Const.Faces.African;
                this.m.Hairs = this.Const.Hair.African;
                this.m.HairColors = this.Const.HairColors.SouthernYoung;
                this.m.Beards = this.Const.Beards.Southern;
                this.m.Names = this.Const.Strings.AfricanNames;
                this.m.LastNames = this.Const.Strings.AfricanLastNames;
			}
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/skills/backgrounds/belly_dancer_background: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/gladiator_background", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		try {
			if (this.Math.rand(1, 100) <= 25)
			{
                this.m.Bodies = this.Const.Bodies.African;
                this.m.Faces = this.Const.Faces.African;
                this.m.Hairs = this.Const.Hair.African;
                this.m.HairColors = this.Const.HairColors.African;
                this.m.Beards = this.Const.Beards.Southern;
                this.m.Names = this.Const.Strings.AfricanNames;
                this.m.LastNames = this.Const.Strings.AfricanLastNames;
			}
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/skills/backgrounds/gladiator_background: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/manhunter_background", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		try {
			this.m.BeardChance = 90;
			this.m.Bodies = this.Const.Bodies.SouthernThick;
			this.m.Ethnicity = 1;
			if (this.Math.rand(1, 100) <= 5)
			{
                this.m.Bodies = this.Const.Bodies.African;
                this.m.Faces = this.Const.Faces.African;
                this.m.Hairs = this.Const.Hair.African;
                this.m.HairColors = this.Const.HairColors.African;
                this.m.Beards = this.Const.Beards.Southern;
                this.m.Names = this.Const.Strings.AfricanNames;
                this.m.LastNames = this.Const.Strings.AfricanLastNames;
			}
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/skills/backgrounds/manhunter_background: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/nomad_background", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		try {
			if (this.Math.rand(1, 100) <= 15)
			{
                this.m.Bodies = this.Const.Bodies.African;
                this.m.Faces = this.Const.Faces.African;
                this.m.Hairs = this.Const.Hair.African;
                this.m.HairColors = this.Const.HairColors.African;
                this.m.Beards = this.Const.Beards.Southern;
                this.m.Names = this.Const.Strings.AfricanNames;
                this.m.LastNames = this.Const.Strings.AfricanLastNames;
			}
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/skills/backgrounds/nomad_background: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/shepherd_southern_background", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		try {
			if (this.Math.rand(1, 100) <= 15)
			{
                this.m.Bodies = this.Const.Bodies.African;
                this.m.Faces = this.Const.Faces.African;
                this.m.Hairs = this.Const.Hair.African;
                this.m.HairColors = this.Const.HairColors.African;
                this.m.Beards = this.Const.Beards.Southern;
                this.m.Names = this.Const.Strings.AfricanNames;
                this.m.LastNames = this.Const.Strings.AfricanLastNames;
			}
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/skills/backgrounds/shepherd_southern_background: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/slave_southern_background", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		try {
			if (this.Math.rand(1, 100) <= 25)
			{
                this.m.Bodies = this.Const.Bodies.African;
                this.m.Faces = this.Const.Faces.African;
                this.m.Hairs = this.Const.Hair.African;
                this.m.HairColors = this.Const.HairColors.African;
                this.m.Beards = this.Const.Beards.SouthernUntidy;
                this.m.Names = this.Const.Strings.AfricanNames;
                this.m.LastNames = this.Const.Strings.AfricanLastNames;
			}
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/skills/backgrounds/slave_southern_background: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/servant_southern_background", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		try {
			if (this.Math.rand(1, 100) <= 15)
			{
                this.m.Bodies = this.Const.Bodies.African;
                this.m.Faces = this.Const.Faces.African;
                this.m.Hairs = this.Const.Hair.African;
                this.m.HairColors = this.Const.HairColors.African;
                this.m.Beards = this.Const.Beards.Southern;
                this.m.Names = this.Const.Strings.AfricanNames;
                this.m.LastNames = this.Const.Strings.AfricanLastNames;
			}
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/skills/backgrounds/servant_southern_background: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/thief_southern_background", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		try {
			if (this.Math.rand(1, 100) <= 25)
			{
                this.m.Bodies = this.Const.Bodies.African;
                this.m.Faces = this.Const.Faces.African;
                this.m.Hairs = this.Const.Hair.African;
                this.m.HairColors = this.Const.HairColors.SouthernYoung;
                this.m.Beards = this.Const.Beards.Southern;
                this.m.Names = this.Const.Strings.AfricanNames;
                this.m.LastNames = this.Const.Strings.AfricanLastNames;
			}
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/skills/backgrounds/thief_southern_background: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/executioner_southern_background", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		try {
			if (this.Math.rand(1, 100) <= 5)
			{
                this.m.Bodies = this.Const.Bodies.African;
                this.m.Faces = this.Const.Faces.African;
                this.m.Hairs = this.Const.Hair.African;
                this.m.HairColors = this.Const.HairColors.African;
                this.m.Beards = this.Const.Beards.Southern;
                this.m.Names = this.Const.Strings.AfricanNames;
                this.m.LastNames = this.Const.Strings.AfricanLastNames;
			}
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/skills/backgrounds/executioner_southern_background: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/eunuch_southern_background", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		try {
			if (this.Math.rand(1, 100) <= 15)
			{
                this.m.Bodies = this.Const.Bodies.African;
                this.m.Faces = this.Const.Faces.African;
                this.m.Hairs = this.Const.Hair.African;
                this.m.HairColors = this.Const.HairColors.African;
                this.m.Beards = null;
                this.m.Names = this.Const.Strings.AfricanNames;
                this.m.LastNames = this.Const.Strings.AfricanLastNames;
			}
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/skills/backgrounds/eunuch_southern_background: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/cripple_southern_background", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		try {
			if (this.Math.rand(1, 100) <= 15)
			{
                this.m.Bodies = this.Const.Bodies.African;
                this.m.Faces = this.Const.Faces.African;
                this.m.Hairs = this.Const.Hair.African;
                this.m.HairColors = this.Const.HairColors.African;
                this.m.Beards = this.Const.Beards.SouthernUntidy;
                this.m.Names = this.Const.Strings.AfricanNames;
                this.m.LastNames = this.Const.Strings.AfricanLastNames;
			}
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/skills/backgrounds/cripple_southern_background: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/caravan_hand_southern_background", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		try {
			if (this.Math.rand(1, 100) <= 15)
			{
                this.m.Bodies = this.Const.Bodies.African;
                this.m.Faces = this.Const.Faces.African;
                this.m.Hairs = this.Const.Hair.African;
                this.m.HairColors = this.Const.HairColors.African;
                this.m.Beards = this.Const.Beards.Southern;
                this.m.Names = this.Const.Strings.AfricanNames;
                this.m.LastNames = this.Const.Strings.AfricanLastNames;
			}
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/skills/backgrounds/caravan_hand_southern_background: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/beggar_southern_background", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		try {
			if (this.Math.rand(1, 100) <= 15)
			{
                this.m.Bodies = this.Const.Bodies.African;
                this.m.Faces = this.Const.Faces.African;
                this.m.Hairs = this.Const.Hair.African;
                this.m.HairColors = this.Const.HairColors.African;
                this.m.Beards = this.Const.Beards.SouthernUntidy;
                this.m.Names = this.Const.Strings.AfricanNames;
                this.m.LastNames = this.Const.Strings.AfricanLastNames;
			}
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/skills/backgrounds/beggar_southern_background: " + e);
		}
	}}.create;
});

if (::mods_getRegisteredMod("mod_backgrounds_and_events") != null)
{
    ::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/hackflows/bodyguard_southern_background", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                if (this.Math.rand(1, 100) <= 5)
                {
                    this.m.Bodies = this.Const.Bodies.African;
                    this.m.Faces = this.Const.Faces.African;
                    this.m.Hairs = this.Const.Hair.African;
                    this.m.HairColors = this.Const.HairColors.African;
                    this.m.Beards = this.Const.Beards.Southern;
                    this.m.Names = this.Const.Strings.AfricanNames;
                    this.m.LastNames = this.Const.Strings.AfricanLastNames;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/skills/backgrounds/hackflows/bodyguard_southern_background: " + e);
            }
        }}.create;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/hackflows/bounty_hunter_southern_background", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                if (this.Math.rand(1, 100) <= 10)
                {
                    this.m.Bodies = this.Const.Bodies.African;
                    this.m.Faces = this.Const.Faces.African;
                    this.m.Hairs = this.Const.Hair.African;
                    this.m.HairColors = this.Const.HairColors.African;
                    this.m.Beards = this.Const.Beards.Southern;
                    this.m.Names = this.Const.Strings.AfricanNames;
                    this.m.LastNames = this.Const.Strings.AfricanLastNames;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/skills/backgrounds/hackflows/bounty_hunter_southern_background: " + e);
            }
        }}.create;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/hackflows/cobbler_southern_background", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                if (this.Math.rand(1, 100) <= 15)
                {
                    this.m.Bodies = this.Const.Bodies.African;
                    this.m.Faces = this.Const.Faces.African;
                    this.m.Hairs = this.Const.Hair.African;
                    this.m.HairColors = this.Const.HairColors.African;
                    this.m.Beards = this.Const.Beards.Southern;
                    this.m.Names = this.Const.Strings.AfricanNames;
                    this.m.LastNames = this.Const.Strings.AfricanLastNames;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/skills/backgrounds/hackflows/cobbler_southern_background: " + e);
            }
        }}.create;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/hackflows/myrmidon_southern_background", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                if (this.Math.rand(1, 100) <= 20)
                {
                    this.m.Bodies = this.Const.Bodies.African;
                    this.m.Faces = this.Const.Faces.African;
                    this.m.Hairs = this.Const.Hair.African;
                    this.m.HairColors = this.Const.HairColors.African;
                    this.m.Beards = this.Const.Beards.Southern;
                    this.m.Names = this.Const.Strings.AfricanNames;
                    this.m.LastNames = this.Const.Strings.AfricanLastNames;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/skills/backgrounds/hackflows/myrmidon_southern_background: " + e);
            }
        }}.create;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/hackflows/cook_southern_background", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                if (this.Math.rand(1, 100) <= 15)
                {
                    this.m.Bodies = this.Const.Bodies.African;
                    this.m.Faces = this.Const.Faces.African;
                    this.m.Hairs = this.Const.Hair.African;
                    this.m.HairColors = this.Const.HairColors.African;
                    this.m.Beards = this.Const.Beards.Southern;
                    this.m.Names = this.Const.Strings.AfricanNames;
                    this.m.LastNames = this.Const.Strings.AfricanLastNames;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/skills/backgrounds/hackflows/cook_southern_background: " + e);
            }
        }}.create;
    });

}

if (::mods_getRegisteredMod("mod_wushi") != null)
{
    ::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/jianhao_background", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                this.m.Bodies = this.Const.Bodies.AsianMale;
                this.m.Faces = this.Const.Faces.AsianMale;
                this.m.Hairs = this.Const.Hair.AsianMale;
                this.m.HairColors = this.Const.HairColors.Asian;
                this.m.Beards = this.Const.Beards.AsianMale;
		        this.m.BeardChance = 5;
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/skills/backgrounds/jianhao_background: " + e);
            }
        }}.create;

        q.onSetAppearance = @(__original) { function onSetAppearance()
        {
            __original();
            try {
                local actor = this.getContainer().getActor();
                local tattoos = [
                    1,
                    2,
                    3,
                    4,
                    5,
                    6
                ];
                if (this.Math.rand(1, 100) <= 40)
                {
                    this.m.Tattoo = tattoos[this.Math.rand(0, tattoos.len() - 1)];
                    local tattoo_body = actor.getSprite("tattoo_body");
                    local body = actor.getSprite("body");
                    tattoo_body.setBrush("tattoo_0" + this.m.Tattoo + "_body_04"); // tattoo_01_body_04
                    tattoo_body.Visible = true;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/skills/backgrounds/jianhao_background: " + e);
            }
        }}.onSetAppearance;

        q.updateAppearance = @(__original) { function updateAppearance()
        {
            __original();
            try {
                local actor = this.getContainer().getActor();
                local tattoo_body = actor.getSprite("tattoo_body");

                if (tattoo_body.HasBrush)
                {
                    local body = actor.getSprite("body");
                    tattoo_body.setBrush("tattoo_0" + this.m.Tattoo + "_body_04");
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/skills/backgrounds/jianhao_background: " + e);
            }
        }}.updateAppearance;

    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/langren_background", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                this.m.Bodies = this.Const.Bodies.AsianMale;
                this.m.Faces = this.Const.Faces.AsianMale;
                this.m.Hairs = this.Const.Hair.AsianMale;
                this.m.HairColors = this.Const.HairColors.Asian;
                this.m.Beards = this.Const.Beards.AsianMale;
		        this.m.BeardChance = 5;
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/skills/backgrounds/langren_background: " + e);
            }
        }}.create;

        q.onSetAppearance = @(__original) { function onSetAppearance()
        {
            __original();
            try {
                local actor = this.getContainer().getActor();
                local tattoos = [
                    1,
                    2,
                    3,
                    4,
                    5,
                    6
                ];
                if (this.Math.rand(1, 100) <= 20)
                {
                    this.m.Tattoo = tattoos[this.Math.rand(0, tattoos.len() - 1)];
                    local tattoo_body = actor.getSprite("tattoo_body");
                    local body = actor.getSprite("body");
                    tattoo_body.setBrush("tattoo_0" + this.m.Tattoo + "_body_04"); // tattoo_01_body_04
                    tattoo_body.Visible = true;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/skills/backgrounds/langren_background: " + e);
            }
        }}.onSetAppearance;

        q.updateAppearance = @(__original) { function updateAppearance()
        {
            __original();
            try {
                local actor = this.getContainer().getActor();
                local tattoo_body = actor.getSprite("tattoo_body");

                if (tattoo_body.HasBrush)
                {
                    local body = actor.getSprite("body");
                    tattoo_body.setBrush("tattoo_0" + this.m.Tattoo + "_body_04");
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/skills/backgrounds/langren_background: " + e);
            }
        }}.updateAppearance;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/wushi_background", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                this.m.Bodies = this.Const.Bodies.AsianMale;
                this.m.Faces = this.Const.Faces.AsianMale;
                this.m.Hairs = this.Const.Hair.AsianMale;
                this.m.HairColors = this.Const.HairColors.Asian;
                this.m.Beards = this.Const.Beards.AsianMale;
		        this.m.BeardChance = 5;
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/skills/backgrounds/wushi_background: " + e);
            }
        }}.create;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/renzhe_background", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                this.m.Bodies = this.Const.Bodies.AsianMale;
                this.m.Faces = this.Const.Faces.AsianMale;
                this.m.Hairs = this.Const.Hair.AsianMale;
                this.m.HairColors = this.Const.HairColors.Asian;
                this.m.Beards = this.Const.Beards.AsianMale;
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/skills/backgrounds/renzhe_background: " + e);
            }
        }}.create;

        q.onSetAppearance = @(__original) { function onSetAppearance()
        {
            __original();
            try {
                local actor = this.getContainer().getActor();
                local tattoos = [
                    1,
                    2,
                    3,
                    4,
                    5,
                    6
                ];
                if (this.Math.rand(1, 100) <= 60)
                {
                    this.m.Tattoo = tattoos[this.Math.rand(0, tattoos.len() - 1)];
                    local tattoo_body = actor.getSprite("tattoo_body");
                    local body = actor.getSprite("body");
                    tattoo_body.setBrush("tattoo_0" + this.m.Tattoo + "_body_04"); // tattoo_01_body_04
                    tattoo_body.Visible = true;
                }

                if (this.Math.rand(1, 100) <= 30)
                {
                    local tattoo_head = actor.getSprite("tattoo_head");
                    tattoo_head.setBrush("asian_tattoo_0" + tattoos[this.Math.rand(0, tattoos.len() - 1)] + "_head");
                    tattoo_head.Visible = true;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/skills/backgrounds/renzhe_background: " + e);
            }
        }}.onSetAppearance;

        q.updateAppearance = @(__original) { function updateAppearance()
        {
            __original();
            try {
                local actor = this.getContainer().getActor();
                local tattoo_body = actor.getSprite("tattoo_body");

                if (tattoo_body.HasBrush)
                {
                    local body = actor.getSprite("body");
                    tattoo_body.setBrush("tattoo_0" + this.m.Tattoo + "_body_04");
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/skills/backgrounds/renzhe_background: " + e);
            }
        }}.updateAppearance;
    });

}

if (::mods_getRegisteredMod("mod_LuftRetiredGladiatorOrigin") != null)
{
    ::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/beastslayer_gladiator_background", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                if (this.Math.rand(1, 100) <= 20)
                {
                    this.m.Bodies = this.Const.Bodies.African;
                    this.m.Faces = this.Const.Faces.African;
                    this.m.Hairs = this.Const.Hair.African;
                    this.m.HairColors = this.Const.HairColors.African;
                    this.m.Beards = this.Const.Beards.Southern;
                    this.m.Names = this.Const.Strings.AfricanNames;
                    this.m.LastNames = this.Const.Strings.AfricanLastNames;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/skills/backgrounds/beastslayer_gladiator_background: " + e);
            }
        }}.create;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/pit_fighter_background", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                if (this.Math.rand(1, 100) <= 20)
                {
                    this.m.Bodies = this.Const.Bodies.African;
                    this.m.Faces = this.Const.Faces.African;
                    this.m.Hairs = this.Const.Hair.African;
                    this.m.HairColors = this.Const.HairColors.African;
                    this.m.Beards = this.Const.Beards.Southern;
                    this.m.Names = this.Const.Strings.AfricanNames;
                    this.m.LastNames = this.Const.Strings.AfricanLastNames;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/skills/backgrounds/pit_fighter_background: " + e);
            }
        }}.create;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/skills/backgrounds/retired_gladiator_background", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                if (this.Math.rand(1, 100) <= 20)
                {
                    this.m.Bodies = this.Const.Bodies.African;
                    this.m.Faces = this.Const.Faces.African;
                    this.m.Hairs = this.Const.Hair.African;
                    this.m.HairColors = this.Const.HairColors.African;
                    this.m.Beards = this.Const.Beards.Southern;
                    this.m.Names = this.Const.Strings.AfricanNames;
                    this.m.LastNames = this.Const.Strings.AfricanLastNames;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/skills/backgrounds/retired_gladiator_background: " + e);
            }
        }}.create;
    });

}