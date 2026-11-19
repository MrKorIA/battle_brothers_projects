this.mod_ghost_skull_item <- ::inherit("scripts/items/weapons/weapon", {
	// directory scripts/items/tools/legendary/mod_ghost_skull_item
	m = {
		IsForcedDrop = false,
		Efficiency = 0.25,
		XP_Max = 5000,
		XP = 0,
	},
	function isCurseRemoved()
	{
		return ::ModLegendaryKriegsgeistLocation.ModSettings.getSetting("curse_is_removed_sword").getValue();
	}

	function addXP( _xp )
	{
		if (this.m.XP == this.m.XP_Max) return;

		this.m.XP = ::Math.min(this.m.XP_Max, this.m.XP + _xp);

		if (::Tactical.isActive())
		{
			::Tactical.EventLog.logEx("[color=#1e468f]" + this.m.Name + "[/color] получает [b]" + _xp + "[/b] заряда.");

			if (this.m.XP == this.m.XP_Max)
			{
				::Tactical.EventLog.log("[color=#1e468f]" + this.m.Name + "[/color] полностью заряжен.");
			}
		}
	}

	function useXP( _xp )
	{
		if (this.m.XP == 0) return;

		this.m.XP = this.Math.max(0, this.m.XP - _xp);

		if (::Tactical.isActive())
		{
			::Tactical.EventLog.logEx("[color=#1e468f]" + this.m.Name + "[/color] теряет [b]" + _xp + "[/b] заряда.");

			if (this.m.XP == 0)
			{
				::Tactical.EventLog.log("[color=#1e468f]" + this.m.Name + "[/color] полностью разряжен.");
			}
		}
	}

	function getXPLevel()
	{
		return ::Math.floor(this.m.XP / 500);
	}

	function getXP()
	{
		return this.m.XP;
	}

	function getEfficiency()
	{
		return ::ModLegendaryKriegsgeistLocation.ModSettings.getSetting("efficiency_skull").getValue();
	}

	function getName()
	{
		return ::ModLegendaryKriegsgeistLocation.ModSettings.getSetting("name_skull").getValue();
	}

	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.ghost_skull";
		this.m.Name = "Череп Кригсгейста";
		this.m.Description = "Чудовищный череп легендарного [b]Кригсгейста[/b]. Одно его существование не поддается никакому осмыслению, являясь одновременно и бесплотным, и телесным предметом. Держа его в руке, можно услышать, как некий голос шепчет в ушах, приказывая принести его в жертву в обмен на великую силу.";
		this.m.IconLarge = "tools/mod_ghost_skull.png";
		this.m.Icon = "tools/mod_ghost_skull_70x70.png";
		this.m.SlotType = ::Const.ItemSlot.Offhand;
		this.m.ItemType = ::Const.Items.ItemType.Tool | ::Const.Items.ItemType.Legendary;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.IsIndestructible = true;
		this.m.IsDroppedAsLoot = true;
		this.m.ArmamentIcon = "icon_mod_ghost_skull";
		this.m.Value = 30000;
		this.m.Condition = 1.0;
		this.m.ConditionMax = 1.0;
		this.m.StaminaModifier = 0;
	}

	function isForcedDrop()
	{
		return this.m.IsForcedDrop;
	}

	function drop( _tile = null )
	{
		this.m.IsForcedDrop = true;
		this.weapon.drop(_tile);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.m.IsForcedDrop = false;
		this.addSkill(::new("scripts/skills/special/mod_ghost_skull_XP_collecter"));
		this.addSkill(::new("scripts/skills/ghost_skull/mod_raise_undead_skill")); // tier 0
		this.addSkill(::new("scripts/skills/ghost_skull/mod_wither_skill")); // tier 2
		this.addSkill(::new("scripts/skills/ghost_skull/mod_insects_skill")); // tier 4
		this.addSkill(::new("scripts/skills/ghost_skull/mod_spawn_ghost_skill")); // tier 6
		this.addSkill(::new("scripts/skills/ghost_skull/mod_horror_skill")); // tier 8
		this.addSkill(::new("scripts/skills/ghost_skull/mod_death_skill")); // tier 10

		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().set("has_ghost_skull", this.getName());
		}
	}

	function onUnequip()
	{
		if (!this.m.IsForcedDrop && !this.isCurseRemoved())
		{
			this.useXP(::ModLegendaryKriegsgeistLocation.ModSettings.getSetting("loss_on_unequip").getValue());
		}

		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().remove("has_ghost_skull");
		}

		this.weapon.onUnequip();
	}

	function onUpdateProperties( _properties )
	{
		local stats = this.getBonus();
		_properties.Bravery += stats[0];
		_properties.Stamina += stats[1];
		_properties.Initiative += stats[2];
		_properties.MeleeSkill += stats[3];
		_properties.RangedSkill += stats[4];
		_properties.MeleeDefense += stats[5];
		_properties.RangedDefense += stats[6];
		_properties.DamageTotalMult *= 1.0 + stats[7];
//		_properties.SurvivesAsUndead = true;
		_properties.DamageReceivedMiasmaMult *= 0.5;
	}

	function getBonus()
	{
		local data = this.getBonusData();
		local lv = this.getXPLevel();
		local ret = array(8, 0);

		for (local i = 0; i <= lv; ++i)
		{
			foreach (j, s in data[i])
			{
				ret[j] += s;
			}
		}

		return ret;
	}

	function getBonusData()
	{
		return [
			[ // 0
				0, 0, 5, 0, 0, 0, 0, 0.1
			],
			[ // 1
				5, 5, 0, 0, 0, 0, 0, 0.0
			],
			[ // 2
				0, 0, 0, 5, 5, 0, 0, 0.0
			],
			[ // 3
				0, 0, 0, 0, 0, 5, 5, 0.0
			],
			[ // 4
				0, 3, 5, 0, 0, 0, 0, 0.0
			],
			[ // 5
				0, 0, 0, 3, 0, 3, 0, 0.0
			],
			[ // 6
				0, 0, 0, 0, 3, 0, 3, 0.0
			],
			[ // 7
				3, 0, 0, 0, 0, 0, 0, 0.05
			],
			[ // 8
				0, 0, 3, 0, 3, 0, 3, 0.0
			],
			[ // 9
				3, 0, 0, 3, 0, 3, 0, 0.0
			],
			[ // 10
				5, 5, 5, 5, 5, 5, 5, 0.1
			],
		];
	}

	function getXP_Tooltip()
	{
		return {
			id = 4,
			type = "progressbar",
			icon = "ui/icons/kills.png",
			value = this.m.XP,
			valueMax = this.m.XP_Max,
			text = "" + this.m.XP + " / " + this.m.XP_Max + "",
			style = "fatigue-slim"
		}
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.extend([
			{
				id = 66,
				type = "text",
				text = this.getValueString()
			},
			{
				id = 64,
				type = "text",
				text = "Берётся в левую руку"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт очки души, равные [color=" + ::Const.UI.Color.NegativeValue + "]" + this.getEfficiency() + "%[/color] опыта за убитых."
			}
		]);
		result.push(this.getXP_Tooltip());

		local stats = this.getBonus();

		if (stats[7] > 0.0)
		{
			result.push({
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "Урон от атаки [color=" + ::Const.UI.Color.PositiveValue + "]+" + stats[7] * 100 + "%[/color]"
			});
		}

		if (stats[3] > 0)
		{
			result.push({
				id = 4,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "Навык ближнего боя [color=" + ::Const.UI.Color.PositiveValue + "]+" + stats[3] + "[/color]"
			});
		}

		if (stats[4] > 0)
		{
			result.push({
				id = 4,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "Навык дальнего боя [color=" + ::Const.UI.Color.PositiveValue + "]+" + stats[4] + "[/color]"
			});
		}

		if (stats[5] > 0)
		{
			result.push({
				id = 4,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "Защита в ближнем бою [color=" + ::Const.UI.Color.PositiveValue + "]+" + stats[5] + "[/color]"
			});
		}

		if (stats[6] > 0)
		{
			result.push({
				id = 4,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "Защита в дальнем бою [color=" + ::Const.UI.Color.PositiveValue + "]+" + stats[6] + "[/color]"
			});
		}

		if (stats[1] > 0)
		{
			result.push({
				id = 4,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Максимальная выносливость [color=" + ::Const.UI.Color.PositiveValue + "]+" + stats[1] + "[/color]"
			});
		}

		if (stats[0] > 0)
		{
			result.push({
				id = 4,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "Решимость [color=" + ::Const.UI.Color.PositiveValue + "]+" + stats[0] + "[/color]"
			});
		}

		if (stats[2] > 0)
		{
			result.push({
				id = 4,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "Инициатива [color=" + ::Const.UI.Color.PositiveValue + "]+" + stats[2] + "[/color]"
			});
		}

		if (this.isEquipped() && !this.isCurseRemoved())
		{
			result.extend([
				{
					id = 4,
					type = "hint",
					icon = "ui/tooltips/negative.png",
					text = "Теряет [color=" + ::Const.UI.Color.NegativeValue + "]" + ::ModLegendaryKriegsgeistLocation.ModSettings.getSetting("loss_in_battle").getValue() + "[/color] очков души, если владелец не совершит ни одного убийства в бою"
				},
				{
					id = 4,
					type = "hint",
					icon = "ui/tooltips/negative.png",
					text = "Теряет [color=" + ::Const.UI.Color.NegativeValue + "]" + ::ModLegendaryKriegsgeistLocation.ModSettings.getSetting("loss_on_unequip").getValue() + "[/color] очков души, если владелец снимает этот предмет"
				}
			]);
		}

		return result;
	}

	function onSerialize( _out )
	{
		this.weapon.onSerialize(_out);
		_out.writeU16(this.m.XP);
	}

	function onDeserialize( _in )
	{
		this.weapon.onDeserialize(_in);
		this.m.XP = _in.readU16();
	}

});

