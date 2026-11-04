this.ai_horsecharge <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = true
	},
	function create()
	{
		this.m.ID = "actives.wolf_bite";
		this.m.Name = "Мощный рывок";
		this.m.Description = "";
		this.m.Overlay = "active_55";
		this.m.SoundOnUse = [
			"sounds/fantasyhorse/fantasyhorse_galloping_01.wav",
			"sounds/fantasyhorse/fantasyhorse_galloping_02.wav",
			"sounds/fantasyhorse/fantasyhorse_galloping_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/strike_down_hit_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.DirectDamageMult = 0.4;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 1;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.Delay = 25;
	}

	function onUse( _user, _targetTile )
	{
		this.m.IsSpent = true;
		local target = _targetTile.getEntity();
		local knockToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);

		if (knockToTile == null || target.getCurrentProperties().IsImmuneToKnockBackAndGrab || target.getCurrentProperties().IsRooted)
		{
			this.Tactical.getShaker().shake(target, _user.getTile(), 4);
			return false;
		}

		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " moved " + this.Const.UI.getColorizedEntityName(target));
		}

		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has staggered " + this.Const.UI.getColorizedEntityName(target) + " for one turn");
		}
		target.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));

		this.getContainer().setBusy(true);
		local skills = target.getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");
		local overwhelm = this.getContainer().getSkillByID("perk.overwhelm");
		if (overwhelm != null)
		{
			overwhelm.onTargetHit(this, target, this.Const.BodyPart.Body, 0, 0);
		}
		local damage = this.Math.rand(30, 50);
		local p = _user.getCurrentProperties();
		local tag = {
			Attacker = _user,
			TargetTile = _targetTile,
			Skill = this
		};
		target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
		this.Tactical.getNavigator().teleport(target, knockToTile, this.onKnockedDown, tag, true, 1.2);
		return true;
	}

	function onKnockedDown( _entity, _tag )
	{
		if (_tag.Attacker.isAlive() && !_tag.Attacker.isDying() && _entity.isAlive() && !_entity.isDying() && _entity.isAttackable())
		{
			_tag.Skill.spawnAttackEffect(_entity.getTile(), this.Const.Tactical.AttackEffectSplit);
			_tag.Skill.attackEntity(_tag.Attacker, _entity);
			this.Sound.play("sounds/combat/split_01.wav", this.Const.Sound.Volume.Skill, _entity.getPos());
		}
		if (_tag.Attacker.isAlive() && _tag.TargetTile.IsEmpty)
		{
			_tag.Attacker.setCurrentMovementType(this.Const.Tactical.MovementType.Default);
			this.Tactical.getNavigator().teleport(_tag.Attacker, _tag.TargetTile, null, null, false, 3);
		}
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		local dir = _userTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local knockToTile = _targetTile.getNextTile(dir);

			if (knockToTile.IsEmpty && this.Math.abs(knockToTile.Level - _userTile.Level) <= 1)
			{
				return knockToTile;
			}
		}

		local altdir = dir - 1 >= 0 ? dir - 1 : 5;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && this.Math.abs(knockToTile.Level - _userTile.Level) <= 1)
			{
				return knockToTile;
			}
		}

		altdir = dir + 1 <= 5 ? dir + 1 : 0;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && this.Math.abs(knockToTile.Level - _userTile.Level) <= 1)
			{
				return knockToTile;
			}
		}

		return null;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local actor = this.getContainer().getActor();
			local item = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			local dmg = this.Math.rand(70, 90);
			if (item != null && item.getID() == "weapon.xxheavylance")
			{
				dmg = this.Math.rand(100, 110);
			}
			_properties.DamageRegularMin = dmg;
			_properties.DamageRegularMax = dmg;
			_properties.MeleeSkill += 10;
		}
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			return false;
		}
		else if (this.m.IsSpent)
		{
			return false;
		}
		return true;
	}

	function onTurnStart()
	{
		if (this.Math.rand(1, 100) <= this.m.Delay)
		{
			this.m.IsSpent = false;
		}
	}

});

