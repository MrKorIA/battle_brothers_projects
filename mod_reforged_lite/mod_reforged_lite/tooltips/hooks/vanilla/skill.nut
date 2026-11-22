// Безопасность вложенных тултипов: скилл без контейнера (только что созданный, не на актёре)
// не должен падать в getTooltip — временно даём ему контейнер dummy-игрока MSU.
// Паттерн из mod_reforged/hooks/skills/skill.nut (Lite-адаптация без балансовых правок).
//
// ЛОВУШКА ТАЙМИНГА (урок): обёртка регистрируется НАПРЯМУЮ в load.nut (обычная очередь modern
// hooks), а НЕ через ::MSU.QueueBucket.AfterHooks: очереди выполняются в !mods_preload ДО
// загрузки scripts/**, а MSU.AfterHooks дрейнится в бакете modern-hooks AfterHooks — т.е. ПОСЛЕ
// __finalizeHooks. Хук, зарегистрированный после finalize на уже обработанный класс
// (Processed = true), НИКОГДА не применяется (молчаливая мёртвая обёртка).
// «Последней» среди хуков на getTooltip базового скилла обёртка всё равно будет: регистрация
// идёт в load.nut мода, а хук mod_nested_tooltips на тот же класс — в его preload (мод грузится
// раньше по алфавиту), RawHooks применяются в порядке добавления — наша обёртка внешняя.
::ReforgedLite.HooksMod.hook("scripts/skills/skill", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		if (!::MSU.isNull(this.getContainer()))
			return __original();

		this.m.Container = ::MSU.getDummyPlayer().getSkills();
		local ret = __original();
		this.m.Container = null;
		return ret;
	}}.getTooltip;
});
