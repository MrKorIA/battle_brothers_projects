this.mgl_khan_armor_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Spawned = 0
	},
	function create()
	{
		this.m.ID = "effects.mgl_khan_armor";
		this.m.Name = "Наследие Хана";
		this.m.Description = "Этот доспех когда-то покоился на плечах степного владыки, чьё имя до сих пор произносят шёпотом. Дух его гвардии ещё хранит присягу — и может явиться на зов, если владелец окажется в беде.";
		this.m.Icon = "ui/perks/perk_28.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsHidden = true;
	}

	function getTooltip()
	{
		return [
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
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] к решимости"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "При получении удара появляется призрачный страж, сражающийся на вашей стороне (не чаще " + this.getMaxCharges() + " раз(а) за бой; Шлем Хана даёт ещё одного стража.)"
			}
		];
	}

	function onCombatStarted()
	{
		this.m.Spawned = 0;
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 10;
	}

	function getMaxCharges()
	{
		local actor = this.getContainer().getActor();
		if (actor == null) return 0;
		local charges = 0;
		local body = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		if (body != null && body.getID() == "armor.body.named_mgl10_armor_01") charges = ++charges;
		local head = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		if (head != null && head.getID() == "armor.head.named_mgl11_helmet_01") charges = ++charges;
		return charges;
	}

	// Сигнатура скиллового хука (skill_container.nut:760): (_attacker, _damageHitpoints,
	// _damageArmor). Контейнер игнорирует возврат — как у всех ванильных эффектов
	// (alp_racial, hex_master_effect и пр.). Возвращать hitInfo нельзя: это сигнатура актора.
	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (this.m.Spawned >= this.getMaxCharges())
		{
			return;
		}

		local actor = this.getContainer().getActor();
		if (actor == null || actor.isDying() || !actor.isPlacedOnMap())
		{
			return;
		}

		local myTile = actor.getTile();
		if (myTile == null)
		{
			return;
		}

		local tile;
		for (local i = 0; i < 6; i = ++i)
		{
			if (!myTile.hasNextTile(i)) continue;
			local nextTile = myTile.getNextTile(i);
			if (!nextTile.IsEmpty || this.Math.abs(nextTile.Level - myTile.Level) > 1) continue;
			tile = nextTile;
			break;
		}

		if (tile != null)
		{
			local ghost = this.Tactical.spawnEntity("scripts/entity/tactical/humans/lingmuyouling", tile.Coords);
			ghost.setFaction(actor.getFaction());
			this.m.Spawned = ++this.m.Spawned;
		}
	}
});
