this.rf_unnerving_presence_effect <- ::inherit("scripts/skills/skill", {
	m = {
		Difficulty = -10
	},
	function create()
	{
		this.m.ID = "effects.rf_unnerving_presence";
		this.m.Name = "Нервирующее присутствие";
		this.m.Description = "Этого персонажа сопровождает облако незримого ужаса, подтачивающего рассудок любого, осмелившегося приблизится.";
		this.m.Icon = "skills/rf_unnerving_presence_effect.png";
		this.m.Overlay = "rf_unnerving_presence_effect";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		local difficultyText = this.m.Difficulty == 0 ? "" : format(" с %s [решимости|Concept.Bravery]", ::MSU.Text.colorizeValue(this.m.Difficulty, {AddSign = true}));
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = "Любой, кто закончит свой ход рядом с персонажем, будет вынужден пройти 0проверку боевого духа " + difficultyText
		});

		return ret;
	}

	function onActorSpawned( _actor )
	{
		if (!::MSU.isKindOf(_actor, "rf_draugr") && !_actor.getSkills().hasSkill("special.rf_unnerving_presence_manager"))
		{
			_actor.getSkills().add(::new("scripts/skills/special/rf_unnerving_presence_manager"));
		}
	}

	function onEnemyTurnEnd( _enemy )
	{
		if (_enemy.getMoraleState() == ::Const.MoraleState.Ignore)
			return;

		_enemy.checkMorale(-1, this.m.Difficulty, ::Const.MoraleCheckType.MentalAttack, this.m.Overlay);
	}
});
