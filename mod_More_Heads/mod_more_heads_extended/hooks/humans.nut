// More Heads Extended - hooks for scripts/entity/tactical/humans/*
// Each hook is wrapped in try/catch so a missing Const key or unexpected
// error during save-load leaves the original create() result alone.

::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/assassin", function(q) {
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
			}
			if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/assassin: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/conscript", function(q) {
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
			}
			if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/conscript: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/desert_devil", function(q) {
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
			}
			if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/desert_devil: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/desert_stalker", function(q) {
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
			}
			if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/desert_stalker: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/executioner", function(q) {
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
			}
			if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/executioner: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/gladiator", function(q) {
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
			}
			if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/gladiator: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/gunner", function(q) {
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
			}
			if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/gunner: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/nomad_archer", function(q) {
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
			}
			if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/nomad_archer: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/nomad_cutthroat", function(q) {
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
			}
			if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/nomad_cutthroat: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/nomad_leader", function(q) {
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
			}
			if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/nomad_leader: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/nomad_outlaw", function(q) {
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
			}
			if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/nomad_outlaw: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/nomad_slinger", function(q) {
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
			}
			if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/nomad_slinger: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/peasant_southern", function(q) {
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
			}
			if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/peasant_southern: " + e);
		}
	}}.create;
});

::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/slave", function(q) {
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
			}
			if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
		} catch (e) {
			::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/slave: " + e);
		}
	}}.create;
});


if (::mods_getRegisteredMod("mod_jin") != null)
{
    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/nomad_centurion", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                this.m.Bodies = this.Const.Bodies.AsianMale;
                this.m.Faces = this.Const.Faces.AsianMale;
                this.m.Hairs = this.Const.Hair.AsianMale;
                this.m.HairColors = this.Const.HairColors.Asian;
                this.m.Beards = this.Const.Beards.AsianMale;
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/nomad_centurion: " + e);
            }
        }}.create;

        q.onInit = @(__original) { function onInit()
        {
            __original();
            try {
                if (this.Math.rand(1, 100) <= 66)
                {
                    local tattoo_body = this.actor.getSprite("tattoo_body");
                    local body = this.actor.getSprite("body");
                    tattoo_body.setBrush(::Const.Tattoos.AsianBody[this.Math.rand(0, ::Const.Tattoos.AsianBody.len() - 1)]);
                    tattoo_body.Visible = true;
                }

                if (this.Math.rand(1, 100) <= 50)
                {
                    local tattoo_head = this.actor.getSprite("tattoo_head");
                    tattoo_head.setBrush(::Const.Tattoos.AsianHead[this.Math.rand(0, ::Const.Tattoos.AsianHead.len() - 1)]);
                    tattoo_head.Visible = true;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/nomad_centurion: " + e);
            }
        }}.onInit;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/nomad_fireblunderbuss", function(q) {
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
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/nomad_fireblunderbuss: " + e);
            }
        }}.create;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/nomad_halberdmaster", function(q) {
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
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/nomad_halberdmaster: " + e);
            }
        }}.create;

        q.onInit = @(__original) { function onInit()
        {
            __original();
            try {
                if (this.Math.rand(1, 100) <= 66)
                {
                    local tattoo_body = this.actor.getSprite("tattoo_body");
                    local body = this.actor.getSprite("body");
                    tattoo_body.setBrush(::Const.Tattoos.AsianBody[this.Math.rand(0, ::Const.Tattoos.AsianBody.len() - 1)]);
                    tattoo_body.Visible = true;
                }

                if (this.Math.rand(1, 100) <= 50)
                {
                    local tattoo_head = this.actor.getSprite("tattoo_head");
                    tattoo_head.setBrush(::Const.Tattoos.AsianHead[this.Math.rand(0, ::Const.Tattoos.AsianHead.len() - 1)]);
                    tattoo_head.Visible = true;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/nomad_centurion: " + e);
            }
        }}.onInit;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/nomad_infantry", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                this.m.Bodies = this.Const.Bodies.AsianMale;
                this.m.Faces = this.Const.Faces.AsianMale;
                this.m.Hairs = this.Const.Hair.AsianMale;
                this.m.HairColors = this.Const.HairColors.Asian;
                this.m.Beards = this.Const.Beards.AsianMale;
		        this.m.BeardChance = 0;
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/nomad_infantry: " + e);
            }
        }}.create;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/nomad_ironpagoda", function(q) {
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
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/nomad_ironpagoda: " + e);
            }
        }}.create;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/nomad_spearmaster", function(q) {
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
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/nomad_spearmaster: " + e);
            }
        }}.create;
    });

}

