this.legend_violent_decomposition_skill <- this.inherit("scripts/skills/skill", {
	m = {
		// base damage of the explosion
		MinDamage = 15,
		MaxDamage = 55,
		ArmorDamageMult = 0.65,
	},
	function create()
	{
		this.m.ID = "actives.legend_violent_decomposition";
		this.m.Name = "Губительный распад";
		this.m.Icon = "skills/violent_decomposition.png";
		this.m.IconDisabled = "skills/violent_decomposition_bw.png";
		this.m.Overlay = "violent_decomposition";
		this.m.SoundOnUse = [
		 	"sounds/combat/violent_decomposition.wav"
		];

		this.m.SoundOnHit = [
			"sounds/enemies/necromancer_01.wav",
			"sounds/enemies/necromancer_02.wav",
			"sounds/enemies/necromancer_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted + 105;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 25;
		this.m.MinRange = 2;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 8;
	}

	function getDescription()
	{
		return "Исказить и перегрузить тёмную силу, удерживающую плоть одного из ваших созданных слуг. Заражённый мертвец взорвётся в конце своего хода на следующем раунде, нанося сокрушительный урон в радиусе одной клетки вокруг себя. Чем меньше ОЗ осталось у марионетки в момент взрыва, тем разрушительнее будет детонация. Если противник успеет уничтожить слугу до взрыва, эффект рассеется.";
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultTooltip();

		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность в [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] клеток"
		});

		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (!this.getContainer().getActor().isAlliedWith(target))
		{
			return false;
		}

		if (!target.getFlags().has("mold_minion"))
		{
			return false;
		}

		if (!target.isAlive())
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local properties = this.getContainer().buildPropertiesForUse(this, null);
		local effect = new("scripts/skills/effects/legend_violent_decomposition_effect");
		effect.setDamage({
            MaxDamage = this.m.MaxDamage,
            MinDamage = this.m.MinDamage,
            DirectDamageMult = this.m.DirectDamageMult,
            ArmorDamageMult = this.m.ArmorDamageMult,
            TotalDamageMult = properties.DamageTotalMult, // you can remove this line if you don't want total damage multiplier to be applied in damage calculation
        });
        effect.setActorID(_user.getID());
        target.getSkills().add(effect);

		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " запустил губительное разложение на " + this.Const.UI.getColorizedEntityName(target) + ", он взорвётся на следующий ход.");
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMax = this.m.MaxDamage;
			_properties.DamageRegularMin = this.m.MinRange;
			_properties.DamageArmorMult = this.m.ArmorDamageMult;
			// properties.DamageTotalMult = 1.0;
			// remove comment of the line above to make this skill no longer be affected by total damage multiplier
		}
	}

});
