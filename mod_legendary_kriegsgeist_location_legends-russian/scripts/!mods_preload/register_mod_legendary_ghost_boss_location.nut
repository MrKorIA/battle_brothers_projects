local id = "mod_legendary_kriegsgeist_boss_location";
local version = "1.0.5";

::mods_registerMod(id, version, "Легендарный Кригсгейст");
::mods_queue(id, "mod_msu", function()
{
	// set up a mod setting page
	::ModLegendaryKriegsgeistLocation <- ::MSU.Class.Mod(id, version, "Легендарный Кригсгейст");

	// first page for the sword
	local page = ::ModLegendaryKriegsgeistLocation.ModSettings.addPage("page_sword", "Легендарный меч");
	page.addTitle("title_sword", "Минимальный, максимальный, щитовой урон требует перезагрузки сохранения для применения изменений");
	page.addDivider("divider_sword");
	page.addStringSetting("name_sword", "Нечестивое могущество", "Изменить имя");
	page.addRangeSetting("min_damage_sword", 90, 10, 200, 5, "Минимальный урон");
	page.addRangeSetting("shield_damage_sword", 100, 10, 200, 5, "Щитовой урон");
	page.addRangeSetting("max_damage_sword", 110, 10, 200, 5, "Максимальный урон");
	page.addRangeSetting("stun_sword", 0, 0, 100, 5, "Шанс оглушения");
	page.addBooleanSetting("curse_is_removed_sword", false, "Снятие недостатков");

	// second page for the skull
	page = ::ModLegendaryKriegsgeistLocation.ModSettings.addPage("page_skull", "Легендарный череп");
	page.addTitle("title_skull", "Не требуется перезагрузка сохранения для применения");
	page.addDivider("divider_skull");
	page.addStringSetting("name_skull", "Череп Кригсгейста", "Изменить имя");
	page.addRangeSetting("efficiency_skull", 25, 0, 250, 5, "Соотношение опыта к очкам души (%)");
	page.addRangeSetting("loss_on_unequip", 100, 0, 1000, 50, "Потеря очков души при снятии экипировки");
	page.addRangeSetting("loss_in_battle", 500, 0, 1000, 50, "Потеря очков души при отсутствии убийств");
	page.addBooleanSetting("curse_is_removed_skull", false, "Снять недостатки");


	// new property
	::MSU.Table.merge(::Const.CharacterProperties, {
    	IsSpecializedInGhostSkull = false
    });

	// add some functions to help the summoned geist work properly
	::mods_hookExactClass("entity/tactical/enemies/ghost", function(o)
	{
		local ws_create = o.create;
		o.create = function()
		{
			ws_create();
			this.m.IsActingImmediately = true;
		};
		o.onFactionChanged <- function()
		{
			this.actor.onFactionChanged();
			local flip = this.isAlliedWithPlayer();
			this.getSprite("fog").setHorizontalFlipping(flip);
			this.getSprite("body").setHorizontalFlipping(flip);
			this.getSprite("head").setHorizontalFlipping(flip);
			this.getSprite("blur_1").setHorizontalFlipping(flip);
			this.getSprite("blur_2").setHorizontalFlipping(flip);
		};
		o.onActorKilled <- function( _actor, _tile, _skill )
		{
			this.actor.onActorKilled(_actor, _tile, _skill);

			if (this.getFaction() == ::Const.Faction.Player || this.getFaction() == ::Const.Faction.PlayerAnimals)
			{
				local XPgroup = _actor.getXPValue();
				local brothers = ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player);

				foreach( bro in brothers )
				{
					if (bro.getCurrentProperties().IsAllyXPBlocked)
					{
						return;
					}

					bro.addXP(::Math.max(1, ::Math.floor(XPgroup / brothers.len())));
				}
			}
		};
		o.spawnGhostEffect <- function( _tile )
		{
			local effect = {
				Delay = 0,
				Quantity = 12,
				LifeTimeQuantity = 12,
				SpawnRate = 100,
				Brushes = [
					"bust_ghost_01"
				],
				Stages = [
					{
						LifeTimeMin = 1.0,
						LifeTimeMax = 1.0,
						ColorMin = ::createColor("ffffff5f"),
						ColorMax = ::createColor("ffffff5f"),
						ScaleMin = 1.0,
						ScaleMax = 1.0,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(-1.0, -1.0),
						DirectionMax = ::createVec(1.0, 1.0),
						SpawnOffsetMin = ::createVec(-10, -10),
						SpawnOffsetMax = ::createVec(10, 10),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					},
					{
						LifeTimeMin = 1.0,
						LifeTimeMax = 1.0,
						ColorMin = ::createColor("ffffff2f"),
						ColorMax = ::createColor("ffffff2f"),
						ScaleMin = 0.9,
						ScaleMax = 0.9,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(-1.0, -1.0),
						DirectionMax = ::createVec(1.0, 1.0),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.1,
						ColorMin = ::createColor("ffffff00"),
						ColorMax = ::createColor("ffffff00"),
						ScaleMin = 0.1,
						ScaleMax = 0.1,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(-1.0, -1.0),
						DirectionMax = ::createVec(1.0, 1.0),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					}
				]
			};
			::Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, ::createVec(0, 40));
		};
	});


	// give a buff for cursed_crystal_skull
	::mods_hookExactClass("items/accessory/legendary/cursed_crystal_skull", function(o)
	{
		local ws_getTooltip = o.getTooltip;
		o.getTooltip = function()
		{
			local result = ws_getTooltip();

			if (this.isEquipped() && this.getContainer().getActor().getFlags().has("has_ghost_skull"))
			{
				result.push({
					id = 4,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Улучшает [color=" + ::Const.UI.Color.NegativeValue + "]" + ::getContainer().getActor().getFlags().get("has_ghost_skull") + "[/color] способность получать очки души",
				});
			}

			return result;
		};

		local ws_onUpdateProperties = o.onUpdateProperties;
		o.onUpdateProperties = function( _properties )
		{
			_properties.IsSpecializedInGhostSkull = true;
			ws_onUpdateProperties(_properties);
		};
	});


	// add additional skills for this behavior
	::mods_hookExactClass("ai/tactical/behaviors/ai_always_use", function(o)
	{
		o.m.PossibleSkills.push("actives.ghost_collect_fragment");
	});


	// make illusion disappear when attacked by melee attacks
	::mods_hookBaseClass("skills/skill", function(o) 
	{
		o = o[o.SuperName];
		local ws_attackEntity = o.attackEntity;
		o.attackEntity = function( _user, _targetEntity, _allowDiversion = true )
		{
			if (!this.isRanged() && _targetEntity.getFlags().has("illusion"))
			{
				_targetEntity.kill(_user);
				return false;
			}

			return ws_attackEntity(_user, _targetEntity, _allowDiversion);
		}
	})


	::mods_hookExactClass("ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(o)
	{
		o.onEntityClicked = function( _entityId )
		{
			if (!::Tactical.CameraDirector.isInputAllowed())
			{
				return;
			}

			local entity = this.findEntityByID(this.m.CurrentEntities, _entityId);

			if (entity && !entity.entity.getFlags().get("undetectable"))
			{
				this.moveToEntity(entity.entity, false, true);
			}
		}
	});


	// add the new legendary location to world generation
	::mods_hookExactClass("factions/actions/build_unique_locations_action", function(o)
	{
		o.m.BuildUndeadStronghold <- true;

		local ws_updateBuildings = o.updateBuildings;
		o.updateBuildings = function()
		{
			local locations = ::World.EntityManager.getLocations();

			foreach( v in locations )
			{
				if (v.getTypeID() == "location.legendary_kriegsgeist_location")
				{
					this.m.BuildUndeadStronghold = false;
				}
			}

			ws_updateBuildings();
		};
		local ws_onExecute = o.onExecute;
		o.onExecute = function( _faction )
		{
			if (this.m.BuildUndeadStronghold)
			{
				local lair;
				local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, [
					::Const.World.TerrainType.Mountains,
					::Const.World.TerrainType.Desert,
					::Const.World.TerrainType.Oasis
				], 5, 11, 1000, 7, 7, null, ::Const.DLC.Desert ? 0.2 : 0.0);

				if (tile != null)
				{
					lair = ::World.spawnLocation("scripts/entity/world/locations/mods/mod_legendary_kriegsgeist_location", tile.Coords);
				}

				if (lair != null)
				{
					::World.Flags.set("LegendaryKriegsgeistLocation", true);
					lair.onSpawned();
				}
			}
			else
			{
				ws_onExecute(_faction);
			}
		};
	});


	// generate this legendary location in an existed save
	::mods_hookExactClass("states/world_state", function(o)
	{
		local ws_onDeserialize = o.onDeserialize;
		o.onDeserialize = function( _in )
		{
			ws_onDeserialize(_in);

			if (!::World.Flags.get("LegendaryKriegsgeistLocation"))
			{
				local f = ::World.FactionManager.getFactionOfType(::Const.FactionType.Zombies);
				local action = f.getAction("build_zombie_camp_action");
				local tile 
				do
				{
					tile = action.getTileToSpawnLocation(::Const.Factions.BuildCampTries, [
						::Const.World.TerrainType.Mountains,
						::Const.World.TerrainType.Desert,
						::Const.World.TerrainType.Oasis
					], 5, 11, 1000, 7, 7, null, ::Const.DLC.Desert ? 0.2 : 0.0);
				}
				while (tile == null)
				
				local lair = ::World.spawnLocation("scripts/entity/world/locations/mods/mod_legendary_kriegsgeist_location", tile.Coords);

				if (lair != null)
				{
					::World.Flags.set("LegendaryKriegsgeistLocation", true);
					lair.onSpawned();
				}
			}
		}
	});
});
