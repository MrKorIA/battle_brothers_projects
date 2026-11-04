this.legend_spawn_zombie_med_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.legend_spawn_zombie_med";
		this.m.Name = "Собрать ратника";
		this.m.Description = "Влить концентрированную кровь некросованта в останки закалённого воина, сшивая его тело воедино, и направить восставшего ратника прямиком в пекло сражения. Способность требует свободную клетку по соседству.";
		this.m.Icon = "skills/fashion_body.png";
		this.m.IconDisabled = "skills/fashion_body_bw.png";
		this.m.Overlay = "fashion_body";
		 this.m.SoundOnUse = [
		 	"sounds/combat/meat_01.wav",
		 	"sounds/combat/meat_02.wav",
		 	"sounds/combat/meat_03.wav",
			"sounds/combat/meat_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/necromancer_01.wav",
			"sounds/enemies/necromancer_02.wav",
			"sounds/enemies/necromancer_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.NonTargeted + 7;
		this.m.MaxLevelDifference = 4;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsTargetingActor = false;
	}

	function getTooltip()
    {
        local ret = [
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
                id = 3,
                type = "text",
                text = this.getCostString()
            },
            {
                id = 4,
                type = "text",
                icon = "ui/icons/health.png",
                text = "Стоит [color=" + this.Const.UI.Color.NegativeValue + "]20[/color] ОЗ."
            },
            {
                id = 5,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Потратит [color=" + this.Const.UI.Color.NegativeValue + "]1[/color] человеческую плоть из обоза отряда"
            }
        ];
        if (this.Tactical.isActive())
        {
            local haveItem = false;
            local items = this.World.Assets.getStash().getItems();
            foreach (item in items)
            {
                if (item == null)
                {
                    continue;
                }

                if (item.getID() != "spawns.zombie")
                {
                    continue;
                }

                haveItem = true;
                break;
            }
            if (this.getContainer().getActor().getHitpoints() < 21)
            {
                ret.push({
                    id = 9,
                    type = "text",
                    icon = "ui/tooltips/warning.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]Не может быть использовано, так как персонажу не хватает ОЗ.[/color]"
                });
            }
            if (!haveItem)
            {
                ret.push({
                    id = 10,
                    type = "text",
                    icon = "ui/tooltips/warning.png",
                    text = "[color=" + this.Const.UI.Color.NegativeValue + "]Не может быть использовано, так как закончилась человеческая плоть в обозе отряда.[/color]"
                });
            }
        }
        return ret;
    }

	function onVerifyTarget( _originTile, _targetTile )
	{
		return this.skill.onVerifyTarget(_originTile, _targetTile) && _targetTile.IsEmpty;
	}

	function onUse( _user, _targetTile )
	{
		_user.setHitpoints(_user.getHitpoints() - 20);
		this.World.Assets.getStash().removeByID("spawns.zombie");
		local entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/zombie", _targetTile.Coords.X, _targetTile.Coords.Y);
		entity.setFaction(this.Const.Faction.PlayerAnimals);
		entity.storeSpriteColors();
		entity.fadeTo(this.createColor("00000000"), 0);
		entity.getFlags().add("mold_minion");
		entity.setName("Сшитый ратник");

		local b = entity.getCurrentProperties();
        b.ActionPoints = ::Const.Tactical.Actor.LegendZombieMedium.ActionPoints;
        b.Hitpoints = ::Const.Tactical.Actor.LegendZombieMedium.Hitpoints;
        b.Bravery = ::Const.Tactical.Actor.LegendZombieMedium.Bravery;
        b.Stamina = ::Const.Tactical.Actor.LegendZombieMedium.Stamina;
        b.MeleeSkill = ::Const.Tactical.Actor.LegendZombieMedium.MeleeSkill;
        b.RangedSkill = ::Const.Tactical.Actor.LegendZombieMedium.RangedSkill;
        b.MeleeDefense = ::Const.Tactical.Actor.LegendZombieMedium.MeleeDefense;
        b.RangedDefense = ::Const.Tactical.Actor.LegendZombieMedium.RangedDefense;
        b.Initiative = ::Const.Tactical.Actor.LegendZombieMedium.Initiative;

		entity.setActionPoints(b.ActionPoints);
		entity.setHitpoints(b.Hitpoints);
		entity.m.CurrentProperties = clone b;

		entity.getSkills().add(this.new("scripts/skills/perks/perk_nine_lives"));
		entity.getSkills().add(this.new("scripts/skills/perks/perk_rotation"));
		local items = entity.getItems();

        if (items.getItemAtSlot(this.Const.ItemSlot.Head) != null)
        {
            items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
        }
        if (items.getItemAtSlot(this.Const.ItemSlot.Body) != null)
        {
            items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
        }
        if (items.getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
        {
            items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
        }
        if (items.getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
        {
            items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
        }

        local r = this.Math.rand(1, 6);
		if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/morning_star"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/ancient/falx"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/scramasax"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}
		else if (r == 6)
		{
			items.equip(this.new("scripts/items/weapons/shortsword"));
		}

        r = this.Math.rand(1, 7);
		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_lamellar"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/leather_scale_armor"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
		}
		else if (r == 6)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 7)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}

        r = this.Math.rand(1, 10);
		if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/kettle_hat"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/padded_kettle_hat"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/helmets/dented_nasal_helmet"));
		}
		else if (r == 6)
		{
			items.equip(this.new("scripts/items/helmets/mail_coif"));
		}
		else if (r == 7)
		{
			items.equip(this.new("scripts/items/helmets/full_leather_cap"));
		}

		if (this.Const.Tactical.RaiseUndeadParticles.len() != 0)
		{
			for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, _targetTile, this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
			}
			for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, _user.getTile(), this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
			}
		}
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 300, this.onDelayedEffect.bindenv(this), tag);
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local user = _tag.User;
		local ttile = _tag.TargetTile;
		local mtile = user.getTile();
		for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, ttile, this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
		}
		for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, mtile, this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
		}
		if (ttile.IsOccupiedByActor && ttile.getEntity().getFlags().has("mold_minion"))
		{
			local xtarget = ttile.getEntity();
			xtarget.fadeToStoredColors(500);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 510, function ( _tag )
			{
				xtarget.restoreSpriteColors();
                xtarget.setAlwaysApplySpriteOffset(true);
			}.bindenv(this), this);
		}
		return true;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else if (this.getContainer().getActor().getHitpoints() < 21)
		{
			return false;
		}

        local haveItem = false;
		local items = this.World.Assets.getStash().getItems();
		foreach (item in items)
		{
			if (item == null)
			{
				continue;
			}

			if (item.getID() != "spawns.zombie")
			{
				continue;
			}

			haveItem = true;
			break;
		}
		return haveItem;
	}

	function isHidden()
	{
		return false;
	}

    function onAfterUpdate(_properties) {
        local hasRange = this.getContainer().hasSkill("perk.legend_extended_aura");
        if (hasRange) this.m.MaxRange += 1;
    }

});
