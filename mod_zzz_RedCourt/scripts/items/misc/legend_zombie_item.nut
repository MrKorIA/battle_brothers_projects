this.legend_zombie_item <- this.inherit("scripts/items/item", {
	m = {
		UnleashSounds = [
			"sounds/enemies/geist_idle_10.wav",
			"sounds/enemies/geist_idle_11.wav",
			"sounds/enemies/geist_idle_12.wav"
		],
		Timer = 7
	},
	function create()
	{
		this.item.create();
		this.m.ID = "spawns.zombie";
        this.m.Name = "Человеческая плоть";
        this.m.Description = "Груда сочащихся кровью человеческих потрохов, оторванных конечностей и лоскутов кожи, собранных после побоища. Идеальный материал для ваших жутких некромантских трудов. Через некоторое время приходит в негодность.";
		this.m.Icon = "supplies/human_carrion.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 100;
	}

	function playInventorySound( _eventType )
	{
		local index = this.Math.rand(1, 16);
		local variant = "" + index;
		if (index < 10){
			variant = "0" + index;
		}
		this.Sound.play("sounds/enemies/zombie_idle_" +  variant + ".wav", this.Const.Sound.Volume.Inventory);
	}

	function getSellPriceMult()
	{
		return this.World.State.getCurrentTown().getBeastPartsPriceMult();
	}

	function getBuyPriceMult()
	{
		return this.World.State.getCurrentTown().getBeastPartsPriceMult();
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
			},
			{
                id = 3,
                type = "image",
                image = this.getIcon()
            },
            {
                id = 66,
                type = "text",
                text = this.getValueString()
            },
            {
                id = 67,
                type = "text",
                text = "Испортится через [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.Timer + "[/color] дня(ей)."
            }
		];

		return result;
	}

	function onSerialize( _out )
	{
		this.item.onSerialize(_out);
		_out.writeU16(this.m.Timer);
	}

	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);
		this.m.Timer = _in.readU16();
	}

});

