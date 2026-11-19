this.nggh_mod_frenzy_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.frenzy";
		this.m.Name = "Боевое безумие";
		this.m.Description = "Впасть в боевое безумие. Действия становятся безрассудными, но взамен персонаж приобретает страшную физическую силу, достаточную, чтобы разорвать человека пополам. Когда безумие стихает, тело замечает накопившуюся усталость.";
		this.m.Icon = "ui/perks/perk_madden_active.png";
		this.m.IconDisabled = "ui/perks/perk_madden_active_sw.png";
		this.m.Overlay = "perk_madden_active";
		this.m.SoundOnUse = [
			"sounds/enemies/ghoul_hurt_13.wav",
			"sounds/enemies/ghoul_hurt_14.wav",
			"sounds/enemies/ghoul_hurt_15.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 25;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function onAdded()
	{
		local AI = this.getContainer().getActor().getAIAgent();

		if (AI != null && AI.getID() != ::Const.AI.Agent.ID.Player && AI.findBehavior(::Const.AI.Behavior.ID.Warcry) == null)
		{
			AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_warcry"));
		}
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();

		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+15%[/color] к наносимому урону"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+15%[/color] к навыку ближнего боя"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+50%[/color] к инициативе"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-50%[/color] к защите в ближнем бою"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Все умения тратят на [color=" + ::Const.UI.Color.PositiveValue + "]1[/color] меньше ОД"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Может наложить эффект [color=" + ::Const.UI.Color.PositiveValue + "]подавлен[/color] на цель"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Получает невосприимчивость к отталкиванию и захвату"
			}
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Получает невосприимчивость оглушению"
			},
		]);

		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().hasSkill("effects.frenzy") && !this.getContainer().hasSkill("effects.dazed");
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onUse( _user, _targetTile )
	{
		if (!this.getContainer().hasSkill("effects.frenzy"))
		{
			this.getContainer().add(::new("scripts/skills/effects/nggh_mod_frenzy_effect"));
			return true;
		}

		return false;
	}

});

