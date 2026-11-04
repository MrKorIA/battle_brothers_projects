this.sb_bloodlust_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 1
	},
	function create()
	{
		this.m.ID = "effects.sb_bloodlust_effect";
		this.m.Name = "Жажда крови";
		this.m.Description = "[color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color] Урон в ближнем бою, [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Навык ближнего боя";
		this.m.Icon = "ui/perks/perk_36.png";
		this.m.IconMini = "perk_36_mini";
		this.m.Overlay = "perk_36";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		if (actor.hasSprite("permanent_injury_bld1"))
		{
			actor.getSprite("permanent_injury_bld1").Visible = false;
			actor.removeSprite("permanent_injury_bld1");
		}
		actor.addSprite("permanent_injury_bld1");
		actor.getSprite("permanent_injury_bld1").setBrush("bust_body_sunburn");
		actor.getSprite("permanent_injury_bld1").Visible = true;
		_properties.MeleeDamageMult += 0.2;
		_properties.MeleeSkill += 5;
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		if (actor.hasSprite("permanent_injury_bld1"))
		{
			actor.getSprite("permanent_injury_bld1").Visible = false;
			actor.removeSprite("permanent_injury_bld1");
		}
	}

	function onTurnEnd()
	{
		this.m.TurnsLeft = this.m.TurnsLeft - 1
		if (this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});

