this.cp_bird_auto_release <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "special.cp_bird_auto_release";
		this.m.Name = "";
		this.m.Description = "";
		this.m.Type = ::Const.SkillType.Special;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsRemovedAfterBattle = false;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (!this.getItem().isReleased() && (_damageHitpoints > 0 || _damageArmor > 0))
		{
			this.getItem().playInventorySound(::Const.Items.InventoryEventType.None);

			local owner = this.getContainer().getActor();
			if (owner != null)
			{
				::Tactical.EventLog.log("Птица " + this.getItem().getName() + " персонажа " + ::Const.UI.getColorizedEntityName(owner) + " испугалась и сбежала");
			}

			this.getItem().setReleased(true);
			// TODO: overlay icon?
		}
	}
});
