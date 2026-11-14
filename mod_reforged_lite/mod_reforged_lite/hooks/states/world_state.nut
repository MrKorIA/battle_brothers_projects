// Охотники за головами + набеги на пристройки (порт из mod_hardened)
::ReforgedLite.HooksMod.hook("scripts/states/world_state", function(q) {
	// Private
	q.m.HD_ForceRaidTarget <- null;	// WeakRef на raidable-пристройку, выбранную атакующим кликом (Ctrl+ЛКМ, или ЛКМ по враждебной)

	// Охотники за головами: список отрядов хранится в World.Flags — пишем его ДО ванильной
	// сериализации (флаги пишутся внутри __original)
	q.onSerialize = @(__original) function( _out )
	{
		::World.EntityManager.m.HD_BountyHunterManager.onSerialize();

		__original(_out);
	}

	// Набеги: атакующий клик (только button-события, не драг) по raidable-пристройке помечает
	// её целью — по аналогии с ванильным AutoAttack партий. Ctrl+ЛКМ по союзной пристройке
	// (курсор атаки с Ctrl рисует хук updateCursorAndTooltip), или обычный ЛКМ, если владеющий
	// город и так враждебен.
	q.onMouseInput = @(__original) function( _mouse )
	{
		if (_mouse.getID() != 6 && _mouse.getID() != 7 && _mouse.getState() == 1 && !this.m.WasInCameraMovementMode)
		{
			this.m.HD_ForceRaidTarget = null;	// цель пересматривается каждым кликом

			if (!this.World.Assets.isCamping())
			{
				local entities = this.World.getAllEntitiesAndOneLocationAtPos(this.World.getCamera().screenToWorld(_mouse.getX(), _mouse.getY()), 1.0);

				foreach (entity in entities)
				{
					if (entity.getID() == this.m.Player.getID()) continue;
					if (!entity.isLocation()) continue;
					if (!entity.isLocationType(::Const.World.LocationType.AttachedLocation)) continue;
					if (!entity.isRaidable() || !entity.isActive()) continue;

					local forceAttack = this.m.IsForcingAttack && this.World.Contracts.getActiveContract() == null;
					if (!forceAttack && entity.isAlliedWithPlayer()) continue;

					this.m.HD_ForceRaidTarget = this.WeakTableRef(entity);
					::logInfo("RFL-DBG: raid target set: " + entity.getName() + " (faction " + entity.getFaction() + ")");
					break;
				}
			}
		}

		local ret = __original(_mouse);

		// Флаг живёт, пока ваниль ведёт отряд к этой локации (AutoEnterLocation): события мыши
		// с зажатой кнопкой/клики в другое место сбрасывают цель вместе с ним
		if (this.m.HD_ForceRaidTarget != null && !this.m.HD_ForceRaidTarget.isNull())
		{
			if (this.m.AutoEnterLocation == null || this.m.AutoEnterLocation.isNull() || this.m.AutoEnterLocation.getID() != this.m.HD_ForceRaidTarget.getID())
			{
				this.m.HD_ForceRaidTarget = null;
			}
		}

		return ret;
	}

	// Набеги: enterLocation — точка входа при прибытии (и при клике на тот же тайл).
	// Помеченная цель → диалог боя (как у ванильных враждебных локаций). Обычный клик по
	// союзной raidable-пристройке ничего не делает (миссклик без последствий). Ваниль пускает
	// бой с локацией только с не-союзной, поэтому союзную временно метим ванильным
	// setIsTemporaryEnemy(true) — сброс делает ванильная faction_manager.onCombatFinished
	// (после боя и при отмене диалога).
	q.enterLocation = @(__original) function( _location )
	{
		if (_location.isLocationType(::Const.World.LocationType.AttachedLocation) && _location.isRaidable())
		{
			local raidRequested = false;
			if (this.m.HD_ForceRaidTarget != null && !this.m.HD_ForceRaidTarget.isNull() && this.m.HD_ForceRaidTarget.getID() == _location.getID())
			{
				raidRequested = true;
			}
			this.m.HD_ForceRaidTarget = null;
			::logInfo("RFL-DBG: enterLocation " + _location.getName() + " raidRequested=" + raidRequested + " faction=" + _location.getFaction() + " attackable=" + _location.isAttackable() + " active=" + _location.isActive());

			if (raidRequested && _location.isActive() && this.m.CombatProperties == null)
			{
				if (_location.isAlliedWithPlayer())
				{
					local faction = ::World.FactionManager.getFaction(_location.getFaction());
					if (faction != null) faction.setIsTemporaryEnemy(true);
				}

				if (!this.isPaused())
				{
					this.setNormalTime();
				}

				this.m.Player.setDestination(null);
				this.m.Player.setPath(null);
				this.m.AutoEnterLocation = null;
				this.m.LastEnteredLocation = this.WeakTableRef(_location);
				this.m.IsRunningUpdatesWhilePaused = false;

				if (_location.onEnter())
				{
					if (_location.onEnteringCombatWithPlayer())
					{
						this.showCombatDialog();
					}
				}
				return true;
			}

			if (_location.isAlliedWithPlayer())
			{
				// Союзная пристройка без атакующего клика: без диалога и боя.
				// Ванильная enterLocation чистит AutoEnterLocation в своём начале — повторяем,
				// иначе цикл прибытия будет звать enterLocation каждый тик
				this.m.AutoEnterLocation = null;
				return false;
			}
		}

		return __original(_location);
	}

	// Набеги: курсор атаки над союзной raidable-пристройкой с зажатым Ctrl (по аналогии
	// с ванильным поведением над союзными партиями)
	q.updateCursorAndTooltip = @(__original) function()
	{
		__original();

		if (!this.m.IsForcingAttack || this.World.Contracts.getActiveContract() != null) return;

		local hovered = this.m.LastEntityHovered;
		if (hovered == null) return;
		if (!hovered.isLocation()) return;
		if (!hovered.isLocationType(::Const.World.LocationType.AttachedLocation)) return;
		if (!hovered.isRaidable() || !hovered.isActive()) return;
		if (!hovered.isAlliedWithPlayer()) return;	// враждебную ваниль уже рисует сама

		this.Cursor.setCursor(this.Const.UI.Cursor.Attack);
	}
});
