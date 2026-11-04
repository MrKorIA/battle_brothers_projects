this.xxitem_potion_nice <- this.inherit("scripts/skills/skill", {
	m = {
		Item = null
	},
	function setItem( _i )
	{
		this.m.Item = this.WeakTableRef(_i);
	}

	function create()
	{
		this.m.ID = "actives.xxitem_potion_nice";
		this.m.Name = "Используйте зелье Феникса";
		this.m.Description = "Полностью восстанавливает здоровье и прочность текущего снаряжения для себя или союзника во время боя.";
		this.m.Icon = "ui/xx84.png";
		this.m.IconDisabled = "ui/xx84_sw.png";
		this.m.Overlay = "active_141";
		this.m.SoundOnUse = [
			"sounds/combat/drink_01.wav",
			"sounds/combat/drink_02.wav",
			"sounds/combat/drink_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = true;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 1;
		this.m.MinRange = 0;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Не может быть использован, поскольку этот персонаж участвует в ближнем бою.[/color]"
			});
		}
		return ret;
	}

	function getCursorForTile( _tile )
	{
		if (_tile.ID == this.getContainer().getActor().getTile().ID)
		{
			return this.Const.UI.Cursor.Drink;
		}
		else
		{
			return this.Const.UI.Cursor.Give;
		}
	}

	function isUsable()
	{
		if (!this.Tactical.isActive())
		{
			return false;
		}

		local tile = this.getContainer().getActor().getTile();
		return this.skill.isUsable() && !tile.hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
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

	function onUse( _user, _targetTile )
	{
		local actor = _targetTile.getEntity();
		local helmet = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		local armor = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		local weapon = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local shield = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		local ammo = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);
		actor.setHitpoints(actor.getHitpointsMax());
		actor.setFatigue(0);
		if (helmet != null)
		{
			helmet.setArmor(helmet.getArmorMax());
		}
		if (armor != null)
		{
			armor.setArmor(armor.getArmorMax());
		}
		if (weapon != null)
		{
			weapon.setCondition(this.Math.floor(weapon.m.ConditionMax));
			weapon.setAmmo(this.Math.floor(weapon.m.AmmoMax));
		}
		if (shield != null)
		{
			shield.setCondition(this.Math.floor(shield.m.ConditionMax));
		}
		if (ammo != null)
		{
			ammo.setAmmo(this.Math.floor(ammo.m.AmmoMax));
		}
		if (!actor.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " drinks phoenix potion");
		}
		if (this.m.Item != null && !this.m.Item.isNull())
		{
			this.m.Item.removeSelf();
		}
		local fakeb = this.new("scripts/skills/actives/ai_fakebuff");
		fakeb.m.Overlay = "status_effect_90";
		actor.getSkills().add(fakeb);
		return true;
	}

});

