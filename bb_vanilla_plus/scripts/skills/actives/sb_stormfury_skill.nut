this.sb_stormfury_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sb_stormfury_skill";
		this.m.Name = "63. Ярость бури";
		this.m.Description = "Наносит урон только врагам в радиусе 1 клетки. Это умение всегда наносит максимальный урон. (Умение ближнего боя)\n[color=#8f1e1e]Требования:[/color] Оружие ближнего боя";
		this.m.Icon = "ui/xx60.png";
		this.m.IconDisabled = "ui/xx60_sw.png";
		this.m.Overlay = "active_rand";
		this.m.SoundOnUse = [
			"sounds/combat/hand_hit_01.wav",
			"sounds/combat/hand_hit_02.wav",
			"sounds/combat/hand_hit_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/overhead_strike_hit_01.wav",
			"sounds/combat/overhead_strike_hit_02.wav",
			"sounds/combat/overhead_strike_hit_03.wav"
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
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 40;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 44;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 33;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Двуручное оружие ближнего боя: [color=" + this.Const.UI.Color.PositiveValue + "]110%[/color] Ущерб, \nОдноручное оружие ближнего боя: [color=" + this.Const.UI.Color.PositiveValue + "]100%[/color] Ущерб"
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		local ownTile = this.m.Container.getActor().getTile();
		local rr = 0;
		this.spawnAttackEffect(ownTile, this.Const.Tactical.AttackEffectThresh);
		for( local i = 5; i >= 0; i = --i )
		{
			if (!ownTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = ownTile.getNextTile(i);
				rr = rr + 100;
				this.Time.scheduleEvent(this.TimeUnit.Virtual, rr, function ( _skill )
				{
					_skill.spawnAttackEffect(tile, this.Const.Tactical.AttackEffectSlash);
					_skill.spawnAttackEffect(tile, this.Const.Tactical.AttackEffectThrust);
					this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, this.getContainer().getActor().getPos());
				}.bindenv(this), this);
				if (!tile.IsEmpty && tile.getEntity().isAttackable() && !tile.getEntity().isAlliedWith(_user) && this.Math.abs(tile.Level - ownTile.Level) <= 1)
				{
					this.Time.scheduleEvent(this.TimeUnit.Virtual, 700, function ( _skill )
					{
						if (_user.isAlive() && tile.getEntity().isAlive())
						{
							_skill.attackEntity(_user, tile.getEntity(), false)
						}
						_skill.spawnAttackEffect(tile, this.Const.Tactical.AttackEffectSlash);
						_skill.spawnAttackEffect(tile, this.Const.Tactical.AttackEffectThrust);
					}.bindenv(this), this);
					if (!_user.isAlive() || _user.isDying())
					{
						break;
					}
				}
			}
		}
		return true;
	}

	function onTargetSelected( _targetTile )
	{
		local ownTile = this.m.Container.getActor().getTile();

		for( local i = 0; i != 6; i = ++i )
		{
			if (!ownTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = ownTile.getNextTile(i);

				if (this.Math.abs(tile.Level - ownTile.Level) <= 1)
				{
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
				}
			}
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local mainh = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (mainh != null && mainh.isItemType(this.Const.Items.ItemType.MeleeWeapon))
			{
				this.m.DirectDamageMult = mainh.m.DirectDamageMult;
				if ( mainh.m.RegularDamageMax > mainh.m.RegularDamage)
				{
					_properties.DamageRegularMin += mainh.m.RegularDamageMax - mainh.m.RegularDamage;
				}
				if (mainh.isItemType(this.Const.Items.ItemType.TwoHanded))
				{
					_properties.MeleeDamageMult *= 1.1;
				}
				else
				if (mainh.isItemType(this.Const.Items.ItemType.OneHanded))
				{
					_properties.MeleeDamageMult *= 1.0;
				}
			}
		}
	}

	function isHidden()
	{
		if (this.m.Container.getActor().isPlacedOnMap())
		{
			local actor = this.getContainer().getActor();
			local mainh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (mainh != null && mainh.isItemType(this.Const.Items.ItemType.MeleeWeapon))
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
		local actor = this.getContainer().getActor();
		local mainh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (mainh != null && mainh.isItemType(this.Const.Items.ItemType.MeleeWeapon))
		{
			return true;
		}
		return false;
	}

});

