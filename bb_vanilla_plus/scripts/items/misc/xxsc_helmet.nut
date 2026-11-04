this.xxsc_helmet <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.xxsc_helmet";
		this.m.Name = "Случайний (шлем)";
		this.m.Description = "Copy the helmet shape of the selected target, making it a random option helmet. If the target doesn\'t have helmet, create an invisible hat.";
		this.m.Icon = "xx_item_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.Value = 12000;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 64,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Опция товара: [color=" + this.Const.UI.Color.PositiveValue + "](100 ~ 400 Прочность), (-20 ~ -5 Максимальная усталость), (-3 ~ 0 Зрение)[/color]"
		});
		result.push({
			id = 65,
			type = "text",
			text = "Используйте, щелкнув правой кнопкой мыши или перетащив на слот тела выбранного персонажа. Этот предмет будет израсходован в процессе."
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		local mitem = _item == null ? _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head) : _item;
		local citem;
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
		if (mitem == null)
		{
			citem = this.new("scripts/items/helmets/xxsc_helmet_outx");
		}
		else
		{
			citem = this.new("scripts/items/helmets/xxsc_helmet_outz");
			citem.m.HideHair = mitem.m.HideHair;
			citem.m.HideBeard = mitem.m.HideBeard;
			citem.m.Sprite = mitem.m.Sprite;
			citem.m.SpriteDamaged = mitem.m.SpriteDamaged;
			citem.m.SpriteCorpse = mitem.m.SpriteCorpse;
			citem.m.IconLarge = mitem.m.IconLarge;
			citem.m.Icon = mitem.m.Icon;

			citem.m.VariantString = mitem.m.VariantString;
			if (mitem.m.Variant <= 0)
			{
				citem.setVariant(this.Math.rand(1, 35));
			}
			else
			{
				citem.setVariant(mitem.m.Variant);
			}
		}
		this.World.Assets.getStash().add(citem);
		return true;
	}

});

