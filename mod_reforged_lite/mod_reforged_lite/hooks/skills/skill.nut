// Безопасность вложенных тултипов: скилл без контейнера (только что созданный, не на актёре)
// не должен падать в getTooltip — временно даём ему контейнер dummy-игрока MSU.
// Паттерн из mod_reforged/hooks/skills/skill.nut (Lite-адаптация без балансовых правок).
// ВНИМАНИЕ: бакет 'Late' существует только в фреймворке Reforged — в MSU 1.9 его нет;
// AfterHooks выполняется после применения всех хуков (нужно, чтобы обёртка шла последней).
::MSU.QueueBucket.AfterHooks.push(function() {
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
});
