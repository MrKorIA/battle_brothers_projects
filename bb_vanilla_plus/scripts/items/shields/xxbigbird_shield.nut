this.xxbigbird_shield <- this.inherit("scripts/items/shields/shield", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "shield.xxbigbird_shield";
		this.m.Name = "Divine Beast Lumina";
		this.m.Description = "A legendary beast of the mythical age. It provides high mobility and combat power and is even sturdy.\n\n+15 Melee skill\nMovement costs 1 less AP\nCauses no fatigue from movement\n100% chance to be saved on death";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.SlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Tool;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.Value = 10000;
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 0;
		this.m.StaminaModifier = 0;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.SoundOnHit = [
			"sounds/misc/donkey_hurt_01.wav",
			"sounds/misc/donkey_hurt_02.wav",
			"sounds/misc/donkey_hurt_03.wav"
		];
		this.m.SoundOnDestroyed = [
			"sounds/misc/donkey_death_01.wav",
			"sounds/misc/donkey_death_02.wav"
		];
	}

	function updateVariant()
	{
		this.m.Sprite = "xxbigbird_" + this.m.Variant;
		this.m.SpriteDamaged = "xxbigbird_" + this.m.Variant + "_damaged";
		this.m.IconLarge = "shields/inventory_xxbigbird_shield_" + this.m.Variant + ".png";
		this.m.Icon = "shields/icon_xxbigbird_shield_" + this.m.Variant + ".png";
	}

	function updateAppearance()
	{
		if (this.getContainer() == null || !this.isEquipped())
		{
			return;
		}
		if (this.m.ShowOnCharacter)
		{
			local app = this.getContainer().getAppearance();
			if (this.m.Condition == 0)
			{
				app.Shield = "";
			}
			else if (this.m.Condition <= 50)
			{
				app.Shield = this.m.SpriteDamaged;
			}
			else
			{
				app.Shield = this.m.Sprite;
			}
			this.getContainer().updateAppearance();
		}
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (this.getContainer() == null || !this.isEquipped())
		{
			return;
		}
		if (this.m.Condition <= 0)
		{
			return;
		}
		local damage = _hitInfo.DamageRegular * 0.5;
		if (damage <= 2)
		{
			return;
		}
		this.m.Condition = this.Math.max(2, this.m.Condition - damage);
		local actor = this.getContainer().getActor();
		if (this.m.Condition <= 2 && !this.m.IsIndestructible)
		{
		        this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(actor) + "\'s " + this.getName() + " is hit for [b]" + this.Math.floor(damage) + "[/b] damage and has been struck down!");
			this.Sound.play(this.m.SoundOnDestroyed[this.Math.rand(0, this.m.SoundOnDestroyed.len() - 1)], this.Const.Sound.Volume.Skill, actor.getPos());
			if (actor.getFaction() == this.Const.Faction.Player && this.Math.rand(1, 100) <= 100)
			{
				local dead_drop = this.new("scripts/items/shields/xxbigbird_shield");
				local tile = actor.getTile();
				dead_drop.m.Condition = 0;
				dead_drop.drop(tile);
				dead_drop.m.Variant = this.m.Variant;
				dead_drop.updateVariant();
			}
			this.m.Condition = 1;
		}
		else
		{
			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(actor) + "\'s " + this.getName() + " is hit for [b]" + this.Math.floor(damage) + "[/b] damage");
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill * 0.5, actor.getPos());
		}
		this.updateAppearance();
	}

	function isDroppedAsLoot()
	{
		return this.item.isDroppedAsLoot();
	}

	function onCombatFinished()
	{
		this.item.onCombatFinished();
		if (this.m.Condition < 10)
		{
			this.m.Condition = 10;
		}
		this.updateAppearance();
	}

	function applyShieldDamage( _damage, _playHitSound = true )
	{
	}

	function moveActorSprites(_actor, _offsetx,  _offsety)
	{
		local sprites = [
		        "background",
		        "quiver",
		        "body",
		        "tattoo_body",
		        "scar_body",
		        "injury_body",
		        "armor",
		        "surcoat",
		        "armor_upgrade_back",
		        "armor_upgrade_front",
		        "shaft",
		        "head",
		        "closed_eyes",
		        "eye_rings",
		        "tattoo_head",
		        "scar_head",
		        "injury",
		        "beard",
		        "hair",
		        "helmet",
		        "helmet_damage",
		        "beard_top",
		        "body_blood",
		        "accessory",
		        "accessory_special",
		        "dirt",
		        "permanent_injury_1",
		        "permanent_injury_2",
		        "permanent_injury_3",
		        "permanent_injury_4",
		        "bandage_1",
		        "bandage_2",
		        "bandage_3"
		];
		foreach (sprite in sprites)
		{
			if (_actor.hasSprite(sprite))
			{
				_actor.setSpriteOffset(sprite, this.createVec(_offsetx, _offsety));
			}
		}
	}

	function onEquip()
	{
		this.item.onEquip();
		this.addGenericItemSkill();
		this.updateAppearance();
		this.addSkill(this.new("scripts/skills/actives/xxitem_horse_skill"));
		this.addSkill(this.new("scripts/skills/actives/xxitem_horseaa_skill"));
		local actor = this.getContainer().getActor();
		if (actor.getSkills().hasSkill("effects.sb_wolfride_effect"))
		{
			actor.getSkills().removeByID("effects.sb_wolfride_effect");
		}
		if (actor.isAlliedWithPlayer())
		{
			actor.setSpriteOffset("arms_icon", this.createVec(-15, 5));
			this.moveActorSprites(actor, -10, 5);
		}
		else
		{
			actor.setSpriteOffset("arms_icon", this.createVec(15, 5));
			this.moveActorSprites(actor, 10, 5);
		}
		actor.setAlwaysApplySpriteOffset(true);
	}

	function onUnequip()
	{
		this.item.onUnequip();
		if (this.m.ShowOnCharacter)
		{
			local app = this.getContainer().getAppearance();
			app.Shield = "";
			app.RaiseShield = false;
			this.getContainer().updateAppearance();
		}
		local actor = this.getContainer().getActor();
		actor.setSpriteOffset("arms_icon", this.createVec(0, 0));
		this.moveActorSprites(actor, 0, 0);
		actor.setAlwaysApplySpriteOffset(false);
	}

	function onUpdateProperties( _properties )
	{
		this.item.onUpdateProperties(_properties);
		_properties.MeleeSkill += 15;
		_properties.MovementAPCostAdditional -= 1;
		_properties.MovementFatigueCostMult *= 0;
		_properties.MeleeDefense += this.m.MeleeDefense;
		_properties.RangedDefense += this.m.RangedDefense;
		_properties.Stamina += this.m.StaminaModifier;
		if (this.m.Condition == 1)
		{
			local actor = this.getContainer().getActor();
			if (actor != null && actor.isPlacedOnMap())
		        {
				actor.getItems().unequip(actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
			}
		}
	}

});

