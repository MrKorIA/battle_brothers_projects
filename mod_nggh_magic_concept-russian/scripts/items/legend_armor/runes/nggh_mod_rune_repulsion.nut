this.nggh_mod_rune_repulsion <- ::inherit("scripts/items/legend_armor/legend_armor_upgrade", {
	m = {},
	function create()
	{
		this.legend_armor_upgrade.create();
		this.m.ID = "legend_armor_upgrade.legend_rune_repulsion";
		this.m.Type = ::Const.Items.ArmorUpgrades.Rune;
		this.m.Name = "Рунный знак брони: Отталкивание";
		this.m.Description = "Расписанный рунами камень, который может быть прикреплён к доспеху персонажа.";
		this.m.ArmorDescription = "Включает в себя резной камень, позволяющий отбросить нападающих противников.";
		this.m.Icon = "rune_sigils/rune_stone_3.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "layers/glow_runed_icon.png";
		this.m.OverlayIconLarge = "layers/glow_runed_inventory.png";
		this.m.SpriteFront = "";
		this.m.SpriteBack = "";
		this.m.SpriteDamagedFront = "";
		this.m.SpriteDamagedBack = "";
		this.m.SpriteCorpseFront = "";
		this.m.SpriteCorpseBack = "";
		this.setRuneVariant(::Legends.Rune.NgGHRsaRepulsion);
		this.setRuneBonus(false);
		this.m.Value = 1200;
	}

	function getTooltip()
	{
		local result = this.legend_armor_upgrade.getTooltip();
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Этот предмет обладает силой рунного знака Отталкивание:\nШанс [color=" + ::Const.UI.Color.PositiveValue + "]50%[/color] на отталкивание противника. [color=" + ::Const.UI.Color.PositiveValue + "]Невосприимчивость[/color] к отталкиванию и захватам."
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Этот предмет обладает силой рунного знака Отталкивание:\nШанс [color=" + ::Const.UI.Color.PositiveValue + "]50%[/color] на отталкивание противника. [color=" + ::Const.UI.Color.PositiveValue + "]Невосприимчивость[/color] к отталкиванию и захватам."
		});
	}

	function onEquip()
	{
		this.legend_armor_upgrade.onEquip();
		this.addSkill(::new("scripts/skills/rune_sigils/nggh_mod_RSA_repulsion"));
	}

});

