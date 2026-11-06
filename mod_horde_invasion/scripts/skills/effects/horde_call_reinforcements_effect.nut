// Скрытый эффект «сотника гарнизона» контракта «Порох орды».
// Каждые 3 хода владельца призывает подкрепления с восточного края карты
// (образец — zmod_davkul_rising-russian/scripts/skills/actives/summon_reinforcements_skill.nut).
// Эффект, а не активный скилл: срабатывает детерминированно в onTurnEnd, не зависит от AI-агента.
this.horde_call_reinforcements_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2
	},
	function create()
	{
		this.m.ID = "effects.horde_call_reinforcements";
		this.m.Name = "Сигнал подкреплению";
		this.m.Description = "";
		this.m.Icon = "";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsHidden = true;
		this.m.IsActive = false;
		this.m.IsStacking = false;
	}

	function onTurnEnd()
	{
		this.m.TurnsLeft = this.m.TurnsLeft - 1;

		if (this.m.TurnsLeft > 0)
		{
			return;
		}

		this.m.TurnsLeft = 3;

		local user = this.getContainer().getActor();

		if (!user.isAlive() || user.isDying() || this.Tactical.Entities.isEnemyRetreating())
		{
			return;
		}

		local faction = user.getFaction();

		if (this.Tactical.Entities.getInstancesOfFaction(faction).len() >= 25)
		{
			return;
		}

		local numSummons = 3;
		local tileArray = [];
		local size = this.Tactical.getMapSize();

		// восточный край карты, за спинами гарнизона (линия врага — x 19..24)
		for( local x = size.X - 5; x < size.X - 1; x = ++x )
		{
			for( local y = 6; y < size.Y - 6; y = ++y )
			{
				if (!this.Tactical.isValidTileSquare(x, y))
				{
					continue;
				}

				tileArray.push(this.Tactical.getTileSquare(x, y));
			}
		}

		local spawnTiles = [];

		while (tileArray.len() > 0)
		{
			local idx = this.Math.rand(0, tileArray.len() - 1);
			local startTile = tileArray.remove(idx);

			if (!startTile.IsEmpty || startTile.IsVisibleForPlayer)
			{
				continue;
			}

			spawnTiles = [startTile];

			for( local i = 0; i < 6; i = ++i )
			{
				if (startTile.hasNextTile(i))
				{
					local nextTile = startTile.getNextTile(i);

					if (nextTile.IsEmpty && !nextTile.IsVisibleForPlayer)
					{
						spawnTiles.push(nextTile);
					}
				}
			}

			if (spawnTiles.len() >= numSummons)
			{
				break;
			}
		}

		if (spawnTiles.len() < numSummons)
		{
			return;
		}

		local scripts = [
			"scripts/entity/tactical/humans/nomad_ironpagoda",
			"scripts/entity/tactical/humans/nomad_ironpagoda",
			"scripts/entity/tactical/humans/nomad_fireblunderbuss"
		];

		for( local i = 0; i < numSummons; i = ++i )
		{
			local spawn = this.Tactical.spawnEntity(scripts[this.Math.rand(0, scripts.len() - 1)], spawnTiles[i].Coords);
			spawn.setFaction(faction);
			spawn.assignRandomEquipment();
		}

		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " подаёт сигнал — со стороны лагеря прибывает подкрепление!");
	}

});
