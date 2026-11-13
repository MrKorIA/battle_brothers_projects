// Механика BaseItemScript для named-предметов (адаптация mod_modular_vanilla/framework под lite):
// named-предмет с заполненным m.BaseItemScript копирует поля и скиллы с базового предмета.
// В отличие от оригинала, хуки применены только к named_weapon — обычные предметы не затрагиваются.
::ReforgedLite.HooksMod.hook("scripts/items/item", function(q) {
	// MV: Added part of framework: base item for named items
	q.m.BaseItemScript <- null;
	q.m.IsUsingBaseItemSkills <- true;

	// MV: Added part of framework: base item for named items
	q.getBaseItemFields <- { function getBaseItemFields()
	{
		return [];
	}}.getBaseItemFields;

	// MV: Added part of framework: base item for named items
	q.setValuesBeforeRandomize <- { function setValuesBeforeRandomize( _baseItem )
	{
		if (_baseItem != null)
		{
			foreach (field in this.getBaseItemFields())
			{
				this.m[field] = _baseItem.m[field];
			}
		}
	}}.setValuesBeforeRandomize;

	// VanillaFix: vanilla removes each skill in `m.SkillPtrs` via `skill_container.remove` which
	// immediately calls update on skill container before clearing `m.SkillPtrs` which can lead to
	// errors if a skill accesses skills which are removed from the skill container but still
	// present in the item's `m.SkillPtrs` and tries to do anything with that skill's
	// `getContainer()` which would be null at that point.
	q.clearSkills = @() { function clearSkills()
	{
		if (this.getContainer() == null || this.getContainer().getActor() == null || this.getContainer().getActor().isNull())
		{
			return;
		}

		// Instead of calling container.remove(skill) on each skill (which would trigger skill container update)
		// we set each skill to garbage and do a single skill_container.update later.
		foreach (skill in this.m.SkillPtrs)
		{
			skill.removeSelf();
		}

		this.m.SkillPtrs = [];
		this.getContainer().getActor().getSkills().update();
	}}.clearSkills;
});

::MSU.QueueBucket.VeryLate.push(function() {
	::ReforgedLite.HooksMod.hookTree("scripts/items/weapons/named/named_weapon", function(q) {
		// MV: Part of framework: base item for named items
		q.create = @(__original) { function create()
		{
			// Prevent the vanilla call to this.randomizeValues() within create() from randomizing anything
			// because we want to set the values from the base item first.
			local randomizeValues = this.randomizeValues;
			this.randomizeValues = @() null;
			__original();
			this.randomizeValues = randomizeValues;

			this.setValuesBeforeRandomize(this.m.BaseItemScript == null ? null : ::new(this.m.BaseItemScript));
			this.randomizeValues();
		}}.create;

		// MV: Part of framework: base item for named items
		q.setValuesBeforeRandomize = @(__original) { function setValuesBeforeRandomize( _baseItem )
		{
			if (_baseItem == null)
			{
				__original(_baseItem);
				return;
			}

			// The Named itemtype is lost when copying the ItemType from the base item
			// so we add it back if this item already had it
			local isNamedItem = this.isItemType(::Const.Items.ItemType.Named);
			__original(_baseItem);
			if (isNamedItem)
			{
				this.m.ItemType = this.m.ItemType | ::Const.Items.ItemType.Named;
			}
		}}.setValuesBeforeRandomize;

		// MV: Part of framework: base item for named items
		q.onEquip = @(__original) function()
		{
			if (this.m.BaseItemScript == null || !this.m.IsUsingBaseItemSkills)
				return __original();

			local function getParents( _obj )
			{
				local ret = [];
				while ("SuperName" in _obj && _obj.SuperName != "item")
				{
					ret.push(_obj.SuperName);
					_obj = _obj[_obj.SuperName];
				}
				return ret;
			}

			local baseItem = ::new(this.m.BaseItemScript);

			// During the call on `onEquip` with this as env variable, any parents of baseItem which are not our parents will throw an error,
			// so we add them to us temporarily.
			local myParents = getParents(this);
			local baseItemParents = getParents(baseItem).filter(@(_, _p) myParents.find(_p) == null);
			foreach (p in baseItemParents)
			{
				this[p] <- baseItem[p];
				this[p].onEquip = this[p].onEquip.bindenv(this);
			}

			local topParent = myParents.pop(); // this will be one step below "item" class

			// We want the top parent's onEquip e.g. this.weapon.onEquip to run at the end (during base item onEquip)
			// so we switcheroo it with a null function for now.
			local topParent_onEquip = this[topParent].onEquip;
			this[topParent].onEquip = @() null;

			// This will call this object's parent's onEquip which is named_weapon,
			// that in turn will call its parent's e.g. this.weapon.onEquip but we have already nullified that above.
			this[this.SuperName].onEquip();

			// Revert the switcheroo so that during the call to base item's onEquip below, the top parent's onEquip will properly run
			this[topParent].onEquip = topParent_onEquip;

			// We have to switcheroo BaseItemScript to be null otherwise a stack overflow will occur
			// as we are calling the function with `this` as the env.
			local baseItemScript = this.m.BaseItemScript;
			this.m.BaseItemScript = null;

			baseItem.onEquip.call(this);

			this.m.BaseItemScript = baseItemScript;

			foreach (p in baseItemParents)
			{
				delete this[p];
			}
		}
	});
});
