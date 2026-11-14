// Набеги на пристройки (порт из mod_hardened, api/hooks_early + hooks_early объединены).
// IsRaidable — пристройку можно атаковать и временно разрушить, даже если она союзная;
// GoesIntoLockdown — пристройка закрыта, пока у поселения ситуация "Набеги";
// автодетект: производственная пристройка (с продукцией) становится raidable
// с защитниками-крестьянами/ополчением.
::ReforgedLite.HooksMod.hook("scripts/entity/world/attached_location", function(q) {
	q.m.IsRaidable <- false;						// Hardened-поле
	q.m.GoesIntoLockdown <- false;					// Hardened-поле
	q.m.IsAutoDetectedRaidableLocation <- false;	// Hardened-поле: raidable определён автоматически

	// Feat: развалины показывают исходное имя
	q.getName = @(__original) function()
	{
		if (this.isActive()) return __original();
		return this.world_entity.getName() + " (Развалины)";
	}

	// Feat: тултип показывает состав защитников (через временную "не-союзность") и продукцию
	q.getTooltip = @(__original) function()
	{
		local ret;
		if (this.isRaidable())
		{
			this.m.HD_IsTemporaryUnallied = true;
			ret = __original();
			this.m.HD_IsTemporaryUnallied = false;
		}
		else
		{
			ret = __original();
		}

		local childrenElements = [];
		local childrenId = 41;
		foreach (produce in this.getProduceList())
		{
			local item = ::new("scripts/items/" + produce);
			childrenElements.push({
				id = childrenId,
				type = "text",
				icon = "ui/items/" + item.getIcon(),
				text = item.getName(),
			});
			++childrenId;
		}

		if (childrenElements.len() != 0)
		{
			ret.push({
				id = 40,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Производит:",
				children = childrenElements,
			});
		}

		if (this.isActive() && this.isInLockdown())
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/locked_small.png",
				text = "Заблокирован набегами — атаковать нельзя",
			});
		}

		return ret;
	}

	// Feat: восстановленная пристройка перебрасывает именной лут; разрушенная — теряет защитников.
	// Feat (Hardened): смена CombatSeed меняет тактическую карту пристройки.
	q.setActive = @(__original) function( _active )
	{
		if (!this.isActive() && _active && !::MSU.Serialization.isLoading())	// при десериализации не перебрасываем
		{
			this.m.Loot.clear();
			this.onSpawned();
		}
		else if (!_active)
		{
			this.clearTroops();
		}

		__original(_active);

		if (_active)
		{
			this.m.CombatSeed = ::Math.rand();
		}

		if (this.isRaidable())
		{
			this.m.IsSpawningDefenders = _active;
			this.m.IsAttackable = _active;
			this.getSprite("location_banner").Visible = this.m.IsShowingBanner && _active;
		}
	}

	// Победа над raidable-пристройкой: временно разрушаем её и вводим статус "Набеги"
	q.onCombatLost = @(__original) function()
	{
		__original();

		if (this.isRaidable())
		{
			this.setActive(false);

			if (!this.getSettlement().hasSituation("situation.raided"))
			{
				this.getSettlement().addSituation(::new("scripts/entity/world/settlements/situations/raided_situation"));
			}
		}
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);

		// Восстановление raidable-состояния после загрузки сейва: create() при десериализации
		// не вызывается, а ваниль не сериализует наши поля — перепроводим автодетект
		if (!this.isRaidable()) this.autodetectRaidableCivilians();

		if (this.isRaidable())
		{
			// Базовый класс attached_location всегда сбрасывает это в false при десериализации
			this.setAttackable(this.isActive());
			this.HD_ensureRaidFaction();

			// Fix: setSettlement (вызывается при десериализации) гоняет onSpawned, который
			// докидывает именной лут — при повторных загрузках лут накапливался. Стабилизируем.
			if (this.m.Loot.len() > 2)
			{
				this.m.Loot.clear();
				this.onSpawned();
			}
		}
	}

	// Vanilla fix: ваниль не вызывает onSpawned для пристроек; они всегда сразу привязываются
	// к поселению — вызываем вручную
	q.setSettlement = @(__original) function( _settlement )
	{
		__original(_settlement);

		this.onSpawned();
		this.HD_ensureRaidFaction();
	}

	q.isAttackable = @(__original) function()
	{
		if (this.isInLockdown()) return false;

		return __original();
	}

	// Лут автодетект-пристройки: крестьяне сами дропают припасы/еду, добавляем краски и продукцию
	q.onDropLootForPlayer = @(__original) function( _lootTable )
	{
		__original(_lootTable);

		if (this.m.IsAutoDetectedRaidableLocation)
		{
			local paintList = [
				"misc/paint_remover_item",
				"misc/paint_black_item",
				"misc/paint_red_item",
				"misc/paint_orange_red_item",
				"misc/paint_white_blue_item",
				"misc/paint_white_green_yellow_item",
			];
			this.dropTreasure(1, paintList, _lootTable);

			local produce = this.getProduceList();
			this.dropTreasure(::Math.rand(1, 2), produce, _lootTable);
		}
	}

	// Автодетект: выбор северного/южного списка защитников культурой поселения
	// (список ставится в create, когда поселение ещё неизвестно — откладываем до спавна защитников)
	q.createDefenders = @(__original) function()
	{
		if (this.m.IsAutoDetectedRaidableLocation && this.getSettlement() != null && !this.getSettlement().isNull())
		{
			this.m.DefenderSpawnList = this.getSettlement().isSouthern() ? ::Const.World.Spawn.HD_AttachedProductionSouthern : ::Const.World.Spawn.HD_AttachedProduction;
		}

		__original();
	}

