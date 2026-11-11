// Скрытый эффект гарнизона склада контракта «Порох орды».
// Призывает подкрепления с восточного края карты (образец —
// zmod_davkul_rising-russian/scripts/skills/actives/summon_reinforcements_skill.nut).
// Эффект, а не активный скилл: срабатывает детерминированно в onTurnEnd, не зависит
// от AI-агента. Висит на КАЖДОМ бойце гарнизона, но волна идёт раз в 3 раунда
// на всё поле — общий гейт в TempFlags активного контракта: первый сработавший
// хозяин закрывает гейт на 3 раунда, остальные молча выходят. Волны растут
// (3 → 6 → 12 → 24 → 32, потолок 32) — оставить бочки и фармить
// подкрепления невыгодно.
this.horde_call_reinforcements_effect <- this.inherit("scripts/skills/skill", {
	m = {},
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
		local user = this.getContainer().getActor();

		if (!user.isAlive() || user.isDying() || this.Tactical.Entities.isEnemyRetreating())
		{
			return;
		}

		local faction = user.getFaction();

		if (this.Tactical.Entities.getInstancesOfFaction(faction).len() >= 40)
		{
			return;
		}

		local contract = this.World.Contracts.getActiveContract();

		if (contract == null)
		{
			return;
		}

		local round = this.Time.getRound();

		if (contract.m.TempFlags.get("HordeReinfNextRound") > round)
		{
			return;
		}

		// волна растёт: 3, 6, 12, 24, далее 32 (потолок)
		local wave = contract.m.TempFlags.get("HordeReinfWave");
		local numSummons = this.Math.min(3 * this.Math.pow(2, wave), 32);

		// площадка призыва — восточный край карты, за спинами гарнизона
		local size = this.Tactical.getMapSize();
		local centerX = size.X - 4;
		local centerY = this.Math.rand(8, size.Y - 8);
		local tiles = [];

		for( local x = centerX - 3; x <= size.X - 2; x = ++x )
		{
			for( local y = centerY - 5; y <= centerY + 5; y = ++y )
			{
				if (!this.Tactical.isValidTileSquare(x, y))
				{
					continue;
				}

				local t = this.Tactical.getTileSquare(x, y);

				if (t.IsEmpty && !t.IsVisibleForPlayer)
				{
					tiles.push(t);
				}
			}
		}

		if (tiles.len() < numSummons)
		{
			// площадки не хватило — волна не выходит, гейт не тратим
			return;
		}

		// волна выходит: закрываем гейт на 3 раунда и двигаем счётчик
		contract.m.TempFlags.set("HordeReinfNextRound", round + 3);
		contract.m.TempFlags.set("HordeReinfWave", wave + 1);

		local scripts = [
			"scripts/entity/tactical/humans/nomad_ironpagoda",
			"scripts/entity/tactical/humans/nomad_ironpagoda",
			"scripts/entity/tactical/humans/nomad_fireblunderbuss"
		];

		for( local i = 0; i < numSummons; i = ++i )
		{
			local t = tiles.remove(this.Math.rand(0, tiles.len() - 1));
			local spawn = this.Tactical.spawnEntity(scripts[this.Math.rand(0, scripts.len() - 1)], t.Coords);
			spawn.setFaction(faction);
			spawn.assignRandomEquipment();
			// новички тоже зовут следующие волны: пока жив хоть один боец орды,
			// склад не остаётся без подкреплений (волна всё равно одна на всех —
			// общий гейт по раундам)
			spawn.getSkills().add(this.new("scripts/skills/effects/horde_call_reinforcements_effect"));
		}

		if (("ClassName" in user) && user.ClassName == "barrel_of_gunpowder")
		{
			this.Tactical.EventLog.log("Со стороны лагеря прибывает очередное подкрепление орды!");
		}
		else
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " подаёт сигнал — со стороны лагеря прибывает подкрепление!");
		}
	}

});
