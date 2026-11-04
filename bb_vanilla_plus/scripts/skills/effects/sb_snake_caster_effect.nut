this.sb_snake_caster_effect <- this.inherit("scripts/skills/skill", {
	m = {
		OnRemoveCallback = null,
		OnRemoveCallbackData = null
	},
	function setOnRemoveCallback( _c, _d )
	{
		this.m.OnRemoveCallback = _c;
		this.m.OnRemoveCallbackData = _d;
	}

	function create()
	{
		this.m.ID = "effects.net";
		this.m.Name = "Спутанный (Кастер)";
		this.m.Description = "Этот персонаж запутался в огромном змее.";
		this.m.Icon = "skills/status_effect_113.png";
		this.m.IconMini = "status_effect_113_mini";
		this.m.Overlay = "status_effect_113";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
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
			{
				id = 9,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Unable to move[/color]"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Unable to use skills[/color]"
			}
		];
	}

	function onAdded()
	{
		this.Tactical.TurnSequenceBar.pushEntityBack(this.getContainer().getActor().getID());
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		local rooted = actor.getSprite("status_rooted");
		local rooted_back = actor.getSprite("status_rooted_back");
		if (this.m.OnRemoveCallback != null && !this.Tactical.Entities.isCombatFinished())
		{
			this.m.OnRemoveCallback(this.m.OnRemoveCallbackData);
		}
		else
		{
			rooted.Scale = 0.55;
			rooted.setBrush("");
			rooted.Visible = false;
			rooted_back.Scale = 0.55;
			rooted_back.setBrush("");
			rooted_back.Visible = false;
		}
	}

	function onDeath( _fatalityType )
	{
		this.onRemoved();
	}

	function onUpdate( _properties )
	{
		_properties.IsRooted = true;
		_properties.IsAbleToUseSkills = false;
		if (this.getContainer().getActor().getFaction() != this.Const.Faction.Player)
		{
			_properties.ActionPoints *= 0;
			_properties.InitiativeForTurnOrderAdditional = -100;
		}
	}

});

