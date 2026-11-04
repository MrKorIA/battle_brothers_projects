this.ai_gutsbuff <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.ai_gutsbuff";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsStacking = false;
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getActor().getHitpoints() <= this.getContainer().getActor().getHitpointsMax() * 0.5)
		{
			_properties.DamageTotalMult *= 1.2;
			_properties.MeleeSkill += -10;
			_properties.MeleeDefense += -30;
			_properties.ActionPoints += 9;
			_properties.MovementAPCostAdditional += 1;
			this.getContainer().getActor().getSprite("head").setBrush("bust_helmet_232");
			this.getContainer().getActor().getSprite("head").Saturation = 0.1;
			this.getContainer().getActor().getSprite("head").Color = this.createColor("#9c9c9c");
			this.getContainer().getActor().getSprite("hair").setHorizontalFlipping(true);
			this.getContainer().getActor().getSprite("hair").setBrush("zombie_rage_eyes");
			this.getContainer().getActor().getSprite("hair").Saturation = 1;
			this.getContainer().getActor().getSprite("hair").Visible = true;
			this.getContainer().getActor().getSprite("hair").Color = this.createColor("#fff200");
			this.getContainer().getActor().setSpriteOffset("hair", this.createVec(-4.5, 5.5));
			this.getContainer().getActor().getSprite("tattoo_head").setHorizontalFlipping(false);
			this.getContainer().getActor().getSprite("tattoo_head").setBrush("bust_direwolf_03_head");
			this.getContainer().getActor().getSprite("tattoo_head").Saturation = 0.1;
			this.getContainer().getActor().getSprite("tattoo_head").Color = this.createColor("#9c9c9c");
			this.getContainer().getActor().setSpriteOffset("tattoo_head", this.createVec(10, 20));
			this.getContainer().getActor().setAlwaysApplySpriteOffset(true);
		}
	}

});

