// Мод «Нашествие Железной Орды»: радиокнопка кризиса в меню новой кампании.
// Ванильный файл не перекрывается — оборачиваем прототип (паттерн bb_vanilla_plus).
var HordeInvasionHooks = HordeInvasionHooks || {};

HordeInvasionHooks.buildCompanyCrisisSelectionPanel = NewCampaignMenuModule.prototype.buildCompanyCrisisSelectionPanel;
NewCampaignMenuModule.prototype.buildCompanyCrisisSelectionPanel = function (container)
{
	HordeInvasionHooks.buildCompanyCrisisSelectionPanel.call(this, container);

	var evilHordeControl = $('<div class="control"></div>');
	this.mCompanyCrisisSelectionPanel.find('.permanent-destruction-control:first').before(evilHordeControl);
	this.mEvilHordeCheckbox = $('<input type="radio" id="cb-evil-horde" name="evil"/>');
	evilHordeControl.append(this.mEvilHordeCheckbox);
	this.mEvilHordeLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-evil-horde">Нашествие Железной Орды</label>');
	evilHordeControl.append(this.mEvilHordeLabel);
	this.mEvilHordeCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});
	this.mEvilHordeCheckbox.on('ifChecked', null, this, function (_event)
	{
		var self = _event.data;
		self.mEvil = 5;
	});
	this.mEvilHordeLabel.bindTooltip({ contentType: 'ui-element', elementId: 'menu-screen.new-campaign.EvilHorde' });
	this.mEvilHordeCheckbox.bindTooltip({ contentType: 'ui-element', elementId: 'menu-screen.new-campaign.EvilHorde' });
};
