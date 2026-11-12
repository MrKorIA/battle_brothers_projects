// Скрытый эффект брони из варп-осколков: следит за убийствами носителя и в конце
// боя превращает доспех в следующую стадию (01 → 02 → 03 → 04). Конфигурация
// (Mode / NextArmorScript) задаётся в onEquip соответствующего файла брони.
// Улучшение происходит в onCombatFinished: скилловый контейнер в этот момент
// IsUpdating — remove/add скиллов откладываются контейнером самостоятельно
// (skill_container.remove → removeSelf, add → SkillsToAdd), поэтому замена
// предмета здесь безопасна. Условие: носитель выжил и сам нанёс убивающий удар.
this.warp_shard_upgrade_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Mode = 0, // 1 — чемпион скавенов (минибосс фракции Rat), 2 — морозный утёсник, 3 — чемпион орков (минибосс фракции Orcs)
		NextArmorScript = "",
		PendingUpgrade = false
	},
	function create()
	{
		this.m.ID = "effects.warp_shard_upgrade";
		this.m.Name = "Варп-эволюция";
		this.m.Description = "";
		this.m.Icon = "";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsHidden = true;
		this.m.IsActive = false;
		this.m.IsStacking = false;
	}

	function onCombatStarted()
	{
		this.m.PendingUpgrade = false;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (this.m.PendingUpgrade || this.m.Mode == 0)
		{
			return;
		}

		local match = false;

		if (this.m.Mode == 2)
		{
			// «снежный тролль» — морозный утёсник
			match = _targetEntity.getType() == this.Const.EntityType.UnholdFrost;
		}
		else
		{
			// чемпион фракции: минибосс-спрайт (bust_miniboss) + тип фракции
			local faction = this.World.FactionManager.getFaction(_targetEntity.getFaction());

			if (faction == null)
			{
				return;
			}

			local factionType = faction.getType();
			local miniboss = _targetEntity.getSprite("miniboss");
			local isChampion = miniboss != null && miniboss.Visible;

			if (this.m.Mode == 1)
			{
				match = isChampion && factionType == this.Const.FactionType.Rat;
			}
			else if (this.m.Mode == 3)
			{
				match = isChampion && factionType == this.Const.FactionType.Orcs;
			}
		}

		if (match)
		{
			this.m.PendingUpgrade = true;
		}
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();

		if (!this.m.PendingUpgrade)
		{
			return;
		}

		local actor = this.getContainer().getActor();

		if (actor == null || actor.isNull() || !actor.isAlive())
		{
			return;
		}

		local oldItem = this.getItem();

		if (oldItem == null || oldItem.getContainer() == null || this.m.NextArmorScript == "")
		{
			return;
		}

		local items = actor.getItems();

		// броня должна быть надета ИМЕННО на этого актёра (защита от сиротского
		// эффекта, оставшегося после снятия брони вне unequip)
		if (oldItem.getContainer() != items)
		{
			return;
		}

		local newItem = this.new(this.m.NextArmorScript);
		newItem.setCondition(this.Math.max(1, this.Math.min(oldItem.getCondition(), newItem.getConditionMax())));
		items.unequip(oldItem);
		oldItem.removeSelf();
		items.equip(newItem);
		this.m.PendingUpgrade = false;
	}

});
