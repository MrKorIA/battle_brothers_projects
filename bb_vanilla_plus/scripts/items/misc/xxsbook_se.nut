this.xxsbook_se <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.xxsbook_se";
		this.m.Name = "Эпическая книга навыков";
		this.m.Description = "Выберите одно специальное умение для изучения. Можно изучить максимум 2 специальных умения, и если этот лимит будет превышен, они будут сброшены. (Некоторые специальные наемники не могут использовать книги умений).";
		this.m.Icon = "xx_item_04a_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.Value = 2000;
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
			id = 65,
			type = "text",
			text = "Используйте, щелкнув правой кнопкой мыши или перетащив на слот тела выбранного персонажа. Этот предмет будет израсходован в процессе."
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		local chk = _actor.getSkills();
		foreach ( s in this.FantasyChampList )
		{
			if (chk.hasSkill(s))
			{
				return false;
			}
		}

		local ax = _actor.getFlags().getAsInt("xxSkillBookTraining");
		if (ax < 9999989)
		{
		}
		else
		{
			return false;
		}
		_actor.getFlags().increment("xxSkillBookTraining", 1);
		local axd = 1;
		if (chk.hasSkill("effects.xxzzlimitpotion_skill") || chk.hasSkill("actives.sbp_bondage_skill") || chk.hasSkill("actives.sbq1_propaganda_skill"))
		{
			axd = ++axd;
		}
		if (ax > axd)
		{
			_actor.getFlags().increment("xxSkillBookTraining", -1 * ax);
			this.FantasySpellbookact(_actor);
		}

		chk.add(this.new("scripts/skills/actives/xxzzcheck_skill"));
	        ::World.State.getMenuStack().popAll(true);
		::World.Events.fire("event.xxzzskillbook_event");
		return true;
	}

	function getBuyPrice()
	{
		return this.Math.ceil(this.getValue());
	}

	function getSellPrice()
	{
		return 1;
	}

});

