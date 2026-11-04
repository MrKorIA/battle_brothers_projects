this.sb_whirlwind_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 3,
		Skillcool = 3
	},
	function create()
	{
		this.m.ID = "actives.sb_whirlwind_skill";
		this.m.Name = "76. Атака вихря";
		this.m.Description = "Атакует только врагов в пределах 2 клеток. (Навык ближнего боя)\n[color=#8f1e1e]Требование:[/color] Одноручное оружие ближнего боя";
		this.m.Icon = "ui/xx28.png";
		this.m.IconDisabled = "ui/xx28_sw.png";
		this.m.SoundOnUse = [
			"sounds/combat/round_swing_hit_01.wav",
			"sounds/combat/round_swing_hit_02.wav",
			"sounds/combat/round_swing_hit_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/strike_hit_01.wav",
			"sounds/combat/strike_hit_02.wav",
			"sounds/combat/strike_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAOE = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 35;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.ChanceDecapitate = 44;
		this.m.ChanceDisembowel = 33;
		this.m.ChanceSmash = 11;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Ущерб: [color=" + this.Const.UI.Color.PositiveValue + "]110% текущего урона оружия[/color]"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Перезарядка: 3 хода \nПерезарядка: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] ход"
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		local myTile = _user.getTile();
		local actors = this.Tactical.Entities.getAllInstances();
		this.spawnAttackEffect(myTile, this.Const.Tactical.AttackEffectThresh2);

		this.Time.scheduleEvent(this.TimeUnit.Virtual, 175, function ( _skill )
		{
			this.spawnAttackEffect(myTile, this.Const.Tactical.AttackEffectThresh2);
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, this.getContainer().getActor().getPos());
		}.bindenv(this), this);

		this.Time.scheduleEvent(this.TimeUnit.Virtual, 350, function ( _skill )
		{
			this.spawnAttackEffect(myTile, this.Const.Tactical.AttackEffectThresh2);
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, this.getContainer().getActor().getPos());
		}.bindenv(this), this);

		this.Time.scheduleEvent(this.TimeUnit.Virtual, 525, function ( _skill )
		{
			foreach( i in actors )
			{
				foreach( a in i )
				{
					if (a.getID() == _user.getID())
					{
						continue;
					}
					if (myTile.getDistanceTo(a.getTile()) > 2)
					{
						continue;
					}
					if (_user.isAlive() && a.isAlive() && a.isAttackable() && !a.isAlliedWith(_user))
					{
						this.spawnAttackEffect(a.getTile(), this.Const.Tactical.AttackEffectSlash);
						this.attackEntity(_user, a);
					}
				}
			}
		}.bindenv(this), this);

		return true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageTotalMult *= 1.1;
			local actor = this.getContainer().getActor();
			local mainh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (mainh != null)
			{
				this.m.DirectDamageMult = mainh.m.DirectDamageMult;
			}
		}
	}

	function isHidden()
	{
		if (this.m.Container.getActor().isPlacedOnMap())
		{
			local actor = this.getContainer().getActor();
			local mainh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (mainh != null && mainh.isItemType(this.Const.Items.ItemType.MeleeWeapon) && mainh.isItemType(this.Const.Items.ItemType.OneHanded))
			{
				return false;
			}
			return true;
		}
		return false;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else if (this.m.Skillcool < this.m.Cooldown)
		{
			return false;
		}

		local mainh = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (mainh != null && mainh.isItemType(this.Const.Items.ItemType.MeleeWeapon) && mainh.isItemType(this.Const.Items.ItemType.OneHanded))
		{
			return true;
		}

		return false;
	}

	function onTurnStart()
	{
		this.m.Skillcool = this.m.Skillcool + 1;
	}

	function onCombatFinished()
	{
		this.m.Skillcool = this.m.Cooldown;
	}

});

