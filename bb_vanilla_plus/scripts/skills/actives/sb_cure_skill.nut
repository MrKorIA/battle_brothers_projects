this.sb_cure_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 2
	},
	function create()
	{
		this.m.ID = "actives.sb_cure_skill";
		this.m.Name = "16. Боевое Лечение.";
		this.m.Description = "Устраняет различные негативные эффекты. \n[color=#8f1e1e]Requirements:[/color] 99 крон";
		this.m.Icon = "ui/xx65.png";
		this.m.IconDisabled = "ui/xx65_sw.png";
		this.m.Overlay = "active_96";
		this.m.SoundOnUse = [
			"sounds/combat/drink_01.wav",
			"sounds/combat/drink_02.wav",
			"sounds/combat/drink_03.wav"
		];
		this.m.SoundVolume = 2.1;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Удалены эффекты: \n#Повреждения, возникающие с течением времени, #Кислота, #Яд гоблинов, #Стан, #пОшеломление, #Шататься, #Различные дебаффы"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Бинты и противоядие в сумке: используйте оба предмета. Восстанавливает 50 HP. Снижает усталость на 50. Избавляет от полу- и временных травм. Иммунитет к отравлению и кровотечению на 3–5 ходов."
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Можно использовать [color=#8f1e1e]" + this.m.Skillcharge + "[/color] еще раз в этом бою."
		});
		if (this.Tactical.isActive())
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/icons/asset_money.png",
				text = "Собственный [color=#e6b71e]" + this.World.Assets.getMoney() + "[/color] крон"
			});
		}
		return ret;
	}

	function getCursorForTile( _tile )
	{
		return this.Const.UI.Cursor.Drink;
	}

	function onUse( _user, _targetTile )
	{
		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " on " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()));
		}
		this.m.Skillcharge = this.m.Skillcharge - 1
		this.World.Assets.addMoney(-99);
		local target = _targetTile.getEntity();
		local itemz = _user.m.Items;
		local checkera = 0;
		local checkerb = 0;
		local checkerai;
		local checkerbi;
		while (target.getSkills().hasSkill("effects.bleeding"))
		{
			target.getSkills().removeByID("effects.bleeding");
		}
		while (target.getSkills().hasSkill("effects.spider_poison"))
		{
			target.getSkills().removeByID("effects.spider_poison");
		}
		while (target.getSkills().hasSkill("effects.goblin_poison"))
		{
			target.getSkills().removeByID("effects.goblin_poison");
		}
		while (target.getSkills().hasSkill("effects.acid"))
		{
			target.getSkills().removeByID("effects.acid");
		}
		target.getSkills().removeByType(this.Const.SkillType.DamageOverTime);
		target.getSkills().removeByID("effects.stunned");
		target.getSkills().removeByID("effects.dazed");
		target.getSkills().removeByID("effects.staggered");
		target.getSkills().removeByID("effects.chilled");
		target.getSkills().removeByID("effects.charmed");
		target.getSkills().removeByID("effects.disarmed");
		target.getSkills().removeByID("effects.distracted");
		target.getSkills().removeByID("effects.hex_slave");
		target.getSkills().removeByID("effects.horrified");
		target.getSkills().removeByID("effects.insect_swarm");
		target.getSkills().removeByID("effects.overwhelmed");
		target.getSkills().removeByID("effects.withered");
		target.getSkills().removeByID("effects.ai_weak_effect");
		target.getSkills().removeByID("effects.ai_soaked_effect");
		target.getSkills().removeByID("effects.sbq8_domi_effect");
		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			for( local j = 0; j < this.Const.ItemSlotSpaces[i]; j = ++j )
			{
				local citem = itemz.m.Items[i][j];
				if (citem != null && citem != -1)
				{
					if (citem.getID() == "accessory.bandage" && checkera == 0)
					{
						checkera = 1;
						checkerai = citem;
					}
					if (citem.getID() == "accessory.antidote" && checkerb == 0)
					{
						checkerb = 1;
						checkerbi = citem;
					}
				}
			}
		}
		if (checkera == 1 && checkerb == 1)
		{
			local target = _targetTile.getEntity();
			target.getSkills().removeByType(this.Const.SkillType.TemporaryInjury);
			target.getSkills().removeByType(this.Const.SkillType.SemiInjury);
			target.setHitpoints(this.Math.min(target.getHitpointsMax(), target.getHitpoints() + 50));
			target.setFatigue(this.Math.max(0, target.getFatigue() - 50));
			target.getSkills().removeByID("effects.ai_anti_effect");
			local xsk = this.new("scripts/skills/effects/ai_anti_effect");
			target.getSkills().add(xsk);
			xsk.setTurns(this.Math.rand(3, 5));
			_user.getItems().removeFromBag(checkerai);
			_user.getItems().removeFromBag(checkerbi);
		}
		target.setDirty(true);
		target.onUpdateInjuryLayer();
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
		return true;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}
		if (!this.m.Container.getActor().isAlliedWith(_targetTile.getEntity()))
		{
			return false;
		}
		return true;
	}

	function isUsable()
	{
		if (this.m.Skillcharge <= 0)
		{
			return false;
		}
		if (this.World.Assets.getMoney() < 99)
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
		this.m.Skillcharge = 2;
	}

});

