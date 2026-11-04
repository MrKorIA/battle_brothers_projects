this.sacrificed_effect_enemy <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 1,
		RoundAdded = null,
		IsHighPriest = false
	},
	function create()
	{
		this.m.ID = "effects.sacrified_enemy";
		this.m.Name = "Ослеплён";
		this.m.Icon = "ui/injury/injury_permanent_icon_03.png";
		this.m.IconMini = "blinded_effect_mini";
		this.m.Overlay = "blinded_effect";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Этот персонаж ослеплён тёмной магией жертвоприношений. Эффект пройдёт через [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] ход(а,ов).";
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
				id = 12,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Слепота (-5 к обзору)[/color]"
			},	
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] к урону от ударов в ближнем бою"
			},	
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] к защите в ближнем бою"
			}
		];
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		this.m.TurnsLeft = 1
		this.m.RoundAdded = this.Time.getRound()
	}

	function onRefresh()
	{
		local actor = this.getContainer().getActor();
		this.m.TurnsLeft += 1
		this.m.RoundAdded = this.Time.getRound()
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		if (this.m.TurnsLeft != 0)
		{
			if (this.m.IsHighPriest && actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory) != null && actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory).m.ID != "accessory.sacrificial_collar"){
				_properties.ActionPoints -= 3;
			}

			_properties.Vision = this.Math.max(1, _properties.Vision-5);
			_properties.MeleeSkill -= 10
			_properties.MeleeDefense -= 10
	   	}
	}

	function onTurnEnd()
	{
		if (this.m.RoundAdded == this.Time.getRound()) return
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}


});