if (::mods_getRegisteredMod("mod_wushi") != null)
{
    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/jiangjun", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                this.m.Bodies = this.Const.Bodies.AsianMale;
                this.m.Faces = this.Const.Faces.AsianMale;
                this.m.Hairs = this.Const.Hair.AsianMale;
                this.m.HairColors = this.Const.HairColors.Asian;
                this.m.Beards = this.Const.Beards.AsianMale;
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/jiangjun: " + e);
            }
        }}.create;

        q.onInit = @(__original) { function onInit()
        {
            __original();
            try {
                if (this.Math.rand(1, 100) <= 66)
                {
                    local tattoo_body = this.actor.getSprite("tattoo_body");
                    local body = this.actor.getSprite("body");
                    tattoo_body.setBrush(::Const.Tattoos.AsianBody[this.Math.rand(0, ::Const.Tattoos.AsianBody.len() - 1)]);
                    tattoo_body.Visible = true;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/jiangjun: " + e);
            }
        }}.onInit;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/jianhao", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                this.m.Bodies = this.Const.Bodies.AsianMale;
                this.m.Faces = this.Const.Faces.AsianMale;
                this.m.Hairs = this.Const.Hair.AsianMale;
                this.m.HairColors = this.Const.HairColors.Asian;
                this.m.Beards = this.Const.Beards.AsianMale;
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/jianhao: " + e);
            }
        }}.create;

        q.onInit = @(__original) { function onInit()
        {
            __original();
            try {
                if (this.Math.rand(1, 100) <= 66)
                {
                    local tattoo_body = this.actor.getSprite("tattoo_body");
                    local body = this.actor.getSprite("body");
                    tattoo_body.setBrush(::Const.Tattoos.AsianBody[this.Math.rand(0, ::Const.Tattoos.AsianBody.len() - 1)]);
                    tattoo_body.Visible = true;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/jianhao: " + e);
            }
        }}.onInit;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/langren", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                this.m.Bodies = this.Const.Bodies.AsianMale;
                this.m.Faces = this.Const.Faces.AsianMale;
                this.m.Hairs = this.Const.Hair.AsianMale;
                this.m.HairColors = this.Const.HairColors.Asian;
                this.m.Beards = this.Const.Beards.AsianMale;
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/langren: " + e);
            }
        }}.create;

        q.onInit = @(__original) { function onInit()
        {
            __original();
            try {
                if (this.Math.rand(1, 100) <= 66)
                {
                    local tattoo_body = this.actor.getSprite("tattoo_body");
                    local body = this.actor.getSprite("body");
                    tattoo_body.setBrush(::Const.Tattoos.AsianBody[this.Math.rand(0, ::Const.Tattoos.AsianBody.len() - 1)]);
                    tattoo_body.Visible = true;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/langren: " + e);
            }
        }}.onInit;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/renzhe", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                this.m.Bodies = this.Const.Bodies.AsianMale;
                this.m.Faces = this.Const.Faces.AsianMale;
                this.m.Hairs = this.Const.Hair.AsianMale;
                this.m.HairColors = this.Const.HairColors.Asian;
                this.m.Beards = this.Const.Beards.AsianMale;
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/renzhe: " + e);
            }
        }}.create;

        q.onInit = @(__original) { function onInit()
        {
            __original();
            try {
                if (this.Math.rand(1, 100) <= 33)
                {
                    local tattoo_body = this.actor.getSprite("tattoo_body");
                    local body = this.actor.getSprite("body");
                    tattoo_body.setBrush(::Const.Tattoos.AsianBody[this.Math.rand(0, ::Const.Tattoos.AsianBody.len() - 1)]);
                    tattoo_body.Visible = true;
                }

                if (this.Math.rand(1, 100) <= 20)
                {
                    local tattoo_head = this.actor.getSprite("tattoo_head");
                    tattoo_head.setBrush(::Const.Tattoos.AsianHead[this.Math.rand(0, ::Const.Tattoos.AsianHead.len() - 1)]);
                    tattoo_head.Visible = true;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/renzhe: " + e);
            }
        }}.onInit;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/renzhe02", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                this.m.Bodies = this.Const.Bodies.AsianMale;
                this.m.Faces = this.Const.Faces.AsianMale;
                this.m.Hairs = this.Const.Hair.AsianMale;
                this.m.HairColors = this.Const.HairColors.Asian;
                this.m.Beards = this.Const.Beards.AsianMale;
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/renzhe02: " + e);
            }
        }}.create;

        q.onInit = @(__original) { function onInit()
        {
            __original();
            try {
                if (this.Math.rand(1, 100) <= 50)
                {
                    local tattoo_body = this.actor.getSprite("tattoo_body");
                    local body = this.actor.getSprite("body");
                    tattoo_body.setBrush(::Const.Tattoos.AsianBody[this.Math.rand(0, ::Const.Tattoos.AsianBody.len() - 1)]);
                    tattoo_body.Visible = true;
                }

                if (this.Math.rand(1, 100) <= 25)
                {
                    local tattoo_head = this.actor.getSprite("tattoo_head");
                    tattoo_head.setBrush(::Const.Tattoos.AsianHead[this.Math.rand(0, ::Const.Tattoos.AsianHead.len() - 1)]);
                    tattoo_head.Visible = true;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/renzhe: " + e);
            }
        }}.onInit;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/sengbing", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                this.m.Bodies = this.Const.Bodies.AsianMale;
                this.m.Faces = this.Const.Faces.AsianMale;
                this.m.Hairs = null;
                this.m.HairColors = this.Const.HairColors.Asian;
                this.m.Beards = this.Const.Beards.AsianMale;
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/sengbing: " + e);
            }
        }}.create;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/wushi", function(q) {
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
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/wushi: " + e);
            }
        }}.create;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/wushi02", function(q) {
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
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/wushi02: " + e);
            }
        }}.create;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/wushi03", function(q) {
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
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/wushi03: " + e);
            }
        }}.create;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/wushi04", function(q) {
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
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/wushi04: " + e);
            }
        }}.create;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/wushi05", function(q) {
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
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/wushi05: " + e);
            }
        }}.create;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/wushidajiang", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                this.m.Bodies = this.Const.Bodies.AsianMale;
                this.m.Faces = this.Const.Faces.AsianMale;
                this.m.Hairs = this.Const.Hair.AsianMale;
                this.m.HairColors = this.Const.HairColors.Asian;
                this.m.Beards = this.Const.Beards.AsianMale;
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/wushidajiang: " + e);
            }
        }}.create;

        q.onInit = @(__original) { function onInit()
        {
            __original();
            try {
                if (this.Math.rand(1, 100) <= 66)
                {
                    local tattoo_body = this.actor.getSprite("tattoo_body");
                    local body = this.actor.getSprite("body");
                    tattoo_body.setBrush(::Const.Tattoos.AsianBody[this.Math.rand(0, ::Const.Tattoos.AsianBody.len() - 1)]);
                    tattoo_body.Visible = true;
                }
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/wushidajiang: " + e);
            }
        }}.onInit;
    });

    ::MoreHeadsExtended.HooksMod.hook("scripts/entity/tactical/humans/zuqing", function(q) {
        q.create = @(__original) { function create()
        {
            __original();
            try {
                this.m.Bodies = this.Const.Bodies.AsianMale;
                this.m.Faces = this.Const.Faces.AsianMale;
                this.m.Hairs = this.Const.Hair.AsianMale;
                this.m.HairColors = this.Const.HairColors.Asian;
                this.m.Beards = this.Const.Beards.AsianMale;
			    if (this.m.Bodies != null && this.m.Bodies.len() > 0) this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
            } catch (e) {
                ::logError("[mod_more_heads_extended] scripts/entity/tactical/humans/zuqing: " + e);
            }
        }}.create;
    });
}
