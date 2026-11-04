this.crippled_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 3,
		Count = 1
	},
	function create()
	{
		this.m.ID = "effects.crippled";
		this.m.Name = "Калека";
		this.m.Description = "Этот персонаж сильно ранен и будет получать на 5% больше урона и наносить на 5% меньше с каждым уровнем этого эффекта.";
		this.m.Icon = "skills/status_effect_79.png";
		this.m.IconMini = "perk_55_mini";
		this.m.Overlay = "perk_55";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getName()
	{
		if (this.m.Count <= 1)
		{
			return this.m.Name;
		}
		else
		{
			return this.m.Name + " (x" + this.m.Count + ")";
		}
	}

	function onAdded()
	{
		this.m.TurnsLeft = this.Math.max(1, 3 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);

		if (this.getContainer().hasSkill("trait.ailing"))
		{
			++this.m.TurnsLeft;
		}
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.Count * 5 + "%[/color] к наносимому урону"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.Count * 5 + "%[/color] к получаемому урону"
			}
		];
	}

	function onRefresh()
	{
		if (this.getContainer().getActor().getCurrentProperties().IsResistantToAnyStatuses && this.Math.rand(1, 100) <= 50)
		{
			if (!this.getContainer().getActor().isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " сопротивляется подавлению благодаря неестественной физиологии");
			}

			return;
		}

		++this.m.Count;
		this.spawnIcon("status_effect_79", this.getContainer().getActor().getTile());
	}

	function onUpdate( _properties )
	{
		_properties.DamageTotalMult = this.Math.maxf(0.0, _properties.DamageTotalMult - 0.05 * this.m.Count);
		_properties.DamageReceivedMeleeMult = this.Math.maxf(0.0, _properties.DamageReceivedMeleeMult - 0.05 * this.m.Count);
		_properties.DamageReceivedRangedMult = this.Math.maxf(0.0, _properties.DamageReceivedRangedMult - 0.05 * this.m.Count);
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

	function onNewRound()
	{
	}

});

