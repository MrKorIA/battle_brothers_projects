::TheRedCourt.HooksMod.hook("scripts/entity/world/locations/legendary/black_monolith_location", function(q) {

    q.onSpawned = @(__original) function()
    {
        __original(); // let the old function run

        if (this.World.Assets.getOrigin().getID() == "scenario.hemovores_avatar")
        {
            local tilePos = this.getTile().Pos;
            this.World.State.getPlayer().setPos(tilePos);
            this.World.setPlayerPos(tilePos);
            this.World.getCamera().setPos(tilePos);
            this.onDiscovered();
        }
    }
});