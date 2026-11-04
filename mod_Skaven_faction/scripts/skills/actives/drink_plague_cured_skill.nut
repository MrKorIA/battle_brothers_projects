this.drink_plague_cured_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Item = null
	},
	function setItem( _i )
	{
		this.m.Item = this.WeakTableRef(_i);
	}

	function create()
	{
		this.m.ID = "actives.drink_plague_cured";
		this.m.Name = "Выпить или передать лекарство от чумы";
		this.m.Description = "Передайте союзнику рядом или выпейте сами лекарство от чумы, чтобы снять любые чумные эффекты. Не может использоваться в ближнем бою, и у получающего предмет должна быть свободная ячейка в сумке.";
		this.m.Icon = "skills/rat_plague_cured_active.png";
		this.m.IconDisabled = "skills/rat_plague_cured_active_sw.png";
		this.m.Overlay = "rat_plague_cured_active";
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
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 5;
		this.m.MinRange = 0;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Снимает эффект статуса \'Чума\'"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт невосприимчивость к Чуме на 3 хода"
			}
		];

		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Не может быть использовано, так как этот персонаж в ближнем бою[/color]"
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

		local target = _targetTile.getEntity();

		if (!this.m.Container.getActor().isAlliedWith(target))
		{
			return false;
		}

		if (target.getID() != _originTile.getEntity().getID())
		{
			if (!target.getItems().hasEmptySlot(this.Const.ItemSlot.Bag))
			{
				return false;
			}

			return true;
		}
		else
		{
			return true;
		}
	}

	function onUse( _user, _targetTile )
	{
		local user = _targetTile.getEntity();
		this.spawnIcon("rat_status_effect_02", _targetTile);

		if (_user.getID() == user.getID())
		{

			while (user.getSkills().hasSkill("effects.rat_plague"))
			{
				user.getSkills().removeByID("effects.rat_plague");
			}

			user.getSkills().add(this.new("scripts/skills/effects/plague_cured_effect"));

			if (!user.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " выпивает лекарство от чумы");
			}

			if (this.m.Item != null && !this.m.Item.isNull())
			{
				this.m.Item.removeSelf();
			}

			this.Const.Tactical.Common.checkDrugEffect(user);
		}
		else
		{
			if (!_user.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " передаёт лекарство от чумы персонажу" + this.Const.UI.getColorizedEntityName(user));
			}

			this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
			local item = this.m.Item.get();
			_user.getItems().removeFromBag(item);
			user.getItems().addToBag(item);
		}

		return true;
	}

});

