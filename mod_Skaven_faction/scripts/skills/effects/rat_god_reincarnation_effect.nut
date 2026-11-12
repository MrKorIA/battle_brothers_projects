// Скрытый эффект цепочки «Повелители тварей»: вешается ТОЛЬКО на экземпляров
// rat_god_01 и rat_god_02, заспавненных событием входа в Гнездо Рогатой Крысы
// (scripts/events/events/rat_god_camp_enter_event.nut). После гибели носителя
// с восточного края карты выходит подкрепление во главе со следующей стадией:
// rat_god_01 → rat_god_02 → rat_god_03. Синхронный спавн из onDeath —
// ванильный прецедент: scripts/entity/tactical/enemies/ghoul.nut (выплёвывание
// проглоченной цели в onDeath через addEntityToMap).
this.rat_god_reincarnation_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Stage = 1
	},
	function create()
	{
		this.m.ID = "effects.rat_god_reincarnation";
		this.m.Name = "Зов туннелей";
		this.m.Description = "";
		this.m.Icon = "";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsHidden = true;
		this.m.IsActive = false;
		this.m.IsStacking = false;
	}

	function onDeath( _fatalityType )
	{
		if (this.Tactical.State.isScenarioMode())
		{
			return;
		}

		if (this.Tactical.Entities.isEnemyRetreating())
		{
			return;
		}

		local god;
		local wave = [];

		if (this.m.Stage == 1)
		{
			god = "scripts/entity/tactical/enemies/rat_god_02";
			wave = [
				"scripts/entity/tactical/enemies/rat_warrior",
				"scripts/entity/tactical/enemies/rat_warrior",
				"scripts/entity/tactical/enemies/rat_warrior",
				"scripts/entity/tactical/enemies/rat_clanrat",
				"scripts/entity/tactical/enemies/rat_clanrat",
				"scripts/entity/tactical/enemies/rat_banner_men"
			];
		}
		else if (this.m.Stage == 2)
		{
			god = "scripts/entity/tactical/enemies/rat_god_03";
			wave = [
				"scripts/entity/tactical/enemies/rat_warrior",
				"scripts/entity/tactical/enemies/rat_warrior",
				"scripts/entity/tactical/enemies/rat_warrior",
				"scripts/entity/tactical/enemies/rat_warrior",
				"scripts/entity/tactical/enemies/rat_assassin",
				"scripts/entity/tactical/enemies/rat_monk",
				"scripts/entity/tactical/enemies/rat_banner_men"
			];
		}
		else
		{
			return;
		}

		// площадка призыва — восточный край карты (образец сбора тайлов —
		// horde_call_reinforcements_effect): свободные тайлы вне видимости игрока
		local faction = this.getContainer().getActor().getFaction();
		local size = this.Tactical.getMapSize();
		local tiles = [];

		for (local x = size.X - 6; x <= size.X - 2; x = ++x)
		{
			for (local y = 6; y <= size.Y - 6; y = ++y)
			{
				if (!this.Tactical.isValidTileSquare(x, y))
				{
					continue;
				}

				local t = this.Tactical.getTileSquare(x, y);

				if (t.IsEmpty && !t.IsOccupiedByActor && !t.IsVisibleForPlayer)
				{
					tiles.push(t);
				}
			}
		}

		if (tiles.len() == 0)
		{
			return;
		}

		local scripts = [god];
		scripts.extend(wave);

		foreach (script in scripts)
		{
			if (tiles.len() == 0)
			{
				break;
			}

			local t = tiles.remove(this.Math.rand(0, tiles.len() - 1));
			local spawn = this.Tactical.spawnEntity(script, t.Coords);
			spawn.setFaction(faction);
			spawn.assignRandomEquipment();

			// следующая стадия несёт в себе тот же зов — кроме финального бога
			if (script == god && this.m.Stage == 1)
			{
				local nextStage = this.new("scripts/skills/effects/rat_god_reincarnation_effect");
				nextStage.m.Stage = 2;
				spawn.getSkills().add(nextStage);
			}
		}

		if (this.m.Stage == 1)
		{
			this.Tactical.EventLog.log("Из варп-туннелей вырывается Повелитель тварей — и за ним лезут всё новые полчища!");
		}
		else
		{
			this.Tactical.EventLog.log("Земля дрожит: из глубин выходит последний из Повелителей тварей, обманщик, а вокруг него стынет воздух!");
		}
	}

});
