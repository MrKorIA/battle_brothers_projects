this.rf_barrow_chant_effect <- ::inherit("scripts/skills/skill", {
	m = {
		RestlessnessChance = 50
	},
	function create()
	{
		this.m.ID = "effects.rf_barrow_chant";
		this.m.Name = "Курганное пение";
		this.m.Description = "Низкое, ужасное пение, которое ублажает мёртвых, но тяготит дух живых, терзая их уверенность.";
		// TODO: Placeholder icons
		this.m.Icon = "ui/perks/perk_32.png";
		// this.m.IconMini = "TODO";
		// this.m.Overlay = "TODO";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Враги на поле боя не могут иметь [уверенный|Concept.Morale] боевой дух")
		});

		local debuff = ::new("scripts/skills/effects/rf_barrow_chant_debuff_effect");
		if (debuff.m.DamageMultPerMoraleStateAdd != 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Услышавшие пение враги наносят на " + ::MSU.Text.colorizeMultWithText(1.0 + debuff.m.DamageMultPerMoraleStateAdd) + " урона за каждое состояние боевого духа ниже [уверенного|Concept.Morale]")
			});
		}

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("После смерти персонажа каждый союзный курганник имеет индивидуальный " + ::MSU.Text.colorizeValue(this.m.RestlessnessChance, {AddPercent = true}) + " шанс получить эффект [$ $|Skill+rf_draugr_restless_effect]")
		});

		return ret;
	}

	function onDeath( _fatalityType )
	{
		local actor = this.getContainer().getActor();
		foreach (a in ::Tactical.Entities.getAllInstancesAsArray())
		{
			a.getSkills().removeByID("effects.rf_barrow_chant_debuff");

			if (a.isAlliedWith(actor) && ::MSU.isKindOf(a, "rf_draugr") && ::Math.rand(1, 100) <= this.m.RestlessnessChance)
			{
				a.getSkills().add(::new("scripts/skills/effects/rf_draugr_restless_effect"));
			}
		}
	}

	function onActorSpawned( _actor )
	{
		if (::MSU.isEqual(_actor, this.getContainer().getActor()))
		{
			foreach (a in ::Tactical.Entities.getAllInstancesAsArray())
			{
				a.getSkills().add(::new("scripts/skills/effects/rf_barrow_chant_debuff_effect"));
			}
		}
		else
		{
			_actor.getSkills().add(::new("scripts/skills/effects/rf_barrow_chant_debuff_effect"));
		}
	}
});
