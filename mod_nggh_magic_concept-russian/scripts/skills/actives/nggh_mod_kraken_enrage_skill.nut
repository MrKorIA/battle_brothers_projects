this.nggh_mod_kraken_enrage_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.kraken_enrage";
		this.m.Name = "Ярость";
		this.m.Description = "Приходит в ярость, становясь всё более свирепым.";
		this.m.Icon = "ui/perks/perk_madden_active.png";
		this.m.IconDisabled = "ui/perks/perk_madden_active_sw.png";
		this.m.Overlay = "perk_madden_active";
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getTooltip()
	{
		return [
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
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Приходит в [color=" + ::Const.UI.Color.NegativeValue + "]ярость[/color]"
			},
		];
	}

	function isHidden()
	{
		return this.getContainer().getActor().isEnraged();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onUse( _user, _targetTile )
	{
		_user.setEnraged(true);

		if (!_user.isHiddenToPlayer())
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " приходит в ярость");
		}

		return true;
	}

});

