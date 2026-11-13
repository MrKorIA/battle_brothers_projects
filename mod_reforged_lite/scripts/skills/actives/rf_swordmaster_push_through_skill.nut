this.rf_swordmaster_push_through_skill <- ::inherit("scripts/skills/actives/line_breaker", {
	m = {},
	function create()
	{
		this.line_breaker.create();
		this.m.ID = "actives.rf_swordmaster_push_through";
		this.m.Name = "Прорвать ряды";
		this.m.Description = "Использовать силу мышц и навыки борьбы, чтобы одним действием отбросить цель и занять её место."
		this.m.Icon = "skills/rf_swordmaster_push_through_skill.png";
		this.m.IconDisabled = "skills/rf_swordmaster_push_through_skill_sw.png";
		this.m.Overlay = "rf_swordmaster_push_through_skill";
		this.m.SoundOnUse = [
			"sounds/combat/indomitable_01.wav",
			"sounds/combat/indomitable_02.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/knockback_hit_01.wav",
			"sounds/combat/knockback_hit_02.wav",
			"sounds/combat/knockback_hit_03.wav"
		];
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.LineBreaker;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		local actor = this.getContainer().getActor();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Накладывает на цель эффект [Ошеломлён|Skill+staggered_effect]")
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Выполняет свободную атаку умением " + ::ReforgedLite.NestedTooltips.getNestedSkillName(this.getContainer().getAttackOfOpportunity()) + " по цели")
		});

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Если атака персонажа успешна, он сразу же бесплатно применит умение [Прорвать строй|Skill+line_breaker] на цель")
		});

		if (actor.getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorNegative("Нельзя использовать при [обездвиживании|Concept.Rooted]"))
			});
		}

		if (!this.isEnabled())
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::MSU.Text.colorNegative("Требуется меч")
			});
		}

		return ret;
	}

	function isEnabled()
	{
		if (this.getContainer().getActor().isDisarmed())
			return false;

		local weapon = this.getContainer().getActor().getMainhandItem();
		return weapon != null && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Sword);
	}

	function isUsable()
	{
		local actor = this.getContainer().getActor();
		return this.line_breaker.isUsable() && !actor.getCurrentProperties().IsRooted && !actor.getCurrentProperties().IsStunned && this.isEnabled();
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();

		target.getSkills().add(::new("scripts/skills/effects/staggered_effect"));
		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " отбрасывает и ошеломляет противника " + ::Const.UI.getColorizedEntityName(target));
		}

		local aoo = this.getContainer().getAttackOfOpportunity();
		local overlay = aoo.m.Overlay;
		aoo.m.Overlay = "";
		local success = aoo.useForFree(_targetTile);
		aoo.m.Overlay = overlay;

		if (success)
		{
			local tag = {
				User = _user,
				TargetTile = _targetTile,
				TargetEntity = target
			}
			// Doing this.line_breaker.onUse here directly doesn't work properly.
			// The target gets knocked back by Linebreaker, but the attacker does not move to the target tile.
			// Using scheduleEvent even with a delay of 1 is enough to make it work properly. No idea why.
			::Time.scheduleEvent(::TimeUnit.Virtual, 1, this.onPushThrough.bindenv(this), tag);
		}

		return success;
	}

	function onPushThrough( _tag )
	{
		if (_tag.TargetEntity.isAlive())
			this.line_breaker.onUse(_tag.User, _tag.TargetTile);
		else
			::Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, null, null, false);
	}
});