// Новые функции
	q.isRaidable <- function()
	{
		return this.m.IsRaidable;
	}

	// Vanilla fix: фракция пристройкам раздаётся только settlement.addFaction (faction.nut:378)
	// и только среди УЖЕ существующих пристроек — позднестроящиеся остаются с фракцией 0.
	// Без фракции ваниль молча пропускает локацию в showCombatDialog/getLocalCombatProperties
	// (getFaction() == 0 → continue) — бой невозможен вообще. Гарантируем фракцию поселения.
	q.HD_ensureRaidFaction <- function()
	{
		if (!this.isRaidable()) return;
		if (this.getFaction() != 0) return;
		if (this.getSettlement() == null || this.getSettlement().isNull()) return;

		this.setFaction(this.getSettlement().getFaction());
	}

	q.isInLockdown <- function()
	{
		if (!this.m.GoesIntoLockdown) return false;
		if (this.getSettlement() == null) return false;		// бывает при генерации карты
		if (!this.getSettlement().hasSituation("situation.raided")) return false;

		// Пристройка — цель контракта никогда не в блокировке
		if (this.getSettlement().getSprite("selection").Visible) return false;

		return true;
	}

	q.getProduceList <- function()
	{
		local produceList = [];
		this.onUpdateProduce(produceList);
		return produceList;
	}

	// Производственная пристройка (с продукцией) становится доступной для набегов
	q.autodetectRaidableCivilians <- function()
	{
		if (this.m.IsRaidable) return;

		local produce = [];
		this.onUpdateProduce(produce);
		if (produce.len() == 0) return;

		this.m.IsAttackable = true;
		this.m.IsScalingDefenders = true;

		this.m.IsAutoDetectedRaidableLocation = true;
		this.m.IsRaidable = true;
		this.m.GoesIntoLockdown = true;

		// Тактическая карта
		this.m.CombatLocation.Template[0] = "tactical.human_camp";
		this.m.CombatLocation.Fortification = ::Const.Tactical.FortificationType.None;
		this.m.CombatLocation.CutDownTrees = true;
		this.m.CombatLocation.AdditionalRadius = 1;

		// Защитники
		this.m.Resources = 150;
		this.setDefenderSpawnList(::Const.World.Spawn.HD_AttachedProduction);
	}
});

// Автодетект после create всех пристроек (военные пристройки не затрагиваются:
// у них нет продукции, и они уже помечены IsRaidable)
::ReforgedLite.HooksMod.hookTree("scripts/entity/world/attached_location", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.autodetectRaidableCivilians();
	}
});
