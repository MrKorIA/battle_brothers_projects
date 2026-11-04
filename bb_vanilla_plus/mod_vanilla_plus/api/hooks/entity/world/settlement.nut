::VanillaPlus.HooksMod.hook("scripts/entity/world/settlement", function(q) {
// New Functions
	// @Return a WeightContainer with all applicable random situations for this settlemtn
	q.VP_getApplicableRandomSituations <- function()
	{
		local ret = ::MSU.Class.WeightedContainer();

		if (::World.FactionManager.isGreaterEvil())
		{
			ret.add("refugees_situation", 24);
		}

		switch (this.getSize())
		{
			case 2:
			{
				ret.add("warehouse_burned_down_situation", 12);
				ret.add("public_executions_situation", 12);

				if (!::isKindOf(this, "city_state"))
				{
					ret.add("cultist_procession_situation", 12);
					ret.add("archery_contest_situation", 12);

					if (::World.Assets.getOrigin().getID() == "scenario.cultists")
					{
						ret.add("cultist_procession_situation", 12);
					}

					if (!this.isMilitary())
					{
						ret.add("collectors_situation", 12);

						if (this.hasBuilding("building.taxidermist"))
						{
							ret.add("collectors_situation", 24);
						}
					}
				}
				break;
			}
			case 3:
			{
				if (!this.hasSituation("situation.ambushed_trade_routes"))
				{
					ret.add("seasonal_fair_situation", 12);
				}
				break;
			}
		}

		if (this.isMilitary())
		{
			ret.add("local_holiday_situation", 12);

			if (!::isKindOf(this, "city_state"))
			{
				ret.add("witch_burnings_situation", 12);
				ret.add("sickness_situation", 12);
			}
		}
		else
		{
			ret.add("mustering_troops_situation", 12);

			if (!::World.FactionManager.isGreaterEvil())
			{
				ret.add("disbanded_troops_situation", 12);

				if (!this.hasSituation("situation.ambushed_trade_routes"))
				{
					ret.add("preparing_feast_situation", 12);
				}
			}
		}

		if (::isKindOf(this, "city_state"))
		{
			ret.add("good_harvest_situation", 12);
		}

		if (this.isSouthern())
		{
			ret.add("sand_storm_situation", 12);

			if (this.hasBuilding("building.arena"))
			{
				if (!this.hasSituation("situation.arena_tournament"))
				{
					ret.add("bread_and_games_situation", 12);
				}

				if (::World.getTime().Days > 10 && !this.hasSituation("situation.bread_and_games"))
				{
					ret.add("arena_tournament_situation", 12);
				}
			}
		}
		else
		{
			if (this.hasBuilding("building.temple"))
			{
				ret.add("ceremonial_season_situation", 12);
			}
		}

		return ret;
	}
});
