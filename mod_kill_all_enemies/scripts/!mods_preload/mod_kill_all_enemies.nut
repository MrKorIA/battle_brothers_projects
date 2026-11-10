::KillAllEnemies <- {
	ID = "mod_kill_all_enemies",
	Name = "Kill All Enemies (test)",
	Version = "1.0.0"
}
::KillAllEnemies.HooksMod <- ::Hooks.register(::KillAllEnemies.ID, ::KillAllEnemies.Version, ::KillAllEnemies.Name);
::KillAllEnemies.HooksMod.require(["mod_msu"]);

::KillAllEnemies.HooksMod.queue(">mod_msu", function() {
	::KillAllEnemies.Mod <- ::MSU.Class.Mod(::KillAllEnemies.ID, ::KillAllEnemies.Version, ::KillAllEnemies.Name);

	// Тестовый чит: хоткей мгновенно убивает всех врагов на тактической карте.
	// Кейбинд MSU — переназначается в настройках модов (стр. «Горячие клавиши» мода).
	::KillAllEnemies.Mod.Keybinds.addSQKeybind("KillAllEnemies", "ctrl+k", ::MSU.Key.State.Tactical, function()
	{
		if (this.isBattleEnded() || this.m.CharacterScreen.isVisible() || this.Tactical.getNavigator().IsTravelling)
			return false;

		local kills = 0;
		foreach (faction in this.Tactical.Entities.getAllInstances())
		{
			foreach (entity in faction)
			{
				if (this.isKindOf(entity, "actor") && entity.isAlive() && !entity.isAlliedWithPlayer())
				{
					if (entity == this.Tactical.TurnSequenceBar.getActiveEntity())
						this.cancelEntityPath(entity);
					entity.kill(null, null, this.Const.FatalityType.None, true);
					kills++;
				}
			}
		}
		this.logInfo("KillAllEnemies: убито врагов — " + kills);
		return true;
	}, "Убить всех врагов", null, "Мгновенно убивает всех врагов на тактической карте (союзники не трогаются). Тестовый инструмент.");
});
