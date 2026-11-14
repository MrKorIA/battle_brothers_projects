// Экран города, список контрактов: тултип контракта по наведению (mod_reforged_lite,
// Contract.Tooltip+<ID>) и расторжение контракта по ПКМ (аналог хука Reforged 0.9.3;
// портрет персонажа-заказчика из оригинала не переносится).
ReforgedLite.Hooks.WorldTownScreenMainDialogModule_createContract = WorldTownScreenMainDialogModule.prototype.createContract;
WorldTownScreenMainDialogModule.prototype.createContract = function (_data, _i, _isDisabled, _content)
{
	ReforgedLite.Hooks.WorldTownScreenMainDialogModule_createContract.call(this, _data, _i, _isDisabled, _content);
	var self = this;

	if (_data !== null)
	{
		var contract = _content.find('.is-contract.contract' + _i);
		if (contract.length > 0)
		{
			contract.unbindTooltip();
			contract.bindTooltip({ contentType: 'msu-generic', modId: ReforgedLite.ID, elementId: "Contract.Tooltip+" + _data.ID });

			// Right click to dismiss contract
			// We allow dismissing even disabled contracts i.e. even while you have an active contract.
			contract.on('mousedown', function (_event)
			{
				if (_event.which === 3)
				{
					self.mParent.RF_notifyBackendContractRightClicked(_data.ID);
				}
			});

			contract.on('contextmenu', function (_event)
			{
				_event.preventDefault();
			});
		}
	}
};
