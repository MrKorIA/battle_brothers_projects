this.sbq5_wrath_skill <- this.inherit("scripts/skills/skill", {
	m = {
		SkillFire = 0,
		Skillcharge = 1
	},
	function create()
	{
		this.m.ID = "actives.sbq5_wrath_skill";
		this.m.Name = "112. Гнев Давкула";
		this.m.Description = "После 3 ходов наносит боль всем врагам. Однако ваши ОЗ становятся равны 0 до тех пор, пока не активируется эффект этого навыка. Этот навык можно использовать только во время ближнего боя с врагом. \n[color=#8f1e1e]Требование:[/color] 299 Крон";
		this.m.Icon = "ui/xx79.png";
		this.m.IconDisabled = "ui/xx79_sw.png";
		this.m.Overlay = "active_102";
		this.m.SoundOnUse = [
			"sounds/combat/perfect_focus_01.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsAttack = true;
		this.m.ActionPointCost = 9;
		this.m.FatigueCost = 35;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Боль: теряет 10-50 здоровья в начале следующего хода. Этот эффект классифицируется как кровотечение, но не приводит к смерти."
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Может использоваться [color=#8f1e1e]" + this.m.Skillcharge + "[/color] еще несколько раз в этой битве."
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
		if (this.Tactical.isActive() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Этот навык можно использовать только во время ближнего боя.[/color]"
			});
		}
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.m.SkillFire = 1;
		this.m.Skillcharge = this.m.Skillcharge - 1
		this.World.Assets.addMoney(-299);
		local stun = this.new("scripts/skills/effects/ai_stun_effect");
		_user.getSkills().add(stun);
		stun.setTurns(2);
		if (_user.hasSprite("xwrath_eye"))
		{
			_user.getSprite("xwrath_eye").Visible = false;
			_user.removeSprite("xwrath_eye");
		}
		_user.addSprite("xwrath_eye");
		_user.getSprite("xwrath_eye").setBrush("zombie_rage_eyes");
		_user.getSprite("xwrath_eye").Visible = true;
		_user.getSprite("xwrath_eye").Color = this.createColor("#ffd000");
		if (_user.hasSprite("arms_icon"))
		{
			_user.removeSprite("arms_icon");
			_user.addSprite("arms_icon")
			_user.getItems().updateAppearance();
		}
		return true;
	}

	function fakeAffectedTiles()
	{
		local atile = this.getContainer().getActor().getTile();
		local ret = [
			atile
		];
		local size = this.Tactical.getMapSize();
		for( local x = 0; x < size.X; x = ++x )
		{
			for( local y = 0; y < size.Y; y = ++y )
			{
				if (atile.getDistanceTo(this.Tactical.getTileSquare(x, y)) == 9 && this.Tactical.getTileSquare(x, y) != atile)
				{
					ret.push(this.Tactical.getTileSquare(x, y));
				}
			}
		}
		return ret;
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		if (actor.isAlive() && this.m.SkillFire == 1)
		{
			local atile = actor.getTile();
			local tiles = this.fakeAffectedTiles();
			this.Tactical.spawnSpriteEffect("active_102", this.createColor("#ffffff"), atile, this.Const.Tactical.Settings.SkillOverlayOffsetX, this.Const.Tactical.Settings.SkillOverlayOffsetY, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration + this.m.Delay, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
			this.Sound.play("sounds/enemies/horror_spell_0" + this.Math.rand(1, 3) + ".wav", this.Const.Sound.Volume.Skill * 1.2, atile.Pos);
			this.Tactical.getCamera().quake(this.createVec(0, -1.0), 6.0, 0.16, 0.35);
			if (actor.hasSprite("xwrath_eye"))
			{
				actor.getSprite("xwrath_eye").Visible = false;
				actor.removeSprite("xwrath_eye");
			}
			foreach( t in tiles )
			{
				local flip = !this.m.IsProjectileRotated && e.getPos().X > actor.getPos().X;
				this.Tactical.spawnProjectileEffect("bust_body_bloodied_02", atile, t, 0.7, 2, false, flip);
				this.Tactical.spawnProjectileEffect("blood_splatter_dark_0" + this.Math.rand(1, 6), atile, t, 1.4 + (this.Math.rand(1, 3) * 0.1), 2, false, flip);
			}
			local targets = this.Tactical.Entities.getAllInstancesAsArray();
			foreach( target in targets )
			{
				if (actor.isAlive() && target.isAlive() && !actor.isAlliedWith(target))
				{
					local dmg = this.Math.rand(10, 50);
					local effect = this.new("scripts/skills/effects/ai_pain_effect");
					effect.m.Name = "Pain (" + dmg + " Damage)";
					effect.setDamage(dmg);
					target.getSkills().add(effect);
				}
			}
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " successfully casts the spell and activates its effect.");
		}
		this.m.SkillFire = this.Math.max(0, this.m.SkillFire - 1);
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		if (this.World.Assets.getMoney() < 299)
		{
			return false;
		}
		if (this.m.SkillFire != 0)
		{
			return false;
		}
		else if (this.m.Skillcharge <= 0)
		{
			return false;
		}
		else if (!this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
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
		this.m.SkillFire = 0;
		if (this.getContainer().getActor().hasSprite("xwrath_eye"))
		{
			this.getContainer().getActor().getSprite("xwrath_eye").Visible = false;
			this.getContainer().getActor().removeSprite("xwrath_eye");
		}
	}

});

