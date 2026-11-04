this.sbp_challenger_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 1
	},
	function create()
	{
		this.m.ID = "actives.sbp_challenger_skill";
		this.m.Name = "85. Претендент (пассивный)";
		this.m.Icon = "ui/xxp19.png";
		this.m.Description = "Когда вы убиваете врага-человека с 450 или более очками опыта, вы и все союзники восстанавливаете 35 очков усталости и получаете 350 крон. Действует один раз за сражение.";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast + 100;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
		this.m.IsHidden = false;
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
			}
		];
		return ret;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (!this.getContainer().getActor().isPlacedOnMap() || !this.getContainer().getActor().isAlive())
		{
			return;
		}
		else if (_targetEntity.getFlags().has("human") && _targetEntity.getXPValue() >= 450 && this.m.Skillcharge > 0)
		{
			this.m.Skillcharge = this.m.Skillcharge - 1;
			local actor = this.getContainer().getActor();
			local actors = this.Tactical.Entities.getAllInstancesAsArray();
			foreach( a in actors )
			{
				if (a.getFaction() == actor.getFaction())
				{
					a.setFatigue(this.Math.max(0, a.getFatigue() - 35));
					this.spawnIcon("status_effect_73", a.getTile());
				}
			}
			this.World.Assets.addMoney(350);
			this.Sound.play("sounds/combat/indomitable_01.wav", this.Const.Sound.Volume.Skill * 0.9, actor.getPos());
		}
	}

	function onCombatFinished()
	{
		this.m.Skillcharge = 1;
	}

});

