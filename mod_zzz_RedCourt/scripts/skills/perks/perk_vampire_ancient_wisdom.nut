this.perk_vampire_ancient_wisdom <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.vampire_ancient_wisdom";
		this.m.Name = this.Const.Strings.PerkName.VampireAncientWisdom;
		this.m.Description = this.Const.Strings.PerkDescription.VampireAncientWisdom;
		this.m.Icon = "ui/perks/vampire_ancient_wisdom.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function getTooltip()
	{
		local chance = this.getChance();
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
				id = 7,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Получает только [color=" + this.Const.UI.Color.PositiveValue + "]" + chance + "%[/color] от любого урона по ОЗ от атак"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Бонус увеличивается на [color=" + this.Const.UI.Color.PositiveValue + "]5%[/color] за каждый уровень вплоть до 12-го"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.HitpointsMult *= 1.30; //+30%
	}

	function getChance()
	{
		return 0.05 * this.Math.max(this.getContainer().getActor().getLevel(), 12); // TO DO: bro gets +5% DR and 5% DR per level up to 12 (total 60%)
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker != null && _attacker.getID() == this.getContainer().getActor().getID() || _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
		{
			return;
		}

		local chance = this.getChance();
		_properties.DamageReceivedRegularMult *= (1.0 - chance);
	}

});
