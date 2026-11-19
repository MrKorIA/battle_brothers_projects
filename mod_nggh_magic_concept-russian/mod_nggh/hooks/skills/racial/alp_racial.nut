::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/alp_racial", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Name = "Полусон";
		m.Description = "Обладает сильной устойчивостью к пронзающим и дальнобойным атакам, поскольку часть реального тела существует только во сне. Имеет привычку преследовать и выслеживать свою жертву.";
		m.Icon = "skills/status_effect_102.png";
		m.IconMini = "status_effect_102_mini";
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First + 1;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

	q.getTooltip <- function()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = getName()
			},
			{
				id = 2,
				type = "description",
				text = getDescription()
			}
		];

		if (::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue()) {
			ret.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = "[color=" + ::Const.UI.Color.NegativeValue + "]-15%[/color] к урону в ближнем бою"
				},
				{
					id = 7,
					type = "text",
					icon = "ui/icons/ranged_skill.png",
					text = "[color=" + ::Const.UI.Color.NegativeValue + "]-15%[/color] к урону в дальнем бою"
				}
			]);
		}

		ret.extend([
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]Невосприимчивость[/color] к пронзающим или дальнобойным атакам"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Уязвимость[/color] к повреждению огнём"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Вызывает телепортацию союзных альпов после получения урона"
			}
		]);

		return ret;
	}

	q.onAdded <- function()
	{
		if (::MSU.isKindOf(getContainer().getActor(), "player"))
			getContainer().getActor().getAIAgent().addBehavior(::new("scripts/ai/tactical/behaviors/ai_alp_teleport"));
	}

	q.onUpdate <- function( _properties )
	{
		if (!::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue()) return; // nerf alp player as these doesn't do anything to npc alp

		_properties.MeleeDamageMult *= ::Const.AlpWeaponDamageMod;
		_properties.RangedDamageMult *= ::Const.AlpWeaponDamageMod;
	}

	q.onDamageReceived = @() function( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_damageHitpoints >= getContainer().getActor().getHitpoints())
			return;

		::Sound.play(::MSU.Array.rand(m.SoundOnUse), ::Const.Sound.Volume.Skill);
		::Time.scheduleEvent(::TimeUnit.Virtual, 30, teleport.bindenv(this), getContainer().getActor().getFaction());
	}

	q.onDeath = @() function( _fatalityType )
	{
		::Sound.play(::MSU.Array.rand(m.SoundOnUse), ::Const.Sound.Volume.Skill);
		::Time.scheduleEvent(::TimeUnit.Virtual, 30, teleport.bindenv(this), getContainer().getActor().getFaction());
	}

	q.teleport = @() function( _faction )
	{
		foreach( a in ::Tactical.Entities.getInstancesOfFaction(_faction) )
		{
			if (!a.isAlive() || a.getHitpoints() <= 0 || !a.getFlags().get("auto_teleport"))
				continue;

			local b = a.getAIAgent().getBehavior(::Const.AI.Behavior.ID.AlpTeleport);

			if (b == null)
				continue;

			local skill = a.getSkills().getSkillByID("actives.alp_teleport");

			if (skill == null)
				continue;

			b.onEvaluate(a);
			b.onExecute(a);
		}
	}

});
