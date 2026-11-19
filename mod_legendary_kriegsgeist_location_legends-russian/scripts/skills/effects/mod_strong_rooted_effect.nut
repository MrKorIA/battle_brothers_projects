this.mod_strong_rooted_effect <- this.inherit("scripts/skills/skill", {
	m = {
		LastRoundApplied = 0,
	},
	function getDamage()
	{
		if (this.getContainer().getActor().getCurrentProperties().IsImmuneToPoison)
		{
			return ::Math.rand(10, 20);
		}

		return ::Math.rand(5, 10);
	}

	function setDamage( _d )
	{
	}

	function create()
	{
		this.m.ID = "effects.rooted";
		this.m.Name = "Оплетён лозой";
		this.m.Description = "Крепкая лоза огромных размеров оплела этого персонажа, лишая его возможности защищаться. Чтобы освободиться, нужно разрубить лозу.";
		this.m.Icon = "skills/status_effect_55.png";
		this.m.IconMini = "status_effect_55_mini";
		this.m.Overlay = "status_effect_55";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return this.m.Description + " С каждым ходом лианы угрожают раздавить персонажа, захватывая все сильнее, что приводит к потере [color=" + this.Const.UI.Color.NegativeValue + "]5[/color] - [color=" + this.Const.UI.Color.NegativeValue + "]10[/color] ОЗ."
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
				id = 9,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Обездвижен[/color]"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-35%[/color] к защите в ближнем бою"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-35%[/color] к защите в дальнем бою"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-35%[/color] к инициативе"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.IsRooted = true;
		_properties.MeleeDefenseMult *= 0.65;
		_properties.RangedDefenseMult *= 0.65;
		_properties.InitiativeMult *= 0.65;
	}

	function onTurnEnd()
	{
		this.applyDamage();
	}

	function onWaitTurn()
	{
		this.applyDamage();
	}

	function applyDamage()
	{
		if (this.m.LastRoundApplied != ::Time.getRound())
		{
			this.m.LastRoundApplied = ::Time.getRound();
			this.spawnIcon("status_effect_55", this.getContainer().getActor().getTile());

			local hitInfo = clone ::Const.Tactical.HitInfo;
			hitInfo.DamageRegular = this.getDamage();
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = ::Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			this.getContainer().getActor().onDamageReceived(this.getContainer().getActor(), this, hitInfo);
		}
	}

});

