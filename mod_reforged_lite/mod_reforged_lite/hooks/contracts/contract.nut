// Тултип контракта на экране города (зависит от mod_nested_tooltips для рендера
// вложенных ссылок) + вложенные ссылки на города/фракции в текстах сцен контракта.
::ReforgedLite.HooksMod.hook("scripts/contracts/contract", function(q) {
	q.RF_getDescription <- { function RF_getDescription()
	{
		local ret = this.RF_getOriginText();
		if (ret != "")
		{
			ret += "\n\n";
		}
		return ret + this.RF_getOfferedByText();
	}}.RF_getDescription;

	// Returns text showing who is offering this contract and where.
	q.RF_getOfferedByText <- { function RF_getOfferedByText()
	{
		local faction = ::World.FactionManager.getFaction(this.getFaction());
		// Имя резолвится на стороне SQ по ID (тип WorldActor), а НЕ через динамический
		// Tooltip+<таблица с именем>: не-ASCII внутри ExtraData вложенной ссылки не
		// переживает транспорт JS->SQ (кодирование идентификатора байтами + UTF-8
		// JSON) — на выходе в тултипе иероглифы вместо имени.
		local character = this.getCharacter();
		local characterString = ::MSU.isNull(character) ? "кто-то" : format("[%s|WorldActor+%i]", character.getName(), this.m.EmployerID);
		local factionString = "";
		local homeString = "";
		if (::MSU.isNull(this.getHome()))
		{
			homeString = " где-то";
		}
		else if (!::MSU.isEqual(::World.State.getCurrentTown(), this.getHome()))
		{
			homeString = " в " + ::ReforgedLite.NestedTooltips.getNestedWorldEntityName(this.getHome());
		}

		if (::MSU.isNull(this.getHome()) || faction.getName() != this.getHome().getName())
		{
			factionString = " из " + ::ReforgedLite.NestedTooltips.getNestedFactionName(faction);
		}

		return ::ReforgedLite.Mod.Tooltips.parseString(format("Предлагает %s%s%s", characterString, factionString, homeString));
	}}.RF_getOfferedByText;

	// If _obj is integer, we assume it is a region, in this case we return its Center.
	// Otherwise we assume its a world entity and return its tile.
	q.RF_getTile <- { function RF_getTile( _obj )
	{
		return typeof _obj == "integer" ? ::World.State.getRegion(_obj).Center : _obj.getTile();
	}}.RF_getTile;

	// Returns text that shows the origin, direction and destination of this contract and the distance.
	q.RF_getOriginText <- { function RF_getOriginText()
	{
		local ret = "";

		// Origin is a location from which directions are based off of.
		local origin = ::MSU.isNull(this.getOrigin()) ? this.getHome() : this.getOrigin();
		if (!::MSU.isNull(origin))
		{
			local originRegion = typeof origin == "integer" ? ::World.State.getRegion(origin) : null;

			local destinations = this.RF_getDestinations();
			foreach (i, d in destinations)
			{
				if (i != 0)
				{
					ret += " затем ";
				}
				if (::MSU.isEqual(origin, d))
				{
					ret += i == 0 ? "Неподалёку " : "неподалёку ";
				}
				else if (!::MSU.isNull(d))
				{
					local destRegion = typeof d == "integer" ? ::World.State.getRegion(d) : null;
					if (destRegion != null)
					{
						ret += i == 0 ? "Неподалёку от " : "неподалёку от ";
						ret += ::Const.Strings.TerrainShort[destRegion.Type] + " на землях, что зовутся " + destRegion.Name;
					}

					// We use getDaysAndHalf function to generate text but we actually show
					// only days (not half) to keep the tooltip concise.
					ret += format("Цель: %s. В пути примерно: %s. к %s ",
									destRegion != null ? "" : ::ReforgedLite.NestedTooltips.getNestedWorldEntityName(d),
									::ReforgedLite.Text.getDaysAndHalf(this.RF_getDaysRequiredToTravel(this.RF_getTile(origin), this.RF_getTile(d)) * ::World.getTime().SecondsPerDay),
									::Const.Strings.Direction8[this.RF_getTile(origin).getDirection8To(this.RF_getTile(d))]);
				}

				if (i != 0)
				{
					ret += "там";
				}
				else
				{
					// If origin is the same as the town we are in, then say "here" instead of town name
					if (originRegion != null)
					{
						ret += i == 0 ? "Неподалёку от " : "неподалёку от ";
						ret += ::Const.Strings.TerrainShort[originRegion.Type] + " на землях, что зовутся " + originRegion.Name;
					}
					else
					{
						// If origin is the same as the town we are in, then say "here" instead of town name
						ret += ::MSU.isEqual(::World.State.getCurrentTown(), origin) ? "отсюда" : ::ReforgedLite.NestedTooltips.getNestedWorldEntityName(origin);
					}

					if (!::MSU.isNull(this.getHome()) && !::MSU.isEqual(origin, this.getHome()))
					{
						// We use getDaysAndHalf function to generate text but we actually show
						// only days (not half) to keep the tooltip concise.
						ret += format(" примерно %s к %s ", ::ReforgedLite.Text.getDaysAndHalf(this.RF_getDaysRequiredToTravel(this.RF_getTile(origin), this.getHome().getTile()) * ::World.getTime().SecondsPerDay), ::Const.Strings.Direction8[this.getHome().getTile().getDirection8To(this.RF_getTile(origin))]);
						ret += ::MSU.isEqual(::World.State.getCurrentTown(), this.getHome()) ? "отсюда" : ::ReforgedLite.NestedTooltips.getNestedWorldEntityName(this.getHome());
					}
				}

				origin = d;
			}
		}

		return ::ReforgedLite.Mod.Tooltips.parseString(ret);
	}}.RF_getOriginText;

	// Returns the goal location of this contract, if one exists.
	// Necessary to calculate the correct distance and location in the contract tooltip.
	// Most of the times it is Origin. But some contracts have custom members like m.Destination, m.Location.
	q.RF_getDestinations <- { function RF_getDestinations()
	{
		return ::MSU.isIn("Destination", this.m, true) && !::MSU.isNull(this.m.Destination) ? [this.m.Destination] : [this.getOrigin()];
	}}.RF_getDestinations;

	// Returns the days required to travel for the purposes of showing in the contract tooltip.
	// Should be ovewritten by child contracts if they have a different speed or road restriction e.g. escort_caravan_contract.
	// _start and _end both must be world tiles.
	q.RF_getDaysRequiredToTravel <- { function RF_getDaysRequiredToTravel( _start, _end )
	{
		return this.getDaysRequiredToTravel(_start.getDistanceTo(_end), ::Const.World.MovementSettings.Speed, false);
	}}.RF_getDaysRequiredToTravel;

	q.RF_getTooltip <- { function RF_getTooltip()
	{
		local daysRemaining = (this.m.TimeOut - ::Time.getVirtualTimeF()) / ::World.getTime().SecondsPerDay;

		local ret = [
			{
				id = 1, type = "title", text = this.getName()
			},
			{
				id = 2, type = "description", text = this.RF_getDescription()
			},
			{
				// daysRemaining < 0 will only be true for "last-known" contracts from your last visit
				id = 3, type = "hint", icon = "ui/icons/action_points.png",
				text = daysRemaining < 0 ? "Вероятно, больше не доступен" : "Будет доступен ещё " + ::ReforgedLite.Text.getDaysRemainingText(daysRemaining)
			},
			{
				id = 100, type = "rf_image", image = ::String.replace(this.getUIDifficultySmall(), "difficulty", "rf_difficulty") + "_tooltip.png", cssClass = "rf-contract-difficulty-tooltip"
			}
		];

		if (this.m.IsStarted || this.isNegotiated())
		{
			local payment = this.getPayment();
			local advance = payment.getInAdvance();
			local completion = payment.getOnCompletion();
			local perCount = payment.getPerCount();
			local strs = [];
			if (advance != 0)
			{
				strs.push(advance + " крон авансом");
			}
			if (completion != 0)
			{
				strs.push(completion + " крон по завершении");
			}
			if (perCount != 0)
			{
				strs.push(perCount + " крон за голову");
			}
			if (strs.len() != 0)
			{
				local str = format("%s %s", this.isNegotiated() ? "Вы заключили этот контракт за" : "Предлагается", strs[0]);
				for (local i = 1; i < strs.len(); i++)
				{
					if (i != strs.len() - 1)
					{
						str += ", ";
					}
					else
					{
						str += " и ";
					}
					str += ::String.replace(strs[i], "крон ", "");
				}
				ret.push({
					id = 4, type = "hint", icon = "ui/icons/asset_money.png",
					text = str
				});
			}
		}

		if (this.m.SituationID != 0)
		{
			local hasAgent = ::World.Retinue.hasFollower("follower.agent");
			local situations = [];
			foreach (settlement in ::World.EntityManager.getSettlements())
			{
				// С Агентом известны текущие ситуации всех поселений; без него — только
				// текущего (Lite не хранит ситуации последнего посещения чужих городов).
				if (hasAgent || ::MSU.isEqual(::World.State.getCurrentTown(), settlement))
				{
					situations.extend(settlement.getSituations());
				}
			}

			foreach (s in situations)
			{
				if (s.getInstanceID() == this.m.SituationID)
				{
					ret.push({
						id = 100, type = "hint", icon = s.getIcon(),
						text = ::ReforgedLite.Mod.Tooltips.parseString(::ReforgedLite.NestedTooltips.getNestedObjectName(s, "contentType:settlement-status-effect"))
					});
					break;
				}
			}
		}

		return ret;
	}}.RF_getTooltip;

	// This is a close copy of how vanilla calculates their distance duration in getDaysRequiredToTravel.
	// НОВЫЙ член класса (в ванили функции нет — только инлайн внутри getDaysRequiredToTravel),
	// поэтому объявляется через <-, а не обёрткой @(__original).
	q.getSecondsRequiredToTravel <- { function getSecondsRequiredToTravel( _numTiles, _speed, _onRoadOnly = false )
	{
		_speed *= ::Const.World.MovementSettings.GlobalMult;
		if (_onRoadOnly) _speed *= ::Const.World.MovementSettings.RoadMult;
		return _numTiles * 170.0 / _speed;
	}}.getSecondsRequiredToTravel;

	// Вложенные ссылки (имена городов/фракций) в текстах сцен контракта:
	// buildText подставляет переменные (%townname%, %origin%, %faction% и т.д.) через
	// getName(), которая при включённом флаге оборачивается во вложенную ссылку.
	q.setScreen = @(__original) { function setScreen( _screen, _restartIfAlreadyActive = true )
	{
		::ReforgedLite.NestedTooltips.setApplyNestingForEvents(true);
		__original(_screen, _restartIfAlreadyActive);
		::ReforgedLite.NestedTooltips.setApplyNestingForEvents(false);
	}}.setScreen;

	q.buildText = @(__original) { function buildText( _text )
	{
		::ReforgedLite.NestedTooltips.setApplyNestingForEvents(true);
		local ret = __original(_text);
		::ReforgedLite.NestedTooltips.setApplyNestingForEvents(false);
		return ret;
	}}.buildText;
});

::ReforgedLite.HooksMod.hookTree("scripts/contracts/contract", function(q) {
	q.onPrepareVariables = @(__original) { function onPrepareVariables( _vars )
	{
		::ReforgedLite.NestedTooltips.setApplyNestingForEvents(true);
		__original(_vars);
		::ReforgedLite.NestedTooltips.setApplyNestingForEvents(false);
	}}.onPrepareVariables;
});
