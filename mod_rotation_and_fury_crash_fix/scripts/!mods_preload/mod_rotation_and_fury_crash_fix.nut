::RotationAndFuryCrashFix <- {
	ID = "mod_rotation_and_fury_crash_fix",
	Name = "Rotation and Fury Crash Fix",
	Version = "1.0.0"
}
::RotationAndFuryCrashFix.HooksMod <- ::Hooks.register(::RotationAndFuryCrashFix.ID, ::RotationAndFuryCrashFix.Version, ::RotationAndFuryCrashFix.Name);
::RotationAndFuryCrashFix.HooksMod.require(["mod_msu"]);

::RotationAndFuryCrashFix.HooksMod.queue(">mod_msu", function() {
	::RotationAndFuryCrashFix.Mod <- ::MSU.Class.Mod(::RotationAndFuryCrashFix.ID, ::RotationAndFuryCrashFix.Version, ::RotationAndFuryCrashFix.Name);

	local isRussianLanguage = false;

    if ("Const" in ::getroottable() && "Credits" in ::Const)
    {
        local creditsText = ::Const.Credits;
        if (typeof creditsText == "string" && creditsText.len() >= 2 && creditsText.slice(0, 2) == "Б")
        {
            isRussianLanguage = true;
        }
    }

    local namePage = isRussianLanguage ? "Основное" : "General";
    local rotationSetting = isRussianLanguage ? "Навык \'Ротация\'" : "Skill \'Rotation\'";
    local furySetting = isRussianLanguage ? "Навык \'Варварская ярость\'" : "Skill \'Barbarian Fury\'";

	local page = ::RotationAndFuryCrashFix.Mod.ModSettings.addPage("Основное");

	page.addEnumSetting("RotationSetting", "Enemy", ["All", "Enemy", "Off"], rotationSetting);
	page.addEnumSetting("FurySetting", "Enemy", ["Enemy", "Off"], furySetting);

	::RotationAndFuryCrashFix.isValidTile <- function( _entity, _tile ) {
        if (_tile != null && _tile.IsEmpty && _tile.Properties.Effect == null && _tile.getEntity() == null)
        {
            for (local d = 0; d <= 5; ++d) {
				if (_tile.hasNextTile(d))
				{
                    local tileEntity = _tile.getNextTile(d).getEntity();
				    if (tileEntity != null && tileEntity.getFaction() != _entity.getFaction())
				        return false;
				}
            }
            return true;
        }
        return false;
	}

	::RotationAndFuryCrashFix.findFakeTile <- function( _entity, _tile ) {
        local x = _tile.SquareCoords.X;
        local y = _tile.SquareCoords.Y;
        local tile;
        local i = 0;

        for (local rx = 1; rx <= 6; ++rx) {
            tile = ::Tactical.getTileSquare(x+rx, y);
            if (::RotationAndFuryCrashFix.isValidTile(_entity, tile))
                return tile;
            tile = ::Tactical.getTileSquare(x-rx, y);
            if (::RotationAndFuryCrashFix.isValidTile(_entity, tile))
                return tile;
            for (local ry = i; ry < rx + 1; ++ry) {
                tile = ::Tactical.getTileSquare(x, y+ry);
                if (::RotationAndFuryCrashFix.isValidTile(_entity, tile))
                    return tile;
                tile = ::Tactical.getTileSquare(x, y-ry);
                if (::RotationAndFuryCrashFix.isValidTile(_entity, tile))
                    return tile;
                tile = ::Tactical.getTileSquare(x+rx, y+ry);
                if (::RotationAndFuryCrashFix.isValidTile(_entity, tile))
                    return tile;
                tile = ::Tactical.getTileSquare(x-rx, y-ry);
                if (::RotationAndFuryCrashFix.isValidTile(_entity, tile))
                    return tile;
            }
            i = rx;
        }
        ::logWarning("RotationAndFuryCrashFix: not found valid tile!");
        return ::Tactical.getTileSquare(1, 1);
	}

	::RotationAndFuryCrashFix.HooksMod.hook("scripts/skills/actives/barbarian_fury_skill", function (q)
    {
        q.onUse = @(__original) { function onUse( _user, _targetTile )
        {
            local getMySettingValue = @(_id) ::RotationAndFuryCrashFix.Mod.ModSettings.getSetting(_id).getValue();
            if (getMySettingValue("FurySetting") == "Off")
            {
                return __original(_user, _targetTile);
            }
            if (_user.getFaction() == this.Const.Faction.Player && getMySettingValue("FurySetting") == "Enemy")
            {
                return __original(_user, _targetTile);
            }
            this.m.IsSpent = true;

            local target = _targetTile.getEntity();
            local userTile = _user.getTile();
            local tag = {
                User = _user,
                Target = target,
                UserTile = _user.getTile(),
                TargetTile = _targetTile,
                TargetAlpha = target.getSprite("body").Alpha
            };
            target.setAlpha(0);
		    target.setDirty(true);
            this.Tactical.getNavigator().teleport(target, ::RotationAndFuryCrashFix.findFakeTile(target, _targetTile), this.onUseFakeTeleportDone.bindenv(this), tag, false, 0.0);

            return true;
        }}.onUse;

        q.onUseFakeTeleportDone <- function( _entity, _tag )
        {
            this.Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, this.onUseTeleportDone.bindenv(this), _tag, false);
        }

        q.onUseTeleportDone <- function( _entity, _tag )
        {
            _tag.Target.setAlpha(_tag.TargetAlpha);
            _tag.Target.setDirty(true);
            this.Tactical.getNavigator().teleport(_tag.Target, _tag.UserTile, null, null, false, 0.0);
        }
    });

	::RotationAndFuryCrashFix.HooksMod.hook("scripts/skills/actives/rotation", function (q)
    {
        q.onUse = @(__original) { function onUse( _user, _targetTile )
        {
            local getMySettingValue = @(_id) ::RotationAndFuryCrashFix.Mod.ModSettings.getSetting(_id).getValue();
            if (getMySettingValue("RotationSetting") == "Off")
            {
                return __original(_user, _targetTile);
            }
            if (_user.getFaction() == this.Const.Faction.Player && getMySettingValue("RotationSetting") == "Enemy")
            {
                return __original(_user, _targetTile);
            }

            local target = _targetTile.getEntity();
            local userTile = _user.getTile();
            local tag = {
                User = _user,
                Target = target,
                UserTile = _user.getTile(),
                TargetTile = _targetTile,
                TargetAlpha = target.getSprite("body").Alpha
            };
            target.setAlpha(0);
            target.setDirty(true);

            this.Tactical.getNavigator().teleport(target, ::RotationAndFuryCrashFix.findFakeTile(target, _targetTile), this.onUseFakeTeleportDone.bindenv(this), tag, false, 0.0);

            return true;
        }}.onUse;

        q.onUseFakeTeleportDone <- function( _entity, _tag )
        {
            this.Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, this.onUseTeleportDone.bindenv(this), _tag, false);
        }

        q.onUseTeleportDone <- function( _entity, _tag )
        {
            _tag.Target.setAlpha(_tag.TargetAlpha);
            _tag.Target.setDirty(true);
            this.Tactical.getNavigator().teleport(_tag.Target, _tag.UserTile, null, null, false, 0.0);
        }
    });

});

