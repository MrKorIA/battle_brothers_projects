this.rf_zombie_racial <- ::inherit("scripts/skills/skill", {
	m = {
		FatigueEffectMult = 0.0,
		FatigueDealtPerHitMultModifier = 1.0
	},
	function create()
	{
		this.m.ID = "racial.rf_zombie";
		this.m.Name = "Восставший";
		this.m.Description = "Этот персонаж - восставший мертвец.";
		this.m.Icon = "ui/orientation/zombie_01_orientation.png";
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Last;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.FatigueEffectMult == 0.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Не [устаёт|Concept.Fatigue]")
			});
		}
		else if (this.m.FatigueEffectMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Расходует на " + ::MSU.Text.colorizeMult(this.m.FatigueEffectMult, {InvertColor = true}) + " меньше [выносливости|Concept.Fatigue]")
			});
		}

		local bonusFatiguePerHit = ::Const.Combat.FatigueReceivedPerHit * this.m.FatigueDealtPerHitMultModifier;
		if (bonusFatiguePerHit != 0.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Наносит " + ::MSU.Text.color(::Const.UI.Color.DamageValue, bonusFatiguePerHit) + " урона по [выносливости|Concept.Fatigue] врагу при попадании")
			});
		}

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/orientation/zombie_01_orientation.png",
			text = "Убитые данным персонажем люди через некоторое время станут восставшими мертвецами.",	// This is implemented in onActorKilled of zombie.nut
		});

		ret.extend([
			{
				id = 20,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к эффекту [Ночное время|Skill+night_effect]")
			},
			{
				id = 21,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Не получает [временные травмы|Concept.InjuryTemporary]")
				// In Reforged undead have the rf_undead_injury_receiver skill which makes them affected by injuries and allows them to receive injuries
			},
			{
				id = 22,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [кровотечению|Skill+bleeding_effect]")
			},
			{
				id = 23,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Невосприимчив к [отравлению|Skill+spider_poison_effect]")
			},
			{
				id = 24,
				type = "text",
				icon = "ui/icons/morale.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString("Не подвержен влиянию эффектов [боевого духа|Concept.Morale]")
			}
		]);

		return ret;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		actor.m.MoraleState = ::Const.MoraleState.Ignore;

		local baseProperties = actor.getBaseProperties();
		baseProperties.IsAffectedByNight = false;
		baseProperties.IsAffectedByInjuries = false;
		baseProperties.IsImmuneToBleeding = true;
		baseProperties.IsImmuneToPoison = true;
		baseProperties.FatigueEffectMult = this.m.FatigueEffectMult;
		baseProperties.FatigueDealtPerHitMult += this.m.FatigueDealtPerHitMultModifier;	// In vanilla normal zombies don't have this bonus
	}
});
