::mods_hookExactClass("skills/actives/release_falcon_skill", function (cls) {
    // TODO: fix tooltip and make true 0 AP
    local onUse = cls.onUse;
    cls.onUse = function (_user, _targetTile) {
        m.Item.setReleased(true);

        if (getContainer().hasSkill("background.hackflows_falconer")) {
            Tactical.queryTilesInRange(_user.getTile(), 1, 16, false, [], onQueryTile, _user.getFaction());
            _user.setActionPoints(_user.getActionPoints() + m.ActionPointCost);
        } else {
            Tactical.queryTilesInRange(_user.getTile(), 1, 12, false, [], onQueryTile, _user.getFaction());
        }

        if (Tactical.TurnSequenceBar.getActiveEntity() != null) {
            Tactical.TurnSequenceBar.getActiveEntity().updateVisibilityForFaction();
        }

        return true;
    }
})

