::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/warcry", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Оглушительный рев может легко напугать до смерти и поднять боевой дух ваших воинов.";
		m.Icon = "skills/active_49.png";
		m.IconDisabled = "skills/active_49_sw.png";
		m.Order = ::Const.SkillOrder.UtilityTargeted + 1;
		m.MaxRange = 5;
	}

	q.onAfterUpdate <- function( _properties )
	{
		if (!::MSU.isKindOf(getContainer().getActor(), "player"))
			return;

		m.ActionPointCost += 1;
		m.FatigueCostMult *= 2.0;
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Воздействует на всех существ на расстоянии [color=" + ::Const.UI.Color.PositiveValue + "]" + (!::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() ? getMaxRange() + 5 : getMaxRange()) + "[/color] клеток"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Вызывает положительную проверку боевого духа или сплочение союзников"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Вызывает отрицательную проверку боевого духа у врагов"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Снимает эффект 'Сон' со всех в радиусе действия"
			}
		]);
		
		if (m.IsSpent)
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Можно использовать только один раз за ход[/color]"
			});

		return ret;
	}

	q.onDelayedEffect = @() function( _tag )
	{
		local f = _tag.User.getFaction(), p = _tag.User.getCurrentProperties(), mytile = _tag.User.getTile()
		local bonus = p.Threat + ::Math.min(15, p.ThreatOnHit), isPlayer = _tag.User.getFaction() == ::Const.Faction.Player;

		foreach( a in ::Tactical.Entities.getActorsByFunction(function( _actor ) {
			if (_actor.getID() == _tag.User.getID()) return false;
			local dis = _actor.getTile().getDistanceTo(mytile);
			if (!::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue()) return dis <= 10;
			else return dis <= 5;
		}) )
		{
			local dis = a.getTile().getDistanceTo(mytile);

			if (a.getFaction() == f) {
				local difficulty = 10 + bonus - ::Math.pow(dis, ::Const.Morale.EnemyKilledDistancePow);

				if (a.getMoraleState() == ::Const.MoraleState.Fleeing)
					a.checkMorale(::Const.MoraleState.Wavering - ::Const.MoraleState.Fleeing, difficulty);
				else
					a.checkMorale(1, difficulty);

				if (a.getFaction() != ::Const.Faction.Player);
					a.setFatigue(::Math.max(0, a.getFatigue() - 20));
			}
			else if (a.getFaction() == ::Const.Faction.PlayerAnimals && isPlayer)
				continue;
			else
				a.checkMorale(-1, bonus + 10 - ::Math.pow(dis, ::Const.Morale.AllyKilledDistancePow), ::Const.MoraleCheckType.MentalAttack);

			a.getSkills().removeByID("effects.sleeping");
		}
	}

});
