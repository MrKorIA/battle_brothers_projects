::HordeInvasion.HooksMod.hook("scripts/factions/faction_manager", function(q) {
	// Предикат кризиса «Нашествие Железной Орды»
	q.isHordeInvasion <- { function isHordeInvasion()
	{
		return this.m.GreaterEvil.Type == ::Const.World.GreaterEvilType.Horde && this.m.GreaterEvil.Phase == ::Const.World.GreaterEvilPhase.Live;
	}}.isHordeInvasion;

	// Альянс Jurchen <-> Mgl на время кризиса (паттерн кризиса Зеленокожих)
	q.hordeSetAlliance <- { function hordeSetAlliance( _on )
	{
		local jin = this.getFactionOfType(::Const.FactionType.Jurchen);
		local mgl = this.getFactionOfType(::Const.FactionType.Mgl);
		if (jin == null || mgl == null)
			return;

		if (_on)
		{
			jin.addAlly(mgl.getID());
			mgl.addAlly(jin.getID());
		}
		else
		{
			jin.removeAlly(mgl.getID());
			mgl.removeAlly(jin.getID());
		}
	}}.hordeSetAlliance;

	// Реакции на смену состояния кризиса — наблюдение состояния Greater Evil.
	// ВАЖНО: не оборачиваем updateGreaterEvil для этого — моды вроде mod_useful_pack
	// переписывают его на уровне инстанса, и классовый хук оказался бы в тени. Хук на
	// update (никто не перекрывает) + флаг в World.Statistics.getFlags() (переживает
	// сейвы, защищает от повторного срабатывания после загрузки).
	q.hordeUpdateCrisisState <- { function hordeUpdateCrisisState()
	{
		local GE = this.m.GreaterEvil;
		local flags = this.World.Statistics.getFlags();
		local isLiveHorde = GE.Type == ::Const.World.GreaterEvilType.Horde && GE.Phase == ::Const.World.GreaterEvilPhase.Live;

		if (!flags.get("HordeCrisisActive") && isLiveHorde)
		{
			// Старт Live-фазы: новость + альянс фракций орды
			flags.set("HordeCrisisActive", true);
			this.World.Statistics.addNews("crisis_horde_start", this.World.Statistics.createNews());
			this.hordeSetAlliance(true);
			this.logInfo("HordeInvasion: LIVE started — news 'crisis_horde_start', Jurchen<->Mgl alliance ON");
		}
		else if (flags.get("HordeCrisisActive") && !isLiveHorde)
		{
			// Конец кризиса: игра сбрасывает Type в Random и ставит LastType, но про
			// Орду не знает — дописываем бит TypesUsed, новость (после ванильного
			// clearNews, как у других кризисов) и снимаем альянс
			flags.set("HordeCrisisActive", false);
			GE.TypesUsed = GE.TypesUsed | ::Const.World.GreaterEvilTypeBit.Horde;
			this.World.Statistics.addNews("crisis_horde_end", this.World.Statistics.createNews());
			this.hordeSetAlliance(false);
			this.logInfo("HordeInvasion: crisis ended — news 'crisis_horde_end', TypesUsed bit set, alliance OFF");
		}
	}}.hordeUpdateCrisisState;

	q.update = @(__original) { function update( _ignoreDelay = false )
	{
		__original(_ignoreDelay);
		this.hordeUpdateCrisisState();
	}}.update;
});

// Включение Орды в пул случайного выбора кризиса.
// Через легаси mods_hookNewObject намеренно: моды вроде mod_useful_pack
// (mod_crisis_duration_setting) переписывают updateGreaterEvil на уровне инстанса
// (obj.updateGreaterEvil = ...), и классовый хук оказался бы в тени. Мы грузимся
// после них (см. queue в scripts/!mods_preload/mod_horde_invasion.nut), a хуки
// mods_hookNewObject применяются к инстансу в порядке регистрации — поэтому здесь
// obj.updateGreaterEvil уже их реализация, и мы оборачиваем именно её. Без них —
// ванильную.
// Порог силы отряда здесь намеренно не проверяем: выбранный тип ждёт перехода
// Warning столько, сколько требует реализация таймеров (vanilla 160 / настройки
// мода-замены), — как при явном выборе игроком.
::mods_hookNewObject("factions/faction_manager", function(obj) {
	local horde_updateGreaterEvil = obj.updateGreaterEvil;
	obj.updateGreaterEvil = function()
	{
		local GE = this.m.GreaterEvil;

		// Зеркалим условия момента случайного выбора типа кризиса и резервируем
		// Орде один слот с тем же шансом, что и у ванильных кризисов
		if (GE.Type == ::Const.World.GreaterEvilType.Random
			&& GE.Phase == ::Const.World.GreaterEvilPhase.NotSet
			&& GE.NextPhaseTime != 0.0 && GE.NextPhaseTime <= ::Time.getVirtualTimeF()
			&& (GE.TypesUsed & ::Const.World.GreaterEvilTypeBit.Horde) == 0)
		{
			local possibilities = 3; // Greenskins, Undead + Horde
			if (this.isNoblesFeuding())
				possibilities += 1; // CivilWar
			if (::Const.DLC.Desert && this.isCityStateExisting() && this.isNoblesFeuding())
				possibilities += 1; // HolyWar

			if (::Math.rand(0, possibilities - 1) == 0)
				GE.Type = ::Const.World.GreaterEvilType.Horde;
		}

		horde_updateGreaterEvil();
	};
});
