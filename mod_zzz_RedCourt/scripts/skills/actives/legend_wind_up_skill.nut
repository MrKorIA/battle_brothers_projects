this.legend_wind_up_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Item = null
	},
	function setItem( _i )
	{
		this.m.Item = this.WeakTableRef(_i);
	}

	function create()
	{
		this.m.ID = "actives.legend_wind_up";
		this.m.Name = "Замах";
		this.m.Description = "Оцените врага, чтобы подготовить следующую атаку и отбросить его назад.";
		this.m.KilledString = "Рассечён";
		this.m.Icon = "skills/active_10.png";
		this.m.IconDisabled = "skills/active_10_sw.png";
		this.m.Overlay = "mini_smackdown_circle";
		this.m.SoundOnUse = [
			"sounds/combat/rupture_blood_01.wav",
			"sounds/combat/rupture_blood_02.wav",
			"sounds/combat/rupture_blood_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = true;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.ActionPointCost = 2;
		this.m.FatigueCost = 15;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
		this.m.IsHidden = false;
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
			}
		];

		if (this.getContainer().hasSkill("effects.legend_knockback_prepared"))
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "Этот персонаж уже готов к сокрушительному удару."
			});
			return ret;
		}

		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local hasMelee = item == null || item.isItemType(this.Const.Items.ItemType.MeleeWeapon);

		if (hasMelee)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Следующая атака отбросит врага назад и ошеломит его в случае попадания; в противном случае эффект пропадёт впустую."
			});
		}
		else if (item.isWeaponType(this.Const.Items.WeaponType.Sling) && item.isItemType(this.Const.Items.ItemType.OneHanded))
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Следующая атака нанесёт увеличенный урон с повышенным пробиванием брони в зависимости от текущей инициативы атакующего."
			});
		}
		else
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "Требуется оружие ближнего боя, атака без оружия или одноручная праща."
			});
		}

		return ret;
	}

	function isHidden()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local hasMelee = item == null || item.isItemType(this.Const.Items.ItemType.MeleeWeapon) || (item.isWeaponType(this.Const.Items.WeaponType.Sling) && item.isItemType(this.Const.Items.ItemType.OneHanded));
		return !((!this.Tactical.isActive() || !this.getContainer().hasSkill("effects.legend_knockback_prepared")) && hasMelee);
	}

	function onUse( _user, _targetTile )
	{
		if (this.m.Item != null && !this.m.Item.isNull() && item.isWeaponType(this.Const.Items.WeaponType.Sling) && item.isItemType(this.Const.Items.ItemType.OneHanded))
		{
            this.getContainer().getSkills().add(this.new("scripts/skills/effects/legend_prepare_bullet_effect"));
		}
		else
		{
			this.getContainer().getSkills().add(this.new("scripts/skills/effects/legend_knockback_prepared_effect"));
		}

		if (this.m.Item != null && !this.m.Item.isNull())
			this.m.Item.removeSelf();

		return true;
	}

	function onAfterUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local item = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (item == null)
			return;

		if (item.isItemType(this.Const.Items.ItemType.TwoHanded))
			this.m.ActionPointCost = 1;
		else if (item.isItemType(this.Const.Items.ItemType.OneHanded))
			this.m.ActionPointCost = 2;
	}
});
