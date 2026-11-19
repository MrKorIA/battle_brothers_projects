::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/grow_shield_skill", function ( q )
{
	q.create =  @(__original) function()
	{
		__original();
		m.Name = "Вырастить щит";
		m.Description = "Отрастить свою кору, создавая защитный слой";
		m.Icon = "skills/active_121.png";
		m.IconDisabled = "skills/active_121_sw.png";
		m.Overlay = "active_121";
		m.Order = ::Const.SkillOrder.NonTargeted + 1;
	}

	q.getTooltip = @() function()
	{
		local ret = getDefaultUtilityTooltip();

		ret.push({
			id = 4,
			type = "text",
			icon = "/ui/icons/melee_defense.png",
			text = "Дает [color=" + ::Const.UI.Color.PositiveValue + "]+20[/color] к защите ближнего и дальнего боя, в виде щита с [color=" + ::Const.UI.Color.PositiveValue + "]32[/color] единицами прочности"
		});

		if (getContainer().getActor().getCurrentProperties().IsSpecializedInHammers)
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Получает эффект [color=" + ::Const.UI.Color.PositiveValue + "]Стена щитов[/color] бесплатно при выращивании нового щита"
			});
		
		return ret;
	}

	q.onAfterUpdate <- function( _properties )
	{
		m.FatigueCostMult = _properties.IsSpecializedInHammers ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		local ret = __original(_user, _targetTile);

		if (_user.getCurrentProperties().IsSpecializedInHammers) {
			::Time.scheduleEvent(::TimeUnit.Virtual, 2000, function ( _itsMe ) {
				local shield = _itsMe.getOffhandItem();
				if (shield != null && shield.isItemType(::Const.Items.ItemType.Shield))
					_itsMe.getSkills().add(::new("scripts/skills/effects/shieldwall_effect"));
			}, _user);
		}
		
		return ret;
	}
	
});
