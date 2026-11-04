this.xxitem_heavylanceaa_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.thrust";
		this.m.Name = "Lance Thrust";
		this.m.Description = "A powerful thrust attack.";
		this.m.Icon = "skills/active_04.png";
		this.m.IconDisabled = "skills/active_04_sw.png";
		this.m.Overlay = "active_04";
		this.m.SoundOnUse = [
			"sounds/combat/split_01.wav",
			"sounds/combat/split_02.wav",
			"sounds/combat/split_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/split_hit_01.wav",
			"sounds/combat/split_hit_02.wav",
			"sounds/combat/split_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.HitChanceBonus = 10;
		this.m.DirectDamageMult = 0.4;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "While Single Grip: +30 Damage, +10% Chance to Hit"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Polearm/Spear mastery effect: -2 Fatigue cost."
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		local a = 0;
		a += _properties.IsSpecializedInPolearms ? 1 : 0;
		a += _properties.IsSpecializedInSpears ? 1 : 0;
		this.m.FatigueCost = 15 - (a * 2);
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectThrust);
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local ii = this.getContainer().getActor().getItems();
			local main = ii.getItemAtSlot(this.Const.ItemSlot.Mainhand);
			local off = ii.getItemAtSlot(this.Const.ItemSlot.Offhand);
			if (main != null && off == null && main.isDoubleGrippable()) {} else
			{
				_properties.MeleeSkill += 10;
				_properties.DamageRegularMin += 30;
				_properties.DamageRegularMax += 30;
			}
		}
	}

});

