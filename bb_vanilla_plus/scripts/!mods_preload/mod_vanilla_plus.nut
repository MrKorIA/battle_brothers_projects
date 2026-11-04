::VanillaPlus <- {
	ID = "mod_fantasybro",
	Name = "Vanilla Plus",
	Version = "0.15.0",
	GitHubURL = "",
    Const = {
        DayThresholdMinDangerBeasts = 10,	// Higher Tier Beast Caves (Lindwurms and Unholds) only start appearing at this day count
    },
    QueueBucket = {
        Late = [],
        VeryLate = [], // For experimental modules only
        AfterHooks = [],
        FirstWorldInit = []
    }
}

local requiredMods = [
	"vanilla >= 1.5.1-8",
	"mod_msu >= 1.8.0",
	"mod_modern_hooks >= 0.4.10",
	"dlc_lindwurm",
	"dlc_unhold",
	"dlc_wildmen",
	"dlc_desert",
	"dlc_paladins"
];

::VanillaPlus.HooksMod <- ::Hooks.register(::VanillaPlus.ID, ::VanillaPlus.Version, ::VanillaPlus.Name);

local queueLoadOrder = [];
foreach (requirement in requiredMods)
{
	local idx = requirement.find(" ");
	queueLoadOrder.push(">" + (idx == null ? requirement : requirement.slice(0, idx)));
}

