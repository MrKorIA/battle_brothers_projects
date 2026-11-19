this.nggh_mod_rune_night_vision <- ::inherit("scripts/items/legend_helmets/legend_helmet_upgrade", {
	m = {},
	function create()
	{
		this.legend_helmet_upgrade.create();
		this.m.ID = "legend_helmet_upgrade.legend_rune_night_vision";
		this.m.Type = ::Const.Items.HelmetUpgrades.Rune;
		this.m.Name = "Рунный знак шлема: Ночное зрение";
		this.m.Description = "Расписанный рунами камень, который может быть прикреплён к шлему персонажа.";
		this.m.ArmorDescription = "На персонажа больше не действует эффект 'Ночное время'.";
		this.m.Icon = "rune_sigils/rune_stone_2.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "layers/glow_runed_icon.png";
		this.m.OverlayIconLarge = "layers/glow_runed_icon.png";
		this.m.Sprite = "bust_legend_helmet_runed";
		this.setRuneVariant(::Legends.Rune.NgGHRshNightVision);
		this.setRuneBonus(false);
		this.m.Value = 1200;
	}

	function updateVariant()
	{
	}

	function getTooltip()
	{
		local result = this.legend_helmet_upgrade.getTooltip();
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Этот предмет обладает силой рунного знака Ночное зрение:\nНе подвержен эффекту [color=" + ::Const.UI.Color.PositiveValue + "]Ночное время[/color]."
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Этот предмет обладает силой рунного знака Ночное зрение:\nНе подвержен эффекту [color=" + ::Const.UI.Color.PositiveValue + "]Ночное время[/color]."
		});
	}

	function onEquip()
	{
		this.legend_helmet_upgrade.onEquip();
		this.addSkill(::new("scripts/skills/rune_sigils/nggh_mod_RSH_night_vision"));
	}

});

