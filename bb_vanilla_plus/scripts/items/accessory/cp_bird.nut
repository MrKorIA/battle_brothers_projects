this.cp_bird <- this.inherit("scripts/items/accessory/accessory", {
	m = {
		// Config
		IsReleasedOnTakingDamage = true,
		ReleasedIcon = "tools/falcon_released.png",
		DefaultIcon = "",
		DefaultSound = [],
		DefaultVolume = 1.0,

		// Private
		IsReleased = false,
	},

	function create()
	{
		this.accessory.create();
		// this.m.ID = "accessory.falcon";
		this.m.Name = "TODO";
		this.m.Description = "TODO.";
		this.m.SlotType = ::Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = false;
		this.m.IconLarge = "";
		this.m.DefaultVolume = ::Const.Sound.Volume.Inventory;
	}

	function getTooltip()
	{
		local tooltip = this.accessory.getTooltip();

		if (this.m.IsReleasedOnTakingDamage)
		{
			tooltip.push({
				id = 9,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "Будет автоматически отменён без каких-либо последствий, если персонаж получит урон."
			});
		}

		return tooltip;
	}

	function getName()
	{
		if (this.m.IsReleased)
		{
			return this.item.getName() + " (выпущен)";
		}
		else
		{
			return this.item.getName();
		}
	}

	function isAllowedInBag()
	{
		return false;
	}

	function onCombatFinished()
	{
		this.setReleased(false);
	}

	function onEquip()
	{
		this.accessory.onEquip();
		if (this.m.IsReleasedOnTakingDamage)
		{
			local skill = ::new("scripts/skills/special/cp_bird_auto_release");	// Birds will be released automatically
			skill.setItem(this);
			this.addSkill(skill);
		}
	}

	function playInventorySound( _eventType )
	{
		if (this.m.DefaultSound.len() != 0)
		{
			::Sound.play(::MSU.Array.rand(this.m.DefaultSound), this.m.DefaultVolume);
		}
	}

// New Functions
	function isReleased()
	{
		return this.m.IsReleased;
	}

	function setReleased( _r )
	{
		this.m.IsReleased = _r;

		if (this.m.IsReleased)
		{
			this.m.Icon = this.m.ReleasedIcon;
		}
		else
		{
			this.m.Icon = this.m.DefaultIcon;
		}
	}

});

