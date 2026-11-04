this.sbq23_rebuild_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 3
	},
	function create()
	{
		this.m.ID = "effects.sbq23_rebuild_effect";
		this.m.Name = "Rebuilding";
		this.m.Icon = "skills/status_effect_82.png";
		this.m.IconMini = "status_effect_82_mini";
		this.m.Overlay = "status_effect_82";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "This character takes more damage, and has very reduced melee and ranged defense. Cannot act for [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] turn(s).";
	}



	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		local aa = actor.getHitpointsMax() * 0.5;
		if (actor.getHitpoints() < aa)
		{
			actor.setHitpoints(aa);
		}
		local items = actor.getItems().getAllItems();
		foreach( item in items )
		{
			local slotType = item.getSlotType();
			if (slotType == this.Const.ItemSlot.Head || slotType == this.Const.ItemSlot.Body)
			{
				aa = item.getConditionMax() * 0.5;
				if (item.getCondition() <  aa)
				{
					item.setCondition(aa);
				}
				aa = item.getArmorMax() * 0.5;
				if (item.getArmor() <  aa)
				{
					item.setArmor(aa);
				}
			}
		}
		if (actor.hasSprite("status_stunned"))
		{
			actor.getSprite("status_stunned").Visible = false;
		}
		if (actor.hasSprite("closed_eyes"))
		{
			actor.getSprite("closed_eyes").Visible = false;
		}
		actor.setDirty(true);
		local effect = {
			Delay = 0,
			Quantity = 10,
			LifeTimeQuantity = 200,
			SpawnRate = 500,
			Brushes = [
				"sparkleflare_1",
				"sparkleflare_2"
			],
			Stages = [
				{
					LifeTimeMin = 0.2,
					LifeTimeMax = 0.4,
					ColorMin = this.createColor("fff4d9cc"),
					ColorMax = this.createColor("ffe091cc"),
					ScaleMin = 0.8,
					ScaleMax = 1.2,
					RotationMin = 0,
					RotationMax = 300,
					VelocityMin = 0,
					VelocityMax = 5,
					DirectionMin = this.createVec(-0.1, -0.1),
					DirectionMax = this.createVec(0.1, 0.1),
					SpawnOffsetMin = this.createVec(-50, -50),
					SpawnOffsetMax = this.createVec(50, 50),
					ForceMin = this.createVec(-20, -20), 
					ForceMax = this.createVec(20, 20)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.5,
					ColorMin = this.createColor("ffffff88"),
					ColorMax = this.createColor("ffffff00"),
					ScaleMin = 0.1,
					ScaleMax = 0.2,
					VelocityMin = 0,
					VelocityMax = 0,
					ForceMin = this.createVec(0, 0),
					ForceMax = this.createVec(0, 0)
				}
			]
		};
		this.Tactical.spawnParticleEffect(false, effect.Brushes, actor.getTile(), effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
		this.Sound.play("sounds/combat/taunt_0" + this.Math.rand(2, 3) + ".wav", 1.5, actor.getPos(), 1.2);
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		if (this.m.TurnsLeft != 0)
		{
			_properties.IsStunned = true;
			actor.setActionPoints(0);
			if (actor.hasSprite("status_stunned"))
			{
				actor.getSprite("status_stunned").setBrush("mind_control");
				actor.getSprite("status_stunned").Visible = true;
				if (actor.hasSprite("closed_eyes"))
				{
					actor.getSprite("closed_eyes").Visible = true;
				}
			}
			actor.setDirty(true);
		}
		else
		{
			if (actor.hasSprite("status_stunned"))
			{
				actor.getSprite("status_stunned").Visible = false;
			}
			if (actor.hasSprite("closed_eyes"))
			{
				actor.getSprite("closed_eyes").Visible = false;
			}
			actor.setDirty(true);
		}
		_properties.RangedSkillMult *= 0.01;
		_properties.MeleeDefenseMult *= 0.01;
		_properties.DamageReceivedTotalMult *= 2;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
			local actor = this.getContainer().getActor();
			if (actor.hasSprite("status_stunned"))
			{
				actor.getSprite("status_stunned").Visible = false;
			}
			actor.setDirty(true);
		}
	}

});

