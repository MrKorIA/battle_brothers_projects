this.xxitem_leftsaa_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 1,
		Skillcool = 1
	},
	function create()
	{
		this.m.ID = "actives.xxitem_leftsaa_skill";
		this.m.Name = "Двойная атака";
		this.m.Description = "Наносит два удара левым и правым оружием. Сила атаки зависит от значения основного оружия.";
		this.m.KilledString = "Cut down";
		this.m.Icon = "skills/active_07.png";
		this.m.IconDisabled = "skills/active_07_sw.png";
		this.m.Overlay = "active_07";
		this.m.SoundOnUse = [
			"sounds/combat/slash_01.wav",
			"sounds/combat/slash_02.wav",
			"sounds/combat/slash_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/slash_hit_01.wav",
			"sounds/combat/slash_hit_02.wav",
			"sounds/combat/slash_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 20;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 55;
		this.m.ChanceDisembowel = 54;
		this.m.ChanceSmash = 0;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5%[/color] Шанс попадания"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Перезарядка: 1 ход \nПерезарядка: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] ход"
		});
		return ret;
	}

	function isHidden()
	{
		local mainh = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (mainh != null && mainh.isDoubleGrippable() && mainh.getID() != "weapon.xxringblade" && mainh.getID() != "weapon.xxheavylance")
		{
			return false;
		}
		else if (this.m.Skillcool < this.m.Cooldown)
		{
			return false;
		}
		return true;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		local target = _targetTile.getEntity();
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 5, function ( _skill )
		{
			if (_user.isAlive() && target.isAlive())
			{
				_skill.attackEntity(_user, target);
			}
			_skill.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectChop);
		}.bindenv(this), this);
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 300, function ( _skill )
		{
			if (_user.isAlive() && target.isAlive())
			{
				_skill.attackEntity(_user, target);
			}
			_skill.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSlash);
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, this.getContainer().getActor().getPos());
		}.bindenv(this), this);
		return true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local actor = this.getContainer().getActor();
			local mainh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (mainh != null)
			{
				this.m.DirectDamageMult = mainh.m.DirectDamageMult;
			}
			_properties.MeleeSkill -= 5;
		}
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
		return true;
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

