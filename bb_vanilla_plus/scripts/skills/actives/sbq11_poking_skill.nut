this.sbq11_poking_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Poke = 20
	},
	function create()
	{
		this.m.ID = "actives.sbq11_poking_skill";
		this.m.Name = "118. Протыкание";
		this.m.Description = "Быстрая атака с случайным штрафом к шансу попадания в каждом бою. (Навык ближнего боя)\n[color=#8f1e1e]Требование:[/color] Кинжал / Одноручный меч / Одноручное копье";
		this.m.KilledString = "Stabbed";
		this.m.Icon = "skills/active_13.png";
		this.m.IconDisabled = "skills/active_13_sw.png";
		this.m.Overlay = "active_13";
		this.m.SoundOnUse = [
			"sounds/combat/stab_01.wav",
			"sounds/combat/stab_02.wav",
			"sounds/combat/stab_03.wav"
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/combat/stab_hit_01.wav",
			"sounds/combat/stab_hit_02.wav",
			"sounds/combat/stab_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.1;
		this.m.ActionPointCost = 2;
		this.m.FatigueCost = 8;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "-" + this.m.Poke + "% Шанс попадания штраф"
		});
		return ret;
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
			local actor = this.getContainer().getActor();
			local mainh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (mainh != null && mainh.isItemType(this.Const.Items.ItemType.RangedWeapon))
			{
				this.m.DirectDamageMult = mainh.m.DirectDamageMult;
			}
			local ak = actor.getSkills();
			if (ak.hasSkill("actives.slash") || ak.hasSkill("actives.thrust"))
			{
				_properties.DamageTotalMult *= 0.7;
			}
			else if (ak.hasSkill("actives.stab"))
			{
				_properties.DamageTotalMult *= 0.9;
			}
			_properties.MeleeSkill -= this.m.Poke;
		}
	}

	function isHidden()
	{
		if (this.m.Container.getActor().isPlacedOnMap())
		{
			local ak = this.getContainer();
			if (ak.hasSkill("actives.slash") || ak.hasSkill("actives.thrust") || ak.hasSkill("actives.stab"))
			{
				local mainh = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
				if (mainh != null && mainh.isItemType(this.Const.Items.ItemType.MeleeWeapon) && mainh.isItemType(this.Const.Items.ItemType.OneHanded))
				{
					return false;
				}
			}
			return true;
		}
		return false;
	}

	function onCombatStarted()
	{
		this.m.Poke = this.Math.rand(10, 30);
	}

});

