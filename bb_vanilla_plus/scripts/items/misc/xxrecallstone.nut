this.xxrecallstone <- this.inherit("scripts/items/item", {
	m = {	},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.xxrecallstone";
		this.m.Name = "Камень воспоминаний";
		this.m.Description = "При использовании мгновенно телепортирует вас к порталу. Не может быть использовано во время выполнения контрактов на сопровождение или доставку, а также на экране города.";
		this.m.Icon = "xx_item_08_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.Value = 1000;
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

		local z = this.World.Contracts.getActiveContract();
		local t65 = "Щелкните правой кнопкой мыши или перетащите на выбранного персонажа, чтобы выпить. Этот предмет будет израсходован в процессе.";
		if (z != null)
		{
			local a = z.getType();
			if (a == "contract.escort_caravan" || a == "contract.deliver_item" || a == "contract.escort_caravan")
			{
				t65 = this.Const.Strings.FT.NoUse;
			}
		}
		if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null)
		{
			t65 = this.Const.Strings.FT.NoUse;
		}
		result.push({
			id = 65,
			type = "text",
			text = t65
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse(_actor, _item = null)
	{
		if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null)
		{
			return false;
		}
		local z = this.World.Contracts.getActiveContract();
		if (z != null)
		{
			local a = z.getType();
			if (a == "contract.escort_caravan" || a == "contract.deliver_item" || a == "contract.escort_caravan")
			{
				return;
			}
		}

		local world = this.World;
		local settlements = world.EntityManager.getLocations();
		local currentTile = world.State.getPlayer().getTile();
		local closest = null;
		local closestDist = 999999;
		foreach (s in settlements)
		{
			if (s.m.Name != this.Const.Strings.FT.PortalGateName || s.m.VisibilityMult != 1.57)
			{
				continue;
			}
			local dist = s.getTile().getDistanceTo(currentTile);
			if (dist < closestDist)
			{
				closest = s;
				closestDist = dist;
			}
		}

		if (closest != null)
		{
			this.Sound.play("sounds/fast_travel_boat_01.wav", this.Const.Sound.Volume.Inventory);
		        local tilePos = closest.getTile().Pos;
	        	this.World.setPlayerPos(tilePos);
		        this.World.State.getPlayer().setPos(tilePos);
		        ::World.State.getMenuStack().popAll(true);
			::World.State.enterLocation(closest);
			this.World.getCamera().setPos(this.World.State.getPlayer().getPos());
				////this.World.getCamera().moveTo(this.World.State.getPlayer());	this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());	Non used scirpt
		}
		return true;
	}

	function getBuyPrice()
	{
		return this.Math.ceil(this.getValue());
	}

	function getSellPrice()
	{
		return this.Math.round(this.getValue() * 0.2);
	}

});

