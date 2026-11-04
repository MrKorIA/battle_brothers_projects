::Stronghold.FactionDefs <- {};
::Stronghold.FactionDefs[this.Const.FactionType.Goblins] <- {
	Name = "Гоблины-налетчики",
	Spawnlist = this.Const.World.Spawn.GoblinRaiders,
	Description = "Боевой отряд гоблинов.",
	Footprint = this.Const.World.FootprintsType.Goblins,
}
if(this.Const.DLC.Wildmen)
{
	::Stronghold.FactionDefs[this.Const.FactionType.Barbarians] <- {
		Name = "Варвары",
		Spawnlist = this.Const.World.Spawn.Barbarians,
		Description = "Варварская племенная рать.",
		Footprint = this.Const.World.FootprintsType.Barbarians,
	}
}
::Stronghold.FactionDefs[this.Const.FactionType.OrientalBandits] <- {
	Name = "Кочевники",
	Spawnlist = this.Const.World.Spawn.NomadDefenders,
	Description = "Боевой отряд кочевников.",
	Footprint = this.Const.World.FootprintsType.Nomads,
}
::Stronghold.FactionDefs[this.Const.FactionType.Orcs] <- {
	Name = "Орки-мародеры",
	Spawnlist = this.Const.World.Spawn.OrcRaiders,
	Description = "Боевой отряд орков.",
	Footprint = this.Const.World.FootprintsType.Orcs,
}
::Stronghold.FactionDefs[this.Const.FactionType.Zombies] <- {
	Name = "Армия мeртвых",
	Spawnlist = this.Const.World.Spawn.Necromancer,
	Description = "Армия нежити, возглавляемая некромантом.",
	Footprint = this.Const.World.FootprintsType.Undead,
}
::Stronghold.FactionDefs[this.Const.FactionType.NobleHouse] <- {
	Name = "Армия благородного дома",
	Spawnlist = this.Const.World.Spawn.Noble,
	Description = "Армия благородных воинов.",
	Footprint = this.Const.World.FootprintsType.Nobles,
}
::Stronghold.FactionDefs[this.Const.FactionType.OrientalCityState] <- {
	Name = "Городской полк",
	Spawnlist = this.Const.World.Spawn.Southern,
	Description = "Армия солдат благородного дома.",
	Footprint = this.Const.World.FootprintsType.CityState,
}
if (::mods_getRegisteredMod("mod_cultists") != null)
{
    ::Stronghold.FactionDefs[this.Const.FactionType.Cultists] <- {
        Name = "Карательный отряд культистов",
        Spawnlist = this.Const.World.Spawn.CultistDefenders,
        Description = "Карательный отряд культистов вышедший поживиться в новом поселении.",
        Footprint = this.Const.World.FootprintsType.Brigands,
    }
}
if (::mods_getRegisteredMod("mod_warhammer") != null)
{
    ::Stronghold.FactionDefs[this.Const.FactionType.Rat] <- {
        Name = "Армия скавенов",
        Spawnlist = this.Const.World.Spawn.RatDefenders,
        Description = "Армия скавенов в поисках новых мест обитания.",
        Footprint = this.Const.World.FootprintsType.Skavens,
    }
}
if (::mods_getRegisteredMod("mod_jin") != null)
{
    ::Stronghold.FactionDefs[this.Const.FactionType.Jurchen] <- {
        Name = "Армия Чжурчжэней",
        Spawnlist = this.Const.World.Spawn.JurchenDefenders,
        Description = "Армия иноземных захватчиков.",
        Footprint = this.Const.World.FootprintsType.Brigands,
    }
}
if (::mods_getRegisteredMod("mod_mgl") != null)
{
    ::Stronghold.FactionDefs[this.Const.FactionType.Mgl] <- {
        Name = "Отряд Железной Орды",
        Spawnlist = this.Const.World.Spawn.MglDefenders,
        Description = "Орда степных захватчиков.",
        Footprint = this.Const.World.FootprintsType.Brigands,
    }
}
if (::mods_getRegisteredMod("mod_wushi") != null)
{
    ::Stronghold.FactionDefs[this.Const.FactionType.Wushi] <- {
        Name = "Иноземные мародеры",
        Spawnlist = this.Const.World.Spawn.WushiDefenders,
        Description = "Отряд иноземных мародёров.",
        Footprint = this.Const.World.FootprintsType.Brigands,
    }
}
