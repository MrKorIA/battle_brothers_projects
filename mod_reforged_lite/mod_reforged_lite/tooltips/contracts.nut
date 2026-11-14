// Регистрация тултипов мира мода (экран города / сцены контрактов):
// - Contract.Tooltip+<ID> — тултип контракта на экране города (JS-хук
//   world_town_screen_main_dialog_module.js привязывает его к строке контракта);
// - WorldActor+<ID> — тултип работодателя контракта (имя резолвится на стороне SQ;
//   динамический Tooltip+ с русским текстом в ExtraData давал иероглифы — не-ASCII
//   внутри идентификатора вложенной ссылки не переживает транспорт JS->SQ);
// - Faction+<ID> — вложенный тултип фракции (ссылки [имя|Faction+ID] в текстах
//   контрактов и в тултипе контракта).
// Contract/Faction — НОВЫЕ верхнеуровневые ключи в словаре тултипов мода
// (setTooltips существующие подтаблицы не мёржит, Concept не трогаем).
::ReforgedLite.Mod.Tooltips.setTooltips({
	// Тултип работодателя контракта по ID (имя резолвится здесь, на стороне SQ —
	// см. комментарий в RF_getOfferedByText о не-ASCII в ExtraData).
	WorldActor = ::MSU.Class.CustomTooltip(function( _data ) {
		local actor = ::Tactical.getEntityByID(_data.ExtraData.tointeger());
		if (::MSU.isNull(actor))
			return null;

		return [
			{ id = 1, type = "title", text = actor.getName() }
		];
	}),
	Faction = ::MSU.Class.CustomTooltip(function( _data ) {
		local ret = [
			{ contentType = "settlement-status-effect" }
		];

		ret.extend(::World.FactionManager.getFaction(_data.ExtraData.tointeger()).RF_getTooltip());
		return ret;
	}),
	Contract = {
		Tooltip = ::MSU.Class.CustomTooltip(function(_data) {
			local id = _data.ExtraData.tointeger();
			local contract;
			local active = ::World.Contracts.getActiveContract();
			if (active != null && active.getID() == id)
			{
				contract = active;
			}
			else
			{
				foreach (c in ::World.Contracts.getOpenContracts())
				{
					if (c.getID() == id)
					{
						contract = c;
						break;
					}
				}
			}

			if (contract != null)
			{
				local ret = contract.RF_getTooltip();
				// Маркер полной ширины тултипа (классы is-full-width is-status-effect-content
				// навешивает ванильный TooltipModule.buildFromData по этому contentType).
				ret.insert(0, {contentType = "settlement-status-effect"});
				if (active != null)
				{
					ret.push({
						id = 100, type = "hint", icon = "ui/icons/locked_small.png",
						text = "Вы не можете принять больше одного контракта"
					})
				}
				ret.push({
					id = 300, type = "hint", icon = "ui/icons/mouse_right_button.png",
					text = "Расторгнуть контракт"
				});
				return ret;
			}
		})
	}
});
