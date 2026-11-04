::LuftRetiredGladiatorOrigin <- {
	ID = "mod_LuftRetiredGladiatorOrigin",
	Name = "Отставной гладиатор Люфта",
	Version = "3.3.7",
	GitHubURL = "",
}

::LuftRetiredGladiatorOrigin.HooksMod <- ::Hooks.register(::LuftRetiredGladiatorOrigin.ID, ::LuftRetiredGladiatorOrigin.Version, ::LuftRetiredGladiatorOrigin.Name);

::LuftRetiredGladiatorOrigin.HooksMod.require("mod_msu >= 1.8.0");

::LuftRetiredGladiatorOrigin.HooksMod.queue(">mod_msu", function() {
	::LuftRetiredGladiatorOrigin.Mod <- ::MSU.Class.Mod(::LuftRetiredGladiatorOrigin.ID, ::LuftRetiredGladiatorOrigin.Version, ::LuftRetiredGladiatorOrigin.Name);

    ::LuftRetiredGladiatorOrigin.HooksMod.hookTree("scripts/entity/world/settlement", function (q) {
        local numQiyan = 0;

        if (q.ClassName.find("city_state") != null) numQiyan = 4;
        else if (q.ClassName.find("_southern_village") != null) numQiyan = 2;

        q.create = @(__original) function () {
            __original();
            for (local i = 0; i < numQiyan; i++)
            {
                this.m.DraftList.push("legend_qiyan_background");
            }
        };

        q.onUpdateShopList = @(__original) function( _id, _list )
        {
            if (_list != null)
            {
                switch (_id)
                {
                    case "building.marketplace":
                    {
                        if (this.isSouthern())
                        {
                            _list.push({
                              R = 50,
                              P = 1.0,
                              S = "helmets/legend_southern_veil",
                            });
                            _list.push({
                              R = 50,
                              P = 1.0,
                              S = "helmets/legend_southern_cloth_headress",
                            });
                            _list.push({
                              R = 60,
                              P = 1.0,
                              S = "helmets/legend_earings",
                            });
                            _list.push({
                              R = 60,
                              P = 1.0,
                              S = "helmets/legend_headband_coin",
                            });
                            _list.push({
                              R = 70,
                              P = 1.0,
                              S = "helmets/legend_headress_coin",
                            });
                        }
                    }
                }

              __original(_id, _list);
            }
        }
    });

    if (!("DynamicPerks" in getroottable()) || typeof ::DynamicPerks == "string") {
        if (!("DynamicPerks" in getroottable()))
            ::DynamicPerks <- "gladiator_placeholder"; // needed to fool mod_plan_perks
    
        ::Hooks.registerJS("ui/mods/gladiatorPerkTree.js");
        ::Hooks.registerCSS("ui/mods/gladiatorPerkTree.css");
    
        ::LuftRetiredGladiatorOrigin.HooksMod.hook("scripts/ui/global/data_helper", function (q) {
    
            q.convertEntityToUIData = @(__original) function(_entity, _activeEntity) {
                local result = __original(_entity, _activeEntity);
                local perks = ::Const.Perks.Perks.map(@(row) clone row);
                if (_entity != null && _entity.getSkills().hasSkill("background.converted_gladiator")) {
                    foreach (perk in ::Const.Perks.RetiredGladiatorTreeLight) {
                        perks[perk.Row].push(perk);
                    }
                    result.gladiatorLight_perkTree <- perks;
                }
                else if (_entity != null && _entity.getSkills().hasSkill("background.retired_gladiator")) {
                    foreach (perk in ::Const.Perks.RetiredGladiatorTree) {
                        perks[perk.Row].push(perk);
                    }
                    result.gladiator_perkTree <- perks;
                }
                return result;
            }
        });
    }

    ::LuftRetiredGladiatorOrigin.HooksMod.hook("scripts/skills/actives/throw_dirt_skill", function (q) {
    	q.create = @(__original) function() {
    		__original();
    		this.m.Description = "Бросает грязь, чтобы отвлечь врага. Снижает инициативу и урон цели на 35% на один ход.";
    		this.m.IconDisabled = "skills/active_215_sw.png";
    		this.m.IsUsingHitchance = true;
    	}

    	q.getTooltip = @(__original) function() {
    		local ret = __original();
            ret.push({
                id = 3,
                type = "text",
                text = this.getCostString()
            });
            return ret;
    	}
    });

    ::LuftRetiredGladiatorOrigin.HooksMod.hook("scripts/states/world/asset_manager", function(q) {
        q.updateLook = @(__original) function (_updateTo = -1) {
            if (this.World.Assets.getOrigin().getID() == "scenario.ret_gladiator")
                __original(16);
            else
                __original(_updateTo);
        }
    });
});
