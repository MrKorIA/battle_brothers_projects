this.sbq9_domi_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 1
	},
	function create()
	{
		this.m.ID = "actives.sbq9_domi_skill";
		this.m.Name = "116. Доминирование в бою";
		this.m.Description = "Накладывает отрицательный эффект на врагов с определенными состояниями на поле боя, уменьшая наносимый урон на 30% и увеличивая получаемый урон на 30%.";
		this.m.Icon = "ui/xx83.png";
		this.m.IconDisabled = "ui/xx83_sw.png";
		this.m.Overlay = "active_117";
		this.m.SoundOnUse = [
			"sounds/combat/perfect_focus_01.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsAttack = true;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 25;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Нацеливается на врагов в следующих состояниях: ошеломленные, отвлеченные, с открытой слабостью, с израсходованной усталостью более 50%."
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Может использоваться [color=#8f1e1e]" + this.m.Skillcharge + "[/color] больше раз в этой битве"
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcharge = this.m.Skillcharge - 1;
		local actor = this.getContainer().getActor();
		local atile = actor.getTile();
		local everyone = this.Tactical.Entities.getAllInstances();
		foreach( ever in everyone )
		{
			foreach( e in ever )
			{
				if (actor.isAlive() && e.isAlive() && !actor.isAlliedWith(e))
				{
					local ek = e.getSkills();
					if (ek.hasSkill("effects.staggered") || ek.hasSkill("effects.distracted") || ek.hasSkill("effects.ai_weak_effect") || e.getFatiguePct() >= 0.5)
					{
						ek.add(this.new("scripts/skills/effects/sbq8_domi_effect"));
						local fakeb = this.new("scripts/skills/actives/ai_fakebuff");
						fakeb.m.Overlay = "";
						ek.add(fakeb);
					}
				}
			}
		}
		return true;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else if (this.m.Skillcharge <= 0)
		{
			return false;
		}
		return true;
	}

	function isHidden()
	{
		if (this.m.Skillcharge > 0)
		{
			return false;
		}

		return true;
	}

	function onCombatFinished()
	{
		this.m.Skillcharge = 1;
	}

});

