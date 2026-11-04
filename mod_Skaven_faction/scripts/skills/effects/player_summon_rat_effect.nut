this.player_summon_rat_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 4
	},
	function create()
	{
		this.m.ID = "effects.player_summon_rat";
		this.m.Name = "Зов скавенов";
		this.m.Icon = "skills/summon_rat_effect_01.png";
		this.m.IconMini = "summon_rat_effect_01_mini";
		this.m.Overlay = "";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Этот навык восстановится через [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.TurnsLeft + "[/color] ход(ов).";
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		local candidates = [];
		local myTile = actor.getTile();

        for( local i = 0; i < 6; i = ++i )
        {
            if (!myTile.hasNextTile(i))
            {
            }
            else
            {
                local nextTile = myTile.getNextTile(i);

                if (nextTile.IsEmpty && this.Math.abs(myTile.Level - nextTile.Level) <= 1)
                {
                    candidates.push(nextTile);
                }
            }
        }

        if (candidates.len() != 0)
        {
            local spawnTile = candidates[this.Math.rand(0, candidates.len() - 1)];
            local sapling = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/player_ratswarm", spawnTile.Coords);
            sapling.setFaction(actor.getFaction() == this.Const.Faction.Player ? this.Const.Faction.PlayerAnimals : actor.getFaction());
            sapling.riseFromGround();

            for( local i = 0; i < this.Const.Tactical.PlagueParticles.len(); i = ++i )
            {
                this.Tactical.spawnParticleEffect(true, this.Const.Tactical.RaiseFromGroundParticles[i].Brushes, spawnTile, this.Const.Tactical.RaiseFromGroundParticles[i].Delay, this.Const.Tactical.RaiseFromGroundParticles[i].Quantity, this.Const.Tactical.RaiseFromGroundParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseFromGroundParticles[i].SpawnRate, this.Const.Tactical.RaiseFromGroundParticles[i].Stages);
            }
        }

	}

	function onTurnStart()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});

