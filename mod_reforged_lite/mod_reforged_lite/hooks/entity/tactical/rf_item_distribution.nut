// Раздача предметов Reforged ванильным врагам — пост-экипировочные хуки (адаптация
// подсистемы Reforged без его инфраструктуры): после ванильной выдачи снаряжения
// с шансом часть слотов заменяется на rf-предметы того же тира.
// Состав списков — из Reforged 0.9.3 (hooks/entity/tactical/...).

local function rollRFItem( _items, _slot, _scripts, _chance )
{
	local current = _items.getItemAtSlot(_slot);
	if (current == null || ::Math.rand(1, 100) > _chance)
		return;

	local script = _scripts[::Math.rand(0, _scripts.len() - 1)];
	_items.unequip(current);
	_items.equip(::new("scripts/items/" + script));
}

// Главарь бандитов: тяжёлое оружие/броня/шлемы
::ReforgedLite.HooksMod.hook("scripts/entity/tactical/enemies/bandit_leader", function(q) {
	q.assignRandomEquipment = @(__original) { function assignRandomEquipment()
	{
		__original();
		local items = this.m.Items;
		rollRFItem(items, ::Const.ItemSlot.Mainhand, [
			"weapons/rf_greatsword",
			"weapons/rf_kriegsmesser",
			"weapons/rf_swordstaff"
		], 30);
		rollRFItem(items, ::Const.ItemSlot.Body, [
			"armor/rf_breastplate",
			"armor/rf_brigandine_armor"
		], 30);
		rollRFItem(items, ::Const.ItemSlot.Head, [
			"helmets/rf_half_closed_sallet",
			"helmets/rf_conical_billed_helmet",
			"helmets/rf_sallet_helmet_with_mail",
			"helmets/rf_padded_conical_billed_helmet"
		], 30);
	}}.assignRandomEquipment;
});

// Рыцарь-нежить
::ReforgedLite.HooksMod.hook("scripts/entity/tactical/enemies/zombie_knight", function(q) {
	q.assignRandomEquipment = @(__original) { function assignRandomEquipment()
	{
		__original();
		rollRFItem(this.m.Items, ::Const.ItemSlot.Mainhand, [
			"weapons/rf_battle_axe",
			"weapons/rf_greatsword",
			"weapons/rf_poleflail",
			"weapons/rf_two_handed_falchion"
		], 30);
	}}.assignRandomEquipment;
});

// Наёмник
::ReforgedLite.HooksMod.hook("scripts/entity/tactical/humans/mercenary", function(q) {
	q.assignRandomEquipment = @(__original) { function assignRandomEquipment()
	{
		__original();
		rollRFItem(this.m.Items, ::Const.ItemSlot.Mainhand, [
			"weapons/rf_kriegsmesser",
			"weapons/rf_greatsword"
		], 25);
	}}.assignRandomEquipment;
});

// Сержант дворянского дома
::ReforgedLite.HooksMod.hook("scripts/entity/tactical/humans/noble_sergeant", function(q) {
	q.assignRandomEquipment = @(__original) { function assignRandomEquipment()
	{
		__original();
		rollRFItem(this.m.Items, ::Const.ItemSlot.Mainhand, [
			"weapons/rf_battle_axe",
			"weapons/rf_kriegsmesser"
		], 25);
	}}.assignRandomEquipment;
});

// Мастер меча
::ReforgedLite.HooksMod.hook("scripts/entity/tactical/humans/swordmaster", function(q) {
	q.assignRandomEquipment = @(__original) { function assignRandomEquipment()
	{
		__original();
		local items = this.m.Items;
		rollRFItem(items, ::Const.ItemSlot.Mainhand, [
			"weapons/rf_estoc"
		], 25);
		rollRFItem(items, ::Const.ItemSlot.Body, [
			"armor/rf_breastplate",
			"armor/rf_brigandine_armor"
		], 25);
		rollRFItem(items, ::Const.ItemSlot.Head, [
			"helmets/rf_greatsword_helm"
		], 25);
	}}.assignRandomEquipment;
});

// Орки-военачальники: двуручная булава Reforged (в оригинале выдавалась через dynamic spawns)
::ReforgedLite.HooksMod.hook("scripts/entity/tactical/enemies/orc_warlord", function(q) {
	q.assignRandomEquipment = @(__original) { function assignRandomEquipment()
	{
		__original();
		rollRFItem(this.m.Items, ::Const.ItemSlot.Mainhand, [
			"weapons/greenskins/rf_orc_mace_2h"
		], 20);
	}}.assignRandomEquipment;
});
