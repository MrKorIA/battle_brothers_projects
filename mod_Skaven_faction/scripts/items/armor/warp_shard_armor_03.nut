this.warp_shard_armor_03 <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.warp_shard_armor_03";
		this.m.Name = "Броня из варп-осколков";
		this.m.Description = "Броня из шипованных пластин, инкрустированных осколками чистого варп-камня. Которая защищает владельца от вреда, а также вредит тем, кто наносит ему удары, посредством силы варп-камня.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 1000;
		this.m.Condition = 100;
		this.m.ConditionMax = 100;
		this.m.StaminaModifier = -18;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_warp_shard_armor_03";
		this.m.SpriteDamaged = "bust_warp_shard_armor_03_damaged";
		this.m.SpriteCorpse = "bust_warp_shard_armor_03_dead";
		this.m.IconLarge = "armor/inventory_warp_shard_armor_03.png";
		this.m.Icon = "armor/icon_warp_shard_armor_03.png";
	}

	function getTooltip()
	{
		local result = this.armor.getTooltip();

		result.push({
			id = 1,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Возвращает [color=" + this.Const.UI.Color.PositiveValue + "]10%[/color] урона, полученного в ближнем бою, обратно атакующему"
		});

		result.push({
			id = 2,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Восстанавливает [color=" + this.Const.UI.Color.PositiveValue + "]30[/color] единиц прочности каждый ход."
		});

		result.push({
			id = 3,
			type = "text",
			icon = "ui/icons/health.png",
			text = "Восстанавливает [color=" + this.Const.UI.Color.PositiveValue + "]10[/color] ОЗ каждый ход"
		});

		return result;
	}

	function onDamageReceived( _damage, _fatalityType, _attacker )
	{
		this.armor.onDamageReceived(_damage, _fatalityType, _attacker);

		if (_attacker != null && _attacker.isAlive() && _attacker.getHitpoints() > 0 && _attacker.getID() != this.getContainer().getActor().getID() && _attacker.getTile().getDistanceTo(this.getContainer().getActor().getTile()) == 1 && !_attacker.getCurrentProperties().IsImmuneToDamageReflection)
		{
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = this.Math.maxf(1.0, _damage * 0.1);
			hitInfo.DamageArmor = this.Math.maxf(1.0, _damage * 0.1);
			hitInfo.DamageDirect = 0.0;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			_attacker.onDamageReceived(_attacker, null, hitInfo);
		}
	}

	function onTurnStart()
	{
		this.m.Condition = this.Math.minf(this.m.ConditionMax, this.m.Condition + 30.0);
		this.updateAppearance();

		local actor = this.getContainer().getActor();
		local healthMissing = actor.getHitpointsMax() - actor.getHitpoints();
		local healthAdded = this.Math.min(healthMissing, 10);

		if (healthAdded <= 0)
		{
			return;
		}

		actor.setHitpoints(actor.getHitpoints() + healthAdded);
		actor.setDirty(true);

		if (!actor.isHiddenToPlayer())
		{
			this.Tactical.spawnIconEffect("status_effect_79", actor.getTile(), this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
			this.Sound.play("sounds/enemies/unhold_regenerate_01.wav", this.Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " восстанавливает " + healthAdded + " ОЗ");
		}
	}

	function onCombatFinished()
	{
		this.m.Condition = this.m.ConditionMax;
		this.updateAppearance();

		local actor = this.getContainer().getActor();

		if (actor != null && !actor.isNull() && actor.isAlive())
		{
			actor.setHitpoints(actor.getHitpointsMax());
			actor.setDirty(true);
		}
	}

	function onSerialize( _out )
	{
		this.armor.onSerialize(_out);
		_out.writeString(this.m.Description);
	}

	function onDeserialize( _in )
	{
		this.armor.onDeserialize(_in);
		this.m.Description = _in.readString();
	}
});

