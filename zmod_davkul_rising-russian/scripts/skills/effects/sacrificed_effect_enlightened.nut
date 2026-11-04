this.sacrificed_effect_enlightened <- this.inherit("scripts/skills/skill", {
	m = {
	},
	function create()
	{
		this.m.ID = "effects.sacrificed_effect_enlightened";
		this.m.Name = "Просвещён";
		this.m.Icon = "ui/injury/injury_permanent_icon_03.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "";
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
			rs
		];
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		actor.m.SoundPitch = 0.7;
		local sprite = actor.addSprite("duelistEyes");
		sprite.setHorizontalFlipping(true);
		sprite.Visible = true;
		sprite.setBrush("cultist_rage_eyes");
		sprite.Alpha = 200;
		sprite.varySaturation(0.3);
		switch(actor.m.Type){
			case this.Const.EntityType.Cultist_Acolyte:
				actor.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
				actor.m.Skills.add(this.new("scripts/skills/perks/perk_duelist"));
				break;
			case this.Const.EntityType.Cultist_Fanatic:
				actor.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
				actor.m.Skills.add(this.new("scripts/skills/perks/perk_duelist"));
				break;
			case this.Const.EntityType.Cultist_Defiler:
				actor.m.Skills.add(this.new("scripts/skills/perks/perk_mastery_polearm"));
				actor.m.Skills.add(this.new("scripts/skills/perks/perk_colossus"));
				actor.m.Skills.add(this.new("scripts/skills/perks/perk_sundering_strikes"));
				break;
			default:
			    break;
		}
		actor.m.Name = "Просвещённый " + actor.getName()
		this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(actor) + " был просвещён!");
		
	}

});

