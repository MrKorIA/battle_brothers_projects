this.legend_spawn_zombie_low_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.legend_spawn_zombie_low";
		this.m.Name = "Сшить падаль";
		this.m.Description = "Вдохнуть искру тёмной магии в куски гнилого мяса, поднимая изломанного крестьянина, и мгновенно бросить его в яростную атаку на врага. Способность требует свободную клетку по соседству.";
		this.m.Icon = "skills/mold_carrion.png";
		this.m.IconDisabled = "skills/mold_carrion_bw.png";
		this.m.Overlay = "mold_carrion";
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
		this.m.Order = this.Const.SkillOrder.NonTargeted + 5;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 10;
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
				text = "Стоит [color=" + this.Const.UI.Color.NegativeValue + "]15[/color] ОЗ."
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
            if (this.getContainer().getActor().getHitpoints() < 16)
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
		_user.setHitpoints(_user.getHitpoints() - 15);
		this.World.Assets.getStash().removeByID("spawns.zombie");
		local entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/zombie", _targetTile.Coords.X, _targetTile.Coords.Y);
		entity.setFaction(this.Const.Faction.PlayerAnimals);
		entity.storeSpriteColors();
		entity.fadeTo(this.createColor("00000000"), 0);
		entity.getFlags().add("mold_minion");
		entity.setName("Сшитая падаль");

		local b = entity.getCurrentProperties();
        b.ActionPoints = ::Const.Tactical.Actor.LegendZombieLight.ActionPoints;
        b.Hitpoints = ::Const.Tactical.Actor.LegendZombieLight.Hitpoints;
        b.Bravery = ::Const.Tactical.Actor.LegendZombieLight.Bravery;
        b.Stamina = ::Const.Tactical.Actor.LegendZombieLight.Stamina;
        b.MeleeSkill = ::Const.Tactical.Actor.LegendZombieLight.MeleeSkill;
        b.RangedSkill = ::Const.Tactical.Actor.LegendZombieLight.RangedSkill;
        b.MeleeDefense = ::Const.Tactical.Actor.LegendZombieLight.MeleeDefense;
        b.RangedDefense = ::Const.Tactical.Actor.LegendZombieLight.RangedDefense;
        b.Initiative = ::Const.Tactical.Actor.LegendZombieLight.Initiative;

		entity.setActionPoints(b.ActionPoints);
		entity.setHitpoints(b.Hitpoints);
		entity.m.CurrentProperties = clone b;

		entity.getSkills().add(this.new("scripts/skills/perks/perk_fast_adaption"));
		entity.getSkills().add(this.new("scripts/skills/perks/perk_nine_lives"));
		local items = entity.getItems();

        if (items.getItemAtSlot(this.Const.ItemSlot.Head) != null)
        {
            items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
        }
        if (items.getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
        {
            items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
        }
        if (items.getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
        {
            items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
        }

        local r = this.Math.rand(1, 2);
        if (r == 1)
        {
            items.equip(this.new("scripts/items/weapons/militia_spear"));
        }
        else if (r == 2)
        {
            items.equip(this.new("scripts/items/weapons/ancient/ancient_spear"));
        }

        r = this.Math.rand(1, 2);
		if (r == 1)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield_old"));
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
		else if (this.getContainer().getActor().getHitpoints() < 16)
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
