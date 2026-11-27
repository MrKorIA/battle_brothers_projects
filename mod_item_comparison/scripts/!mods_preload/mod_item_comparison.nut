::ItemComparison <- {
	ID = "mod_item_comparison",
	Name = "Item Comparison",
	Version = "1.3.9",
	DummyPlayer = null,
	DummyRosterID = "mod_item_comparison_dummy"
}

::ItemComparison.HooksMod <- ::Hooks.register(::ItemComparison.ID, ::ItemComparison.Version, ::ItemComparison.Name);
::ItemComparison.HooksMod.require(["mod_msu", "mod_modern_hooks"]);

::ItemComparison.destroyDummyPlayer <- function()
{
	if (this.DummyPlayer == null)
		return;

	this.DummyPlayer = null;
	::World.deleteRoster(this.DummyRosterID);
}

::ItemComparison.getDummyPlayer <- function()
{
	if (this.DummyPlayer != null)
		return this.DummyPlayer;

	if (!::Tactical.isActive() && (!("State" in ::World) || ::World.State == null))
		return null;

	local roster = ::World.createRoster(this.DummyRosterID);
	this.DummyPlayer = roster.create("scripts/entity/tactical/player");
	this.DummyPlayer.m.Talents.resize(::Const.Attributes.COUNT, 0);
	this.DummyPlayer.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints - 1);
	this.DummyPlayer.setStartValuesEx(["brawler_background"], false);
	this.DummyPlayer.m.Name = "Item Comparison Dummy";
	this.DummyPlayer.getSkills().removeByID("special.double_grip");

	this.DummyPlayer.hasSprite = function( _name )
	{
		return false;
	}

	this.DummyPlayer.onAppearanceChanged = function( _appearance, _setDirty = true )
	{
	}

	local items = this.DummyPlayer.getItems().getAllItems();
	foreach (item in items)
	{
		if (item.getCurrentSlotType() == ::Const.ItemSlot.Bag)
			this.DummyPlayer.getItems().removeFromBag(item);
		else
			this.DummyPlayer.getItems().unequip(item);
	}

	return this.DummyPlayer;
}

::ItemComparison.getSkillText <- function( _skill, _itemId = null, _itemOwner = null, _entityId = null )
{
	local name = "Name" in _skill ? _skill.Name : _skill.m.Name;
	if (!("NestedTooltips" in ::MSU))
		return name;

	local script = "Script" in _skill ? _skill.Script : _skill.ClassName;
	local extraData = "";
	if (_itemId != null && _itemOwner != null)
	{
		extraData = ",itemId:" + _itemId + ",itemOwner:" + _itemOwner;
		if (_entityId != null)
			extraData += ",entityId:" + _entityId;
	}
	return this.Mod.Tooltips.parseString(::format("[%s|Skill+%s%s]", name, script, extraData));
}

::ItemComparison.extractSkills <- function( _item )
{
	local ret = [];

	foreach (skill in _item.m.SkillPtrs)
	{
		if (skill == null || skill.m.IsHidden || skill.getID() == "items.generic" || skill.getName() == "")
			continue;

		ret.push({
			ID = skill.getID(),
			Name = skill.getName(),
			Text = this.getSkillText(skill),
			Script = skill.ClassName,
			Icon = skill.getIconColored()
		});
	}

	return ret;
}

::ItemComparison.getSkillCacheKey <- function( _item )
{
	local ret = _item.m.Condition + "/" + _item.m.ConditionMax + "/" + _item.m.Variant + "/" + _item.m.MagicNumber;
	if ("Ammo" in _item.m)
		ret += "/" + _item.m.Ammo;
	return ret;
}

::ItemComparison.getSkills <- function( _item )
{
	local ret = this.extractSkills(_item);
	if (_item.m.SkillPtrs.len() > 0 || _item.m.SlotType == ::Const.ItemSlot.None || _item.m.SlotType == ::Const.ItemSlot.Bag)
		return ret;

	local cacheKey = this.getSkillCacheKey(_item);
	if ("ItemComparisonSkillCache" in _item.m && _item.m.ItemComparisonSkillCacheKey == cacheKey)
		return _item.m.ItemComparisonSkillCache;

	local player = this.getDummyPlayer();
	if (player == null)
		return ret;

	local data = ::MSU.Class.SerializationData();
	_item.onSerialize(data.getSerializationEmulator());
	local cloneItem = ::new(::IO.scriptFilenameByHash(_item.ClassNameHash));
	cloneItem.onDeserialize(data.getDeserializationEmulator());
	cloneItem.setCondition(cloneItem.getConditionMax());

	local container = player.getItems();
	local existingItem = container.getItemAtSlot(cloneItem.m.SlotType);
	if (existingItem != null)
		container.unequip(existingItem);

	local success = false;
	try
	{
		if (container.equip(cloneItem))
		{
			ret = this.extractSkills(cloneItem);
			success = true;
		}
	}
	catch (_error)
	{
		::logWarning(this.ID + ": не удалось получить навыки предмета " + _item.getID() + ": " + _error);
	}

	if (cloneItem.getContainer() != null)
		container.unequip(cloneItem);

	if (existingItem != null)
		container.equip(existingItem);

	if (success)
	{
		_item.m.ItemComparisonSkillCache <- ret;
		_item.m.ItemComparisonSkillCacheKey <- cacheKey;
	}
	return ret;
}

