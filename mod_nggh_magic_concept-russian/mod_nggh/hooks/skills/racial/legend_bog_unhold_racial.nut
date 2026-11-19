::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/legend_bog_unhold_racial", function(q) 
{
	//obj.m.RecoverMult <- 15;
	q.m.IsPlayer <- false;

	q.getRecoverMult <- function()
	{
		return (!m.IsPlayer || !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue()) ? 15 : 10;
	}

	q.create = @(__original) function()
	{
		__original();
		m.Name = "Регенерация болотного тролля";
		m.Description = "Тролли обладают невероятной регенерацией, с которой не может сравниться ни одно другое существо. Они могут легко отрастить отсутствующую конечность в течение нескольких часов. Этот тролль воняет тиной.";
		m.Icon = "skills/status_effect_79.png";
		m.IconMini = "status_effect_79_mini";
		//m.RecoverMult = !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() ? 15 : 10;
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First + 1;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

	q.onAdded <- function()
	{
		m.IsPlayer = ::MSU.isKindOf(getContainer().getActor(), "player");
	}

	q.getTooltip <- function()
	{
		return [
			{
				id = 1,
				type = "title",
				text = getName()
			},
			{
				id = 2,
				type = "description",
				text = getDescription()
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Восстанавливает [color=" + ::Const.UI.Color.PositiveValue + "]" + getRecoverMult() + "%[/color] от максимального здоровья каждый ход"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Эффект [color=" + ::Const.UI.Color.NegativeValue + "]Отравлен[/color] не прерывает регенерацию здоровья"
			}
		];
	}

	q.onTurnStart = @() function()
	{
		local actor = getContainer().getActor();
		local healthMissing = actor.getHitpointsMax() - actor.getHitpoints();
		local healthAdded = ::Math.min(healthMissing, ::Math.floor(actor.getHitpointsMax() * getRecoverMult() * 0.01));

		if (healthAdded <= 0)
			return;

		actor.setHitpoints(actor.getHitpoints() + healthAdded);

		if (!actor.isHiddenToPlayer()) {
			spawnIcon("status_effect_79", actor.getTile());

			if (m.SoundOnUse.len() != 0)
				::Sound.play(::MSU.Array.rand(m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());

			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " исцеляет " + healthAdded + " ОЗ");
		}
	}

});
