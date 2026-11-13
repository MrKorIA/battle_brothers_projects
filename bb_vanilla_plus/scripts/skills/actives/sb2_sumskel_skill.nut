this.sb2_sumskel_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 1
	},
	function create()
	{
		this.m.ID = "actives.sb2_sumskel_skill";
		this.m.Name = "66. Нечестивое благословение";
		this.m.Description = "Сделайте одного из своих скелетных приспешников навсегда сильнее с помощью нечестивой магии.  \n[color=#8f1e1e]Требования:[/color] Можно использовать только против дружественных призываемых скелетов.";
		this.m.Icon = "ui/xx26.png";
		this.m.IconDisabled = "ui/xx26_sw.png";
		this.m.SoundOnUse = [
			"sounds/enemies/swarm_of_insects_01.wav",
			"sounds/enemies/swarm_of_insects_02.wav",
			"sounds/enemies/swarm_of_insects_03.wav"
		];
		this.m.SoundVolume = 1.2;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 230;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 3,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Add +10 Hit chance, Bonus HP based on the caster\'s resolve, Action point become 9"
		});
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Can be used [color=#8f1e1e]" + this.m.Skillcharge + "[/color] more times in this battle."
		});
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (!target.getFlags().has("skeleton_minion"))
		{
			return false;
		}

		if (target.getFlags().has("skeleton_powerup"))
		{
			return false;
		}

		if (!target.isAlliedWith(this.getContainer().getActor()))
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcharge = this.m.Skillcharge - 1
		for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, _user.getTile(), this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, _targetTile, this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
		}
		local effect = {
			Delay = 0,
			Quantity = 60,
			LifeTimeQuantity = 60,
			SpawnRate = 50,
			Brushes = [
			"blood_red_01",
			"blood_red_02",
			"blood_red_03",
			"blood_red_04",
			"blood_red_05",
			"blood_red_06",
			"blood_red_07"
			],
		Stages = [
			{
				LifeTimeMin = 0.2,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 0.5,
				ScaleMax = 0.8,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 30,
				VelocityMax = 50,
				DirectionMin = this.createVec(-0.5, 0.4),
				DirectionMax = this.createVec(0.5, 0.4),
				SpawnOffsetMin = this.createVec(-30, -30),
				SpawnOffsetMax = this.createVec(30, 0)
			},
			{
				LifeTimeMin = 1.4,
				LifeTimeMax = 1.4,
				ColorMin = this.createColor("ffffffff"),
				ColorMax = this.createColor("ffffffff"),
				ScaleMin = 0.5,
				ScaleMax = 0.8,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 70,
				VelocityMax = 140,
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 0)
			},
			{
				LifeTimeMin = 0.2,
				LifeTimeMax = 0.3,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 0.5,
				ScaleMax = 0.8,
				VelocityMin = 30,
				VelocityMax = 50,
				ForceMin = this.createVec(0, -60),
				ForceMax = this.createVec(0, -60)
			}
		]
		};
		this.Tactical.spawnParticleEffect(false, effect.Brushes, _targetTile, effect.Delay, effect.Quantity * 0.5, effect.LifeTimeQuantity * 0.5, effect.SpawnRate, effect.Stages, this.createVec(0, 40));

		local actor = _targetTile.getEntity();
		actor.getFlags().add("skeleton_powerup");
		actor.getBaseProperties().MeleeSkill += 10;
		actor.getBaseProperties().ActionPoints = 9;
		local gg = this.Math.max(_user.getCurrentProperties().getBravery() * 1, 1);
		actor.getBaseProperties().Hitpoints += this.Math.min(gg, 200);
		actor.setHitpoints(actor.getHitpointsMax());
		actor.setName("Драугр");

		local body = actor.getSprite("body");
		body.setBrush(this.Const.Items.Default.PlayerNakedBody);
		body.Saturation = 0.5;
		body.varySaturation(0.2);
		body.Color = this.createColor("#c1ddaa");
		body.varyColor(0.05, 0.05, 0.05);

		local tattoo_body = actor.getSprite("tattoo_body");
		tattoo_body.setBrush("bust_body_9" + this.Math.rand(0, 5));
		tattoo_body.setBrightness(0.9);

		local head = actor.getSprite("head");
		head.setBrush(this.Const.Faces.WildMale[this.Math.rand(0, this.Const.Faces.WildMale.len() - 1)]);
		head.Saturation = body.Saturation;
		head.Color = body.Color;

		local beard = actor.getSprite("beard");
		if (this.Math.rand(1, 100) <= 50)
		{
			beard.setBrush("beard_" + this.Const.HairColors.All[this.Math.rand(0, this.Const.HairColors.All.len() - 1)] + "_" + this.Math.rand(12, 14) + "_top");
		}

		local tattoo_head = actor.getSprite("tattoo_head");
		tattoo_head.setBrush("bust_skeleton_face_0" + this.Math.rand(3, 5));
		tattoo_head.setBrightness(0.9);

		local hair = actor.getSprite("hair");
		local hair_type = [
			"195",
			"195",
			"196",
			"01",
			"52"
		];
		hair_type = hair_type[this.Math.rand(0, hair_type.len() - 1)]
		hair.setBrush("bust_helmet_" + hair_type);
		hair.setBrightness(0.9);
		return true;
	}

	function isUsable()
	{
		if (this.m.Skillcharge <= 0)
		{
			return false;
		}

		return true;
	}

	function isHidden()
	{
		if (this.m.Skillcharge > 0)
		{
			return false;
		}

		return true;
	}

	function onCombatFinished()
	{
		this.m.Skillcharge = 1;
	}

});

