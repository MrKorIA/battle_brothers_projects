this.mod_ghost_skull_XP_collecter <- ::inherit("scripts/skills/skill", {
	m = {
		XP_collected = 0,
	},
	function create()
	{
		this.m.ID = "special.mod_ghost_skull_XP_collecter";
		this.m.Name = "ХЗ";
		this.m.Description = "";
		this.m.Icon = "";
		this.m.Type = ::Const.SkillType.Special;
		this.m.Order = ::Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function getMult()
	{
		return (this.getContainer().getActor().getCurrentProperties().IsSpecializedInGhostSkull ? 1.25 : 1.0) * this.m.Item.getEfficiency() * 0.01;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		::logInfo("mod_ghost_skull_XP_collecter обрабатывает убийство");

		if (_targetEntity.getXPValue() <= 0) return;

		if (_targetEntity.getFlags().has("give_no_xp")) return;

		local mult = this.getMult();
		local XP = _targetEntity.getXPValue();
		local SP = ::Math.floor(XP * mult);
		::logInfo("Опыта от противника: " + XP);
		::logInfo("Соотношения опыта к очкам души: " + ::Math.floor(mult * 100));
		::logInfo("Получено очков души: " + SP);
		this.m.XP_collected += SP;
		this.m.Item.addXP(SP);
	}

	function onCombatStarted()
	{
		this.m.XP_collected = 0;
	}

	function onCombatFinished()
	{
		if (this.m.XP_collected > 0 || this.m.Item.isCurseRemoved()) return;

		this.m.Item.useXP(::ModLegendaryKriegsgeistLocation.ModSettings.getSetting("loss_in_battle").getValue());
	}

});

