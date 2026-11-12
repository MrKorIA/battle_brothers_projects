this.warp_shard_armor_02 <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.warp_shard_armor_02";
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
		this.m.Sprite = "bust_warp_shard_armor_02";
		this.m.SpriteDamaged = "bust_warp_shard_armor_02_damaged";
		this.m.SpriteCorpse = "bust_warp_shard_armor_02_dead";
		this.m.IconLarge = "armor/inventory_warp_shard_armor_02.png";
		this.m.Icon = "armor/icon_warp_shard_armor_02.png";
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
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Для преображения брони носитель должен [color=" + this.Const.UI.Color.NegativeValue + "] убить снежного тролля[/color]"
		});

		return result;
	}

	function onEquip()
	{
		this.armor.onEquip();
		local skill = this.new("scripts/skills/effects/warp_shard_upgrade_effect");
		skill.m.Mode = 2;
		skill.m.NextArmorScript = "scripts/items/armor/warp_shard_armor_03";
		this.addSkill(skill);
	}

	function onUnequip()
	{
		this.armor.onUnequip();

		if (this.getContainer() != null && this.getContainer().getActor() != null && !this.getContainer().getActor().isNull())
		{
			local skill = this.getContainer().getActor().getSkills().getSkillByID("effects.warp_shard_upgrade");

			if (skill != null && skill.getItem() == this)
			{
				skill.removeSelf();
			}
		}
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

	}

	function onCombatFinished()
	{
		this.m.Condition = this.m.ConditionMax;
		this.updateAppearance();
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