::ItemComparison.getItem <- function( _entityId, _itemId, _itemOwner )
{
	local entity = _entityId != null ? ::Tactical.getEntityByID(_entityId) : null;

	switch (_itemOwner)
	{
		case "entity":
			return entity != null ? entity.getItems().getItemByInstanceID(_itemId) : null;

		case "character-screen-inventory-list-module.ground":
			if (entity == null || entity.getTile() == null || entity.getTile().Items == null)
				return null;

			foreach (item in entity.getTile().Items)
			{
				if (item.getInstanceID() == _itemId)
					return item;
			}
			return null;

		case "character-screen-inventory-list-module.stash":
			local result = ::Stash.getItemByInstanceID(_itemId);
			return result != null ? result.item : null;
	}

	return null;
}

::ItemComparison.getKind <- function( _item )
{
	if (_item.isItemType(::Const.Items.ItemType.Weapon))
		return "weapon";
	if (_item.isItemType(::Const.Items.ItemType.Shield))
		return "shield";
	if (_item.isItemType(::Const.Items.ItemType.Armor))
		return "armor";
	if (_item.isItemType(::Const.Items.ItemType.Helmet))
		return "helmet";
	return "";
}

::ItemComparison.getItemData <- function( _item )
{
	local kind = this.getKind(_item);
	local ret = {
		ID = _item.getInstanceID(),
		Name = _item.getName(),
		Icon = _item.getIcon(),
		IconOverlay = _item.getIconOverlay(),
		IconLarge = _item.getIconLarge() != null ? _item.getIconLarge() : "",
		Slot = _item.m.SlotType,
		Kind = kind,
		IsMelee = false,
		IsRanged = false,
		Skills = this.getSkills(_item),
		Stats = {
			Value = _item.getValue(),
			Condition = _item.getCondition(),
			ConditionMax = _item.getConditionMax(),
			Stamina = _item.getStaminaModifier()
		}
	};

	if (kind == "weapon")
	{
		ret.IsMelee = _item.isItemType(::Const.Items.ItemType.MeleeWeapon);
		ret.IsRanged = _item.isItemType(::Const.Items.ItemType.RangedWeapon);
		ret.Stats.DamageMin <- _item.getDamageMin();
		ret.Stats.DamageMax <- _item.getDamageMax();
		ret.Stats.DirectDamage <- ::Math.floor((_item.m.DirectDamageMult + _item.m.DirectDamageAdd) * 100);
		ret.Stats.ArmorDamage <- ::Math.floor(_item.getArmorDamageMult() * 100);
		ret.Stats.ShieldDamage <- _item.getShieldDamage();
		ret.Stats.Accuracy <- _item.getAdditionalAccuracy();
		ret.Stats.Headshot <- _item.m.ChanceToHitHead;
		ret.Stats.RangeMin <- _item.getRangeMin();
		ret.Stats.RangeMax <- _item.getRangeMax();
		ret.Stats.RangeIdeal <- _item.getRangeIdeal();
		ret.Stats.RangeMaxBonus <- _item.getRangeMaxBonus();
		ret.Stats.Ammo <- _item.getAmmo();
		ret.Stats.AmmoMax <- _item.getAmmoMax();
		ret.Stats.SkillFatigue <- _item.m.FatigueOnSkillUse;
	}
	else if (kind == "shield")
	{
		ret.Stats.MeleeDefense <- _item.getMeleeDefense();
		ret.Stats.RangedDefense <- _item.getRangedDefense();
		ret.Stats.SkillFatigue <- _item.m.FatigueOnSkillUse;
	}
	else if (kind == "armor" || kind == "helmet")
	{
		ret.Stats.Armor <- _item.getArmor();
		ret.Stats.ArmorMax <- _item.getArmorMax();
	}

	if (kind == "helmet")
		ret.Stats.Vision <- _item.m.Vision;

	return ret;
}

