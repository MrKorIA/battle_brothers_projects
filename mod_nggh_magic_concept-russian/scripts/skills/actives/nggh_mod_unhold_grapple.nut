this.nggh_mod_unhold_grapple <- this.inherit("scripts/skills/skill", {
	m = {
		DisarmChance = 50
		SmackCount = 3,
	},

	function create()
	{
		this.m.ID = "actives.unhold_grapple";
		this.m.Name = "Схватить";
		this.m.Description = "Хватает и удерживает цель или наносит 3 удара, размахивая ею, как игрушкой. Основная рука должна быть свободна.";
		this.m.Icon = "skills/grapple_square.png";
		this.m.IconDisabled = "skills/grapple_square_bw.png";
		this.m.Overlay = "active_grapple";
		this.m.SoundOnUse = [
			"sounds/combat/hand_01.wav",
			"sounds/combat/hand_02.wav",
			"sounds/combat/hand_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/hand_hit_01.wav",
			"sounds/combat/hand_hit_02.wav",
			"sounds/combat/hand_hit_03.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted + 1;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsTargetingActor = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.InjuriesOnBody = ::Const.Injury.BluntBody;
		this.m.InjuriesOnHead = ::Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.2;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 35;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
	}

	function isHidden()
	{
		return !::MSU.isNull(this.getContainer().getActor().getMainhandItem()) || this.skill.isHidden();
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInFists)
		{
			ret.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/icons/hitchance.png",
					text = "[color=" + ::Const.UI.Color.PositiveValue + "]+10%[/color] к шансу на попадание, благодаря мастерству рукопашного боя"
				},
				{
					id = 7,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Шанс [color=" + ::Const.UI.Color.PositiveValue + "]100%[/color] обезоружить противника при попадании, благодаря мастерству рукопашного боя"
				},
			]);
		}
		else
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Шанс [color=" + ::Const.UI.Color.PositiveValue + "]50%[/color] обезоружить противника"
			});
		}

		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит урон целям, не имеющим [color=" + ::Const.UI.Color.NegativeValue + "]невосприимчивости к отбрасыванию и захвату[/color]"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Может выкорчевывать деревья или поднимать камни"
			},
		]);

		return ret;
	}

	function equipTree( _user )
	{
		::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " срывает дерево и использует его как самодельное оружие");

		local main = _user.getMainhandItem();

		if (main != null)
			_user.getItems().unequip(main);

		local weapon = ::new("scripts/items/weapons/greenskins/" + ::MSU.Array.rand(["orc_wooden_club", "legend_bough"]));

		if (weapon.isItemType(::Const.Items.ItemType.TwoHanded)) {

			local off = _user.getOffhandItem();

			if (off != null)
				_user.getItems().unequip(off);

			_user.getItems().getData()[::Const.ItemSlot.Offhand][0] = null;
		}

		_user.getItems().getData()[::Const.ItemSlot.Mainhand][0] = null;
		local ret = _user.getItems().equip(weapon);
		weapon.setCondition(::Math.rand(8, 15) * 1.0);
		return ret;
	}

	function equipRock( _user )
	{
		::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " поднимает камень над землёй");

		local main = _user.getMainhandItem();

		if (main != null && main.isItemType(::Const.Items.ItemType.TwoHanded))
			_user.getItems().unequip(main);

		local off = _user.getOffhandItem();

		if (off != null)
			_user.getItems().unequip(off);

		_user.getItems().getData()[::Const.ItemSlot.Offhand][0] = null;
		return _user.getItems().equip(::new("scripts/items/weapons/nggh_mod_picked_up_rock"));
	}

	function grabOnObject( _user, _object )
	{
		local _tile = _object.getTile();
		local isTree = _object.isTree();

		_tile.removeObject();

		if (isTree) 
		{
			_tile.spawnObject("entity/tactical/objects/tree_sticks");
			return this.equipTree(_user);
		}
		
		::Tactical.clearBlockedTileHighlights();
		::Tactical.createBlockedTileHighlights();
		return this.equipRock(_user);
	}

	function onAfterUpdate( _properties )
	{
		if (!_properties.IsSpecializedInFists)
			return;

		this.m.FatigueCostMult *= this.Const.Combat.WeaponSpecFatigueMult;
	}

	function onCombatFinished()
	{
		local actor = this.getContainer().getActor();
		local main = actor.getMainhandItem();

		if (main != null)
			actor.getItems().unequip(main);

		local offhand = actor.getOffhandItem();

		if (offhand != null)
			actor.getItems().unequip(offhand);

		this.skill.onCombatFinished();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
			return false;

		if (_targetTile.IsEmpty)
			return false;

		local target = _targetTile.getEntity();

		if (::MSU.isNull(target))
			return false;

		if (!_targetTile.IsOccupiedByActor)
		{
			if (target.isTree() || target.isRock())
				return true;

			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		if (_targetTile.IsEmpty)
			return false;

		local target = _targetTile.getEntity();

		if (!_targetTile.IsOccupiedByActor)
			return this.grabOnObject(_user, target);

		local toHit = this.getHitchance(target);
		local rolled = ::Math.rand(1, 100);

		// this is treated as an attack
		target.onAttacked(_user);

		if (rolled > toHit)
		{
			target.onMissed(this.getContainer().getActor(), this);
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + ", используя умение '" + this.getName() + "', промахивается по персонажу " + ::Const.UI.getColorizedEntityName(target) + " (шанс: " + toHit + ", выпало: " + rolled + ").");
			return false;
		}

		local toKnock = target.getCurrentProperties().IsRooted || target.getCurrentProperties().IsImmuneToKnockBackAndGrab ? null : this.findTileToKnockBackTo(_user.getTile(), _targetTile);

		if (toKnock == null)
		{
			target.getSkills().add(::new("scripts/skills/effects/legend_grappled_effect"));

			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " схватил противника " + ::Const.UI.getColorizedEntityName(target) + " на два хода (шанс: " + toHit + ", выпало: " + rolled + ")");

			if (!target.getCurrentProperties().IsImmuneToDisarm && (::Math.rand(1, 100) <= this.m.DisarmChance || _user.getCurrentProperties().IsSpecializedInFists))
				target.getSkills().add(::new("scripts/skills/effects/disarmed_effect"));
			
			this.applyEffectToTarget( _user, target, _targetTile )
		}
		else
		{
			this.getContainer().setBusy(true);

			local tag = {
				User = _user,
				TargetEntity = target,
				TileToKnock = toKnock,
				Count = this.m.SmackCount
			};

			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " схватил противника " + ::Const.UI.getColorizedEntityName(target) + " и начинает дико размахивать им (шанс: " + toHit + ", выпало: " + rolled + ")");

			if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
				::Time.scheduleEvent(::TimeUnit.Virtual, this.m.Delay, this.onPerformAttack.bindenv(this), tag);
			else
				this.onPerformAttack(tag);
		}

		return true;
	}

	function onPerformAttack( _tag )
	{
		local _user = _tag.User;
		local target = _tag.TargetEntity;

		if (_tag.TileToKnock == null)
			return;

		local skills = target.getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");

		target.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);
		local properties = this.getContainer().buildPropertiesForUse(this, target);
		local defenderProperties = target.getSkills().buildPropertiesForDefense(_user, this);
		
		local tag = {
			User = _user,
			TargetEntity = target,
			TargetTile = _tag.TileToKnock,
			HitInfo = clone ::Const.Tactical.HitInfo,
			Count = _tag.Count,
		};

		this.processDamageCalculation(target, properties, defenderProperties, tag.HitInfo);
		::Tactical.getNavigator().teleport(target, _tag.TileToKnock, this.onKnockedDown.bindenv(this), tag, true);
	}

	function onKnockedDown( _entity, _tag )
	{
		if (this.m.SoundOnHit.len() != 0)
			::Sound.play(::MSU.Array.rand(this.m.SoundOnHit), ::Const.Sound.Volume.Skill, _entity.getPos());
		
		_entity.onDamageReceived(_tag.User, this, _tag.HitInfo);
		
		if (typeof _tag.User == "instance" && _tag.User.isNull() || !_tag.User.isAlive() || _tag.User.isDying())
			return;
		
		this.getContainer().onTargetHit(this, _entity, _tag.HitInfo.BodyPart, _tag.HitInfo.DamageRegular, 0);
		
		if (_entity.isAlive() || !_entity.isDying())
		{
			this.applyEffectToTarget(_tag.User, _entity, _entity.getTile());

			if (::Math.abs(_entity.getTile().Level - _tag.User.getTile().Level) <= 1)
				::Time.scheduleEvent(::TimeUnit.Virtual, 115, this.onFollowUp.bindenv(this), _tag);
		}
	}

	function onFollowUp( _tag )
	{
		if (--_tag.Count > 0)
		{
			local tile = this.findTileToKnockBackTo(_tag.User.getTile(), _tag.TargetTile);

			if (tile != null)
			{
				_tag.TileToKnock <- tile;
				::Time.scheduleEvent(::TimeUnit.Virtual, 200, this.onPerformAttack.bindenv(this), _tag);
				return;
			}
		}
		
		this.getContainer().setBusy(false);
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		local availableTiles = [];

		for( local i = 0; i < 6; ++i )
		{
			if (!_userTile.hasNextTile(i))
				continue;

			local flingToTile = _userTile.getNextTile(i);

			if (flingToTile.IsEmpty && flingToTile.Level <= _userTile.Level)
				availableTiles.push(flingToTile);
		}
		
		if (availableTiles.len() != 0)
			return ::MSU.Array.rand(availableTiles);

		return null;
	}

	function applyEffectToTarget( _user, _target, _targetTile )
	{
		if (_target.isNonCombatant() || !this.getContainer().hasSkill("perk.unhold_unarmed_training") || ::Math.rand(1, 100) > 25)
			return;

		_target.getSkills().add(::new("scripts/skills/effects/distracted_effect"));
	}

	function processDamageCalculation( _targetEntity, _properties, _defenderProperties, _hitInfo )
	{
		local damage = ::Const.Combat.FallingDamage + this.getAdditionalDamage(_targetEntity, _properties, _defenderProperties);
		local damageMult = _properties.MeleeDamageMult * _properties.DamageTotalMult;

		_hitInfo.DamageRegular = damage * damageMult;
		_hitInfo.DamageArmor = damage * damageMult;
		_hitInfo.DamageDirect = this.Math.minf(1.0, _properties.DamageDirectMult * (this.m.DirectDamageMult + _properties.DamageDirectAdd + _properties.DamageDirectMeleeAdd));
		_hitInfo.DamageFatigue = ::Const.Combat.FatigueReceivedPerHit * _properties.FatigueDealtPerHitMult;
		_hitInfo.DamageMinimum = _properties.DamageMinimum;
		_hitInfo.BodyPart = ::Math.rand(0, 1);
		_hitInfo.BodyDamageMult = _properties.DamageAgainstMult[_hitInfo.BodyPart];
		_hitInfo.FatalityChanceMult = _properties.FatalityChanceMult;
		_hitInfo.Injuries = _hitInfo.BodyPart == 0 ? this.m.InjuriesOnBody : this.m.InjuriesOnHead;
		_hitInfo.InjuryThresholdMult = _properties.ThresholdToInflictInjuryMult;
	}

	function getAdditionalDamage( _targetEntity, _properties, _defenderProperties )
	{
		local armor = 0;
		local a = _targetEntity.getHeadItem();

		if (a != null)
			armor += a.getArmor();

		local h = _targetEntity.getBodyItem();

		if (h != null)
			armor += h.getArmor();

		if (a == null && h == null)
			armor += ::Math.min(200, _targetEntity.getHitpoints() * 0.5);

		return ::Math.max(1, (_properties.IsSpecializedInFists ? 10 : 0) + armor * 0.05);
	}

	function getExpectedDamage( _target )
	{
		local actor = this.getContainer.getActor();
		local p = this.m.Container.buildPropertiesForUse(this, _target);
		local d = _target.getSkills().buildPropertiesForDefense(actor, this);
		local hitInfo = clone ::Const.Tactical.HitInfo;
		this.processDamageCalculation(_target, p, d, hitInfo);

		return {
			ArmorDamage = hitInfo.DamageArmor,
			DirectDamage = ::Math.floor(hitInfo.DamageRegular * hitInfo.DamageDirect),
			HitpointDamage = hitInfo.DamageRegular,
			TotalDamage = hitInfo.DamageArmor + hitInfo.DamageRegular
		};
	}

	function onGetHitFactors( _skill, _targetTile, _tooltip ) 
	{
		if (!_targetTile.IsOccupiedByActor || _skill != this)
			return;

		if (_targetTile.getEntity().getCurrentProperties().IsImmuneToKnockBackAndGrab) {
			_tooltip.push({
				icon = "ui/tooltips/negative.png",
				text = "Невосприимчив к отбрасыванию или захвату"
			});
			return;
		}

		if (_targetTile.getEntity().getCurrentProperties().IsRooted) {
			_tooltip.push({
				icon = "ui/tooltips/negative.png",
				text = "Обездвижен"
			});
			return;
		}

		local canKnock = this.findTileToKnockBackTo(this.getContainer().getActor().getTile(), _targetTile) == null;

		if (!canKnock) {
			_tooltip.push({
				icon = "ui/tooltips/negative.png",
				text = "Недостаточно места"
			});
			return;
		}

		local data = this.getExpectedDamage(_targetTile.getEntity());

		_tooltip.insert(0, {
			icon = "ui/icons/regular_damage.png",
			text = "[color=" + ::Const.UI.Color.DamageValue + "]10[/color] - [color=" + ::Const.UI.Color.DamageValue + "]" + data.HitpointDamage + "[/color] урона"
		});

		_tooltip.insert(1, {
			icon = "ui/icons/direct_damage.png",
			text = "[color=" + ::Const.UI.Color.DamageValue + "]0[/color] - [color=" + ::Const.UI.Color.DamageValue + "]" + data.DirectDamage + "[/color] урона, проникающего сквозь броню"
		});

		_tooltip.insert(2, {
			icon = "ui/icons/armor_damage.png",
			text = "[color=" + ::Const.UI.Color.DamageValue + "]10[/color] - [color=" + ::Const.UI.Color.DamageValue + "]" + data.ArmorDamage + "[/color] урона по броне"
		});
	}

});