::VanillaPlus.HooksMod.queue(">mod_msu", ">mod_necro", ">mod_druid", function() {
	::VanillaPlus.Mod <- ::MSU.Class.Mod(::VanillaPlus.ID, ::VanillaPlus.Version, ::VanillaPlus.Name);

	//::VanillaPlus.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, ::VanillaPlus.GitHubURL);
	//::VanillaPlus.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);

	::include("mod_vanilla_plus/load");		// Load mod adjustments and other hooks
	::Hooks.registerJS("ui/mods/vp_perkTree.js");
    ::Hooks.registerCSS("ui/mods/vp_perkTree.css");

	::mods_hookExactClass("ai/tactical/behaviors/ai_attack_default", function (o)
    	{
    		o.m.PossibleSkills.extend([
    				"actives.xx_a",
    				"actives.xx_b",
    				"actives.sb_strike_skill",
    				"actives.xxitem_rifleaa_skill",
    				"actives.xxitem_cestusaa_skill",
    				"actives.ai_punch"
    		]);
    	});

    	::mods_hookExactClass("ai/tactical/behaviors/ai_attack_handgonne", function (o)
    	{
    		o.m.PossibleSkills.extend([
    				"actives.aoe_a"
    		]);
    	});

    	::mods_hookNewObject("ui/screens/tooltip/tooltip_events", function ( o )
    	{
    		local general_queryUIElementTooltipData = o.general_queryUIElementTooltipData
    		o.general_queryUIElementTooltipData = function( _entityId, _elementId, _elementOwner )
    		{
    			local entity;
    			if (_entityId != null)
    			{
    				entity = this.Tactical.getEntityByID(_entityId);
    			}
    			switch(_elementId)
    			{
    				case "world-town-screen.main-dialog-module.ThievesMarket":
    					return [
    						{
    							id = 1,
    							type = "title",
    							text = "Воровской рынок"
    						},
    						{
    							id = 2,
    							type = "description",
    							text = "Место, где можно торговать различными краденными товарами и редкими предметами. Каждые несколько дней появляются новые товары. Здесь также можно отремонтировать оборудование."
    						}
    					];
    				case "world-town-screen.main-dialog-module.AdventurersGuild":
    					local ret = [
    						{
    							id = 1,
    							type = "title",
    							text = "Гильдия авантюристов"
    						},
    						{
    							id = 2,
    							type = "description",
    							text = "Место, где предоставляются различные услуги, необходимые для приключений."
    						}
    					];
    					return ret;
    				case "world-town-screen.main-dialog-module.PortalGate":
    					local ret = [
    					{
    							id = 1,
    							type = "title",
    							text = this.Const.Strings.FT.PortalGateName
    						},
    						{
    							id = 2,
    							type = "description",
    							text = this.Const.Strings.FT.PortalGateText
    						}
    					];
    					local z = this.World.Contracts.getActiveContract();
    					if (z != null)
    					{
    						local a = z.getType();
    						if (a == "contract.escort_caravan" || a == "contract.deliver_item" || a == "contract.escort_caravan")
    						{
    							ret.push({
    								id = 3,
    								type = "hint",
    								icon = "ui/tooltips/warning.png",
    								text = this.Const.Strings.FT.NoUse
    							});
    						}
    					}
    					return ret;
    			}
    			return general_queryUIElementTooltipData( _entityId, _elementId, _elementOwner )
    		}
    	});

    	::mods_hookExactClass("entity/tactical/actor", function ( o )
    	{
    	///
    	o.onRender <- function ()
    	{
    		if (this.m.IsRaisingShield)
    		{
    			if (this.moveSpriteOffset("shield_icon", this.createVec(0, 0), this.Const.Items.Default.RaiseShieldOffset, this.Const.Items.Default.RaiseShieldDuration, this.m.RenderAnimationStartTime))
    			{
    				this.m.IsRaisingShield = false;

    				if (!this.m.IsUsingCustomRendering)
    				{
    					this.setRenderCallbackEnabled(false);
    				}
    			}
    		}
    		else if (this.m.IsLoweringShield)
    		{
    			if (this.moveSpriteOffset("shield_icon", this.Const.Items.Default.RaiseShieldOffset, this.createVec(0, 0), this.Const.Items.Default.LowerShieldDuration, this.m.RenderAnimationStartTime))
    			{
    				this.m.IsLoweringShield = false;

    				if (!this.m.IsUsingCustomRendering)
    				{
    					this.setRenderCallbackEnabled(false);
    				}
    			}
    		}

    		if (this.m.IsLoweringWeapon)
    		{
    			local p = (this.Time.getVirtualTimeF() - this.m.RenderAnimationStartTime) / this.Const.Items.Default.LowerWeaponDuration;
    			local mainw = this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand).m.ID;
    			if (mainw == "weapon.xxcrosslance" || this.m.Skills.hasSkill("effects.ai_spearwall_fake"))
    			{
    				if (this.m.Items.getAppearance().TwoHanded)
    				{
    					this.getSprite("arms_icon").Rotation = this.Math.minf(1.0, p) * -70.0;
    					if (this.isAlliedWithPlayer())
    					{
    						this.moveSpriteOffset("arms_icon", this.getSpriteOffset("arms_icon"), this.createVec(46 * this.Math.minf(1.0, p), -33 * this.Math.minf(1.0, p)), this.Const.Items.Default.LowerWeaponDuration, this.m.RenderAnimationStartTime);
    					}
    					else
    					{
    						this.moveSpriteOffset("arms_icon", this.getSpriteOffset("arms_icon"), this.createVec(-46 * this.Math.minf(1.0, p), -33 * this.Math.minf(1.0, p)), this.Const.Items.Default.LowerWeaponDuration, this.m.RenderAnimationStartTime);
    					}
    				}
    				else
    				{
    					this.getSprite("arms_icon").Rotation = this.Math.minf(1.0, p) * -15.0;
    					if (this.isAlliedWithPlayer())
    					{
    						this.moveSpriteOffset("arms_icon", this.getSpriteOffset("arms_icon"), this.createVec(15 * this.Math.minf(1.0, p), 5 * this.Math.minf(1.0, p)), this.Const.Items.Default.LowerWeaponDuration, this.m.RenderAnimationStartTime);
    					}
    					else
    					{
    						this.moveSpriteOffset("arms_icon", this.getSpriteOffset("arms_icon"), this.createVec(-15 * this.Math.minf(1.0, p), 5 * this.Math.minf(1.0, p)), this.Const.Items.Default.LowerWeaponDuration, this.m.RenderAnimationStartTime);
    					}
    				}
    			}
    			else if (this.m.Items.getAppearance().TwoHanded)
    			{
    				this.getSprite("arms_icon").Rotation = this.Math.minf(1.0, p) * -70.0;
    			}
    			else
    			{
    				this.getSprite("arms_icon").Rotation = this.Math.minf(1.0, p) * -33.0;
    			}

    			if (p >= 1.0)
    			{
    				this.m.IsLoweringWeapon = false;

    				if (!this.m.IsUsingCustomRendering)
    				{
    					this.setRenderCallbackEnabled(false);
    				}
    			}
    		}
    		else if (this.m.IsRaisingWeapon)
    		{
    			local p = (this.Time.getVirtualTimeF() - this.m.RenderAnimationStartTime) / this.Const.Items.Default.RaiseWeaponDuration;

    			if (this.getSpriteOffset("arms_icon").X != 0 || this.getSpriteOffset("arms_icon").Y != 0)
    			{
    				if (this.m.Items.getAppearance().TwoHanded)
    				{
    					this.getSprite("arms_icon").Rotation = (1.0 - this.Math.minf(1.0, p)) * -70.0;
    					if (this.isAlliedWithPlayer())
    					{
    						this.moveSpriteOffset("arms_icon", this.getSpriteOffset("arms_icon"), this.createVec(46 * (1 - this.Math.minf(1.0, p)), -33 * (1 - this.Math.minf(1.0, p))), this.Const.Items.Default.LowerWeaponDuration, this.m.RenderAnimationStartTime);
    					}
    					else
    					{
    						this.moveSpriteOffset("arms_icon", this.getSpriteOffset("arms_icon"), this.createVec(-46 * (1 - this.Math.minf(1.0, p)), -33 * (1 - this.Math.minf(1.0, p))), this.Const.Items.Default.LowerWeaponDuration, this.m.RenderAnimationStartTime);
    					}
    				}
    				else
    				{
    					this.getSprite("arms_icon").Rotation = (1.0 - this.Math.minf(1.0, p)) * -15.0;
    					if (this.isAlliedWithPlayer())
    					{
    						this.moveSpriteOffset("arms_icon", this.getSpriteOffset("arms_icon"), this.createVec(15 * (1 - this.Math.minf(1.0, p)), 5 * (1 - this.Math.minf(1.0, p))), this.Const.Items.Default.LowerWeaponDuration, this.m.RenderAnimationStartTime);
    					}
    					else
    					{
    						this.moveSpriteOffset("arms_icon", this.getSpriteOffset("arms_icon"), this.createVec(-15 * (1 - this.Math.minf(1.0, p)), 5 * (1 - this.Math.minf(1.0, p))), this.Const.Items.Default.LowerWeaponDuration, this.m.RenderAnimationStartTime);
    					}
    				}
    			}
    			else if (this.m.Items.getAppearance().TwoHanded)
    			{
    				this.getSprite("arms_icon").Rotation = (1.0 - this.Math.minf(1.0, p)) * -70.0;
    			}
    			else
    			{
    				this.getSprite("arms_icon").Rotation = (1.0 - this.Math.minf(1.0, p)) * -33.0;
    			}

    			if (p >= 1.0)
    			{
    				this.m.IsRaisingWeapon = false;

    				if (!this.m.IsUsingCustomRendering)
    				{
    					this.setRenderCallbackEnabled(false);
    				}
    			}
    		}

    		if (this.m.IsRaising)
    		{
    			local p = (this.Time.getVirtualTimeF() - this.m.RenderAnimationStartTime) / (this.Const.Combat.ResurrectAnimationTime * this.m.RenderAnimationSpeed);

    			if (p >= 1.0)
    			{
    				this.setPos(this.createVec(0, 0));
    				this.setAlpha(255);
    				this.m.IsRaising = false;
    				this.m.IsAttackable = true;

    				if (!this.m.IsUsingCustomRendering)
    				{
    					this.setRenderCallbackEnabled(false);
    				}
    			}
    			else
    			{
    				this.setPos(this.createVec(0, this.Const.Combat.ResurrectAnimationDistance * this.m.RenderAnimationDistanceMult * (1.0 - p)));
    			}
    		}
    		else if (this.m.IsSinking)
    		{
    			local p = (this.Time.getVirtualTimeF() - this.m.RenderAnimationStartTime) / (this.Const.Combat.ResurrectAnimationTime * this.m.RenderAnimationSpeed);

    			if (p >= 1.0)
    			{
    				this.setPos(this.createVec(0, this.Const.Combat.ResurrectAnimationDistance * this.m.RenderAnimationDistanceMult));
    				this.m.IsSinking = false;
    				this.m.IsAttackable = true;

    				if (!this.m.IsUsingCustomRendering)
    				{
    					this.setRenderCallbackEnabled(false);
    				}
    			}
    			else
    			{
    				this.setPos(this.createVec(0, this.Const.Combat.ResurrectAnimationDistance * this.m.RenderAnimationDistanceMult * p));
    			}
    		}

    		if (this.m.IsRaisingRooted)
    		{
    			local from = this.createVec(this.m.RenderAnimationOffset.X, this.m.RenderAnimationOffset.Y - 100);
    			this.moveSpriteOffset("status_rooted_back", from, this.m.RenderAnimationOffset, this.Const.Combat.RootedAnimationTime, this.m.RenderAnimationStartTime);

    			if (this.moveSpriteOffset("status_rooted", from, this.m.RenderAnimationOffset, this.Const.Combat.RootedAnimationTime, this.m.RenderAnimationStartTime))
    			{
    				this.m.IsRaisingRooted = false;

    				if (!this.m.IsUsingCustomRendering)
    				{
    					this.setRenderCallbackEnabled(false);
    				}

    				this.setDirty(true);
    			}
    		}
    	}
    	///
    	});

    	::mods_hookNewObjectOnce("states/world/asset_manager", function (o)
    	{
    		local update = o.update;
    		o.update = function(_worldState)
    		{
    			update(_worldState)
    			local disallowedTerrain;
    			local f;
    			local tile;
    			local camp;

    			if (!this.World.Flags.get("spawned_xxogretown"))
    			{
    				disallowedTerrain = [this.Const.World.TerrainType.Mountains, this.Const.World.TerrainType.Impassable, this.Const.World.TerrainType.Ocean]
    				f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts)
    				tile = null
    				camp = null
    				while (tile == null)
    				{
    					tile = f.m.Deck[0].getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 1, disallowedTerrain, 1, 800);
    				}
    				if (tile != null)
    				{
    					camp = this.World.spawnLocation("scripts/entity/world/locations/xxogretown_location", tile.Coords);
    				}
    				if (camp != null)
    				{
    					this.logInfo("Ogre Town Here")
    					camp.setBanner("banner_goblins_07")
    					camp.onSpawned();
    					f.addSettlement(camp, false);
    					this.World.Flags.set("spawned_xxogretown", true)
    				}
    			}

    			if (!this.World.Flags.get("spawned_xxswordtown"))
    			{
    			    disallowedTerrain = [];
                    for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i )
                    {
                        if (i == ::Const.World.TerrainType.Steppe || i == ::Const.World.TerrainType.Hills || i == ::Const.World.TerrainType.Oasis || i == ::Const.World.TerrainType.Plains || i == ::Const.World.TerrainType.Farmland)
                        {
                            continue;
                        }
                        disallowedTerrain.push(i);
                    }
    				f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts)
    				tile = null
    				camp = null
    				while (tile == null)
    				{
    					tile = f.m.Deck[0].getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 1, disallowedTerrain, 1, 800);
    				}
    				if (tile != null)
    				{
    					camp = this.World.spawnLocation("scripts/entity/world/locations/xxswordtown_location", tile.Coords);
    				}
    				if (camp != null)
    				{
    					this.logInfo("Sword Town Here")
    					camp.setBanner("banner_goblins_07")
    					camp.onSpawned();
    					f.addSettlement(camp, false);
    					this.World.Flags.set("spawned_xxswordtown", true)
    				}
    			}

    			if (!this.World.Flags.get("spawned_xxruinedtown"))
    			{
    			    disallowedTerrain = [];
                    for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i )
                    {
                        if (i == ::Const.World.TerrainType.Steppe || i == ::Const.World.TerrainType.Hills || i == ::Const.World.TerrainType.Badlands || i == ::Const.World.TerrainType.Plains)
                        {
                            continue;
                        }
                        disallowedTerrain.push(i);
                    }
    				f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts)
    				tile = null
    				camp = null
    				while (tile == null)
    				{
    					tile = f.m.Deck[0].getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 1, disallowedTerrain, 1, 800);
    				}
    				if (tile != null)
    				{
    					camp = this.World.spawnLocation("scripts/entity/world/locations/xxruinedtown_location", tile.Coords);
    				}
    				if (camp != null)
    				{
    					this.logInfo("Ruined Town Here")
    					camp.setBanner("banner_goblins_07")
    					camp.onSpawned();
    					f.addSettlement(camp, false);
    					this.World.Flags.set("spawned_xxruinedtown", true)
    				}
    			}

    			if (!this.World.Flags.get("spawned_xxthieftown"))
    			{
    			    disallowedTerrain = [];
                    for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i )
                    {
                        if (i == ::Const.World.TerrainType.Steppe
                            || i == ::Const.World.TerrainType.Hills
                            || i == ::Const.World.TerrainType.Swamp
                            || i == ::Const.World.TerrainType.Land
                            || i == ::Const.World.TerrainType.Badlands
                            || i == ::Const.World.TerrainType.Plains
                            || i == ::Const.World.TerrainType.Forest
                            || i == ::Const.World.TerrainType.AutumnForest
                            || i == ::Const.World.TerrainType.LeaveForest)
                        {
                            continue;
                        }
                        disallowedTerrain.push(i);
                    }
    				f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts)
    				tile = null
    				camp = null
    				while (tile == null)
    				{
    					tile = f.m.Deck[0].getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 1, disallowedTerrain, 1, 800);
    				}
    				if (tile != null)
    				{
    					camp = this.World.spawnLocation("scripts/entity/world/locations/xxthieftown_location", tile.Coords);
    				}
    				if (camp != null)
    				{
    					this.logInfo("Thief Town Here")
    					camp.setBanner("banner_goblins_07")
    					camp.onSpawned();
    					f.addSettlement(camp, false);
    					this.World.Flags.set("spawned_xxthieftown", true)
    				}
    			}

    			if (!this.World.Flags.get("spawned_xxghoultown"))
    			{
    			    disallowedTerrain = [];
                    for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i )
                    {
                        if (i == ::Const.World.TerrainType.Swamp
                            || i == ::Const.World.TerrainType.Badlands
                            || i == ::Const.World.TerrainType.Forest
                            || i == ::Const.World.TerrainType.AutumnForest
                            || i == ::Const.World.TerrainType.LeaveForest)
                        {
                            continue;
                        }
                        disallowedTerrain.push(i);
                    }
    				f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts)
    				tile = null
    				camp = null
    				while (tile == null)
    				{
    					tile = f.m.Deck[0].getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 1, disallowedTerrain, 1, 800);
    				}
    				if (tile != null)
    				{
    					camp = this.World.spawnLocation("scripts/entity/world/locations/xxghoultown_location", tile.Coords);
    				}
    				if (camp != null)
    				{
    					this.logInfo("Ghoul Town Here")
    					camp.setBanner("banner_goblins_07")
    					camp.onSpawned();
    					f.addSettlement(camp, false);
    					this.World.Flags.set("spawned_xxghoultown", true)
    				}
    			}

    			if (!this.World.Flags.get("spawned_xxdragontown"))
    			{
    				disallowedTerrain = [this.Const.World.TerrainType.Mountains, this.Const.World.TerrainType.Impassable, this.Const.World.TerrainType.Ocean]
    				f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts)
    				tile = null
    				camp = null
    				while (tile == null)
    				{
    					tile = f.m.Deck[0].getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 1, disallowedTerrain, 1, 800);
    				}
    				if (tile != null)
    				{
    					camp = this.World.spawnLocation("scripts/entity/world/locations/xxdragontown_location", tile.Coords);
    				}
    				if (camp != null)
    				{
    					this.logInfo("Dragon Town Here")
    					camp.setBanner("banner_goblins_07")
    					camp.onSpawned();
    					f.addSettlement(camp, false);
    					this.World.Flags.set("spawned_xxdragontown", true)
    				}
    			}

    			if (!this.World.Flags.get("spawned_xxtreetown"))
    			{
    				disallowedTerrain = [];
    				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
    				{
    					if (i == this.Const.World.TerrainType.Forest || i == this.Const.World.TerrainType.LeaveForest || i == this.Const.World.TerrainType.AutumnForest)
    					{
    					}
    					else
    					{
    						disallowedTerrain.push(i);
    					}
    				}
    				f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts)
    				tile = null
    				camp = null
    				while (tile == null)
    				{
    					tile = f.m.Deck[0].getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 1, disallowedTerrain, 1, 800);
    				}
    				if (tile != null)
    				{
    					camp = this.World.spawnLocation("scripts/entity/world/locations/xxtreetown_location", tile.Coords);
    				}
    				if (camp != null)
    				{
    					this.logInfo("Tree Town Here")
    					camp.setBanner("banner_goblins_07")
    					camp.onSpawned();
    					f.addSettlement(camp, false);
    					this.World.Flags.set("spawned_xxtreetown", true)
    				}
    			}

    			if (!this.World.Flags.get("spawned_xxwolftown"))
    			{
    			    disallowedTerrain = [];
                    for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i )
                    {
                        if (i == ::Const.World.TerrainType.Steppe
                            || i == ::Const.World.TerrainType.Hills
                            || i == ::Const.World.TerrainType.Swamp
                            || i == ::Const.World.TerrainType.Tundra
                            || i == ::Const.World.TerrainType.Snow
                            || i == ::Const.World.TerrainType.Land
                            || i == ::Const.World.TerrainType.Badlands
                            || i == ::Const.World.TerrainType.Plains
                            || i == ::Const.World.TerrainType.Forest
                            || i == ::Const.World.TerrainType.AutumnForest
                            || i == ::Const.World.TerrainType.LeaveForest)
                        {
                            continue;
                        }
                        disallowedTerrain.push(i);
                    }
    				f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts)
    				tile = null
    				camp = null
    				while (tile == null)
    				{
    					tile = f.m.Deck[0].getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 1, disallowedTerrain, 1, 800);
    				}
    				if (tile != null)
    				{
    					camp = this.World.spawnLocation("scripts/entity/world/locations/xxwolftown_location", tile.Coords);
    				}
    				if (camp != null)
    				{
    					this.logInfo("Wolf Town Here")
    					camp.setBanner("banner_goblins_07")
    					camp.onSpawned();
    					f.addSettlement(camp, false);
    					this.World.Flags.set("spawned_xxwolftown", true)
    				}
    			}

    			if (!this.World.Flags.get("spawned_xxmagetown"))
    			{
    				disallowedTerrain = [this.Const.World.TerrainType.Mountains, this.Const.World.TerrainType.Impassable, this.Const.World.TerrainType.Ocean]
    				f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts)
    				tile = null
    				camp = null
    				while (tile == null)
    				{
    					tile = f.m.Deck[0].getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 1, disallowedTerrain, 1, 800);
    				}
    				if (tile != null)
    				{
    					camp = this.World.spawnLocation("scripts/entity/world/locations/xxmagetown_location", tile.Coords);
    				}
    				if (camp != null)
    				{
    					this.logInfo("Mage Town Here")
    					camp.setBanner("banner_goblins_07")
    					camp.onSpawned();
    					f.addSettlement(camp, false);
    					this.World.Flags.set("spawned_xxmagetown", true)
    				}
    			}

    			if (!this.World.Flags.get("spawned_xxculttown"))
    			{
    			    disallowedTerrain = [];
                    for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i )
                    {
                        if (i == ::Const.World.TerrainType.Steppe
                            || i == ::Const.World.TerrainType.Hills
                            || i == ::Const.World.TerrainType.Tundra
                            || i == ::Const.World.TerrainType.Snow
                            || i == ::Const.World.TerrainType.Land
                            || i == ::Const.World.TerrainType.Badlands
                            || i == ::Const.World.TerrainType.Plains)
                        {
                            continue;
                        }
                        disallowedTerrain.push(i);
                    }
    				f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts)
    				tile = null
    				camp = null
    				while (tile == null)
    				{
    					tile = f.m.Deck[0].getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 1, disallowedTerrain, 1, 800);
    				}
    				if (tile != null)
    				{
    					camp = this.World.spawnLocation("scripts/entity/world/locations/xxculttown_location", tile.Coords);
    				}
    				if (camp != null)
    				{
    					this.logInfo("Cult Town Here")
    					camp.setBanner("banner_goblins_07")
    					camp.onSpawned();
    					f.addSettlement(camp, false);
    					this.World.Flags.set("spawned_xxculttown", true)
    				}
    			}

    			if (!this.World.Flags.get("spawned_xxknighttown"))
    			{
    			    disallowedTerrain = [];
                    for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i )
                    {
                        if (i == ::Const.World.TerrainType.Steppe
                            || i == ::Const.World.TerrainType.Snow
                            || i == ::Const.World.TerrainType.Land
                            || i == ::Const.World.TerrainType.Badlands
                            || i == ::Const.World.TerrainType.Plains)
                        {
                            continue;
                        }
                        disallowedTerrain.push(i);
                    }
    				f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts)
    				tile = null
    				camp = null
    				while (tile == null)
    				{
    					tile = f.m.Deck[0].getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 1, disallowedTerrain, 1, 800);
    				}
    				if (tile != null)
    				{
    					camp = this.World.spawnLocation("scripts/entity/world/locations/xxknighttown_location", tile.Coords);
    				}
    				if (camp != null)
    				{
    					this.logInfo("Knight Town Here")
    					camp.setBanner("banner_goblins_07")
    					camp.onSpawned();
    					f.addSettlement(camp, false);
    					this.World.Flags.set("spawned_xxknighttown", true)
    				}
    			}

    			if (!this.World.Flags.get("spawned_xxinfidungeon"))
    			{
    				disallowedTerrain = [this.Const.World.TerrainType.Mountains, this.Const.World.TerrainType.Impassable, this.Const.World.TerrainType.Ocean]
    				f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts)
    				tile = null
    				camp = null
    				while (tile == null)
    				{
    					tile = f.m.Deck[0].getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 1, disallowedTerrain, 1, 800);
    				}
    				if (tile != null)
    				{
    					camp = this.World.spawnLocation("scripts/entity/world/locations/xxinfidungeon_location", tile.Coords);
    				}
    				if (camp != null)
    				{
    					this.logInfo("Infinite Dungeon Here")
    					camp.setBanner("banner_goblins_07")
    					camp.onSpawned();
    					f.addSettlement(camp, false);
    					this.World.Flags.set("spawned_xxinfidungeon", true)
    				}
    			}

    			if (!this.World.Flags.get("spawned_xxblackdragontown"))
    			{
    				disallowedTerrain = [this.Const.World.TerrainType.Mountains, this.Const.World.TerrainType.Impassable, this.Const.World.TerrainType.Ocean]
    				f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts)
    				tile = null
    				camp = null
    				while (tile == null)
    				{
    					tile = f.m.Deck[0].getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 1, disallowedTerrain, 1, 800);
    				}
    				if (tile != null)
    				{
    					camp = this.World.spawnLocation("scripts/entity/world/locations/xxblackdragontown_location", tile.Coords);
    				}
    				if (camp != null)
    				{
    					this.logInfo("Black Dragon Town Here")
    					camp.setBanner("banner_goblins_07")
    					camp.onSpawned();
    					f.addSettlement(camp, false);
    					this.World.Flags.set("spawned_xxblackdragontown", true)
    				}
    			}

    			if (!this.World.Flags.get("spawned_xxblackstatuetown"))
    			{
    				disallowedTerrain = [this.Const.World.TerrainType.Mountains, this.Const.World.TerrainType.Impassable, this.Const.World.TerrainType.Ocean]
    				f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts)
    				tile = null
    				camp = null
    				while (tile == null)
    				{
    					tile = f.m.Deck[0].getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 1, disallowedTerrain, 1, 800);
    				}
    				if (tile != null)
    				{
    					camp = this.World.spawnLocation("scripts/entity/world/locations/xxblackstatuetown_location", tile.Coords);
    				}
    				if (camp != null)
    				{
    					this.logInfo("Black Rock Statue Town Here")
    					camp.setBanner("banner_goblins_07")
    					camp.onSpawned();
    					f.addSettlement(camp, false);
    					this.World.Flags.set("spawned_xxblackstatuetown", true)
    				}
    			}

    			if (!this.World.Flags.get("spawned_xxdarkstartown"))
    			{
    				disallowedTerrain = [this.Const.World.TerrainType.Mountains, this.Const.World.TerrainType.Impassable, this.Const.World.TerrainType.Ocean]
    				f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts)
    				tile = null
    				camp = null
    				while (tile == null)
    				{
    					tile = f.m.Deck[0].getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 1, disallowedTerrain, 1, 800);
    				}
    				if (tile != null)
    				{
    					camp = this.World.spawnLocation("scripts/entity/world/locations/xxdarkstartown_location", tile.Coords);
    				}
    				if (camp != null)
    				{
    					this.logInfo("Dark Star Town Here")
    					camp.setBanner("banner_goblins_07")
    					camp.onSpawned();
    					f.addSettlement(camp, false);
    					this.World.Flags.set("spawned_xxdarkstartown", true)
    				}
    			}
    		}
    	})
});

::VanillaPlus.HooksMod.queue(">mod_msu", function() {
	// It remains to be decided, if all module stuff should be run late, but or now it only containes weighted gear container, which need to run after Hardeneds container
	::includeFiles(::IO.enumerateFiles("mod_vanilla_plus/api/modules"));
}, ::Hooks.QueueBucket.Last);

::VanillaPlus.HooksMod.queue(queueLoadOrder, function() {
	foreach (func in ::VanillaPlus.QueueBucket.Late)
	{
		func();
	}
}, ::Hooks.QueueBucket.Late);

::VanillaPlus.HooksMod.queue(queueLoadOrder, function() {
	foreach (func in ::VanillaPlus.QueueBucket.VeryLate)
	{
		func();
	}
}, ::Hooks.QueueBucket.VeryLate);