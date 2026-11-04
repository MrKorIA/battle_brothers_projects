this.sbq1_propaganda_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbq1_propaganda_skill";
		this.m.Name = "108. Пропаганда";
		this.m.Description = "Влияйте на репутацию вашей группы наемников, участвуя в пропагандистских мероприятиях. Пропаганда может быть использована только один раз за сражение и может быть использована снова только после того, как вы примете участие в сражении и выиграете его. Перезарядка общая для всех. Высокий показатель репутации считается хорошим, а низкий — плохим.";
		this.m.Icon = "ui/xx77.png";
		this.m.IconDisabled = "ui/xx77_sw.png";
		this.m.Overlay = "status_effect_106";
		this.m.SoundOnUse = [
			"sounds/combat/taunt_01.wav",
			"sounds/combat/taunt_02.wav",
			"sounds/combat/taunt_03.wav",
			"sounds/combat/taunt_04.wav",
			"sounds/combat/taunt_05.wav"
		];
		this.m.SoundVolume = 2.2;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 20;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "При использовании на себе или союзнике: +1~2 к репутации, +5 к известности"
		});
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "При использовании на враге: -1~2 репутации, +5 славы"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Максимальное количество навыков, которые можно изучить с помощью книг навыков, становится 3."
		});
		return ret;
	}

	function getCursorForTile( _tile )
	{
		return this.Const.UI.Cursor.Give;
	}

	function onUse( _user, _targetTile )
	{
		local everyone = this.Tactical.Entities.getAllInstances();
		if (this.m.Container.getActor().isAlliedWith(_targetTile.getEntity()))
		{
			this.World.Assets.addMoralReputation(this.Math.rand(1, 2));
			this.World.Assets.addBusinessReputation(5);
			this.spawnIcon("morale_up", _targetTile);
		}
		else
		{
			this.World.Assets.addMoralReputation(this.Math.rand(-1, -2));
			this.World.Assets.addBusinessReputation(5);
			this.spawnIcon("morale_down", _targetTile);
		}
		foreach( ever in everyone )
		{
			foreach( e in ever )
			{
				if (e.getSkills().hasSkill("actives.sbq1_propaganda_skill") && !e.getFlags().has("propagander"))
				{
					e.getFlags().add("propagander");
				}
			}
		}
		return true;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (_targetTile.IsEmpty || !_targetTile.getEntity().isAlive() || _targetTile.getEntity().isDying())
		{
			return false;
		}
		return true;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else if (this.getContainer().getActor().getFlags().has("propagander"))
		{
			return false;
		}
		return true;
	}

	function onCombatFinished()
	{
		if (!this.getContainer().getActor().isPlacedOnMap() || !this.getContainer().getActor().isAlive())
		{
			return false;
		}
		local actor = this.getContainer().getActor();
		local gg = 0;
		local actors = this.Tactical.Entities.getAllInstances();
		foreach( i in actors )
		{
			foreach( a in i )
			{
				if (!a.isAlliedWith(actor))
				{
					gg = 1;
					break;
				}
			}
		}
		if (gg == 0)
		{
			this.getContainer().getActor().getFlags().remove("propagander")
		}
	}

});

