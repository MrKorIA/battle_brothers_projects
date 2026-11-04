this.player_summon_rat_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.player_summon_rat";
		this.m.Name = "Зов скавенов";
		this.m.Description = "Слыша призыв к битве, крысиные стаи кишат из каждой трещины и расщелины, чтобы пожирать своих врагов.";
		this.m.Icon = "skills/summon_rat_active.png";
		this.m.IconDisabled = "skills/summon_rat_active_sw.png";
		this.m.Overlay = "summon_rat_active";
		this.m.SoundOnUse = [
			"sounds/enemies/rat_spell.wav"
		];
		this.m.SoundVolume = 3.1;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 16;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
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
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			}
		];
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Призывает [color=" + this.Const.UI.Color.PositiveValue + "]1[/color] крысиную стаю каждые 4 хода"
		});
		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().hasSkill("effects.player_summon_rat");
	}

	function onUse( _user, _targetTile )
	{
		if (!this.getContainer().hasSkill("effects.player_summon_rat"))
		{
			this.m.Container.add(this.new("scripts/skills/effects/player_summon_rat_effect"));
			return true;
		}

		return false;
	}

});

