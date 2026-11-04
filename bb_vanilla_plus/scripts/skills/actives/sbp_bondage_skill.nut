this.sbp_bondage_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_bondage_skill";
		this.m.Name = "Мастерство маны";
		this.m.Icon = "ui/xxp26.png";
		this.m.Description = "Когда обе руки пусты, урон от магии увеличивается. Чем выше ваш текущий показатель «Решимость», тем сильнее эффект.";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast + 100;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
		this.m.IsHidden = false;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Список магических навыков: Огненный шар, Пламенная волна, Армагеддон, Электрический шок, Гроза, Шаровая Молния, Штормовая сила, Ледяной Взрыв, Болотная Бомба"
		});
		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		local a = _skill.getID();
		if (a == "actives.sb_electric_skill" || a == "actives.sb_fireball_skill" || a == "actives.sb_flamewave_skill" || a == "actives.sb_fonature_skill" ||
		a == "actives.sb_frostblast_skill" || a == "actives.sb_gale_skill" || a == "actives.sb_manaforce_skill" || a == "actives.sb_puri_skill" ||
		a == "actives.sb_rock_skill" || a == "actives.sb_uproot_skill" || a == "actives.sbq6_bigfire_skill" || a == "actives.sb_pull_skill" || a == "actives.sb_waterbomb_skill")
		{
			local actor = this.getContainer().getActor();
			local mainh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			local offh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
			local rr = actor.getCurrentProperties().getBravery() * 0.008;
			if (rr > 2)
			{
				rr = 2;
			}
			if (mainh == null && offh == null && rr > 0)
			{
				if (a == "actives.sb_manaforce_skill")
				{
					_properties.RangedDamageMult += rr / 2;
				}
				else
				{
					_properties.RangedDamageMult += rr;
				}
			}
		}
	}

});

