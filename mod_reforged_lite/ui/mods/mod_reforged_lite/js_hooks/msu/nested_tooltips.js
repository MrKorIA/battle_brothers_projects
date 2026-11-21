// Фикс «залипания» тултипа тайла в зависимости mod_nested_tooltips 0.5.5.
//
// Причина: обновлённый showTileTooltip делает ранний return, пока открыт залоченный тултип
// (любой тултип локируется через lockDelay = 500 мс; подавление — коммит f763bbf «keep locked
// tooltips open while the mouse crosses the map»). Подавленный запрос терялся: тултип тайла
// под курсором показывался только при СЛЕДУЮЩЕМ движении мыши (mouseHoverTile ->
// checkTileTooltipMouseMovement, порог mMinMouseMovement = 4 px), а при резком переносе на
// другого юнита без дальнейшего движения не появлялся вообще — «залипание». Разработчики мода
// знают о проблеме (комментарий «separate issue» в tests/tooltip_mouse.nut), фикса нет.
//
// UI-тултипы (навыки и пр.) этой проблемой не затронуты: их цепочка enter/leave залоченный
// тултип снимает корректно (enter нового источника отменяет HIDE-таймер).
//
// Решение: запоминаем подавленный запрос и выполняем его, когда стек тултипов освободится
// (залоченный тултип закрылся по истечении grace). Показ идёт через штатный showTileTooltip
// (с его проверками), поведение залоченных тултипов не меняется — убирается только необходимость
// дёргать мышь, чтобы увидеть тултип тайла под неподвижным курсором.

(function() {
	if (typeof MSU === "undefined" || MSU.NestedTooltip === undefined)
		return;

	var NT = MSU.NestedTooltip;

	// ES3-safe аналог Date.now() (в ванильном UI-окружении используется new Date().getTime())
	var nowMs = function() { return new Date().getTime(); };

	// Самый свежий подавленный запрос тултипа тайла: { data, pos, time }
	NT.__rflPendingTileTooltip = null;

	// Показ тултипа тайла подавлен залоченным тултипом — запоминаем запрос вместо того,
	// чтобы потерять его.
	ReforgedLite.Hooks.NestedTooltip_showTileTooltip = NT.showTileTooltip;
	NT.showTileTooltip = function(_currentData, _cursorPos) {
		if (this.TooltipStack.isLocked()) {
			if (!this.hasTooltipSourceBeneathCursor(_cursorPos))
				this.__rflPendingTileTooltip = { data: _currentData, pos: _cursorPos, time: nowMs() };
			return;
		}
		this.__rflPendingTileTooltip = null;
		ReforgedLite.Hooks.NestedTooltip_showTileTooltip.apply(this, arguments);
	};

	// Стек освободился (залоченный тултип закрылся по grace) — выполняем запомненный запрос,
	// чтобы тултип появился без движения мыши.
	ReforgedLite.Hooks.NestedTooltip_updateStack = NT.updateStack;
	NT.updateStack = function() {
		ReforgedLite.Hooks.NestedTooltip_updateStack.apply(this, arguments);
		var pending = this.__rflPendingTileTooltip;
		if (pending === null || pending === undefined)
			return;
		if (!this.TooltipStack.isEmpty())
			return; // залоченный тултип ещё открыт (мышь внутри него) — ждём его закрытия
		this.__rflPendingTileTooltip = null;
		// Запрос должен быть свежим: иначе это переход тултип -> UI или хвост прошлой цепочки,
		// а не тайл под текущим курсором.
		if (nowMs() - pending.time > this.Events.__TimerDelayGetters["GRACE"]() + 1000)
			return;
		// Курсор сейчас над UI-элементом со своим тултипом — не перекрываем его тултипом тайла.
		if (this.hasTooltipSourceBeneathCursor({ left: this.Events.__lastMouseX, top: this.Events.__lastMouseY }))
			return;
		this.showTileTooltip(pending.data, pending.pos);
	};
})();