::ItemComparison.canCompare <- function( _selected, _equipped )
{
	if (_selected == null || _equipped == null || _selected.getInstanceID() == _equipped.getInstanceID())
		return false;

	local selectedKind = this.getKind(_selected);
	if (selectedKind == "" || selectedKind != this.getKind(_equipped) || _selected.m.SlotType != _equipped.m.SlotType)
		return false;

	if (selectedKind == "weapon")
	{
		local selectedMelee = _selected.isItemType(::Const.Items.ItemType.MeleeWeapon);
		local equippedMelee = _equipped.isItemType(::Const.Items.ItemType.MeleeWeapon);
		local selectedRanged = _selected.isItemType(::Const.Items.ItemType.RangedWeapon);
		local equippedRanged = _equipped.isItemType(::Const.Items.ItemType.RangedWeapon);
		return selectedMelee == equippedMelee && selectedRanged == equippedRanged;
	}

	return true;
}

::ItemComparison.HooksMod.queue(">mod_msu", ">mod_modern_hooks", function() {
	::ItemComparison.Mod <- ::MSU.Class.Mod(::ItemComparison.ID, ::ItemComparison.Version, ::ItemComparison.Name);

	::ItemComparison.HooksMod.hookTree("scripts/items/item", function(q) {
		q.getTooltip = @(__original) function()
		{
			local result = __original();

			foreach (entry in result)
			{
				if ("modItemComparisonSkill" in entry)
					return result;
			}

			local skills = ::ItemComparison.getSkills(this);
			foreach (i, skill in skills)
			{
				local entry = {
					id = 1000 + i,
					type = "text",
					text = skill.Text,
					modItemComparisonSkill = true,
					modItemComparisonSkillData = skill
				};
				if (skill.Icon != "")
					entry.icon <- skill.Icon;
				result.push(entry);
			}

			return result;
		}
	});

	::ItemComparison.HooksMod.hook("scripts/skills/actives/throw_spear_skill", function(q) {
		if (!q.m.contains("AdditionalAccuracy", true))
			q.m.AdditionalAccuracy <- 0;
		if (!q.m.contains("AdditionalHitChance", true))
			q.m.AdditionalHitChance <- 0;
	});

	::ItemComparison.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
		q.onQueryUIItemTooltipData = @(__original) function( _entityId, _itemId, _itemOwner )
		{
			local result = __original(_entityId, _itemId, _itemOwner);
			if (result == null)
				return null;

			foreach (entry in result)
			{
				if ("modItemComparisonSkillData" in entry)
					entry.text = ::ItemComparison.getSkillText(entry.modItemComparisonSkillData, _itemId, _itemOwner, _entityId);
			}

			local selected = ::ItemComparison.getItem(_entityId, _itemId, _itemOwner);
			if (selected == null)
				return result;

			local entity = _entityId != null ? ::Tactical.getEntityByID(_entityId) : null;
			if (entity == null)
				return result;

			local equipped = entity.getItems().getItemAtSlot(selected.m.SlotType);
			if (!::ItemComparison.canCompare(selected, equipped))
				return result;

			result.push({
				id = 2000,
				type = "hint",
				icon = "ui/icons/shift.png",
				text = "Сравнить с экипированным предметом"
			});
			result.push({
				id = 2001,
				type = "mod_item_comparison",
				Equipped = ::ItemComparison.getItemData(equipped),
				Selected = ::ItemComparison.getItemData(selected)
			});
			return result;
		}
	});

	::ItemComparison.HooksMod.hook("scripts/states/world_state", function(q) {
		q.saveCampaign = @(__original) function( _campaignFileName, _campaignLabel = null )
		{
			::ItemComparison.destroyDummyPlayer();
			__original(_campaignFileName, _campaignLabel);
		}

		q.loadCampaign = @(__original) function( _campaignFileName )
		{
			::ItemComparison.destroyDummyPlayer();
			__original(_campaignFileName);
		}

		q.onFinish = @(__original) function()
		{
			::ItemComparison.destroyDummyPlayer();
			__original();
		}
	});

	::ItemComparison.HooksMod.hook("scripts/states/tactical_state", function(q) {
		q.onFinish = @(__original) function()
		{
			::ItemComparison.destroyDummyPlayer();
			__original();
		}
	});
});

::Hooks.registerJS("ui/mods/mod_item_comparison/setup.js");
::Hooks.registerJS("ui/mods/mod_item_comparison/tooltip_module.js");
::Hooks.registerJS("ui/mods/mod_item_comparison/nested_tooltips.js");
::Hooks.registerCSS("ui/mods/mod_item_comparison/tooltip_module.css");
