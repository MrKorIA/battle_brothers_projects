::ReforgedLite.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
	q.general_queryUIElementTooltipData = @(__original) { function general_queryUIElementTooltipData( _entityId, _elementId, _elementOwner )
	{
		// Overwrites
		switch (_elementId)
		{
			case "character-screen.left-panel-header-module.Experience":
				return [
					{
						id = 1,
						type = "title",
						text = "Опыт"
					},
					{
						id = 2,
						type = "description",
						text = "Персонажи получают опыт в бою. После накопления достаточного количества опыта, персонаж повышает уровень.\n\nОпыт зарабатывается при убийстве врагов, независимо от причины их смерти, если ваш отряд нанес этому врагу хоть какой-либо урон. Опыт пропорционален доле общего урона, нанесенного врагу вашими людьми. Из этого опыта " + (::Const.XP.XPForKillerPct * 100) + "% пропорционально распределяется между братьями, нанесшими урон. Остальные " + (100 - ::Const.XP.XPForKillerPct * 100) + "% распределяются поровну между всеми членами отряда."
					}
				];
		}

		// Extending
		local ret = __original(_entityId, _elementId, _elementOwner);

		if (ret != null)
		{
			switch (_elementId)
			{
				case "character-stats.MeleeDefense":
				case "character-stats.RangeDefense":
					if (::Const.Tactical.Settings.AttributeDefenseSoftCap != 0)
					{
						foreach (entry in ret)
						{
							if (entry.id == 2 && entry.type == "description")
							{
								entry.text += " Каждый пункт текущей защиты выше " + ::Const.Tactical.Settings.AttributeDefenseSoftCap + " считается за полпункта.";
								break;
							}
						}
					}
					break;
			}

			ret.extend(this.getBaseAttributesTooltip(_entityId, _elementId, _elementOwner));
		}

		return ret;
	}}.general_queryUIElementTooltipData;

	q.getBaseAttributesTooltip <- { function getBaseAttributesTooltip( _entityId, _elementId, _elementOwner )
	{
		local entity = _entityId == null ? null : ::Tactical.getEntityByID(_entityId);

		if (entity == null)
		{
			return [];
		}

		local baseValue, currentValue, icon, extra;

		// Manually look for all attribute IDs and generate the respective tooltip entries
		switch (_elementId)
		{
			case "character-stats.MeleeSkill":
				baseValue = entity.getBaseProperties().getMeleeSkill();
				currentValue = entity.getCurrentProperties().getMeleeSkill();
				icon = "/ui/icons/melee_skill.png";
				break;

			case "character-stats.RangeSkill":
				baseValue = entity.getBaseProperties().getRangedSkill();
				currentValue = entity.getCurrentProperties().getRangedSkill();
				icon = "/ui/icons/ranged_skill.png";
				break;

			case "character-stats.MeleeDefense":
				baseValue = entity.getBaseProperties().getMeleeDefense();
				currentValue = entity.getCurrentProperties().getMeleeDefense();
				icon = "/ui/icons/melee_defense.png";
				break;

			case "character-stats.RangeDefense":
				baseValue = entity.getBaseProperties().getRangedDefense();
				currentValue = entity.getCurrentProperties().getRangedDefense();
				icon = "/ui/icons/ranged_defense.png";
				break;

			case "character-stats.Bravery":
				baseValue = entity.getBaseProperties().getBravery();
				currentValue = entity.getCurrentProperties().getBravery();
				icon = "/ui/icons/bravery.png";
				break;

			case "character-stats.Initiative":
				// For base, can't use entity.getInitiative() with switcheroo on CurrentProperties
				// because that function subtracts using m.Fatigue.
				baseValue = entity.getBaseProperties().getInitiative();
				// For current, use entity.getInitiative() instead of CurrentProperties.getInitiative()
				// because the entity function is the one that applies reduction based on built Fatigue.
				currentValue = entity.getInitiative();
				icon = "/ui/icons/initiative.png";
				break;

			case "character-stats.Hitpoints":
				// Switcheroo CurrentProperties to BaseProperties to get base value because entity.getHitpointsMax() uses CurrentProperties
				local c = entity.getCurrentProperties();
				entity.m.CurrentProperties = entity.getBaseProperties();
				baseValue = entity.getHitpointsMax();
				entity.m.CurrentProperties = c;
				currentValue = entity.getHitpointsMax();
				icon = "ui/icons/health.png";
				break;

			case "character-stats.Fatigue":
				// Switcheroo CurrentProperties to BaseProperties to get base value because entity.getFatigueMax() uses CurrentProperties
				local c = entity.getCurrentProperties();
				entity.m.CurrentProperties = entity.getBaseProperties();
				baseValue = entity.getFatigueMax();
				entity.m.CurrentProperties = c;
				currentValue = entity.getFatigueMax();
				icon = "ui/icons/fatigue.png";
				extra = [
					{
						id = 5,
						type = "text",
						icon = icon,
						text = "Восстановление выносливости: " + ::MSU.Text.colorizeValue(::Math.floor(c.FatigueRecoveryRate * c.FatigueRecoveryRateMult), {AddSign = true})
					},
					{
						id = 6,
						type = "text",
						icon = "ui/icons/bag.png",
						text = "Вес предметов: " + ::MSU.Text.colorNegative(::Math.abs(-1 * entity.getItems().getStaminaModifier()))
					}
				];
				break;

		}

		if (baseValue == null)
			return [];

		local ret = [
			{
				id = 3,	type = "text",	icon = icon,
				text = "Базовое значение: " + ::MSU.Text.colorizeValue(baseValue, {AddSign = baseValue < 0})
			},
			{
				id = 4,	type = "text",	icon = icon,
				text = "Модификатор: " + ::MSU.Text.colorizeValue(currentValue - baseValue, {AddSign = true})
			}
		];

		if (extra != null)
		{
			ret.extend(extra);
		}

		return ret;
	}}.getBaseAttributesTooltip;

});
