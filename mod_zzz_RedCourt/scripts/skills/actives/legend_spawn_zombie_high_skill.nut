this.legend_spawn_zombie_high_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.legend_spawn_zombie_high";
		this.m.Name = "Шедевр из плоти";
		this.m.Description = "Подчинить волю павшего рыцаря, намертво сковав его кости вечной жаждой Красного Двора, и бросить этот неудержимый живой таран в ряды врага. Способность требует свободную клетку по соседству.";
		this.m.Icon = "skills/remake_man.png";
		this.m.IconDisabled = "skills/remake_man_bw.png";
		this.m.Overlay = "remake_man";
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
		this.m.Order = this.Const.SkillOrder.NonTargeted + 9;
		this.m.MaxLevelDifference = 4;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 25;
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
                text = "Стоит [color=" + this.Const.UI.Color.NegativeValue + "]30[/color] ОЗ."
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
            if (this.getContainer().getActor().getHitpoints() < 31)
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
		_user.setHitpoints(_user.getHitpoints() - 30);
		this.World.Assets.getStash().removeByID("spawns.zombie");
		local entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/zombie", _targetTile.Coords.X, _targetTile.Coords.Y);
		entity.setFaction(this.Const.Faction.PlayerAnimals);
		entity.storeSpriteColors();
		entity.fadeTo(this.createColor("00000000"), 0);
		entity.getFlags().add("mold_minion");
		entity.setName("Сшитый рыцарь");

		local b = entity.getCurrentProperties();
        b.ActionPoints = ::Const.Tactical.Actor.LegendZombieHeavy.ActionPoints;
        b.Hitpoints = ::Const.Tactical.Actor.LegendZombieHeavy.Hitpoints;
        b.Bravery = ::Const.Tactical.Actor.LegendZombieHeavy.Bravery;
        b.Stamina = ::Const.Tactical.Actor.LegendZombieHeavy.Stamina;
        b.MeleeSkill = ::Const.Tactical.Actor.LegendZombieHeavy.MeleeSkill;
        b.RangedSkill = ::Const.Tactical.Actor.LegendZombieHeavy.RangedSkill;
        b.MeleeDefense = ::Const.Tactical.Actor.LegendZombieHeavy.MeleeDefense;
        b.RangedDefense = ::Const.Tactical.Actor.LegendZombieHeavy.RangedDefense;
        b.Initiative = ::Const.Tactical.Actor.LegendZombieHeavy.Initiative;

		entity.setActionPoints(b.ActionPoints);
		entity.setHitpoints(b.Hitpoints);
		entity.m.CurrentProperties = clone b;

		entity.getSkills().add(this.new("scripts/skills/perks/perk_fearsome"));
		entity.getSkills().add(this.new("scripts/skills/perks/perk_reach_advantage"));
		entity.getSkills().add(this.new("scripts/skills/perks/perk_nine_lives"));
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

		local r = this.Math.rand(0, 8);

		if (r <= 1)
		{
			if (this.Const.DLC.Unhold)
			{
				r = this.Math.rand(1, 3);

				if (r == 1)
				{
					items.equip(this.new("scripts/items/weapons/longsword"));
				}
				else if (r == 2)
				{
					items.equip(this.new("scripts/items/weapons/greataxe"));
				}
				else if (r == 3)
				{
					items.equip(this.new("scripts/items/weapons/two_handed_flail"));
				}
			}
			else
			{
				r = this.Math.rand(1, 2);

				if (r == 1)
				{
					items.equip(this.new("scripts/items/weapons/longsword"));
				}
				else if (r == 2)
				{
					items.equip(this.new("scripts/items/weapons/greataxe"));
				}
			}
		}
		else
		{
			if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/winged_mace"));
			}
			else if (r == 3)
			{
				items.equip(this.new("scripts/items/weapons/ancient/ancient_sword"));
			}
			else if (r == 4)
			{
				items.equip(this.new("scripts/items/weapons/fighting_axe"));
			}
			else if (r == 5)
			{
				items.equip(this.new("scripts/items/weapons/morning_star"));
			}
			else if (r == 6)
			{
				items.equip(this.new("scripts/items/weapons/arming_sword"));
			}
			else if (r == 7)
			{
				items.equip(this.new("scripts/items/weapons/flail"));
			}
			else if (r == 8)
			{
				items.equip(this.new("scripts/items/weapons/military_cleaver"));
			}
			else if (this.Math.rand(1, 2) == 1)
			{
				items.equip(this.new("scripts/items/shields/worn_heater_shield"));
			}
			else
			{
				items.equip(this.new("scripts/items/shields/worn_kite_shield"));
			}
		}

        r = this.Math.rand(1, 3);
		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/decayed_coat_of_plates"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/decayed_coat_of_scales"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/decayed_reinforced_mail_hauberk"));
		}

		local helmet = ::MSU.Class.WeightedContainer([
                    [2, "scripts/items/helmets/decayed_closed_flat_top_with_mail"],
                    [1, "scripts/items/helmets/decayed_closed_flat_top_with_sack"],
                    [3, "scripts/items/helmets/decayed_full_helm"],
                    [3, "scripts/items/helmets/decayed_great_helm"]
                ]).roll();

        items.equip(this.new(helmet));

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
		else if (this.getContainer().getActor().getHitpoints() < 31)
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
