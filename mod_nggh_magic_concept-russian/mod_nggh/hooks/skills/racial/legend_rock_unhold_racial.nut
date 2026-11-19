::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/legend_rock_unhold_racial", function(q) 
{
	//obj.m.RecoverMult <- 10;
	q.m.IsPlayer <- false;
	q.m.ApplicablePoison <- [
		"spider_poison",
		"legend_redback_spider_poison",
		"legend_RSW_poison_effect",
		"goblin_poison",
		"legend_zombie_poison",
		"legend_rat_poison",
	];

	q.getRecoverMult <- function()
	{
		return (!m.IsPlayer || !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue()) ? 10 : 3;
	}

	q.create = @(__original) function()
	{
		__original();
		m.Name = "Регенерация каменных троллей";
		m.Description = "Тролли обладают невероятной регенерацией, с которой не может сравниться ни одно другое существо. Он может легко отрастить отсутствующую конечность в течение нескольких часов. У этого особенно прочная кожа, похожая на броню.";
		m.Icon = "skills/status_effect_79.png";
		m.IconMini = "status_effect_79_mini";
		//m.RecoverMult = !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() ? 10 : 3;
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
				icon = "ui/icons/armor_body.png",
				text = "Восстанавливает [color=" + ::Const.UI.Color.PositiveValue + "]" + getRecoverMult() + "%[/color] от максимальной брони"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Восстанавливает [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Math.floor(getRecoverMult() * 1.5) + "%[/color] от максимального здоровья"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/tooltips/negative.png",
				text = "Регенерация здоровья прекращается, если персонаж находся под действием эффекта [color=" + ::Const.UI.Color.NegativeValue + "]Отравлен[/color]"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]Невосприимчивость[/color] к колющим, режущим и огненным атакам"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Уязвимость[/color] к дробящему урону"
			}
		];
	}

	q.onTurnStart = @() function()
	{
		local actor = getContainer().getActor();
		local mult = getRecoverMult() * 0.01;
		local b = actor.getBaseProperties();
		local totalBodyArmor = b.ArmorMax[0];
		local totalHeadArmor = b.ArmorMax[1];
		local currentBodyArmor = b.Armor[0];
		local currentHeadArmor = b.Armor[1];
		local missingBodyArmor = totalBodyArmor - currentBodyArmor;
		local missingHeadArmor = totalHeadArmor - currentHeadArmor;
		local healRateBody = totalBodyArmor * mult;
		local healRateHead = totalHeadArmor * mult;
		local addedBodyArmor = ::Math.abs(::Math.min(missingBodyArmor, healRateBody));
		local addedHeadArmor = ::Math.abs(::Math.min(missingHeadArmor, healRateBody));
		local newBodyArmor = currentBodyArmor + addedBodyArmor;
		local newHeadArmor = currentHeadArmor + addedHeadArmor;

		if (addedBodyArmor <= 0 && addedHeadArmor <= 0)
			return;
		
		foreach (string in m.ApplicablePoison) 
		{
		    if (actor.getSkills().hasSkill("effects." + string))
		    	return;
		}
		
		actor.setArmor(::Const.BodyPart.Body, newBodyArmor);
		actor.setArmor(::Const.BodyPart.Head, newHeadArmor);
		actor.setDirty(true);

		if (!actor.isHiddenToPlayer()) {
			if (m.SoundOnUse.len() != 0)
				::Sound.play(::MSU.Array.rand(m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());

			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " восстанавливает " + addedBodyArmor + " единиц прочности доспеха");
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " восстанавливает " + addedHeadArmor + " единиц прочности шлема");
			spawnIcon("status_effect_79", actor.getTile());
		}
	}

	q.onUpdate = @(__original) function( _properties )
	{
		if (!m.IsPlayer)
			__original(_properties);
	}
	
});
