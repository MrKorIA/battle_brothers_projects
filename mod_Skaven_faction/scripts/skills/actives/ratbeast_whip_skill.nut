this.ratbeast_whip_skill <- this.inherit("scripts/skills/skill", {
	m = {
		SoundsA = [
			"sounds/combat/whip_bleed_01.wav",
			"sounds/combat/whip_bleed_02.wav",
			"sounds/combat/whip_bleed_03.wav"
		],
		SoundsB = [
			"sounds/combat/whip_hit_01.wav",
			"sounds/combat/whip_hit_02.wav",
			"sounds/combat/whip_hit_03.wav",
			"sounds/combat/whip_hit_04.wav"
		]
	},
	function create()
	{
		this.m.ID = "actives.ratbeastwhip";
		this.m.Name = "Тяжёлый хлыст";
		this.m.Description = "Щёлкайте хлыстом на значительном расстоянии, чтобы наносить накапливающийся чумной урон. Довольно неэффективно против брони.";
		this.m.KilledString = "Засечён до смерти";
		this.m.Icon = "skills/rat_whip_active_02.png";
		this.m.IconDisabled = "skills/rat_whip_active_02_sw.png";
		this.m.Overlay = "rat_whip_active_02";
		this.m.SoundOnUse = [
			"sounds/combat/whip_01.wav",
			"sounds/combat/whip_02.wav",
			"sounds/combat/whip_03.wav"
		];
		this.m.SoundOnHit = [];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.1;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 4;
	}

	function addResources()
	{
		foreach( r in this.m.SoundsA )
		{
			this.Tactical.addResource(r);
		}

		foreach( r in this.m.SoundsB )
		{
			this.Tactical.addResource(r);
		}
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		local dmg = 2 * (this.getContainer().getActor().getCurrentProperties().IsSpecializedInCleavers ? 10 : 5);
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность [color=" + this.Const.UI.Color.PositiveValue + "]4" + "[/color] клеток"
		});
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Вызывает заболевание чумной болезнью, наносящее дополнительно [color=" + this.Const.UI.Color.PositiveValue + "]2[/color] чумного урона за ход, в течение 6 ходов"
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInCleavers ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local success = this.attackEntity(_user, _targetTile.getEntity());

		if (!_user.isAlive() || _user.isDying())
		{
			return;
		}

		if (success && !_targetTile.IsEmpty)
		{
			if (!target.isAlive() || target.isDying())
			{
				if (!target.getFlags().has("rat")&& !target.getCurrentProperties().IsImmuneToPlague)
				{
					this.Sound.play(this.m.SoundsA[this.Math.rand(0, this.m.SoundsA.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
				}
				else
				{
					this.Sound.play(this.m.SoundsB[this.Math.rand(0, this.m.SoundsB.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
				}
			}
			else if (!target.getCurrentProperties().IsImmuneToPlague && !target.getFlags().has("rat"))
			{
				target.getSkills().add(this.new("scripts/skills/effects/rat_plague_effect"));
				this.Sound.play(this.m.SoundsA[this.Math.rand(0, this.m.SoundsA.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
			}
			else
			{
				this.Sound.play(this.m.SoundsB[this.Math.rand(0, this.m.SoundsB.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
			}
		}

		return success;
	}

});

