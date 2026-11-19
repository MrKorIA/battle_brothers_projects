::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/champion_racial", function(q) 
{
	//obj.m.Mult <- 1.0;
	q.m.GainHP <- false;
	q.m.IsPlayer <- false;

	q.getMult <- function()
	{
		return !m.IsPlayer || !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() ? 1.0 : 0.67;
	}

	q.create = @(__original) function()
	{
		__original();
		m.Description = "Самые жестокие среди самых сильных. Кто осмелится бросить им вызов?";
		//m.Mult = !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() ? 1.0 : 0.67;
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First + 1;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

	q.onAdded <- function()
	{
		local actor = getContainer().getActor();
		m.IsPlayer = actor.isPlayerControlled();

		if (actor.hasSprite("miniboss")) {
			actor.getSprite("miniboss").setBrush("bust_miniboss");
			actor.setDirty(true);
		}

		if (!m.IsPlayer)
			getContainer().add(::new("scripts/skills/special/nggh_mod_champion_loot"));  
		else {
			actor.m.IsMiniboss = true;
			
			if (::MSU.isKindOf(actor, "nggh_mod_spider_player") && actor.getSize() < 1.0)
				getContainer().getActor().setSize(1.0);
		}
	}

	q.onRemoved <- function()
	{
		if (!getContainer().getActor().hasSprite("miniboss")) return;

		getContainer().getActor().getSprite("miniboss").Visible = false;
		getContainer().getActor().setDirty(true);
	}

	q.getTooltip <- function()
	{
		local mult = getMult();
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
				icon = "ui/icons/health.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor((m.GainHP ? 1.35 : 1.0) * 35 * mult) + "%[/color] к ОЗ"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor(15 * mult) + "%[/color] к наносимому урону"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor(15 * mult) + "%[/color] к инициативе"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor(15 * mult) + "%[/color] к навыку ближнего боя"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor((m.GainHP ? 1.0 : 1.25) * 25 * mult) + "%[/color] к навыку дальнего боя"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor((m.GainHP ? 1.0 : 1.25) * 25 * mult) + "%[/color] к защите в ближнем бою"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor(15 * mult) + "%[/color] к защите в дальнем бою"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor(50 * mult) + "%[/color] к решимости"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + ::Math.floor(50 * mult) + "%[/color] к максимальной выносливости"
			}
		];
	}

	q.onUpdate = @() function( _properties )
	{
		local mult = getMult();
		_properties.DamageTotalMult *= 1.0 + (0.15 * mult);
		_properties.BraveryMult *= 1.0 + (0.5 * mult);
		_properties.StaminaMult *= 1.0 + (0.5 * mult);
		_properties.MeleeSkillMult *= 1.0 + (0.15 * mult);
		_properties.RangedSkillMult *= 1.0 + (0.15 * mult);
		_properties.InitiativeMult *= 1.0 + (0.15 * mult);
		_properties.MeleeDefenseMult *= 1.0 + (0.25 * mult);
		_properties.RangedDefenseMult *= 1.0 + (0.25 * mult);
		_properties.HitpointsMult *= 1.0 + (0.35 * mult);

		m.GainHP = getContainer().getActor().getBaseProperties().MeleeDefense >= 20 || getContainer().getActor().getBaseProperties().RangedDefense >= 20 || getContainer().getActor().getBaseProperties().MeleeDefense >= 15 && getContainer().getActor().getBaseProperties().RangedDefense >= 15;

		if (m.GainHP) {
			_properties.HitpointsMult *= 1.0 + (0.35 * mult);
			return;
		}
		
		_properties.MeleeDefenseMult *= 1.0 + (0.25 * mult);
		_properties.RangedDefenseMult *= 1.0 + (0.25 * mult);
	}

	q.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (_skill == null) return;
		
		if (_skill.getID() != "actives.spider_bite" && _skill.getID() != "actives.legend_redback_spider_bite") return;

		_properties.DamageTotalMult *= 1.15; // a buff for champion spider
	}
	
});
