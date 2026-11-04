this.xxtransmog_armor_out_ijirok <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.ijirok_armor";
		this.m.Name = "Armor of the Ijirok";
		this.m.Description = "Once a barbarian armor broken in battle, this piece has been bathed in the blood of the legendary Ijirok. Powers beyond your understanding mended it whole again, and will likewise mend any wounds of the wearer as well.";
		this.m.ShowOnCharacter = true;
		this.m.VariantString = "body";
		this.m.Variant = 12;
		this.m.Sprite = "bust_body_12";
		this.m.SpriteDamaged = "bust_body_12_damaged";
		this.m.SpriteCorpse = "bust_body_12_dead";
		this.m.IconLarge = "armor/inventory_body_armor_12.png";
		this.m.Icon = "armor/icon_body_armor_12.png";
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 12000;
		this.m.Condition = 320;
		this.m.ConditionMax = 320;
		this.m.StaminaModifier = -32;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
	}

	function getTooltip()
	{
		local result = this.armor.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/health.png",
			text = "Heals [color=" + this.Const.UI.Color.PositiveValue + "]10[/color] hitpoints of the wearer each turn"
		});
		return result;
	}

	function onCombatFinished()
	{
		local actor = this.getContainer().getActor();

		if (actor != null && !actor.isNull() && actor.isAlive())
		{
			actor.setHitpoints(actor.getHitpointsMax());
			actor.setDirty(true);
		}
	}

	function onTurnStart()
	{
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
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " heals for " + healthAdded + " points");
		}
	}

	function updateVariant()
	{
	}

	function onSerialize( _out )
	{
		if (this.m.Upgrade != null)
		{
			_out.writeI32(this.m.Upgrade.ClassNameHash);
			this.m.Upgrade.onSerialize(_out);
		}
		else
		{
			_out.writeI32(0);
		}
		this.item.onSerialize(_out);
		_out.writeF32(this.m.Condition);
		_out.writeF32(this.m.ConditionMax);
		_out.writeI32(this.m.StaminaModifier);
		_out.writeString(this.m.Sprite);
		_out.writeString(this.m.SpriteDamaged);
		_out.writeString(this.m.SpriteCorpse);
		_out.writeString(this.m.IconLarge);
		_out.writeString(this.m.Icon);
	}

	function onDeserialize( _in )
	{
		local upgrade = _in.readI32();
		if (upgrade != 0)
		{
			this.m.Upgrade = this.new(this.IO.scriptFilenameByHash(upgrade));
			this.m.Upgrade.setArmor(this);
			this.m.Upgrade.onDeserialize(_in);
		}
		this.item.onDeserialize(_in);
		this.m.Condition = _in.readF32();
		this.m.ConditionMax = _in.readF32();
		this.m.StaminaModifier = _in.readI32();
		this.m.Sprite = _in.readString();
		this.m.SpriteDamaged = _in.readString();
		this.m.SpriteCorpse = _in.readString();
		this.m.IconLarge = _in.readString();
		this.m.Icon = _in.readString();
	}

});

