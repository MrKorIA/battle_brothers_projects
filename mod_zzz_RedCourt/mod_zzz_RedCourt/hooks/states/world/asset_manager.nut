::TheRedCourt.HooksMod.hook("scripts/states/world/asset_manager", function(q) {

    q.updateLook = @(__original) function (_updateTo = -1) {
        if (this.World.Assets.getOrigin().getID() == "scenario.hemovores")
            this.World.State.getPlayer().getSprite("body").setBrush("figure_vampire_01");
        else if (this.World.Assets.getOrigin().getID() == "scenario.hemovores_avatar")
            this.World.State.getPlayer().getSprite("body").setBrush("figure_vampire_02");
        else
            __original(_updateTo);
    }

    q.update = @(__original) function(_worldState) {
        if (this.World.getTime().Days > this.m.LastDayPaid && this.World.getTime().Hours > 8 && this.m.IsConsumingAssets)
        {
            local items = this.World.Assets.getStash().getItems();
            foreach (item in items)
            {
                if (item == null)
                {
                    continue;
                }

                if (item.getID() != "spawns.zombie")
                {
                    continue;
                }

                item.m.Timer -= 1;
                if (item.m.Timer < 1)
                    this.World.Assets.getStash().remove(item);
            }
        }
        __original(_worldState);
    }
});