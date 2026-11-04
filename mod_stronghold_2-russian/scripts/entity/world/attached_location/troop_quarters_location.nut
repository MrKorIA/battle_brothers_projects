this.troop_quarters_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {
		MoodText = "Провел ночь в %s войсковом жилище.",
		MoodTexts = ["захудалом", "посредственном", "прекрасном", "превосходном"],
	},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Войсковая часть";
		this.m.ID = "attached_location.troop_quarters";
		this.m.Description = "Жилье для ваших братьев.";
		this.m.Sprite = "stronghold_world_troop_quarters_location";
		this.m.SpriteDestroyed = "stronghold_world_troop_quarters_location";
	}

	function getSlots()
	{
		return this.m.Level * ::Stronghold.Locations.Troop_Quarters.MaxTroops;
	}

	function getWageMult()
	{
		return  ::Stronghold.Locations.Troop_Quarters.WageCost - (::Stronghold.Locations.Troop_Quarters.WageCostPerLevel * this.m.Level) ;
	}

	function getMoodTarget()
	{
		return  ::Stronghold.Locations.Troop_Quarters.MoodStateStart + (::Stronghold.Locations.Troop_Quarters.MoodStatePerLevel * this.m.Level) ;
	}

	function getMoodText()
	{
		return  format(this.m.MoodText, this.m.MoodTexts[this.getLevel() - 1]);
	}

	function getMood()
	{
		return {
			Target = this.getMoodTarget(),
			Text = this.getMoodText(),
			Change = ::Stronghold.Locations.Troop_Quarters.MoodChange
		}
	}

	function stronghold_onEnterBase(_daysPassed)
	{
		local moodMods = this.getMood();
		foreach(bro in this.m.Settlement.getLocalRoster().getAll())
		{
			for (local i = 0; i < _daysPassed; ++i)
			{
				local currentMood = bro.getMoodState();
				if (moodMods.Target >= currentMood)
					bro.improveMood(moodMods.Change, moodMods.Text);
				else bro.worsenMood(moodMods.Change, moodMods.Text);
			}
		}
	}

	function stronghold_onNewDay()
	{
		local wageMult = this.getWageMult();
		foreach(bro in this.m.Settlement.getLocalRoster().getAll())
		{
			local wage = bro.getDailyCost() * wageMult;
			bro.getSkills().onNewDay();
			bro.updateInjuryVisuals();

			if (bro.getDailyCost() > 0 && ::World.Assets.m.Money < wage)
			{
				if (bro.getSkills().hasSkill("trait.greedy"))
				{
					bro.worsenMood(this.Const.MoodChange.NotPaidGreedy, "Не заплатили");
				}
				else
				{
					bro.worsenMood(this.Const.MoodChange.NotPaid, "Не заплатили");
				}
			}
			::World.Assets.m.Money -= ::Math.floor(wage);
		}
	}
})
