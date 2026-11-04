this.lingmuxianglian_item <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.lingmuxianglian";
		this.m.Name = "Ожерелье из трофеев нахцерера";
		this.m.Description = "Это ожерелье, сделанное из трофеев, добытых из разных нахцереров, говорит о том, что его владелец — ветеран битв с дикими зверьми, и его нелегко запугать.";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/lingmuxianglian.png";
		this.m.Sprite = "lingmuxianglian";
		this.m.Value = 250;
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
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] к решимости"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		_properties.Bravery += 5;
	}

    function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
	
	    this.accessory.onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties );
		if (_skill == null)
		{
			return;
		}

		if (_skill.getID() == "actives.aimed_shot" || _skill.getID() == "actives.lingmu01_01")
		{
			_properties.DamageReceivedRegularMult *= 0.1;
		}
	}

});

