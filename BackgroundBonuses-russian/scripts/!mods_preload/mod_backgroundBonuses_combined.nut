::modBackgroundBonuses <- {
	Version = "1.14.0",
	ID = "backgroundBonuses",
	Name = "Бонусы предысторий",
};

::modBackgroundBonuses.HooksMod <- ::Hooks.register(::modBackgroundBonuses.ID, ::modBackgroundBonuses.Version, ::modBackgroundBonuses.Name);

::modBackgroundBonuses.HooksMod.queue(">mod_msu", function() {

	::modBackgroundBonuses.Mod <- ::MSU.Class.Mod(::modBackgroundBonuses.ID, ::modBackgroundBonuses.Version, ::modBackgroundBonuses.Name);

	local page = ::modBackgroundBonuses.Mod.ModSettings.addPage("Общая информация");
    local function add(elem) {
        page.addElement(elem);
    }
    ::modBackgroundBonuses.conf <- function(name) {
        return ::modBackgroundBonuses.Mod.ModSettings.getSetting(name).getValue();
    }

    add(::MSU.Class.BooleanSetting("forcePerkGroups", false, "Группы принудительных действий",
        "Если включено, то предыстории с бонусами, связанными с определенным оружием, всегда будут увеличивать группу навыков этого оружия в Reforged (затронутые предыстории: Жонглер, Пастух, Плотник, Флетчер, Пират)"));

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/adventurous_noble_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Увеличивает дальнобойную защиту на 10% от решимости."
			});
			return ret;
		}	

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Увеличивает дальнобойную защиту на 10% от решимости."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			_properties.RangedDefense += 0.1 * this.getContainer().getActor().getCurrentProperties().getBravery();
			__original( _properties);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/anatomist_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Все союзники получают +1 ОЗ в начале хода этого персонажа."
			});
			return ret;
		}	

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Все союзники получают +1 ОЗ в начале хода этого персонажа."
			});
			return ret;
		}	

		q.onTurnStart = @(__original) function( )
		{
			__original( );
			
			local actor = this.getContainer().getActor();
			local allies = this.Tactical.Entities.getInstancesOfFaction(actor.getFaction());
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " лечит всех союзников на 1 ОЗ");
			foreach( ally in allies )
			{
				if (!ally.isPlacedOnMap())
				{
					continue;
				}	

				ally.m.Hitpoints = Math.min(ally.getHitpoints() + 1, ally.getHitpointsMax());
			}
		}
	});	

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/apprentice_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Продолжает повышать характеристики и навыки до 12-го уровня."
			});
			return ret;
		}	

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Продолжает повышать характеристики и навыки до 12-го уровня."
			});
			return ret;
		}	

		q.onUpdateLevel = @(__original) function( )
		{
			__original( );
			
			local actor = this.getContainer().getActor();
			local currLevel = actor.getLevel();
			if(actor.getLevel() == 12)
			{
				actor.fillAttributeLevelUpValues(1);
				actor.m.PerkPoints = actor.m.PerkPoints + 1;
			}
		}
	});
	
	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/assassin_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Все атаки кинжалами игнорируют 100% брони."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Все атаки кинжалами игнорируют 100% брони."
			});
			return ret;
		}

		q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
		{
			if( _targetEntity != null )
			{
				local weapon = _skill.getItem();
				if(weapon != null && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Dagger))
				{
					_properties.DamageDirectMult = 10.0;
				}
			}
			return __original( _skill, _targetEntity, _properties );
		}
	});
	
	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/assassin_southern_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Урон в ближнем бою на +15% больше пробивает броню против оглушенных, ошеломленных, отвлеченных, опутанных паутиной, обездвиженных или опутанных сетью врагов."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Урон в ближнем бою на +15% больше пробивает броню против оглушенных, ошеломленных, отвлеченных, опутанных паутиной, обездвиженных или опутанных сетью врагов."
			});
			return ret;
		}	

		q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
		{
			if( _targetEntity != null )
			{
				if(_skill.isAttack() && !_skill.isRanged() && (_targetEntity.getSkills().hasSkill("effects.stunned") || _targetEntity.getSkills().hasSkill("effects.dazed") || _targetEntity.getSkills().hasSkill("effects.distracted") || _targetEntity.getSkills().hasSkill("effects.rooted") || _targetEntity.getSkills().hasSkill("effects.net")))
				{ 
					_properties.DamageDirectMult += 0.15;
				}
			}
			return __original( _skill, _targetEntity, _properties );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/barbarian_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Исцеляет ОЗ на 20% от нанесенного урона."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Исцеляет ОЗ на 20% от нанесенного урона."
			});
			return ret;
		}	

		q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
		{
			if(_damageInflictedHitpoints > 0)
			{
				local actor = this.getContainer().getActor();
				if(actor.getHitpoints() < actor.getHitpointsMax())
				{
					actor.setHitpoints(this.Math.min(actor.getHitpointsMax(), actor.getHitpoints() + this.Math.round(_damageInflictedHitpoints * 0.2)));
				}
			}
			return __original( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/bastard_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит на 15% больше урона воинам благородных домов."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит на 15% больше урона воинам благородных домов."
			});
			return ret;
		}	

		q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
		{
			if( _targetEntity != null )
			{
				if(_skill.isAttack() && this.Const.EntityType.getDefaultFaction(_targetEntity.getType()) == this.Const.FactionType.NobleHouse)
				{
					_properties.MeleeDamageMult *= 1.15;
					_properties.RangedDamageMult *= 1.15;
				}
			}
			return __original( _skill, _targetEntity, _properties );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/beast_hunter_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит на 15% больше урона зверям."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит на 15% больше урона зверям."
			});
			return ret;
		}	

		q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
		{
			if( _targetEntity != null )
			{
				if(_skill.isAttack() && (this.Const.EntityType.getDefaultFaction(_targetEntity.getType()) == this.Const.FactionType.Beasts || _targetEntity.getType() == this.Const.EntityType.BarbarianUnhold || _targetEntity.getType() == this.Const.EntityType.BarbarianUnholdFrost ))
				{
					_properties.MeleeDamageMult *= 1.15;
					_properties.RangedDamageMult *= 1.15;
				}
			}
			return __original( _skill, _targetEntity, _properties );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/beggar_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт одно дополнительное очко навыков."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт одно дополнительное очко навыков."
			});
			return ret;
		}	

		q.onAdded = @(__original) function( )
		{
			local ret = __original();
			local actor = this.getContainer().getActor();
			actor.m.PerkPoints = actor.m.PerkPoints + 1;

			return ret;
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/belly_dancer_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит 5 единиц урона врагам всякий раз, когда этот персонаж уклоняется от их атаки."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит 5 единиц урона врагам всякий раз, когда этот персонаж уклоняется от их атаки."
			});
			return ret;
		}	

		q.onMissed = @(__original) function( _attacker, _skill )
		{
			local ret = __original( _attacker, _skill);
			if (!_skill.isAttack() || !_attacker.isAlive() || _attacker.isDying() || _attacker.getFaction() == this.Const.Faction.Player)
			{
				return ret;
			}

			local actor = this.getContainer().getActor();
			local _data = {Actor = actor, Attacker = _attacker};
			::Time.scheduleEvent(::TimeUnit.Virtual, 1, this.damageOnMissed, _data);
			
			return ret;
		}

		q.damageOnMissed <- function(_data)
		{
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = 5;
			hitInfo.DamageArmor = 0.0;
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			_data.Attacker.onDamageReceived(_data.Actor, null, hitInfo);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/bowyer_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит +1 дополнительный урон за каждую клетку между персонажем и целью."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит +1 дополнительный урон за каждую клетку между персонажем и целью."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			if(this.getContainer().getActor().isPlacedOnMap())
			{
				_properties.DamageAdditionalWithEachTile = 1.0;
			}
			__original( _properties);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/brawler_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Накапливает на 50% меньше усталости от вражеских атак, независимо от того, попадают они или нет."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Накапливает на 50% меньше усталости от вражеских атак, независимо от того, попадают они или нет."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			__original( _properties);
			if(this.getContainer().getActor().isPlacedOnMap())
			{
				_properties.FatigueLossOnAnyAttackMult = 0.5;
			}
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/butcher_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит один дополнительный уровень кровотечения всякий раз, когда наносит урон, независимо от вида оружия."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит один дополнительный уровень кровотечения всякий раз, когда наносит урон, независимо от вида оружия."
			});
			return ret;
		}	

		q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
		{
			__original( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor );
			
			if( _targetEntity.isAlive() && !_targetEntity.isDying() && _damageInflictedHitpoints >= 1 && !_targetEntity.getCurrentProperties().IsImmuneToBleeding)
			{
				local effect = this.new("scripts/skills/effects/bleeding_effect");
				effect.setDamage(1);
				_targetEntity.getSkills().add(effect);
			}
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/caravan_hand_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит на 15% больше урона бандитам."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит на 15% больше урона бандитам."
			});
			return ret;
		}	

		q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
		{
			if( _targetEntity != null )
			{
				if(_skill.isAttack() && (this.Const.EntityType.getDefaultFaction(_targetEntity.getType()) == this.Const.FactionType.Bandits || this.Const.EntityType.getDefaultFaction(_targetEntity.getType()) == this.Const.FactionType.OrientalBandits ))
				{
					_properties.MeleeDamageMult *= 1.15;
					_properties.RangedDamageMult *= 1.15;
				}
			}
			return __original( _skill, _targetEntity, _properties );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/companion_1h_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Увеличивает все характеристики на +2."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Увеличивает все характеристики на +2."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			__original( _properties);
			_properties.Hitpoints += 2;
			_properties.Bravery += 2;
			_properties.Stamina += 2;
			_properties.Initiative += 2;
			_properties.MeleeSkill += 2;
			_properties.RangedSkill += 2;
			_properties.MeleeDefense += 2;
			_properties.RangedDefense += 2;
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/companion_2h_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Увеличивает все характеристики на +2."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Увеличивает все характеристики на +2."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			__original( _properties);
			_properties.Hitpoints += 2;
			_properties.Bravery += 2;
			_properties.Stamina += 2;
			_properties.Initiative += 2;
			_properties.MeleeSkill += 2;
			_properties.RangedSkill += 2;
			_properties.MeleeDefense += 2;
			_properties.RangedDefense += 2;
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/companion_ranged_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Увеличивает все характеристики на +2."
			});
			return ret;
		}	

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Увеличивает все характеристики на +2."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			__original( _properties);
			_properties.Hitpoints += 2;
			_properties.Bravery += 2;
			_properties.Stamina += 2;
			_properties.Initiative += 2;
			_properties.MeleeSkill += 2;
			_properties.RangedSkill += 2;
			_properties.MeleeDefense += 2;
			_properties.RangedDefense += 2;
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/crucified_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Все оружейные умения стрельбы по одиночным целям, ближнего и дальнего боя, имеют максимальную дальность стрельбы +1."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Все оружейные умения стрельбы по одиночным целям, ближнего и дальнего боя, имеют максимальную дальность стрельбы +1."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			local weapon = this.getContainer().getActor().getMainhandItem();
			if(weapon != null && weapon.isItemType(::Const.Items.ItemType.Weapon))
			{
				foreach (skill in weapon.getSkills())
				{
					if(skill.m.IsAOE == false)
					{
						skill.m.MaxRange += 1;
					}
				}
			}
			__original( _properties);
		}
	});
	
	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/cripple_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт +2 ко всем характеристикам за каждую травму."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт +2 ко всем характеристикам за каждую травму."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			local injuries = this.getContainer().getActor().getSkills().query( this.Const.SkillType.Injury | this.Const.SkillType.SemiInjury);
			local numInj = injuries.len();

			_properties.Hitpoints += 2 * numInj;
			_properties.Bravery += 2 * numInj;
			_properties.Stamina += 2 * numInj;
			_properties.Initiative += 2 * numInj;
			_properties.MeleeSkill += 2 * numInj;
			_properties.RangedSkill += 2 * numInj;
			_properties.MeleeDefense += 2 * numInj;
			_properties.RangedDefense += 2 * numInj;

			__original( _properties);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/crusader_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит нежити на 30% больше урона."
			});
			return ret;
		}	

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит нежити на 30% больше урона."
			});
			return ret;
		}	

		q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
		{
			if( _targetEntity != null )
			{
				if(_skill.isAttack() && (this.Const.EntityType.getDefaultFaction(_targetEntity.getType()) == this.Const.FactionType.Zombies || this.Const.EntityType.getDefaultFaction(_targetEntity.getType()) == this.Const.FactionType.Undead ))
				{
					_properties.MeleeDamageMult *= 1.3;
					_properties.RangedDamageMult *= 1.3;
				}
			}
			return __original( _skill, _targetEntity, _properties );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/cultist_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Положительная проверка боевого духа при смерти союзников."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Положительная проверка боевого духа при смерти союзников."
			});
			return ret;
		}
		
		q.onUpdate = @(__original) function( _properties )
		{
			__original( _properties );

			_properties.IsAffectedByDyingAllies = false;
		}
		
		q.onOtherActorDeath = @(__original) function( _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType )
		{
			__original(  _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType  );
			
			local actor = this.getContainer().getActor();
			if( _victim.isAlliedWith(actor) )
			{
				actor.checkMorale(1, this.Const.Morale.AllyKilledBaseDifficulty);
			}
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/converted_cultist_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Положительная проверка боевого духа при смерти союзников."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Положительная проверка боевого духа при смерти союзников."
			});
			return ret;
		}
		
		q.onUpdate = @(__original) function( _properties )
		{
			__original( _properties );

			_properties.IsAffectedByDyingAllies = false;
		}
		
		q.onOtherActorDeath = @(__original) function( _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType )
		{
			__original(  _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType  );
			
			local actor = this.getContainer().getActor();
			if( _victim.isAlliedWith(actor) )
			{
				actor.checkMorale(1, this.Const.Morale.AllyKilledBaseDifficulty);
			}
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/daytaler_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Увеличивает базовую выносливость на 30%. Каждый ход восстанавливает на 3 выносливости меньше."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Увеличивает базовую выносливость на 30%. Каждый ход восстанавливает на 3 выносливости меньше."
			});
			return ret;
		}	
	
		q.onUpdate = @(__original) function( _properties )
		{
			local baseStamina = this.getContainer().getActor().getBaseProperties().Stamina;
			_properties.Stamina += baseStamina * 0.3;
			_properties.FatigueRecoveryRate += -3;
			__original( _properties);
		}
	});
	
	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/deserter_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит на 20% увеличенный урон при колеблющемся боевом духе и на 40% увеличенный урон при сломленном."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит на 20% увеличенный урон при колеблющемся боевом духе и на 40% увеличенный урон при сломленном."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			if(this.getContainer().getActor().isPlacedOnMap())
			{
				local actor = this.getContainer().getActor();
				if (actor.getMoraleState() == this.Const.MoraleState.Wavering) 
				{
					_properties.DamageTotalMult *= 1.2;
				}
				if (actor.getMoraleState() == this.Const.MoraleState.Breaking)
				{
					_properties.DamageTotalMult *= 1.4;
				}
			}
			__original( _properties);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/disowned_noble_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			local tooltipText = "";
			if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
			{
				tooltipText = "Эффект положительного состояния боевого духа в два раза сильнее. Эффект отрицательного состояния боевого духа на 50% сильнее.";
			}
			else
			{
				tooltipText = "Влияние отрицательных состояний боевого духа на 25% слабее."
			}
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = tooltipText
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			local tooltipText = "";
			if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
			{
				tooltipText = "Эффект положительного состояния боевого духа в два раза сильнее. Эффект отрицательного состояния боевого духа на 50% сильнее.";
			}
			else
			{
				tooltipText = "Влияние отрицательных состояний боевого духа на 25% слабее."
			}
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = tooltipText
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			if(this.getContainer().getActor().isPlacedOnMap())
			{
				local actor = this.getContainer().getActor();
				if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
				{
					if (actor.getMoraleState() == this.Const.MoraleState.Confident) 
					{
						_properties.MeleeSkillMult *= 1.1;
						_properties.RangedSkillMult *= 1.1;
						_properties.MeleeDefenseMult *= 1.1;
						_properties.RangedDefenseMult *= 1.1;
					}
					else if (actor.getMoraleState() == this.Const.MoraleState.Wavering)
					{
						_properties.BraveryMult *= 0.95;
						_properties.MeleeSkillMult *= 0.95;
						_properties.RangedSkillMult *= 0.95;
						_properties.MeleeDefenseMult *= 0.95;
						_properties.RangedDefenseMult *= 0.95;
					}
					else if (actor.getMoraleState() == this.Const.MoraleState.Breaking)
					{
						_properties.BraveryMult *= 0.9;
						_properties.MeleeSkillMult *= 0.9;
						_properties.RangedSkillMult *= 0.9;
						_properties.MeleeDefenseMult *= 0.9;
						_properties.RangedDefenseMult *= 0.9;
					}
					else if (actor.getMoraleState() == this.Const.MoraleState.Fleeing)
					{
						_properties.BraveryMult *= 0.85;
						_properties.MeleeSkillMult *= 0.85;
						_properties.RangedSkillMult *= 0.85;
						_properties.MeleeDefenseMult *= 0.85;
						_properties.RangedDefenseMult *= 0.85;
					}
				}
				else
				{
					if (actor.getMoraleState() == this.Const.MoraleState.Wavering)
					{
						_properties.BraveryMult *= 1.025;
						_properties.MeleeSkillMult *= 1.025;
						_properties.RangedSkillMult *= 1.025;
						_properties.MeleeDefenseMult *= 1.025;
						_properties.RangedDefenseMult *= 1.025;
					}
					else if (actor.getMoraleState() == this.Const.MoraleState.Breaking)
					{
						_properties.BraveryMult *= 1.05;
						_properties.MeleeSkillMult *= 1.05;
						_properties.RangedSkillMult *= 1.05;
						_properties.MeleeDefenseMult *= 1.05;
						_properties.RangedDefenseMult *= 1.05;
					}
					else if (actor.getMoraleState() == this.Const.MoraleState.Fleeing)
					{
						_properties.BraveryMult *= 1.075;
						_properties.MeleeSkillMult *= 1.075;
						_properties.RangedSkillMult *= 1.075;
						_properties.MeleeDefenseMult *= 1.075;
						_properties.RangedDefenseMult *= 1.075;
					}
				}
			}
			__original( _properties);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/regent_in_absentia_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			local tooltipText = "";
			if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
			{
				tooltipText = "Всегда будет поддерживать уверенный боевой дух.";
			}
			else
			{
				tooltipText = "Всегда обретает эффект уверенного боевого духа и никогда не опустится ниже уровня устойчивого боевого духа."
			}
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = tooltipText
			});
			return ret;
		}	

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			local tooltipText = "";
			if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
			{
				tooltipText = "Всегда будет поддерживать уверенный боевой дух.";
			}
			else
			{
				tooltipText = "Всегда обретает эффект уверенного боевого духа и никогда не опустится ниже уровня устойчивого боевого духа."
			}
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = tooltipText
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			__original( _properties );

			if(this.getContainer().getActor().isPlacedOnMap())
			{
				local actor = this.getContainer().getActor();
				if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
				{
					actor.setMoraleState(this.Const.MoraleState.Confident);
				}
				else
				{
					actor.setMoraleState(this.Const.MoraleState.Steady);
					_properties.MeleeSkillMult *= 1.1;
					_properties.RangedSkillMult *= 1.1;
					_properties.MeleeDefenseMult *= 1.1;
					_properties.RangedDefenseMult *= 1.1;
				}
			}
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/eunuch_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Невосприимчив к очарованию, страху и другим психическим воздействиям."
			});
			return ret;
		}	

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Невосприимчив к очарованию, страху и другим психическим воздействиям."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			__original( _properties );

			if(this.getContainer().getActor().isPlacedOnMap())
			{
				_properties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] = 1000.0;
			}
		}
	});

	if( ::mods_getRegisteredMod("mod_reforged") == null )
	{
		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/farmhand_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Увеличивает базовую выносливость на 10%. Увеличивает шанс попадания вилами на 10% и лезвиями с крючьями на 5%."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Увеличивает базовую выносливость на 10%. Увеличивает шанс попадания вилами на 10% и лезвиями с крючьями на 5%."
				});
				return ret;
			}	

			q.onUpdate = @(__original) function( _properties )
			{
				local baseStamina = this.getContainer().getActor().getBaseProperties().Stamina;
				_properties.Stamina += baseStamina * 0.1;
				__original( _properties);
			}

			q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
			{
				__original(_skill, _targetEntity, _properties);	

				local weapon = _skill.getItem();
				if (weapon != null)
				{
					if (weapon.getID() == "weapon.pitchfork")
					{
						_properties.MeleeSkill += 10;
					}
					else if(weapon.getID() == "weapon.hooked_blade")
					{
						_properties.MeleeSkill += 5;
					}
				}
			}
		});
	}
	else
	{
		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/farmhand_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Увеличивает базовую выносливость на 10%."
				});
				return ret;
			}	

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Увеличивает базовую выносливость на 10%."
				});
				return ret;
			}	

			q.onUpdate = @(__original) function( _properties )
			{
				local baseStamina = this.getContainer().getActor().getBaseProperties().Stamina;
				_properties.Stamina += baseStamina * 0.1;
				__original( _properties);
			}
		});
	}

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/fisherman_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Может бросать сети за 0 ОД."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Может бросать сети за 0 ОД."
			});
			return ret;
		}	

		q.onAfterUpdate = @(__original) function( _properties )
		{
			__original( _properties );
			
			local netThrow = this.getContainer().getSkillByID("actives.throw_net");
			if(netThrow != null)
			{
				netThrow.m.ActionPointCost = 0;
			}
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/flagellant_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Положительная проверка боевого духа при получении урона."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Положительная проверка боевого духа при получении урона."
			});
			return ret;
		}
		
		q.onUpdate = @(__original) function( _properties )
		{
			__original( _properties );

			_properties.IsAffectedByLosingHitpoints = false;
		}
		
		q.onDamageReceived = @(__original) function( _attacker, _damageHitpoints, _damageArmor )
		{
			__original( _attacker, _damageHitpoints, _damageArmor );
			
			local actor = this.getContainer().getActor();
			actor.checkMorale(1, this.Const.Morale.OnHitBaseDifficulty);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/monk_turned_flagellant_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт % дополнительного урона, равного % потерянного здоровья."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт % дополнительного урона, равного % потерянного здоровья."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			local actor = this.getContainer().getActor();
			local pct = 1 - actor.getHitpointsPct();
			if (pct > 0)
			{
				_properties.DamageTotalMult *= 1 + pct;
			}
			__original( _properties);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/gambler_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "После повышения уровня производится бросок кубика. При 1 характеристики увеличиваются на 1. При 2-5 характеристики увеличиваются как обычно. При 6 характеристики увеличиваются на максимальное значение +1."
			});
			return ret;
		}	

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "После повышения уровня производится бросок кубика. При 1 характеристики увеличиваются на 1. При 2-5 характеристики увеличиваются как обычно. При 6 характеристики увеличиваются на максимальное значение +1."
			});
			return ret;
		}	

		q.onUpdateLevel = @(__original) function( )
		{
			__original( );
			
			local actor = this.getContainer().getActor();
			local currLevel = actor.getLevel();
			if (currLevel <= 11)
			{
                for (local i = 0; i != this.Const.Attributes.COUNT; i = ++i)
                {
                    local num = Math.rand(1, 6);
                    if (num == 1)
                    {
                        if (actor.m.Attributes[i].len() >= actor.m.LevelUps)
                        {
                            actor.m.Attributes[i].remove(actor.m.LevelUps - 1);
                            actor.m.Attributes[i].insert(actor.m.LevelUps - 1, 1);
                        }
                    }
                    else if (num == 6)
                    {
                        if (actor.m.Attributes[i].len() >= actor.m.LevelUps)
                        {
                            actor.m.Attributes[i].remove(actor.m.LevelUps - 1);
                            actor.m.Attributes[i].insert(actor.m.LevelUps - 1, this.Const.AttributesLevelUp[i].Max + (actor.m.Talents[i] >= 2 ? 1 : 0) + 1);
                        }
                    }
                }
			}
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/gladiator_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт 0,5% дополнительного урона в ближнем бою за каждого союзника и врага, которые в данный момент не вовлечены в ближний бой."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт 0,5% дополнительного урона в ближнем бою за каждого союзника и врага, которые в данный момент не вовлечены в ближний бой."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{			
			if(this.getContainer().getActor().isPlacedOnMap())
			{
				local actor = this.getContainer().getActor();
				local watchers = 0;
				local units = this.Tactical.Entities.getAllInstances();
				foreach (faction in units)
				{
					foreach (unit in faction)
					{
						if (unit.getID() == actor.getID() || !unit.isPlacedOnMap())
						{
							continue;
						}
						if(!unit.isEngagedInMelee())
						{
							watchers++;
						}
					}
				}
				_properties.MeleeDamageMult *= 1 + (0.005 * watchers);
			}
			__original( _properties);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/gravedigger_background", function(q) {
		
		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт +1 к максимальной выносливости за каждого погибшего союзника, до +30."
			});
			return ret;
		}	

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт +1 к максимальной выносливости за каждого погибшего союзника, до +30."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			__original( _properties);
			
			_properties.Stamina += this.getContainer().getActor().m.Flags.get("mod_background_bonuses.GD_alliedDeaths") || 0;
		}

		q.onOtherActorDeath = @(__original) function( _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType )
		{
			__original(  _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType  );
			local actor = this.getContainer().getActor();
			local currentDeathsBonus = actor.m.Flags.get("mod_background_bonuses.GD_alliedDeaths") || 0;
			if(_victim.isPlayerControlled() && _fatalityType != ::Const.FatalityType.Unconscious && currentDeathsBonus < 30)
			{
				actor.m.Flags.increment("mod_background_bonuses.GD_alliedDeaths");
			}
		}
		
		q.onAdded = @(__original) function( )
		{
			if( this.m.IsNew )
			{
				this.getContainer().getActor().m.Flags.set("mod_background_bonuses.GD_alliedDeaths", 0);
			}
			return __original( );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/graverobber_background", function(q) {
		
		q.m.HeadDamageTaken <- 0;
		q.m.BodyDamageTaken <- 0;

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт +2 к броне головы и тела за каждого погибшего союзника, до +60."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт +2 к броне головы и тела за каждого погибшего союзника, до +60."
			});
			return ret;
		}
		
		q.onCombatStarted = @(__original) function( )
		{
			this.m.HeadDamageTaken = 0;
			this.m.BodyDamageTaken = 0;
			return __original();
		}

		q.onCombatFinished = @(__original) function( )
		{
			this.m.HeadDamageTaken = 0;
			this.m.BodyDamageTaken = 0;
			return __original();
		}

		q.onUpdate = @(__original) function( _properties )
		{
			__original( _properties);

			local alliedDeathsBoost = this.getContainer().getActor().m.Flags.get("mod_background_bonuses.GR_alliedDeaths") || 0;
			_properties.Armor[this.Const.BodyPart.Head] += this.Math.max(0.0, alliedDeathsBoost - this.m.HeadDamageTaken);
			_properties.Armor[this.Const.BodyPart.Body] += this.Math.max(0.0, alliedDeathsBoost - this.m.BodyDamageTaken);
			_properties.ArmorMax[this.Const.BodyPart.Head] += alliedDeathsBoost;
			_properties.ArmorMax[this.Const.BodyPart.Body] += alliedDeathsBoost;
		}

		q.onOtherActorDeath = @(__original) function( _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType )
		{
			__original(  _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType  );
			
			local currentDeathsBonus = this.getContainer().getActor().m.Flags.get("mod_background_bonuses.GR_alliedDeaths") || 0;
			if(_victim.isPlayerControlled() && _fatalityType != ::Const.FatalityType.Unconscious && currentDeathsBonus < 60)
			{
				this.getContainer().getActor().m.Flags.increment("mod_background_bonuses.GR_alliedDeaths");
				this.getContainer().getActor().m.Flags.increment("mod_background_bonuses.GR_alliedDeaths");
			}
		}

		q.onBeforeDamageReceived = @(__original) function( _attacker, _skill, _hitInfo, _properties )
		{
			local alliedDeathsBoost = this.getContainer().getActor().m.Flags.get("mod_background_bonuses.GR_alliedDeaths") || 0;
			if (_hitInfo.BodyPart == this.Const.BodyPart.Head && (!this.getContainer().hasSkill("effects.ifrit_potion") || this.getContainer().getSkillByID("effects.ifrit_potion").m.HeadDamageTaken >= 25))
			{
				if (this.m.HeadDamageTaken >= alliedDeathsBoost)
				{
					return;
				}

				_properties.DamageArmorReduction += alliedDeathsBoost - this.m.HeadDamageTaken;
				this.m.HeadDamageTaken += _hitInfo.DamageArmor;
			}
			else if (_hitInfo.BodyPart == this.Const.BodyPart.Body && (!this.getContainer().hasSkill("effects.ifrit_potion") || this.getContainer().getSkillByID("effects.ifrit_potion").m.BodyDamageTaken >= 25))
			{
				if (this.m.BodyDamageTaken >= alliedDeathsBoost )
				{
					return;
				}

				_properties.DamageArmorReduction += alliedDeathsBoost - this.m.BodyDamageTaken;
				this.m.BodyDamageTaken += _hitInfo.DamageArmor;
			}
			return __original( _attacker, _skill, _hitInfo, _properties );
		}
		
		q.onAdded = @(__original) function( )
		{
			if( this.m.IsNew )
			{
				this.getContainer().getActor().m.Flags.set("mod_background_bonuses.GR_alliedDeaths", 0);
			}
			return __original( );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hedge_knight_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Снижает проникающий сквозь броню урон на 10%."
			});
			return ret;
		}	

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Снижает проникающий сквозь броню урон на 10%."
			});
			return ret;
		}	

		q.onBeforeDamageReceived = @(__original) function( _attacker, _skill, _hitInfo, _properties )
		{
			if (_attacker != null && _attacker.getID() == this.getContainer().getActor().getID() || _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
			{
				return __original( _attacker, _skill, _hitInfo, _properties);;
			}
			_properties.DamageReceivedDirectMult *= 0.9;

			return __original( _attacker, _skill, _hitInfo, _properties);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/historian_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Персонаж получает доступ к навыкам на три уровня выше своего текущего уровня."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Персонаж получает доступ к навыкам на три уровня выше своего текущего уровня."
			});
			return ret;
		}	
		
		q.onAdded = @(__original) function( )
		{
			if( this.m.IsNew )
			{
				if( ::mods_getRegisteredMod("mod_dynamic_perks") == null )
				{
					this.getContainer().getActor().m.PerkPointsSpent += 3;
				}
				else
				{
					local level = this.getContainer().getActor().getLevel();
					this.getContainer().getActor().setPerkTier(level + 3);
				}
			}
		
			return __original( );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/houndmaster_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Может выпускать гончих за 0 ОД."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Может выпускать гончих за 0 ОД."
			});
			return ret;
		}	

		q.onAfterUpdate = @(__original) function( _properties )
		{
			__original( _properties );
			
			local releaseHounds = this.getContainer().getSkillByID("actives.unleash_wardog");
			if(releaseHounds != null)
			{
				releaseHounds.m.ActionPointCost = 0;
			}
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hunter_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Обзор увеличен на +2."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Обзор увеличен на +2."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			_properties.Vision = _properties.Vision + 2;
			__original( _properties );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/slave_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт +2 к максимальной выносливости за каждого непрощённого в отряде."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт +2 к максимальной выносливости за каждого непрощённого в отряде."
			});
			return ret;
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/juggler_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Снаряженные в данный момент метательные предметы, использующие боеприпасы, восстанавливают по 1 боеприпасу за каждый ход."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Снаряженные в данный момент метательные предметы, использующие боеприпасы, восстанавливают по 1 боеприпасу за каждый ход."
			});
			return ret;
		}	

		q.onNewRound = @(__original) function( )
		{
			local ret = __original( );
			local weapon = this.getContainer().getActor().getMainhandItem();
			if (weapon == null || !weapon.isItemType(::Const.Items.ItemType.Weapon) || !weapon.isWeaponType(::Const.Items.WeaponType.Throwing) || weapon.getAmmoMax() == 0)
			{
				return ret;
			}
			weapon.setAmmo(::Math.min(weapon.getAmmoMax(), weapon.getAmmo() + 1));
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " получает один дополнительный боеприпас.");
			return ret;
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/killer_on_the_run_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит дополнительные +15% урона в ближнем бою при попадании в голову."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит дополнительные +15% урона в ближнем бою при попадании в голову."
			});
			return ret;
		}	
		
		q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
		{
			if (_skill.isAttack() && !_skill.isRanged())
			{
				_properties.DamageAgainstMult[this.Const.BodyPart.Head] *= 1.15;
			}
			return __original( _skill, _targetEntity, _properties );
		}
	});	

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/kings_guard_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт +3 очка действия в начале каждого хода."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт +3 очка действия в начале каждого хода."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			__original( _properties);
			
			_properties.ActionPoints += 3;
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/lindwurm_slayer_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Невосприимчив к оглушению и нокдауну. Наносит +30% дополнительного урона в ближнем бою противникам более высокого уровня."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Невосприимчив к оглушению и нокдауну. Наносит +30% дополнительного урона в ближнем бою противникам более высокого уровня."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			if(this.getContainer().getActor().isPlacedOnMap())
			{
				_properties.IsImmuneToStun = true;
				_properties.IsImmuneToKnockBackAndGrab = true;
			}
			__original( _properties);
		}

		q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
		{
			if( _targetEntity != null )
			{
				if (_skill.isAttack() && !_skill.isRanged() && this.getContainer().getActor().getXPValue() < _targetEntity.getXPValue())
				{
					_properties.MeleeDamageMult *= 1.3;
				}
			}
			return __original( _skill, _targetEntity, _properties );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/lumberjack_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Умения топора требуют на 3 меньше выносливости."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Умения топора требуют на 3 меньше выносливости."
			});
			return ret;
		}	

		q.onAfterUpdate = @(__original) function( _properties )
		{
			__original( _properties );
			
			local weapon = this.getContainer().getActor().getMainhandItem();
			if(weapon != null && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Axe))
			{
				foreach (skill in weapon.getSkills())
				{
					skill.m.FatigueCost = skill.m.FatigueCost - 3;
				}
			}
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/manhunter_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Умения хлыста снижают выносливость на 2 и увеличивают шанс попадания на 5%."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Умения хлыста снижают выносливость на 2 и увеличивают шанс попадания на 5%."
			});
			return ret;
		}	

		q.onAfterUpdate = @(__original) function( _properties )
		{
			__original( _properties );
			
			local weapon = this.getContainer().getActor().getMainhandItem();
			if(weapon != null && (weapon.getID() == "weapon.battle_whip" || weapon.getID() == "weapon.thorned_whip" || weapon.getID() == "weapon.named_battle_whip"))
			{
				foreach (skill in weapon.getSkills())
				{
					skill.m.FatigueCost = skill.m.FatigueCost - 2;
				}
			}
		}

		q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
		{
			local weapon = _skill.getItem();
			if(weapon != null && (weapon.getID() == "weapon.battle_whip" || weapon.getID() == "weapon.thorned_whip" || weapon.getID() == "weapon.named_battle_whip"))
			{
				_properties.MeleeSkill += 5;
			}
			
			return __original( _skill, _targetEntity, _properties );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/mason_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Базовая защита в ближнем бою увеличена на 75%. Навык ближнего боя снижен на ту же величину."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Базовая защита в ближнем бою увеличена на 75%. Навык ближнего боя снижен на ту же величину."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			local baseMeleeDef = this.getContainer().getActor().getBaseProperties().MeleeDefense;
			_properties.MeleeDefense += Math.floor(baseMeleeDef * 0.75);
			_properties.MeleeSkill -= Math.floor(baseMeleeDef * 0.75);

			__original( _properties);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/messenger_background", function(q) {
		
		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Снижает затраты выносливости на передвижение на 50%."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Снижает затраты выносливости на передвижение на 50%."
			});
			return ret;
		}

		q.onUpdate = @(__original) function( _properties )
		{
			if(this.getContainer().getActor().isPlacedOnMap())
			{
				_properties.MovementFatigueCostMult *= 0.5;
			}
			__original( _properties);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/militia_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит на 15% увеличенный урон, когда союзники превосходят врагов численностью."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит на 15% увеличенный урон, когда союзники превосходят врагов численностью."
			});
			return ret;
		}
		
		q.onUpdate = @(__original) function( _properties )
		{
			if(this.getContainer().getActor().isPlacedOnMap())
			{
				local actor = this.getContainer().getActor();
				local numAllies = this.Tactical.Entities.getAlliesNum();
				local numHostiles = this.Tactical.Entities.getHostilesNum();
				if( numAllies > numHostiles )
				{
					_properties.MeleeDamageMult *= 1.15;
					_properties.RangedDamageMult *= 1.15;
				}
			}
			__original( _properties );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/miller_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт ОЗ в размере 25% от максимальной выносливости."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт ОЗ в размере 25% от максимальной выносливости."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			_properties.Hitpoints += Math.floor( _properties.Stamina * 0.25 );
			__original( _properties );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/miner_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит дополнительно 10% урона броне."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит дополнительно 10% урона броне."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			_properties.DamageArmorMult *= 1.1;
			__original( _properties );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/minstrel_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Восстанавливает +3 выносливости всем союзникам, у которых экипирована лютня в начале хода этого персонажа."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Восстанавливает +3 выносливости всем союзникам, у которых экипирована лютня в начале хода этого персонажа."
			});
			return ret;
		}	

		q.onTurnStart = @(__original) function( )
		{
			__original( );
			
			local actor = this.getContainer().getActor();
			local weapon = actor.getMainhandItem();
			if(weapon != null && weapon.getID() == "weapon.lute")
			{
				this.Sound.play("sounds/enemies/dlc2/hexe_idle_30.wav", this.Const.Sound.Volume.Skill, actor.getPos());
				this.Sound.play("sounds/combat/lute_break_01.wav", this.Const.Sound.Volume.Skill, actor.getPos());
				this.Tactical.EventLog.log("Все союзники восстанавливают 3 балла выносливости от песни " + this.Const.UI.getColorizedEntityName(actor) + "!");
				local allies = this.Tactical.Entities.getInstancesOfFaction(actor.getFaction());	
				foreach( ally in allies )
				{
					if (!ally.isPlacedOnMap() || ally.getID() == actor.getID())
					{
						continue;
					}
					ally.setFatigue(Math.max(0, ally.getFatigue() - 3));
				}
			}
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/monk_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит нежити на 15% больше урона."
			});
			return ret;
		}	

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит нежити на 15% больше урона."
			});
			return ret;
		}	

		q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
		{
			if( _targetEntity != null )
			{
				if(_skill.isAttack() && (this.Const.EntityType.getDefaultFaction(_targetEntity.getType()) == this.Const.FactionType.Zombies || this.Const.EntityType.getDefaultFaction(_targetEntity.getType()) == this.Const.FactionType.Undead ))
				{
					_properties.MeleeDamageMult *= 1.15;
					_properties.RangedDamageMult *= 1.15;
				}
			}
			return __original( _skill, _targetEntity, _properties );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/pacified_flagellant_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Невосприимчив к кровотечениям."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Невосприимчив к кровотечениям."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			if(this.getContainer().getActor().isPlacedOnMap())
			{
				_properties.IsImmuneToBleeding = true;
			}
			__original( _properties);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/nomad_background", function(q) {
		
		q.m.StartTile <- null;

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит на 15% увеличенный урон при перемещении в этот ход. В противном случае наносит на 10% меньше урона."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит на 15% увеличенный урон при перемещении в этот ход. В противном случае наносит на 10% меньше урона."
			});
			return ret;
		}	
		
		q.onUpdate = @(__original) function( _properties )
		{
			if(this.getContainer().getActor().isPlacedOnMap() && this.m.StartTile != null)
			{
				local currTile = this.getContainer().getActor().getTile();
				if( currTile.getDistanceTo(this.m.StartTile) > 0 )
				{
					_properties.MeleeDamageMult *= 1.15;
					_properties.RangedDamageMult *= 1.15;
				}
				else
				{
					_properties.MeleeDamageMult *= 0.9;
					_properties.RangedDamageMult *= 0.9;
				}
			}
			return __original( _properties);
		}
		
		q.onCombatStarted = @(__original) function( )
		{
			if(this.getContainer().getActor().isPlacedOnMap())
			{
				this.m.StartTile = this.getContainer().getActor().getTile();
			}
			return __original();
		}

		q.onRoundEnd = @(__original) function( )
		{
			if(this.getContainer().getActor().isPlacedOnMap())
			{
				this.m.StartTile = this.getContainer().getActor().getTile();
			}
			return __original( );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/paladin_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит на 15% увеличенный урон рядом стоящим врагам, которые не окружены ни одним из союзников принесшего обет."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит на 15% увеличенный урон рядом стоящим врагам, которые не окружены ни одним из союзников принесшего обет."
			});
			return ret;
		}	

		q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
		{
			if( _targetEntity != null )
			{
				if(_skill.isAttack() && this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile()) <= 1 && _targetEntity.getSurroundedCount() == 0)
				{
					_properties.MeleeDamageMult *= 1.15;
					_properties.RangedDamageMult *= 1.15;
				}
			}
			return __original( _skill, _targetEntity, _properties );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/orc_slayer_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит зеленокожим на 30% больше урона."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит зеленокожим на 30% больше урона."
			});
			return ret;
		}	

		q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
		{
			if( _targetEntity != null )
			{
				if(_skill.isAttack() && (this.Const.EntityType.getDefaultFaction(_targetEntity.getType()) == this.Const.FactionType.Orcs || this.Const.EntityType.getDefaultFaction(_targetEntity.getType()) == this.Const.FactionType.Goblins ))
				{ 
					_properties.MeleeDamageMult *= 1.3;
					_properties.RangedDamageMult *= 1.3;
				}
			}
			return __original( _skill, _targetEntity, _properties );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/peddler_background", function(q) {

		q.m.HeadDamageTaken <- 0;
		q.m.BodyDamageTaken <- 0;

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт +1 к броне головы и тела за 1000 золотых, до +200."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт +1 к броне головы и тела за 1000 золотых, до +200."
			});
			return ret;
		}
		
		q.onCombatStarted = @(__original) function( )
		{
			this.m.HeadDamageTaken = 0;
			this.m.BodyDamageTaken = 0;
			return __original();
		}

		q.onCombatFinished = @(__original) function( )
		{
			this.m.HeadDamageTaken = 0;
			this.m.BodyDamageTaken = 0;
			return __original();
		}

		q.onUpdate = @(__original) function( _properties )
		{
			local currentBoost = Math.floor( this.World.Assets.getMoney() / 1000 );
			if(currentBoost > 200)
			{
				currentBoost = 200;
			}
			_properties.Armor[this.Const.BodyPart.Head] += this.Math.max(0.0, currentBoost - this.m.HeadDamageTaken);
			_properties.Armor[this.Const.BodyPart.Body] += this.Math.max(0.0, currentBoost - this.m.BodyDamageTaken);
			_properties.ArmorMax[this.Const.BodyPart.Head] += currentBoost;
			_properties.ArmorMax[this.Const.BodyPart.Body] += currentBoost;

			__original( _properties);
		}

		q.onBeforeDamageReceived = @(__original) function( _attacker, _skill, _hitInfo, _properties )
		{
			local currentBoost = Math.floor( this.World.Assets.getMoney() / 1000 );
			if(currentBoost > 200)
			{
				currentBoost = 200;
			}
			if (_hitInfo.BodyPart == this.Const.BodyPart.Head && (!this.getContainer().hasSkill("effects.ifrit_potion") || this.getContainer().getSkillByID("effects.ifrit_potion").m.HeadDamageTaken >= 25))
			{
				if (this.m.HeadDamageTaken >= currentBoost)
				{
					return;
				}

				_properties.DamageArmorReduction += currentBoost - this.m.HeadDamageTaken;
				this.m.HeadDamageTaken += _hitInfo.DamageArmor;
			}
			else if (_hitInfo.BodyPart == this.Const.BodyPart.Body && (!this.getContainer().hasSkill("effects.ifrit_potion") || this.getContainer().getSkillByID("effects.ifrit_potion").m.BodyDamageTaken >= 25))
			{
				if (this.m.BodyDamageTaken >= currentBoost )
				{
					return;
				}

				_properties.DamageArmorReduction += currentBoost - this.m.BodyDamageTaken;
				this.m.BodyDamageTaken += _hitInfo.DamageArmor;
			}
			return __original( _attacker, _skill, _hitInfo, _properties );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/pimp_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Все союзники начинают бой с более высоким уровнем боевого духа."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Все союзники начинают бой с более высоким уровнем боевого духа."
			});
			return ret;
		}	

		q.onCombatStarted = @(__original) function( )
		{
			__original( );

			local actor = this.getContainer().getActor();
			local allies = this.Tactical.Entities.getInstancesOfFaction(actor.getFaction());
			foreach( ally in allies )
			{
				if (ally.getID() == actor.getID() || !ally.isPlacedOnMap())
				{
					continue;
				}	

				if (ally.getMoraleState() == this.Const.MoraleState.Breaking || ally.getMoraleState() == this.Const.MoraleState.Wavering || ally.getMoraleState() == this.Const.MoraleState.Steady )
				{
					ally.setMoraleState(ally.getMoraleState()+1);
				}
			}
			this.Tactical.EventLog.log("Все союзники обретают повышенный боевой дух!");
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/poacher_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит на 15% больше урона в дальнем бою, если рядом нет союзников."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит на 15% больше урона в дальнем бою, если рядом нет союзников."
			});
			return ret;
		}	
		
		q.onUpdate = @(__original) function( _properties )
		{
			if (this.getContainer().getActor().isPlacedOnMap())
			{
				local actor = this.getContainer().getActor();
				local myTile = actor.getTile();
				local allies = this.Tactical.Entities.getInstancesOfFaction(actor.getFaction());
				local isAlone = true;
				foreach( ally in allies )
				{
					if (ally.getID() == actor.getID() || !ally.isPlacedOnMap())
					{
						continue;
					}	

					if (ally.getTile().getDistanceTo(myTile) <= 1)
					{
						isAlone = false;
						break;
					}
				}
				if(isAlone)
				{
					_properties.RangedDamageMult *= 1.15;
				}
			}
			return __original( _properties);	
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/raider_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит на 15% увеличенный урон фракциям поселений и караванов."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит на 15% увеличенный урон фракциям поселений и караванов."
			});
			return ret;
		}	

		q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
		{
			if( _targetEntity != null )
			{
				if(_skill.isAttack() && (this.Const.EntityType.getDefaultFaction(_targetEntity.getType()) == this.Const.FactionType.Settlement || this.Const.EntityType.getDefaultFaction(_targetEntity.getType()) == this.Const.FactionType.TradingCompany ))
				{
					_properties.MeleeDamageMult *= 1.15;
					_properties.RangedDamageMult *= 1.15;
				}
			}
			return __original( _skill, _targetEntity, _properties );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/ratcatcher_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Позволяет применить яд за 0 ОД. Даёт +5 к навыку ближнего боя при использовании отравленного оружия."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Позволяет применить яд за 0 ОД. Даёт +5 к навыку ближнего боя при использовании отравленного оружия."
			});
			return ret;
		}	

		q.onAfterUpdate = @(__original) function( _properties )
		{
			__original( _properties );
			
			local poisonWeapon = this.getContainer().getSkillByID("actives.coat_with_poison");
			if(poisonWeapon != null)
			{
				poisonWeapon.m.ActionPointCost = 0;
			}
			local spiderPoisonWeapon = this.getContainer().getSkillByID("actives.coat_with_spider_poison");
			if(spiderPoisonWeapon != null)
			{
				spiderPoisonWeapon.m.ActionPointCost = 0;
			}
		}

		q.onUpdate = @(__original) function( _properties )
		{
			if(this.getContainer().getActor().isPlacedOnMap())
			{
				if( this.getContainer().getActor().getSkills().hasSkill("effects.poison_coat") || this.getContainer().getActor().getSkills().hasSkill("effects.spider_poison_coat") )
				{
					_properties.MeleeSkill += 5;
				}
			}
			__original( _properties);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/refugee_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "-1 ОД за каждую пройденную клетку, но затраты выносливости на перемещение увеличиваются на 50%."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "-1 ОД за каждую пройденную клетку, но затраты выносливости на перемещенин увеличиваются на 50%."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			if(this.getContainer().getActor().isPlacedOnMap())
			{
				_properties.MovementAPCostAdditional -= 1;
				_properties.MovementFatigueCostMult *= 1.5;
			}
			__original( _properties);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/retired_soldier_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Невосприимчив к эффекту 'Подавлен'."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Невосприимчив к эффекту 'Подавлен'."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			if(this.getContainer().getActor().isPlacedOnMap())
			{
				_properties.IsImmuneToOverwhelm = true;
			}
			__original( _properties);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/sellsword_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Увеличивает наносимый урон на процент, равный 10% от дневного жалования."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Увеличивает наносимый урон на процент, равный 10% от дневного жалования."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			if(this.getContainer().getActor().isPlacedOnMap())
			{
				local actor = this.getContainer().getActor();
				local dailyWage = actor.getDailyCost();
				_properties.MeleeDamageMult *= 1 + (0.001 * dailyWage);
				_properties.RangedDamageMult *= 1 + (0.001 * dailyWage);
			}
			__original( _properties);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/servant_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Меньше шансов стать мишенью врагов."
			});
			return ret;
		}	

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Меньше шансов стать мишенью врагов."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			_properties.TargetAttractionMult *= 0.1;
			__original( _properties);
		}
	});	

	if( ::mods_getRegisteredMod("mod_reforged") == null )
	{
		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/shepherd_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Позволяет использовать пращу в ближнем бою, а пращи создают зону контроля. Увеличивает шанс попадания пращами на 10%."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Позволяет использовать пращу в ближнем бою, а пращи создают зону контроля. Увеличивает шанс попадания пращами на 10%."
				});
				return ret;
			}

			q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
			{
				__original(_skill, _targetEntity, _properties);	
	
				local weapon = _skill.getItem();
				if (weapon != null)
				{
					if (weapon.getID() == "weapon.staff_sling" || weapon.getID() == "weapon.nomad_sling")
					{
						_properties.RangedSkill += 10;
					}
				}
			}
		});
	}
	else
	{
		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/shepherd_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Позволяет использовать пращу в ближнем бою, а пращи создают зону контроля."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Позволяет использовать пращу в ближнем бою, а пращи создают зону контроля."
				});
				return ret;
			}	
		});
	}

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/squire_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт +1 к навыку ближнего боя за 20 дней работы в отряде, до +30 к навыку ближнего боя."
			});
			return ret;
		}	

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт +1 к навыку ближнего боя за 20 дней работы в отряде, до +30 к навыку ближнего боя."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			local actor = this.getContainer().getActor();
			local hire = actor.getDaysWithCompany();
			local inc = this.Math.floor(hire / 20);
			inc = this.Math.min(inc, 30);
			if (inc >= 1)
			{
				_properties.MeleeSkill += inc;
			}
			__original( _properties);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/swordmaster_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт +1% к проникающему урону за каждые 5 единиц разницы между инициативой персонажа и цели."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт +1% к проникающему урону за каждые 5 единиц разницы между инициативой персонажа и цели."
			});
			return ret;
		}	

		q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
		{
			if( _targetEntity != null )
			{
				if(_skill.isAttack() && !_skill.isRanged() && this.getContainer().getActor().getInitiative() > _targetEntity.getInitiative())
				{ 
					_properties.DamageDirectMult += 0.01 * Math.floor( (this.getContainer().getActor().getInitiative() - _targetEntity.getInitiative()) / 5 );
				}
			}
			return __original( _skill, _targetEntity, _properties );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/tailor_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Полностью восстанавливает свою броню в конце каждого сражения."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Полностью восстанавливает свою броню в конце каждого сражения."
			});
			return ret;
		}	

		q.onCombatFinished = @(__original) function()
		{
			local actor = this.getContainer().getActor();
			local helmet = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
			local armor = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
			if (helmet != null)
			{
				helmet.setArmor(helmet.getArmorMax());
			}
			if (armor != null)
			{
				armor.setArmor(armor.getArmorMax());
			}
			__original();
		}
	});	

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/thief_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "При уклонении от атаки ближнего боя имеет шанс, равный 10% от текущей инициативы, обезоружить атакующего."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "При уклонении от атаки ближнего боя имеет шанс, равный 10% от текущей инициативы, обезоружить атакующего."
			});
			return ret;
		}	

		q.onMissed = @(__original) function( _attacker, _skill )
		{
			local ret = __original( _attacker, _skill );
			if (_skill.isRanged() || !_attacker.isAlive() || _attacker.isAlliedWith(this.getContainer().getActor()) || Math.rand(1, 100) > this.getContainer().getActor().getCurrentProperties().Initiative * 0.1)
				return ret;

			local weapon = _attacker.getMainhandItem();
			if (weapon == null)
				return ret;

			local effect = ::new("scripts/skills/effects/disarmed_effect");
			_attacker.getSkills().add(effect);
			if (!effect.isGarbage()) effect.setTurns(2); // if effect wasn't removed during addition

			if (!this.getContainer().getActor().isHiddenToPlayer() && _attacker.getTile().IsVisibleForPlayer)
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " обезоружил противника " + ::Const.UI.getColorizedEntityName(_attacker) + " на " + effect.m.TurnsLeft + " ход(а)");
			}
			return ret;
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/vagabond_background", function(q) {
		
		q.m.tilesMovedThisRound <- 0;
		q.m.tileBeforeSkillUsed <- null;

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт +5% урона за каждую клетку, пройденную в этот ход."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Даёт +5% урона за каждую клетку, пройденную в этот ход."
			});
			return ret;
		}

		q.onUpdate = @(__original) function( _properties )
		{
			if(this.getContainer().getActor().isPlacedOnMap())
			{
				local currTile = this.getContainer().getActor().getTile();
				if(currTile != null )
				{
					if(this.m.tileBeforeSkillUsed != null)
					{
						local dist = currTile.getDistanceTo(this.m.tileBeforeSkillUsed);
						if(dist > 0)
						{
							this.m.tilesMovedThisRound += dist;
							this.m.tileBeforeSkillUsed = currTile;
						}
					}
					else
					{
						this.m.tileBeforeSkillUsed = currTile;
					}
				}
				_properties.MeleeDamageMult *= 1 + (this.m.tilesMovedThisRound * 0.05);
				_properties.RangedDamageMult *= 1 + (this.m.tilesMovedThisRound * 0.05);
			}
			__original( _properties);
		}

		q.onRoundEnd = @(__original) function( )
		{
			this.m.tilesMovedThisRound = 0;
			this.m.tileBeforeSkillUsed = this.getContainer().getActor().getTile();
			return __original( );
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/wildman_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Удваивает максимальное количество здоровья, если не носить ни броню головы, ни броню тела."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Удваивает максимальное количество здоровья, если не носить ни броню головы, ни броню тела."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			local actor = this.getContainer().getActor();
			local bodyt = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
			local headt = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
			if (bodyt == null && headt == null)
			{
				_properties.Hitpoints = _properties.Hitpoints * 2;
			}
			__original( _properties);
		}
	});

	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/witchhunter_background", function(q) {

		q.getGenericTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Увеличивает на 1 максимальную дальность стрельбы из арбалетов."
			});
			return ret;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Увеличивает на 1 максимальную дальность стрельбы из арбалетов."
			});
			return ret;
		}	

		q.onUpdate = @(__original) function( _properties )
		{
			local weapon = this.getContainer().getActor().getMainhandItem();
			if(weapon != null && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Crossbow))
			{
				foreach (skill in weapon.getSkills())
				{
					skill.m.MaxRange += 1;
				}
			}
			return __original( _properties);
		}
	});
	
	//hooks into the base character to apply indebted bonus
	::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/character_background", function(q) {	

		q.onUpdate = @(__original) function( _properties )
		{
			local actor = this.getContainer().getActor();
			if(actor.getHireTime() > 0.0 || actor.m.PlaceInFormation < 255)
			{
				if(actor.getBackground() != null && actor.getBackground().getID() != "background.slave")
				{
					local roster = this.World.getPlayerRoster().getAll()
					foreach( ally in roster )
					{
						local name = ally.getName();
						if (("getBackground" in ally) && ally.getBackground() != null && ally.getBackground().getID() == "background.slave")
						{
							_properties.Stamina += 2;
						}	
					}			
				}
			}
			return __original( _properties );
		}
	});

	//hooks into sling_stone to apply shepherd bonus
	::modBackgroundBonuses.HooksMod.hook("scripts/skills/actives/sling_stone_skill", function(q) {

		q.isUsable = @(__original) function()
		{
			if(this.getContainer().getActor().isPlayerControlled() && ("getBackground" in this.getContainer().getActor()) && this.getContainer().getActor().getBackground() != null && this.getContainer().getActor().getBackground().getID() == "background.shepherd")
			{
				return this.skill.isUsable();
			}
			return __original();
		}	
	});

	//hooks into skill_container so shepherd slings have ZOC
	::modBackgroundBonuses.HooksMod.hook("scripts/skills/skill_container", function(q) {

		q.getAttackOfOpportunity = @(__original) function()
		{
			local ret = __original();
			local weapon = this.getActor().getMainhandItem();
			if(ret == null && this.getActor().isPlayerControlled() && ("getBackground" in this.getActor()) && this.getActor().getBackground() != null && this.getActor().getBackground().getID() == "background.shepherd" && weapon != null && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Sling))
			{
				return this.getSkillByID("actives.sling_stone");
			}
			return ret;
		}
	});

	if( ::mods_getRegisteredMod("mod_backgrounds_and_events") != null )
	{
		//hooks into fire_handgonne_skill to apply pirate bonus
		::modBackgroundBonuses.HooksMod.hook("scripts/skills/actives/fire_handgonne_skill", function(q) {

			q.isUsable = @(__original) function()
			{
				if(this.getContainer().getActor().isPlayerControlled() && ("getBackground" in this.getContainer().getActor()) && this.getItem().isLoaded() && this.getContainer().getActor().getBackground().getID() == "background.hackflows_pirate")
				{
					return this.skill.isUsable();
				}
				return __original();
			}	
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/arbalester_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "При использовании арбалетов попадания отбрасывают цели на одну клетку назад."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "При использовании арбалетов попадания отбрасывают цели на одну клетку назад."
				});
				return ret;
			}

			q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
			{
				local ret = __original( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor );
				
				if( _targetEntity.isAlive() && !_targetEntity.isDying() )
				{
					if (_targetEntity.getCurrentProperties().IsImmuneToKnockBackAndGrab || _targetEntity.getCurrentProperties().IsRooted)
					{
						return ret;
					}

					local weapon = _skill.getItem();
					if(weapon != null && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Crossbow) && weapon.getID() != "weapon.goblin_crossbow")
					{
						local targetTile = _targetEntity.getTile();
						local actor = this.getContainer().getActor();
						local userTile = actor.getTile();
						local dir = userTile.getDirectionTo(targetTile);
						local knockedTo = null;

						if (targetTile.hasNextTile(dir))
						{
							local knockToTile = targetTile.getNextTile(dir);

							if (knockToTile.IsEmpty && knockToTile.Level - targetTile.Level <= 1)
							{
								knockedTo = knockToTile;
							}
						}
						
						if(knockedTo != null)
						{
							local skills = _targetEntity.getSkills();
							skills.removeByID("effects.shieldwall");
							skills.removeByID("effects.spearwall");
							skills.removeByID("effects.riposte");
							_targetEntity.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);

							local damage = this.Math.max(0, this.Math.abs(knockedTo.Level - targetTile.Level) - 1) * this.Const.Combat.FallingDamage;
							
							this.Tactical.getNavigator().teleport(_targetEntity, knockedTo, null, null, true);
							_targetEntity.setHitpoints( Math.max(1, _targetEntity.getHitpoints() - damage) );
							_targetEntity.getSkills().update();
						}
					}
				}
			}	

			q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
			{
				if( _targetEntity != null )
				{
					local weapon = _skill.getItem();
					if(weapon != null && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Crossbow) )
					{ 
						_properties.DamageDirectMult += 0.2;
					}
				}
				return __original( _skill, _targetEntity, _properties );
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/atilliator_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Дополнительные 15% урона от арбалетов игнорируют броню."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Дополнительные 15% урона от арбалетов игнорируют броню."
				});
				return ret;
			}	

			q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
			{
				if( _targetEntity != null )
				{
					local weapon = _skill.getItem();
					if(weapon != null && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Crossbow) )
					{ 
						_properties.DamageDirectMult += 0.15;
					}
				}
				return __original( _skill, _targetEntity, _properties );
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/barkeep_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Не может получить черту алкоголика. В состоянии алкогольного опьянения наносит урон, увеличенный на 25%."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Не может получить черту алкоголика. В состоянии алкогольного опьянения наносит урон, увеличенный на 25%."
				});
				return ret;
			}	

			q.onUpdate = @(__original) function( _properties )
			{
				this.getContainer().getActor().getFlags().set("PotionsUsed", 0);
				__original( _properties);
			}

			q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
			{
				if( _targetEntity != null && this.getContainer().getActor().getSkills().hasSkill("effects.drunk"))
				{
					_properties.MeleeDamageMult *= 1.25;
					_properties.RangedDamageMult *= 1.25;
				}
				return __original( _skill, _targetEntity, _properties );
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/berserker_background", function(q) {

			q.m.BB_TimesHit <- 0;

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Увеличивает максимальный уровень здоровья на +2 при попадании. Бонус действует до конца битвы."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Увеличивает максимальный уровень здоровья на +2 при попадании. Бонус действует до конца битвы."
				});
				return ret;
			}
			
			q.onCombatStarted = @(__original) function( )
			{
				this.m.BB_TimesHit = 0;
				return __original();
			}

			q.onDamageReceived = @(__original) function( _attacker, _damageHitpoints, _damageArmor )
			{
				__original( _attacker, _damageHitpoints, _damageArmor );
				this.m.BB_TimesHit += 1;
			}

			q.onCombatFinished = @(__original) function()
			{
				this.m.BB_TimesHit = 0;
				return __original();
			}

			q.onUpdate = @(__original) function( _properties )
			{
				if (this.getContainer().getActor().isPlacedOnMap())
				{
					_properties.Hitpoints += (this.m.BB_TimesHit * 2);
				}
				__original( _properties);
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/blacksmith_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "К оружию, снаряженному в настоящее время вашими людьми, в конце боя прибавляется +10 прочности."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "К оружию, снаряженному в настоящее время вашими людьми, в конце боя прибавляется +10 прочности."
				});
				return ret;
			}	

			q.onCombatFinished = @(__original) function()
			{
				if (this.getContainer().getActor().isPlacedOnMap())
				{
					local roster = this.World.getPlayerRoster().getAll()
					foreach( ally in roster )
					{
						if (ally.isPlacedOnMap())
						{
							local weapon = ally.getMainhandItem();
							if(weapon != null && weapon.isItemType(::Const.Items.ItemType.Weapon) && !weapon.isIndestructible())
							{
								weapon.setCondition( Math.min(weapon.getConditionMax(), weapon.getCondition() + 10) );
							}
						}	
					}
				}

				return __original();
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/bodyguard_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Гораздо больше шансов стать мишенью врагов."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Гораздо больше шансов стать мишенью врагов."
				});
				return ret;
			}	

			q.onUpdate = @(__original) function( _properties )
			{
				_properties.TargetAttractionMult *= 1.67;
				__original( _properties);
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/bounty_hunter_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт 50 крон за каждое убийство. Награда в 10 раз больше за убийство чемпиона."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт 50 крон за каждое убийство. Награда в 10 раз больше за убийство чемпиона."
				});
				return ret;
			}	

			q.onOtherActorDeath = @(__original) function( _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType )
			{
				__original(  _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType  );
				
				local actor = this.getContainer().getActor();
				if( _killer != null && _killer.getID() == actor.getID() )
				{
					this.spawnIcon("status_effect_159", _deathTile);
					if(_victim.m.IsMiniboss)
					{
						this.World.Assets.setMoney(this.World.Assets.getMoney() + 500);
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " отряд получает 50 крон за убийство противника " + this.Const.UI.getColorizedEntityName(_victim) + ".");
					}
					else
					{
						this.World.Assets.setMoney(this.World.Assets.getMoney() + 50);
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " отряд получает 50 крон за убийство противника " + this.Const.UI.getColorizedEntityName(_victim) + ".");
					}
				}
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/carpenter_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Защита снаряженного щита этого персонажа в ближнем и дальнем бою увеличивается на 25%, а при использовании 'стены щитов' - на 50%."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Защита снаряженного щита этого персонажа в ближнем и дальнем бою увеличивается на 25%, а при использовании 'стены щитов' - на 50%."
				});
				return ret;
			}	

			q.onUpdate = @(__original) function( _properties )
			{
				local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
				if(item != null && item.isItemType(this.Const.Items.ItemType.Shield) && item.getCondition() > 0 )
				{
					local mBonus = Math.ceil( item.getMeleeDefense() / 4.0 );
					local rBonus = Math.ceil( item.getRangedDefense() / 4.0 );
					_properties.MeleeDefense += mBonus;
					_properties.RangedDefense += rBonus;

					if(this.getContainer().getActor().getSkills().hasSkill("effects.shieldwall"))
					{
						_properties.MeleeDefense += mBonus;
						_properties.RangedDefense += rBonus;
					}
				}
				__original( _properties);
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/cartographer_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Вероятность попадания при атаке увеличивается на 2% за каждую клетку между персонажем и целью."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Вероятность попадания при атаке увеличивается на 2% за каждую клетку между персонажем и целью."
				});
				return ret;
			}
			
			q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
			{
				local ret = __original( _skill, _targetEntity, _properties );
				if( _targetEntity != null )
				{
					if(_skill.isAttack())
					{
						_properties.HitChanceAdditionalWithEachTile += 2;
					}
				}
				return ret;
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/champion_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт +7 ко всем характеристикам, если этот персонаж продвинулся дальше всех в отряде."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт +7 ко всем характеристикам, если этот персонаж продвинулся дальше всех в отряде."
				});
				return ret;
			}	

			q.onUpdate = @(__original) function( _properties )
			{
				if(this.getContainer().getActor().isPlacedOnMap() && this.getContainer().getActor().getTile() != null)
				{
					local furthestForward = true;
					local tile = this.getContainer().getActor().getTile();
					local xPos = tile.Pos.X;
					local roster = this.World.getPlayerRoster().getAll()
					foreach( ally in roster )
					{
						if (ally.isPlacedOnMap() && ally.getID() != this.getContainer().getActor().getID() && ally.getTile() != null)
						{
							if(ally.getTile().Pos.X >= xPos)
							{
								furthestForward = false;
							}
						}	
					}
					if(furthestForward)
					{
						_properties.Stamina += 7;
						_properties.Bravery += 7;
						_properties.Initiative += 7;
						_properties.MeleeSkill += 7;
						_properties.RangedSkill += 7;
						_properties.MeleeDefense += 7;
						_properties.RangedDefense += 7;
					}
				}
				__original( _properties);
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/cobbler_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "На каждую пройденную клетку затрачивается на 3 меньше выносливости."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "На каждую пройденную клетку затрачивается на 3 меньше выносливости."
				});
				return ret;
			}	

			q.onUpdate = @(__original) function( _properties )
			{
				_properties.MovementFatigueCostAdditional -= 3;
				__original( _properties);
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/con_artist_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Любая атака, наносящая не менее 5 урона, применяет эффект 'отвлечён'."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Любая атака, наносящая не менее 5 урона, применяет эффект 'отвлечён'."
				});
				return ret;
			}	

			q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
			{
				__original( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor );
				
				if( _targetEntity.isAlive() && !_targetEntity.isDying() && _damageInflictedHitpoints >= 5 )
				{
					local effect = this.new("scripts/skills/effects/distracted_effect");
					_targetEntity.getSkills().add(effect);
				}
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/cook_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Невосприимчив к урону от огня и не употребляет пищу из запасов."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Невосприимчив к урону от огня и не употребляет пищу из запасов."
				});
				return ret;
			}	

			q.onUpdate = @(__original) function( _properties )
			{
				_properties.IsImmuneToFire = true;
				_properties.DailyFood = 0.0;
				__original( _properties);
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/dissenter_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Проверка боевого духа в результате атак, произведенных этим персонажем, влечёт за собой снижение решимости цели в размере 10% от решимости этого персонажа."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Проверка боевого духа в результате атак, произведенных этим персонажем, влечёт за собой снижение решимости цели в размере 10% от решимости этого персонажа."
				});
				return ret;
			}	

			q.onUpdate = @(__original) function( _properties )
			{
				_properties.ThreatOnHit += _properties.Bravery * 0.1;
				__original( _properties);
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/drifter_background", function(q) {

			q.m.StartTile <- null;
			
			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт +3 к инициативе за каждую клетку удаления от своей клетки в начале боя, до +60."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт +3 к инициативе за каждую клетку удаления от своей клетки в начале боя, до +60."
				});
				return ret;
			}	

			q.onUpdate = @(__original) function( _properties )
			{
				local actor = this.getContainer().getActor();
				if(actor.isPlacedOnMap() && this.m.StartTile != null)
				{
					local initMult = this.m.StartTile.getDistanceTo(actor.getTile());
					if(initMult > 20)
					{
						initMult = 20;
					}
					_properties.Initiative += 3 * initMult;
				}
				__original( _properties);
			}

			q.onCombatStarted = @(__original) function( )
			{
				if(this.getContainer().getActor().isPlacedOnMap())
				{
					this.m.StartTile = this.getContainer().getActor().getTile();
				}
				return __original();
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/druid_background", function(q) {
			
			q.m.StartTile <- null;
			q.m.BonusUsed <- true;
			
			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "В начале хода даёт бонус в зависимости от рельефа стартовой клетки."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				local actor = this.getContainer().getActor();
				if(actor.isPlacedOnMap())
				{
					local tile = actor.getTile();
					if(tile.Subtype == this.Const.Tactical.TerrainSubtype.None || tile.Subtype == this.Const.Tactical.TerrainSubtype.DirtRoad || tile.Subtype == this.Const.Tactical.TerrainSubtype.ClayRoad || tile.Subtype == this.Const.Tactical.TerrainSubtype.CobblestoneRoad)
					{
						ret.push({
							id = 10,
							type = "text",
							icon = "ui/icons/special.png",
							text = "Никаких бонусов при начале хода на этой местности."
						});
					}
					else if(tile.Subtype == this.Const.Tactical.TerrainSubtype.Snow || tile.Subtype == this.Const.Tactical.TerrainSubtype.LightSnow)
					{
						ret.push({
							id = 10,
							type = "text",
							icon = "ui/icons/special.png",
							text = "Снежный бонус: При начале хода на этой клетке первая атака в этот ход охлаждает цель при попадании."
						});
					}
					else if(tile.Subtype == this.Const.Tactical.TerrainSubtype.MurkyWater || tile.Subtype == this.Const.Tactical.TerrainSubtype.ShallowWater )
					{
						ret.push({
							id = 10,
							type = "text",
							icon = "ui/icons/special.png",
							text = "Водный бонус: При начале хода на этой клетке восстанавливается 10 ОЗ."
						});
					}
					else if(tile.Subtype == this.Const.Tactical.TerrainSubtype.MoistEarth || tile.Subtype == this.Const.Tactical.TerrainSubtype.PlashyGrass )
					{
						ret.push({
							id = 10,
							type = "text",
							icon = "ui/icons/special.png",
							text = "Болотный бонус: При начале хода на этой клетке первая атака в этот ход отравляет цель при попадании."
						});
					}
					else if(tile.Subtype == this.Const.Tactical.TerrainSubtype.Desert )
					{
						ret.push({
							id = 10,
							type = "text",
							icon = "ui/icons/special.png",
							text = "Пустынный бонус: При начале хода на этой клетке первая атака в этот ход поджигает целевую клетку при попадании."
						});
					}
					else if(tile.Subtype == this.Const.Tactical.TerrainSubtype.FlatStone || tile.Subtype == this.Const.Tactical.TerrainSubtype.RoughStone )
					{
						ret.push({
							id = 10,
							type = "text",
							icon = "ui/icons/special.png",
							text = "Каменный бонус: При начале хода на этой клетке порог нанесения травм в этом ходу снижается на 50% (суммируется с наносящими урон ударами)."
						});
					}
					else if(tile.Subtype == this.Const.Tactical.TerrainSubtype.Forest )
					{
						ret.push({
							id = 10,
							type = "text",
							icon = "ui/icons/special.png",
							text = "Лесной бонус: При начале хода на этой клетке первая атака в этот ход обездвиживает цель при попадании."
						});
					}
					else if(tile.Subtype == this.Const.Tactical.TerrainSubtype.Grassland || tile.Subtype == this.Const.Tactical.TerrainSubtype.Dirt || tile.Subtype == this.Const.Tactical.TerrainSubtype.Steppe || tile.Subtype == this.Const.Tactical.TerrainSubtype.DrySteppe || tile.Subtype == this.Const.Tactical.TerrainSubtype.Tundra )
					{
						ret.push({
							id = 10,
							type = "text",
							icon = "ui/icons/special.png",
							text = "Равнинный бонус: При начале хода на этой клетке уровень защиты в ближнем и дальнем бою увеличивается на 15% от инициативы."
						});
					}
				}
				else
				{
					ret.push({
						id = 10,
						type = "text",
						icon = "ui/icons/special.png",
						text = "В начале хода даёт бонус в зависимости от рельефа стартовой клетки."
					});
				}
				return ret;
			}

			q.onBeforeTargetHit = @(__original) function( _skill, _targetEntity, _hitInfo )
			{
				__original( _skill, _targetEntity, _hitInfo );
				if(!this.m.BonusUsed)
				{
					if(this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.Desert)
					{
						this.m.BonusUsed = true;
						local p = {
							Type = "fire",
							Tooltip = "Здесь бушует огонь, плавящий как броню, так и плоть",
							IsPositive = false,
							IsAppliedAtRoundStart = false,
							IsAppliedAtTurnEnd = true,
							IsAppliedOnMovement = false,
							IsAppliedOnEnter = false,
							IsByPlayer = true,
							Timeout = this.Time.getRound() + 2,
							Callback = this.Const.Tactical.Common.onApplyFire,
							function Applicable( _a )
							{
								return true;
							}
						};
						local targetTile = _targetEntity.getTile();
						if (targetTile != null && targetTile.Subtype != this.Const.Tactical.TerrainSubtype.Snow && targetTile.Subtype != this.Const.Tactical.TerrainSubtype.LightSnow && targetTile.Type != this.Const.Tactical.TerrainType.ShallowWater && targetTile.Type != this.Const.Tactical.TerrainType.DeepWater)
						{
							if (targetTile.Properties.Effect != null && targetTile.Properties.Effect.Type == "fire")
							{
								targetTile.Properties.Effect.Timeout = this.Time.getRound() + 2;
							}
							else
							{
								if (targetTile.Properties.Effect != null)
								{
									this.Tactical.Entities.removeTileEffect(targetTile);
								}
								targetTile.Properties.Effect = clone p;
								local particles = [];
					
								for( local i = 0; i < this.Const.Tactical.FireParticles.len(); i = ++i )
								{
									particles.push(this.Tactical.spawnParticleEffect(true, this.Const.Tactical.FireParticles[i].Brushes, targetTile, this.Const.Tactical.FireParticles[i].Delay, this.Const.Tactical.FireParticles[i].Quantity, this.Const.Tactical.FireParticles[i].LifeTimeQuantity, this.Const.Tactical.FireParticles[i].SpawnRate, this.Const.Tactical.FireParticles[i].Stages));
								}
			
								this.Tactical.Entities.addTileEffect(targetTile, targetTile.Properties.Effect, particles);
								targetTile.clear(this.Const.Tactical.DetailFlag.Scorchmark);
								targetTile.spawnDetail("impact_decal", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
							}
						}
						if(_targetEntity.isAlive() && !_targetEntity.isDying())
						{
							this.Const.Tactical.Common.onApplyFire(targetTile, _targetEntity);
						}
					}
				}

			}

			q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
			{
				__original( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor );
				
				if(!this.m.BonusUsed)
				{
					this.m.BonusUsed = true;
					if( _targetEntity.isAlive() && !_targetEntity.isDying() )
					{
						this.m.BonusUsed = true;
						if(this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.Snow || this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.LightSnow)
						{
							_targetEntity.getSkills().add(this.new("scripts/skills/effects/chilled_effect"));
						}
						else if(this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.MoistEarth || this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.PlashyGrass)
						{
							if(!_targetEntity.getCurrentProperties().IsImmuneToPoison)
							{
								local effect = this.new("scripts/skills/effects/spider_poison_effect");
								effect.setDamage(10);
								_targetEntity.getSkills().add(effect);
							}
						}
						else if(this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.Forest)
						{
							if(!_targetEntity.getCurrentProperties().IsImmuneToRoot && !_targetEntity.getCurrentProperties().IsRooted)
							{
								_targetEntity.getSkills().add(this.new("scripts/skills/effects/rooted_effect"));
								local breakFree = this.new("scripts/skills/actives/break_free_skill");
								breakFree.setDecal("roots_destroyed");
								breakFree.m.Icon = "skills/active_75.png";
								breakFree.m.IconDisabled = "skills/active_75_sw.png";
								breakFree.m.Overlay = "active_75";
								breakFree.m.SoundOnUse = this.m.SoundOnHitHitpoints;
								_targetEntity.getSkills().add(breakFree);
								_targetEntity.raiseRootsFromGround("bust_roots", "bust_roots_back");
							}
						}
					}
					
				}
			}

			q.onUpdate = @(__original) function( _properties )
			{
				__original( _properties);
				if( this.getContainer().getActor().isPlacedOnMap() && this.m.StartTile != null )
				{
					if( this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.FlatStone || this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.RoughStone )
					{
						_properties.ThresholdToInflictInjuryMult *= 0.5;
					}
					else if( this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.Grassland || this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.Dirt || this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.Steppe || this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.DrySteppe || this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.Tundra )
					{
						_properties.MeleeDefense += _properties.Initiative * 0.15;
						_properties.RangedDefense += _properties.Initiative * 0.15;
					}
				}
			}
		
			q.onTargetMissed = @(__original) function( _skill, _targetEntity )
			{
				__original( _skill, _targetEntity);
				this.m.BonusUsed = true;
			}

			q.onTurnStart = @(__original) function( )
			{
				local actor = this.getContainer().getActor();
				this.m.StartTile = actor.getTile();
				this.m.BonusUsed = false;
				if(this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.MurkyWater || this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.ShallowWater )
				{
					this.Tactical.EventLog.log("При начале хода в воде " + this.Const.UI.getColorizedEntityName(actor) + " восстанавливает 10 ОЗ.");
					actor.setHitpoints( Math.min(actor.getHitpointsMax(), actor.getHitpoints() + 10) );
					this.m.BonusUsed = true;
				}
				else if(this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.Snow || this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.LightSnow)
				{
					this.Tactical.EventLog.log("При начале хода в снегу первая атака " + this.Const.UI.getColorizedEntityName(actor) + " охлаждает при попадании.");
				}
				else if(this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.MoistEarth || this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.PlashyGrass )
				{
					this.Tactical.EventLog.log("При начала хода в болоте первая атака " + this.Const.UI.getColorizedEntityName(actor) + " будет отравлять при попадании.");
				}
				else if(this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.Desert )
				{
					this.Tactical.EventLog.log("При начала хода в пустыне первая атака " + this.Const.UI.getColorizedEntityName(actor) + " поджигает целевую клетку при попадании.");
				}
				else if(this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.FlatStone || this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.RoughStone )
				{
					this.Tactical.EventLog.log("При начала хода на камне у атак " + this.Const.UI.getColorizedEntityName(actor) + " снижен порог нанесения травм на 50%.");
				}
				else if(this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.Grassland || this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.Dirt || this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.Steppe || this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.DrySteppe || this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.Tundra )
				{
					this.Tactical.EventLog.log("При начало хода на равнинах " + this.Const.UI.getColorizedEntityName(actor) + " увеличивает защиту в ближнем и дальнем бою на 15% от инициативы.");
				}
				else if(this.m.StartTile.Subtype == this.Const.Tactical.TerrainSubtype.Forest)
				{
					this.Tactical.EventLog.log("При начала хода в лесу первая атака " + this.Const.UI.getColorizedEntityName(actor) + " обездвижит цель при попадании");
				}
				return __original( );
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/falconer_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Позволяет выпускать соколов бесплатно."
				});
				return ret;
			}

			q.onAfterUpdate = @(__original) function( _properties )
			{
				__original( _properties );
				
				local releaseFalcon = this.getContainer().getSkillByID("actives.release_falcon");
				if(releaseFalcon  != null)
				{
					releaseFalcon.m.ActionPointCost = 0;
				}
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/fletcher_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "В колчане, оборудованном этим боевым устройством, в начале каждого хода заправляется по одной стреле."
				});
				return ret;
			}	

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "В колчане, оборудованном этим боевым устройством, в начале каждого хода заправляется по одной стреле."
				});
				return ret;
			}	

			q.onNewRound = @(__original) function( )
			{
				local ret = __original( );
				local ammo = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);
				if ( ammo != null && ammo.getAmmoType() == this.Const.Items.AmmoType.Arrows)
				{
					ammo.setAmmo(::Math.min(ammo.getAmmoMax(), ammo.getAmmo() + 1));
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " восстанавливает 1 боеприпас.");
				}
				return ret;
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/folk_hero_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт +1 к навыку ближнего боя, защите в ближнем бою, выносливости или решимости за каждое убийство, совершенное во время выполнения контрактов на защиту."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				local stamBonus = this.getContainer().getActor().m.Flags.get("mod_background_bonuses.FH_stamina") || 0;
				local bravBonus = this.getContainer().getActor().m.Flags.get("mod_background_bonuses.FH_bravery") || 0;
				local mSkillBonus = this.getContainer().getActor().m.Flags.get("mod_background_bonuses.FH_meleeSkill") || 0;
				local mDefBonus = this.getContainer().getActor().m.Flags.get("mod_background_bonuses.FH_meleeDefense") || 0;
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт +1 к навыку ближнего боя, защите в ближнем бою, выносливости или решимости за каждое убийство, совершенное во время выполнения контрактов на защиту. Текущие бонусы: " + mSkillBonus + " к навык ближнего боя, " + mDefBonus + " к защите в ближнем бою, " + stamBonus + " к выносливости, " + bravBonus + " к решимости."
				});
				return ret;
			}

			q.onOtherActorDeath = @(__original) function( _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType )
			{
				__original(  _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType  );
				
				local actor = this.getContainer().getActor();
				if( _killer != null && _killer.getID() == actor.getID() )
				{
					local contract = this.World.Contracts.getActiveContract();
					if(contract != null && (contract.getType() == "contract.defend_settlement_bandits" || contract.getType() == "contract.defend_settlement_greenskins" || contract.getType() == "contract.hunting_hexen" || contract.getType() == "contract.break_greenskin_siege" || contract.getType() == "contract.free_greenskin_prisoners" || contract.getType() == "contract.intercept_raiding_parties" || contract.getType() == "contract.last_stand") )
					{
						local randChoice = Math.rand(0, 3);
						switch(randChoice)
						{
							case 0 : this.getContainer().getActor().m.Flags.increment("mod_background_bonuses.FH_stamina"); this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " получает +1 к максимальной выносливости навсегда."); break;
							case 1 : this.getContainer().getActor().m.Flags.increment("mod_background_bonuses.FH_bravery"); this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " получает +1 к максимальной решимости навсегда."); break;
							case 2 : this.getContainer().getActor().m.Flags.increment("mod_background_bonuses.FH_meleeSkill"); this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " получает +1 к навыку ближнего боя навсегда."); break;
							case 3 : this.getContainer().getActor().m.Flags.increment("mod_background_bonuses.FH_meleeDefense"); this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " получает +1 к защите в ближнем бою навсегда."); break;
						}
					}
				}
			}

			q.onUpdate = @(__original) function( _properties )
			{
				__original( _properties);
				
				_properties.Stamina += this.getContainer().getActor().m.Flags.get("mod_background_bonuses.FH_stamina") || 0;
				_properties.Bravery += this.getContainer().getActor().m.Flags.get("mod_background_bonuses.FH_bravery") || 0;
				_properties.MeleeSkill += this.getContainer().getActor().m.Flags.get("mod_background_bonuses.FH_meleeSkill") || 0;
				_properties.MeleeDefense += this.getContainer().getActor().m.Flags.get("mod_background_bonuses.FH_meleeDefense") || 0;
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/gardener_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Характеристики этого персонажа равны среднему значению его собственных характеристик и характеристик всех рядом стоящих союзников."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Характеристики этого персонажа равны среднему значению его собственных характеристик и характеристик всех рядом стоящих союзников."
				});
				return ret;
			}	

			q.onUpdate = @(__original) function( _properties )
			{
				local ret = __original( _properties );
				local actor = this.getContainer().getActor();
				if(actor.isPlacedOnMap())
				{
					local ownTile = actor.getTile();
					local staminaAvg = _properties.Stamina;
					local braveryAvg = _properties.Bravery;
					local initiativeAvg = _properties.Initiative;
					local meleeSkillAvg = _properties.MeleeSkill;
					local rangedSkillAvg = _properties.RangedSkill;
					local meleeDefenseAvg = _properties.MeleeDefense;
					local rangedDefenseAvg = _properties.RangedDefense;
					local numAvg = 1;
				
					local lowestPercentHealth = 1.0;
					for( local i = 5; i >= 0; i = --i )
					{
						if (!ownTile.hasNextTile(i))
						{
						}
						else
						{
							local tile = ownTile.getNextTile(i);	
						
							if (!tile.IsEmpty && tile.IsOccupiedByActor && tile.getEntity() != null && tile.getEntity().isPlayerControlled() && this.Math.abs(tile.Level - ownTile.Level) <= 1)
							{
								numAvg++;
								staminaAvg += tile.getEntity().getCurrentProperties().Stamina;
								braveryAvg += tile.getEntity().getCurrentProperties().Bravery;
								initiativeAvg += tile.getEntity().getCurrentProperties().Initiative;
								meleeSkillAvg += tile.getEntity().getCurrentProperties().MeleeSkill;
								rangedSkillAvg += tile.getEntity().getCurrentProperties().RangedSkill;
								meleeDefenseAvg += tile.getEntity().getCurrentProperties().MeleeDefense;
								rangedDefenseAvg += tile.getEntity().getCurrentProperties().RangedDefense;
							}
						}
					}
					if(numAvg > 1)
					{
						_properties.Stamina = staminaAvg / numAvg;
						_properties.Bravery = braveryAvg / numAvg;
						_properties.Initiative = initiativeAvg / numAvg;
						_properties.MeleeSkill = meleeSkillAvg / numAvg;
						_properties.RangedSkill = rangedSkillAvg / numAvg;
						_properties.MeleeDefense = meleeDefenseAvg / numAvg;
						_properties.RangedDefense = rangedDefenseAvg / numAvg;
					}
				}
				
				return ret;
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/hangman_background", function(q) {

			q.m.DeathBonus <- 0;		

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт +3 решимости за каждого персонажа, погибшего в этом бою."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт +3 решимости за каждого персонажа, погибшего в этом бою."
				});
				return ret;
			}	

			q.onOtherActorDeath = @(__original) function( _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType )
			{
				__original(  _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType  );
				
				if( _fatalityType != ::Const.FatalityType.Unconscious )
				{
					this.m.DeathBonus += 3;
				}
			}

			q.onUpdate = @(__original) function( _properties )
			{
				_properties.Bravery += this.m.DeathBonus;
				__original( _properties);
			}

			q.onCombatStarted = @(__original) function( )
			{
				if(this.getContainer().getActor().isPlacedOnMap())
				{
					this.m.DeathBonus = 0;
				}
				return __original();
			}

			q.onCombatFinished = @(__original) function( )
			{
				this.m.DeathBonus = 0;
				return __original();
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/executioner_background", function(q) {

			q.m.DeathBonus <- 0;

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт +3 решимости за каждого персонажа, погибшего в этом бою."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт +3 решимости за каждого персонажа, погибшего в этом бою."
				});
				return ret;
			}

			q.onOtherActorDeath = @(__original) function( _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType )
			{
				__original(  _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType  );

				if( _fatalityType != ::Const.FatalityType.Unconscious )
				{
					this.m.DeathBonus += 3;
				}
			}

			q.onUpdate = @(__original) function( _properties )
			{
				_properties.Bravery += this.m.DeathBonus;
				__original( _properties);
			}

			q.onCombatStarted = @(__original) function( )
			{
				if(this.getContainer().getActor().isPlacedOnMap())
				{
					this.m.DeathBonus = 0;
				}
				return __original();
			}

			q.onCombatFinished = @(__original) function( )
			{
				this.m.DeathBonus = 0;
				return __original();
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/herbalist_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Может перевязывать союзников за 0 ОД и может перевязывать союзников на расстоянии до двух клеток."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Может перевязывать союзников за 0 ОД и может перевязывать союзников на расстоянии до двух клеток."
				});
				return ret;
			}		

			q.onAfterUpdate = @(__original) function( _properties )
			{
				__original( _properties );
				
				local bandage = this.getContainer().getSkillByID("actives.bandage_ally");
				if(bandage != null)
				{
					bandage.m.ActionPointCost = 0;
					bandage.m.MaxRange = 2;
				}
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/lancer_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Копья и секиры наносят дополнительные 20% урона броне."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Копья и секиры наносят дополнительные 20% урона броне."
				});
				return ret;
			}	

			q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
			{
				if( _targetEntity != null )
				{
					local weapon = _skill.getItem();
					if(weapon != null && weapon.isItemType(::Const.Items.ItemType.Weapon) && (weapon.isWeaponType(::Const.Items.WeaponType.Spear) || weapon.isWeaponType(::Const.Items.WeaponType.Polearm)) )
					{ 
						_properties.DamageArmorMult += 0.2;
					}
				}
				return __original( _skill, _targetEntity, _properties );
			}
		});
		
		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/leper_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Наносит 10% от максимального ОЗ всем рядом стоящим персонажам в начале хода этого персонажа (влияет только на персонажей, которые могут истекать кровью)."
				});
				return ret;
			}	

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Наносит 10% от максимального ОЗ всем рядом стоящим персонажам в начале хода этого персонажа (влияет только на персонажей, которые могут истекать кровью)."
				});
				return ret;
			}	

			q.onTurnStart = @(__original) function( )
			{
				local actor = this.getContainer().getActor();
				this.Sound.play("sounds/humans/human_coughing_01.wav", this.Const.Sound.Volume.Skill * 3, actor.getPos());
				local ownTile = actor.getTile();
				local didDamage = false;
				for( local i = 5; i >= 0; i = --i )
				{
					if (!ownTile.hasNextTile(i))
					{
					}
					else
					{
						local tile = ownTile.getNextTile(i);	

						if (!tile.IsEmpty && tile.getEntity().isAttackable() && !tile.getEntity().getCurrentProperties().IsImmuneToBleeding && this.Math.abs(tile.Level - ownTile.Level) <= 1)
						{
							if(! ("Background" in tile.getEntity().m) || tile.getEntity().getBackground() == null || (tile.getEntity().getBackground().getID() != "background.hackflows_leper" && tile.getEntity().getBackground().getID() != "background.anatomist"))
							{
								this.spawnIcon("status_effect_50", tile);
								didDamage = true;
								local hitInfo = clone this.Const.Tactical.HitInfo;
								hitInfo.DamageRegular = Math.floor(actor.getHitpointsMax() * 0.1);
								hitInfo.DamageArmor = 0.0;
								hitInfo.DamageDirect = 1.0;
								hitInfo.BodyPart = this.Const.BodyPart.Body;
								hitInfo.BodyDamageMult = 1.0;
								hitInfo.FatalityChanceMult = 0.0;
								tile.getEntity().onDamageReceived(actor, null, hitInfo);
							}
						}
					}
				}
				if(didDamage)
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " наносит " + Math.floor(actor.getHitpointsMax() * 0.1) + " урона всем рядом стоящим персонажам.");
				}
				return __original( );
			}
		});
		
		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/locksmith_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Каждое попадание всегда наносит минимум 10 единиц урона по ОЗ."
				});
				return ret;
			}	

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Каждое попадание всегда наносит минимум 10 единиц урона по ОЗ."
				});
				return ret;
			}	

			q.onUpdate = @(__original) function( _properties )
			{
				_properties.DamageMinimum = 10;
				__original( _properties);
			}
		});
		
		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/master_archer_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Штраф за препятствия на прямой линии видимости снижен на 20%."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Штраф за препятствия на прямой линии видимости снижен на 20%."
				});
				return ret;
			}	

			q.onUpdate = @(__original) function( _properties )
			{
				_properties.RangedAttackBlockedChanceMult *= 0.8;
				__original( _properties);
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/myrmidon_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Шанс попадания в истекающих кровью врагов увеличивается на 10%."
				});
				return ret;
			}	

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Шанс попадания в истекающих кровью врагов увеличивается на 10%."
				});
				return ret;
			}	

			q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
			{
				if( _targetEntity != null && _targetEntity.getSkills().hasSkill("effects.bleeding"))
				{
					_skill.m.HitChanceBonus += 10;
				}
				return __original( _skill, _targetEntity, _properties );
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/outlander_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт +1 ко всем характеристикам за каждую клетку до ближайшего союзника, вплоть до +15."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт +1 ко всем характеристикам за каждую клетку до ближайшего союзника, вплоть до +15."
				});
				return ret;
			}	

			q.onUpdate = @(__original) function( _properties )
			{
				if(this.getContainer().getActor().isPlacedOnMap() && this.getContainer().getActor().getTile() != null)
				{
					local tile = this.getContainer().getActor().getTile();
					local minDistance = 15;
					local roster = this.World.getPlayerRoster().getAll()
					foreach( ally in roster )
					{
						if (ally.isPlacedOnMap() && ally.getID() != this.getContainer().getActor().getID() && ally.getTile() != null)
						{
							local distance = tile.getDistanceTo(ally.getTile());
							if(distance < minDistance)
							{
								minDistance = distance;
							}
						}	
					}
					_properties.Stamina += minDistance;
					_properties.Bravery += minDistance;
					_properties.Initiative += minDistance;
					_properties.MeleeSkill += minDistance;
					_properties.RangedSkill += minDistance;
					_properties.MeleeDefense += minDistance;
					_properties.RangedDefense += minDistance;
				}
				__original( _properties);
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/painter_background", function(q) {
			
			q.m.EngagedInCombat <- false;
			
			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт +15 ко всем характеристикам. Этот бонус теряется при нанесении урона."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт +15 ко всем характеристикам. Этот бонус теряется при нанесении урона."
				});
				return ret;
			}	

			q.onUpdate = @(__original) function( _properties )
			{
				if(this.getContainer().getActor().isPlacedOnMap() && !this.m.EngagedInCombat)
				{
					_properties.Stamina += 15;
					_properties.Bravery += 15;
					_properties.Initiative += 15;
					_properties.MeleeSkill += 15;
					_properties.RangedSkill += 15;
					_properties.MeleeDefense += 15;
					_properties.RangedDefense += 15;
				}
				__original( _properties);
			}

			q.onCombatStarted = @(__original) function( )
			{
				if(this.getContainer().getActor().isPlacedOnMap())
				{
					this.m.EngagedInCombat = false;
				}
				return __original();
			}
			
			q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
			{
				this.m.EngagedInCombat = true;
				return __original( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor );
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/paladin_commander_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Уменьшает урон, наносимый броне и здоровью, на фиксированную величину, равную 2% от решимости."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Уменьшает урон, наносимый броне и здоровью, на фиксированную величину, равную 2% от решимости."
				});
				return ret;
			}	

			q.onUpdate = @(__original) function( _properties )
			{
				_properties.DamageArmorReduction += Math.floor(_properties.getBravery() * 0.02);
				_properties.DamageRegularReduction += Math.floor(_properties.getBravery() * 0.02);
				__original( _properties);
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/pirate_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Замена ручницы автоматически перезаряжает её. Стрельба из ручницы тратит +2 ОД."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Замена ручницы автоматически перезаряжает её. Стрельба из ручницы тратит +2 ОД."
				});
				return ret;
			}		
			
			q.onEquip = @(__original) function( _item )
			{
				local ret = __original( _item );
				if(this.getContainer().getActor().isPlacedOnMap())
				{
					local ammo = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);
//					if( _item != null && _item.isItemType(::Const.Items.ItemType.Weapon) && _item.isWeaponType(::Const.Items.WeaponType.Firearm) && !_item.isLoaded() && ammo != null && ammo.getAmmoType() == this.Const.Items.AmmoType.Powder && ammo.getAmmo() > 0)
					if (_item != null && _item.isItemType(::Const.Items.ItemType.Weapon) && ("setLoaded" in _item) && ammo != null && ammo.getAmmoType() == this.Const.Items.AmmoType.Powder && ammo.getAmmo() > 0 && this.getContainer().getActor().getSkills().hasSkill("actives.reload_handgonne"))
					{
						_item.setLoaded(true);
//						if(this.getContainer().getActor().getSkills().hasSkill("actives.reload_handgonne"))
//						{
							this.getContainer().getActor().getSkills().removeByID("actives.reload_handgonne");
//						}
						ammo.consumeAmmo();
					}
				}
				return ret;
			}	

			q.onAfterUpdate = @(__original) function( _properties )
			{
				__original( _properties );
				
				local fire = this.getContainer().getSkillByID("actives.fire_handgonne");
				if(fire != null)
				{
					fire.m.ActionPointCost += 2;
				}
			}

			q.onUpdate = @(__original) function( _properties )
			{
				local weapon = this.getContainer().getActor().getMainhandItem();
				if(weapon != null && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Firearm))
				{
					foreach (skill in weapon.getSkills())
					{
						skill.m.MinRange = 1;
					}
				}
				return __original( _properties);
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/roofer_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт дополнительный шанс попадания +10% за каждый уровень преимущества в высоте местности над целью."
				});
				return ret;
			}	

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт дополнительный шанс попадания +10% за каждый уровень преимущества в высоте местности над целью."
				});
				return ret;
			}		

			q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
			{
				if( _targetEntity != null )
				{
					if(_skill.isAttack() && this.getContainer().getActor().getTile().Level - _targetEntity.getTile().Level >= 1)
					{
						_skill.m.HitChanceBonus += (this.getContainer().getActor().getTile().Level - _targetEntity.getTile().Level) * 10;
					}
				}
				return __original( _skill, _targetEntity, _properties );
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/skirmisher_background", function(q) {
			
			q.m.HasThrown <- false;

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Первая атака в каждый ход метательным предметом (за исключением пращей) тратит -2 ОД."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Первая атака в каждый ход метательным предметом (за исключением пращей) тратит -2 ОД."
				});
				return ret;
			}		

			q.onAfterUpdate = @(__original) function( _properties )
			{
				__original( _properties );
				
				local weapon = this.getContainer().getActor().getMainhandItem();
				if(weapon != null && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Throwing) && !weapon.isWeaponType(::Const.Items.WeaponType.Sling) )
				{
					foreach (skill in weapon.getSkills())
					{
						if(!this.m.HasThrown)
						{
							skill.m.ActionPointCost = skill.m.ActionPointCost - 2;
						}
					}
				}
			}

			q.onAnySkillExecuted = @(__original) function( _skill, _targetTile, _targetEntity, _forFree )
			{
				local ret = __original( _skill, _targetTile, _targetEntity, _forFree );
				
				local weapon = _skill.getItem();
				if( _skill.isAttack() && _skill.isRanged() && weapon != null && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Throwing))
				{
					this.m.HasThrown = true;
				}
				
				return ret;
			}

			q.onTurnStart = @(__original) function( )
			{
				local ret = __original();

				this.m.HasThrown = false;
				return ret;
			}	
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/surgeon_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "В начале хода исцеляет ближайшего союзника с наименьшим процентом ОЗ на 50% от его недостающего ОЗ."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "В начале хода исцеляет ближайшего союзника с наименьшим процентом ОЗ на 50% от его недостающего ОЗ."
				});
				return ret;
			}	

			q.onTurnStart = @(__original) function( )
			{
				local actor = this.getContainer().getActor();
				local ownTile = actor.getTile();
				local allyToHeal = null;
				local lowestPercentHealth = 1.0;
				for( local i = 5; i >= 0; i = --i )
				{
					if (!ownTile.hasNextTile(i))
					{
					}
					else
					{
						local tile = ownTile.getNextTile(i);	
						
						if (!tile.IsEmpty && tile.IsOccupiedByActor && tile.getEntity() != null && tile.getEntity().isPlayerControlled() && this.Math.abs(tile.Level - ownTile.Level) <= 1)
						{
							if(tile.getEntity().getHitpointsPct() < lowestPercentHealth)
							{
								lowestPercentHealth = tile.getEntity().getHitpointsPct();
								allyToHeal = tile.getEntity();
							}
						}
					}
				}
				if(allyToHeal != null)
				{
					local hpRestored = Math.ceil((allyToHeal.getHitpointsMax() - allyToHeal.getHitpoints()) / 2.0);
					allyToHeal.setHitpoints( Math.min(allyToHeal.getHitpointsMax(), allyToHeal.getHitpoints() + hpRestored) );
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " исцеляет персонажа " + this.Const.UI.getColorizedEntityName(allyToHeal) + " на " + hpRestored + " ОЗ.");
				}
				
				return __original( );
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/torturer_background", function(q) {
		
			q.m.LastTargetID <- 0;
			q.m.TargetMortal <- true;

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Наносит урон, увеличенный на 25%, но никогда не снижает уровень здоровья врагов ниже 1 ОЗ (если только у них уже не было 1 ОЗ)."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Наносит урон, увеличенный на 25%, но никогда не снижает уровень здоровья врагов ниже 1 ОЗ (если только у них уже не было 1 ОЗ)."
				});
				return ret;
			}

			q.onBeforeTargetHit = @(__original) function( _skill, _targetEntity, _hitInfo )
			{
				if(_targetEntity.m.Hitpoints > 1)
				{
					this.m.TargetMortal = _targetEntity.m.IsAbleToDie;
					this.m.LastTargetID = _targetEntity.getID();
					_targetEntity.m.IsAbleToDie = false;
				}
				return __original( _skill, _targetEntity, _hitInfo );
			}
		
			q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
			{
				if( _targetEntity.getID() == this.m.LastTargetID )
				{
					_targetEntity.m.IsAbleToDie = this.m.TargetMortal;
				}
				return __original( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor );
			}

			q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
			{
				if( _targetEntity != null )
				{
					if(_skill.isAttack() )
					{
						_properties.MeleeDamageMult *= 1.25;
						_properties.RangedDamageMult *= 1.25;
					}
				}
				return __original( _skill, _targetEntity, _properties );
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/town_watchman_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "После ожидания получает +5 ко всем характеристикам."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "После ожидания получает +5 ко всем характеристикам."
				});
				return ret;
			}		

			q.onUpdate = @(__original) function( _properties )
			{
				if(this.getContainer().getActor().isPlacedOnMap())
				{
					if( this.getContainer().getActor().m.IsWaitActionSpent )
					{
						_properties.Stamina += 5;
						_properties.Bravery += 5;
						_properties.Initiative += 5;
						_properties.MeleeSkill += 5;
						_properties.RangedSkill += 5;
						_properties.MeleeDefense += 5;
						_properties.RangedDefense += 5;
					}
				}
				__original( _properties);
			}
		});
	}

	if( ::mods_getRegisteredMod("mod_fantasybro") != null )
	{
		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/xxhero_baku_background", function(q) {

			q.m.Clawed <- false;

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Когда во второй руке ничего нет, завершает каждую атаку по рядом стоящим целям взмахом когтя."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Когда во второй руке ничего нет, завершает каждую атаку по рядом стоящим целям взмахом когтя."
				});
				return ret;
			}

			q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
			{
				__original( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor );
				
				if(this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) == null && (this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null || !this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).isItemType(this.Const.Items.ItemType.TwoHanded)) && _targetEntity.isAlive() && !_targetEntity.isDying() && !this.m.Clawed && _targetEntity.getTile().getDistanceTo(this.getContainer().getActor().getTile()) <= 1)
				{
					this.m.Clawed = true;
					local actor = this.getContainer().getActor();
					local dmgMin = actor.getCurrentProperties().DamageRegularMin;
					local dmgMax = actor.getCurrentProperties().DamageRegularMax;
					local dmgMult = actor.getCurrentProperties().DamageRegularMult;
					local armorDmgMult = actor.getCurrentProperties().DamageArmorMult;
					local directDmgMult = actor.getCurrentProperties().DamageDirectMult;

					actor.getCurrentProperties().DamageRegularMin = 10 + actor.getLevel();
					actor.getCurrentProperties().DamageRegularMax = 20 + actor.getLevel();
					actor.getCurrentProperties().DamageRegularMult = 1.0;
					actor.getCurrentProperties().DamageArmorMult = 0.5;
					actor.getCurrentProperties().DamageDirectMult = 0.2;

					this.attackEntity(actor, _targetEntity, false);
					this.m.Clawed = false;

					actor.getCurrentProperties().DamageRegularMin = dmgMin;
					actor.getCurrentProperties().DamageRegularMax = dmgMax;
					actor.getCurrentProperties().DamageRegularMult = dmgMult;
					actor.getCurrentProperties().DamageArmorMult = armorDmgMult;
					actor.getCurrentProperties().DamageDirectMult = directDmgMult;
				}
			}

			q.onTargetMissed = @(__original) function( _skill, _targetEntity )
			{
				__original( _skill, _targetEntity);
				
				if(this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) == null && (this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null || !this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).isItemType(this.Const.Items.ItemType.TwoHanded)) && _targetEntity.isAlive() && !_targetEntity.isDying() && !this.m.Clawed && _targetEntity.getTile().getDistanceTo(this.getContainer().getActor().getTile()) <= 1)
				{
					this.m.Clawed = true;
					local actor = this.getContainer().getActor();
					local dmgMin = actor.getCurrentProperties().DamageRegularMin;
					local dmgMax = actor.getCurrentProperties().DamageRegularMax;
					local dmgMult = actor.getCurrentProperties().DamageRegularMult;
					local armorDmgMult = actor.getCurrentProperties().DamageArmorMult;
					local directDmgMult = actor.getCurrentProperties().DamageDirectMult;

					actor.getCurrentProperties().DamageRegularMin = 10 + actor.getLevel();
					actor.getCurrentProperties().DamageRegularMax = 20 + actor.getLevel();
					actor.getCurrentProperties().DamageRegularMult = 1.0;
					actor.getCurrentProperties().DamageArmorMult = 0.5;
					actor.getCurrentProperties().DamageDirectMult = 0.2;

					this.attackEntity(actor, _targetEntity, false);
					this.m.Clawed = false;

					actor.getCurrentProperties().DamageRegularMin = dmgMin;
					actor.getCurrentProperties().DamageRegularMax = dmgMax;
					actor.getCurrentProperties().DamageRegularMult = dmgMult;
					actor.getCurrentProperties().DamageArmorMult = armorDmgMult;
					actor.getCurrentProperties().DamageDirectMult = directDmgMult;
				}
			}

			q.onUpdate = @(__original) function( _properties )
			{
				this.getContainer().removeByID("special.double_grip");
				__original( _properties);
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/xxhero_elf_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Не вызывает атак при перемещении через зону контроля."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Не вызывает атак при перемещении через зону контроля."
				});
				return ret;
			}

			q.onUpdate = @(__original) function( _properties )
			{
				_properties.IsImmuneToZoneOfControl = true;
				__original( _properties);
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/xxhero_female_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Стоимость любых умений из книги умений, которые тратят ОД, снижается на 2, до минимума в 0 ОД."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Стоимость любых умений из книги умений, которые тратят ОД, снижается на 2, до минимума в 0 ОД."
				});
				return ret;
			}

			q.onAfterUpdate = @(__original) function( _properties )
			{
				__original( _properties );
				
				local container = this.getContainer();
				foreach (skill in container.m.Skills)
				{
					if(skill != null && skill.getID().find("actives.sb") != null && skill.m.ActionPointCost > 0)
					{
						skill.m.ActionPointCost -= 2;
						if(skill.m.ActionPointCost < 0)
						{
							skill.m.ActionPointCost = 0;
						}
					}
				}
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/xxhero_goblin_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Увеличивает +1 ОД при владении оружием гоблинов, эффект удваивается, если оружие именное."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Увеличивает +1 ОД при владении оружием гоблинов, эффект удваивается, если оружие именное."
				});
				return ret;
			}

			q.onUpdate = @(__original) function( _properties )
			{
				local weapon = this.getContainer().getActor().getMainhandItem();
				if(weapon != null)
				{
					if(weapon.getID().find("goblin") != null)
					{
						_properties.ActionPoints += 1;
						if(weapon.isItemType(::Const.Items.ItemType.Named) || weapon.isItemType(::Const.Items.ItemType.Legendary) )
						{
							_properties.ActionPoints += 1;
						}
					}
				}
				__original( _properties);
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/vp_goblin_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Увеличивает +1 ОД при владении оружием гоблинов, эффект удваивается, если оружие именное."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Увеличивает +1 ОД при владении оружием гоблинов, эффект удваивается, если оружие именное."
				});
				return ret;
			}

			q.onUpdate = @(__original) function( _properties )
			{
				local weapon = this.getContainer().getActor().getMainhandItem();
				if(weapon != null)
				{
					if(weapon.getID().find("goblin") != null)
					{
						_properties.ActionPoints += 1;
						if(weapon.isItemType(::Const.Items.ItemType.Named) || weapon.isItemType(::Const.Items.ItemType.Legendary) )
						{
							_properties.ActionPoints += 1;
						}
					}
				}
				__original( _properties);
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/xxhero_lizard_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "При попаданиях, наносящих не менее 10 урона, применяет суммирующийся эффект яда, который уменьшает ОД цели на единицу на один ход."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "При попаданиях, наносящих не менее 10 урона, применяет суммирующийся эффект яда, который уменьшает ОД цели на единицу на один ход."
				});
				return ret;
			}

			q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
			{
				__original( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor );
				
				if( _targetEntity.isAlive() && !_targetEntity.isDying() && _damageInflictedHitpoints >= 10 && !_targetEntity.getCurrentProperties().IsImmuneToPoison && !_targetEntity.getFlags().has("undead"))
				{
					local effect = this.new("scripts/skills/effects/goblin_poison_effect");
					local statusDuration = _targetEntity.getCurrentProperties().NegativeStatusEffectDuration;
					_targetEntity.getCurrentProperties().NegativeStatusEffectDuration = -5;
					_targetEntity.getSkills().add(effect);
					_targetEntity.getCurrentProperties().NegativeStatusEffectDuration = statusDuration;
				}
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/xxhero_male_background", function(q) {

			q.m.Turns <- 0;

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт +7 ко всем характеристикам и -1 ко всем в конце каждого хода."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт +7 ко всем характеристикам и -1 ко всем в конце каждого хода."
				});
				return ret;
			}

			q.onUpdate = @(__original) function( _properties )
			{
				_properties.Stamina += 7 - this.m.Turns;
				_properties.Bravery += 7 - this.m.Turns;
				_properties.Initiative += 7 - this.m.Turns;
				_properties.MeleeSkill += 7 - this.m.Turns;
				_properties.RangedSkill += 7 - this.m.Turns;
				_properties.MeleeDefense += 7 - this.m.Turns;
				_properties.RangedDefense += 7 - this.m.Turns;
				__original( _properties );
			}

			q.onRoundEnd = @(__original) function( )
			{
				if(this.getContainer().getActor().isPlacedOnMap())
				{
					this.m.Turns++;
				}
				return __original( );
			}

			q.onCombatFinished = @(__original) function( )
			{
				this.m.Turns = 0;
				return __original();
			}

			q.onCombatStarted = @(__original) function( )
			{
				this.m.Turns = -1;
				return __original();
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/xxhero_orc_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Невосприимчив к оглушению и нокдауну и нет штрафа к выносливости при использовании оружия орков."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Невосприимчив к оглушению и нокдауну и нет штрафа к выносливости при использовании оружия орков."
				});
				return ret;
			}

			q.onUpdate = @(__original) function( _properties )
			{
				_properties.IsProficientWithHeavyWeapons = true;
				_properties.IsImmuneToStun = true;
				_properties.IsImmuneToKnockBackAndGrab = true;
				__original( _properties);
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/vp_orc_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Невосприимчив к оглушению и нокдауну и нет штрафа к выносливости при использовании оружия орков."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Невосприимчив к оглушению и нокдауну и нет штрафа к выносливости при использовании оружия орков."
				});
				return ret;
			}

			q.onUpdate = @(__original) function( _properties )
			{
				_properties.IsProficientWithHeavyWeapons = true;
				_properties.IsImmuneToStun = true;
				_properties.IsImmuneToKnockBackAndGrab = true;
				__original( _properties);
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/xxhero_undead_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Базовая выносливость снижается на 70%. Умения и передвижение не тратят выносливость."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Базовая выносливость снижается на 70%. Умения и передвижение не тратят выносливость."
				});
				return ret;
			}

			q.onUpdate = @(__original) function( _properties )
			{
				local baseStamina = this.getContainer().getActor().getBaseProperties().Stamina;
				_properties.Stamina -= baseStamina * 0.7;
				_properties.MovementFatigueCostMult = 0.0;
				_properties.FatigueEffectMult = 0.0;
				_properties.FatigueLossOnAnyAttackMult = 0.0;
				this.getContainer().getActor().m.LevelFatigueCost = 0;
				__original( _properties);
			}
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/xxi_female_background", function(q) {

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "При атаке от рядом стоящего противника, персонаж попытается переместиться на пустую соседнюю клетку, игнорируя зону контроля."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "При атаке от рядом стоящего противника, персонаж попытается переместиться на пустую соседнюю клетку, игнорируя зону контроля."
				});
				return ret;
			}

			q.onMissed = @(__original) function( _attacker, _skill )
			{
				__original( _attacker, _skill);
				local actor = this.getContainer().getActor();
				local ownTile = actor.getTile();
				if(ownTile.getDistanceTo(_attacker.getTile()) <= 1)
				{
					local tiles = [];
					this.Tactical.queryTilesInRange(ownTile, 1, 1, true, [], this.onQueryEvadeTiles1, tiles);
					if(tiles.len() > 0)
					{
						local teleTarget = tiles[Math.rand(0, tiles.len() - 1)];
						this.Tactical.getNavigator().teleport(actor, teleTarget, null, null, false, 1.5);
					}
					else
					{
						tiles = [];
						this.Tactical.queryTilesInRange(ownTile, 1, 1, true, [], this.onQueryEvadeTiles2, tiles);
						local teleTarget = tiles[Math.rand(0, tiles.len() - 1)];
						this.Tactical.getNavigator().teleport(actor, teleTarget, null, null, false, 1.5);
					}
				}
			}

			q.onDamageReceived = @(__original) function( _attacker, _damageHitpoints, _damageArmor )
			{
				__original( _attacker, _damageHitpoints, _damageArmor );
				
				local actor = this.getContainer().getActor();
				if (!actor.isAlive() || actor.isDying() || !actor.isPlacedOnMap())
				{
					return 0;
				}
				local lorekeeperPotionEffect = actor.m.Skills.getSkillByID("effects.lorekeeper_potion");
				local nineLivesSkill = actor.m.Skills.getSkillByID("perk.nine_lives");
				if(Math.round(actor.m.Hitpoints - _damageHitpoints) <= 0 && actor.m.IsAbleToDie && (lorekeeperPotionEffect == null || lorekeeperPotionEffect.isSpent()) && (nineLivesSkill == null || nineLivesSkill.isSpent()))
				{
					return 0;
				}
				local ownTile = actor.getTile();
				if(ownTile.getDistanceTo(_attacker.getTile()) <= 1)
				{
					local tiles = [];
					this.Tactical.queryTilesInRange(ownTile, 1, 1, true, [], this.onQueryEvadeTiles1, tiles);

					if(tiles.len() > 0)
					{
						local teleTarget = tiles[Math.rand(0, tiles.len() - 1)];
						this.Tactical.getNavigator().teleport(actor, teleTarget, null, null, false, 1.5);
					}
					else
					{
						tiles = [];
						this.Tactical.queryTilesInRange(ownTile, 1, 1, true, [], this.onQueryEvadeTiles2, tiles);
						local teleTarget = tiles[Math.rand(0, tiles.len() - 1)];
						this.Tactical.getNavigator().teleport(actor, teleTarget, null, null, false, 1.5);
					}
				}
			}

			q.onQueryEvadeTiles1 <- function( _tile, _tag )
			{
				if (_tile == null)
				{
					return;
				}
				if (!this.Tactical.isValidTileSquare(_tile.Coords.X, _tile.Coords.Y))
				{
					return;
				}
				if (_tile.Type == this.Const.Tactical.TerrainType.Impassable) 
				{
					return;
				}
				if (!_tile.IsEmpty)
				{
					return;
				}
				local adjTiles = ::MSU.Tile.getNeighbors(_tile);
				foreach( adjTile in adjTiles )
				{
					if(!adjTile.IsEmpty && adjTile.IsOccupiedByActor && adjTile.getEntity() != null && adjTile.getEntity().getFaction() != this.Const.Faction.Player && this.Math.abs(adjTile.Level - _tile.Level) <= 1)
					{
						return;
					}
				}
				_tag.push(_tile);
			}

			q.onQueryEvadeTiles2 <- function( _tile, _tag )
			{
				if (_tile == null)
				{
					return;
				}
				if (!this.Tactical.isValidTileSquare(_tile.Coords.X, _tile.Coords.Y))
				{
					return;
				}
				if (_tile.Type == this.Const.Tactical.TerrainType.Impassable) 
				{
					return;
				}
				if (!_tile.IsEmpty)
				{
					return;
				}
				_tag.push(_tile);
			}
		});
	}

	if( ::mods_getRegisteredMod("mod_necro") != null )
	{
		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/necro_background", function(q) {

			q.m.Minions <- [];

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт +1 ко всем характеристикам за каждую контролируемую нежить."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Даёт +1 ко всем характеристикам за каждую контролируемую нежить."
				});
				return ret;
			}

			q.onUpdate = @(__original) function( _properties )
			{
				local numRaised = 0;
				foreach(minion in this.m.Minions)
				{
					if(minion != null && minion.isAlive())
					{
						numRaised++;
					}
				}
				_properties.Bravery += numRaised;
				_properties.Stamina += numRaised;
				_properties.Initiative += numRaised;
				_properties.MeleeSkill += numRaised;
				_properties.RangedSkill += numRaised;
				_properties.MeleeDefense += numRaised;
				_properties.RangedDefense += numRaised;

				__original( _properties);
			}

			q.onRaiseUndead = @(__original) function( _undead ) 
			{
		        this.m.Minions.push(_undead);
		        return __original( _undead );
		    }

			q.onCombatStarted = @(__original) function( )
			{
				this.m.Minions = [];
				return __original();
			}

			q.onCombatFinished = @(__original) function( )
			{
				this.m.Minions = [];
				return __original();
			}
		});
	}

	if( ::mods_getRegisteredMod("earnedFreedom") != null )
	{
		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/ef_freedman_background", function(q) {

			q.m.Minions <- [];

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Невосприимчив к воздействию эффектов обездвиживания (сетей, паутины и т.д.)."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Невосприимчив к воздействию эффектов обездвиживания (сетей, паутины и т.д.)."
				});
				return ret;
			}

			q.onUpdate = @(__original) function( _properties )
			{
				if(this.getContainer().getActor().isPlacedOnMap())
				{
					_properties.IsImmuneToRoot = true;
				}
				__original( _properties);
			}
		});
	}

	if (::mods_getRegisteredMod("mod_wushi") != null)
	{
		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/wushi_background", function(q) {

			q.m.Minions <- [];

			q.getGenericTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Урон двуручным оружием в ближнем бою на +15% лучше пробивает броню."
				});
				return ret;
			}

			q.getTooltip = @(__original) function()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Урон двуручным оружием в ближнем бою на +15% лучше пробивает броню."
				});
				return ret;
			}

            q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
            {
                if (_targetEntity != null)
                {
                    local weapon = _skill.getItem();
                    if (weapon != null && weapon.isItemType(::Const.Items.ItemType.MeleeWeapon) && weapon.isWeaponType(::Const.Items.ItemType.TwoHanded))
                    {
                        _properties.DamageDirectMult += 0.15;
                    }
                }
                return __original( _skill, _targetEntity, _properties );
            }
		});
	}

	if (::mods_getRegisteredMod("mod_necropolis") != null)
	{
        ::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/templar_background", function(q) {

            q.getGenericTooltip = @(__original) function()
            {
                local ret = __original();
                ret.push({
                    id = 10,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Наносит нежити на 30% больше урона."
                });
                return ret;
            }

            q.getTooltip = @(__original) function()
            {
                local ret = __original();
                ret.push({
                    id = 10,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Наносит нежити на 30% больше урона."
                });
                return ret;
            }

            q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
            {
                if( _targetEntity != null )
                {
                    if(_skill.isAttack() && (this.Const.EntityType.getDefaultFaction(_targetEntity.getType()) == this.Const.FactionType.Zombies || this.Const.EntityType.getDefaultFaction(_targetEntity.getType()) == this.Const.FactionType.Undead ))
                    {
                        _properties.MeleeDamageMult *= 1.3;
                        _properties.RangedDamageMult *= 1.3;
                    }
                }
                return __original( _skill, _targetEntity, _properties );
            }
        });

	}

	if (::mods_getRegisteredMod("mod_LuftRetiredGladiatorOrigin") != null)
	{
        ::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/beastslayer_gladiator_background", function(q) {

            q.getGenericTooltip = @(__original) function()
            {
                local ret = __original();
                ret.push({
                    id = 10,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Наносит линдвурмам на 30% больше урона."
                });
                return ret;
            }

            q.getTooltip = @(__original) function()
            {
                local ret = __original();
                ret.push({
                    id = 10,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Наносит линдвурмам на 30% больше урона."
                });
                return ret;
            }

            q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
            {
                if( _targetEntity != null )
                {
                    if(_skill.isAttack() && _targetEntity.getType() == this.Const.EntityType.Lindwurm)
                    {
                        _properties.MeleeDamageMult *= 1.3;
                        _properties.RangedDamageMult *= 1.3;
                    }
                }
                return __original( _skill, _targetEntity, _properties );
            }
        });

        ::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/converted_gladiator_background", function(q) {

            q.getGenericTooltip = @(__original) function()
            {
                local ret = __original();
                ret.push({
                    id = 10,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Даёт 0,5% дополнительного урона в ближнем бою за каждого союзника и врага, которые в данный момент не вовлечены в ближний бой."
                });
                return ret;
            }

            q.getTooltip = @(__original) function()
            {
                local ret = __original();
                ret.push({
                    id = 10,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Даёт 0,5% дополнительного урона в ближнем бою за каждого союзника и врага, которые в данный момент не вовлечены в ближний бой."
                });
                return ret;
            }

            q.onUpdate = @(__original) function( _properties )
            {
                if(this.getContainer().getActor().isPlacedOnMap())
                {
                    local actor = this.getContainer().getActor();
                    local watchers = 0;
                    local units = this.Tactical.Entities.getAllInstances();
                    foreach (faction in units)
                    {
                        foreach (unit in faction)
                        {
                            if (unit.getID() == actor.getID() || !unit.isPlacedOnMap())
                            {
                                continue;
                            }
                            if(!unit.isEngagedInMelee())
                            {
                                watchers++;
                            }
                        }
                    }
                    _properties.MeleeDamageMult *= 1 + (0.005 * watchers);
                }
                __original( _properties);
            }


//
//            q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
//            {
//                if(this.getContainer().getActor().isPlacedOnMap())
//                {
//                    local actor = this.getContainer().getActor();
//                    local watchers = 0;
//                    local units = this.Tactical.Entities.getAllInstances();
//                    foreach (faction in units)
//                    {
//                        foreach (unit in faction)
//                        {
//                            if (unit.getID() == actor.getID() || !unit.isPlacedOnMap())
//                            {
//                                continue;
//                            }
//                            if(!unit.isEngagedInMelee())
//                            {
//                                watchers++;
//                            }
//                        }
//                    }
//                    _properties.MeleeDamageMult *= 1 + (0.003 * watchers);
//                }
//                return __original( _skill, _targetEntity, _properties );
//            }
        });

        ::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/pit_fighter_background", function(q) {

            q.getGenericTooltip = @(__original) function()
            {
                local ret = __original();
                ret.push({
                    id = 10,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Даёт 0,5% дополнительного урона в ближнем бою за каждого союзника и врага, которые в данный момент не вовлечены в ближний бой."
                });
                return ret;
            }

            q.getTooltip = @(__original) function()
            {
                local ret = __original();
                ret.push({
                    id = 10,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Даёт 0,5% дополнительного урона в ближнем бою за каждого союзника и врага, которые в данный момент не вовлечены в ближний бой."
                });
                return ret;
            }

            q.onUpdate = @(__original) function( _properties )
            {
                if(this.getContainer().getActor().isPlacedOnMap())
                {
                    local actor = this.getContainer().getActor();
                    local watchers = 0;
                    local units = this.Tactical.Entities.getAllInstances();
                    foreach (faction in units)
                    {
                        foreach (unit in faction)
                        {
                            if (unit.getID() == actor.getID() || !unit.isPlacedOnMap())
                            {
                                continue;
                            }
                            if(!unit.isEngagedInMelee())
                            {
                                watchers++;
                            }
                        }
                    }
                    _properties.MeleeDamageMult *= 1 + (0.005 * watchers);
                }
                __original( _properties);
            }
        });

        ::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/retired_gladiator_background", function(q) {

            q.getGenericTooltip = @(__original) function()
            {
                local ret = __original();
                ret.push({
                    id = 10,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Невосприимчив к эффекту 'Подавлен'."
                });
                return ret;
            }

            q.getTooltip = @(__original) function()
            {
                local ret = __original();
                ret.push({
                    id = 10,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "Невосприимчив к эффекту 'Подавлен'."
                });
                return ret;
            }

            q.onUpdate = @(__original) function( _properties )
            {
                if(this.getContainer().getActor().isPlacedOnMap())
                {
                    _properties.IsImmuneToOverwhelm = true;
                }
                __original( _properties);
            }
        });

        ::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/legend_qiyan_background", function(q) {

            q.getGenericTooltip = @(__original) function()
            {
                local ret = __original();
                ret.push({
                    id = 10,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] к шансу противостоять любому негативному состоянию, такому как \'Оглушение\' или \'Ошеломление\'"
                });
                return ret;
            }

            q.getTooltip = @(__original) function()
            {
                local ret = __original();
                ret.push({
                    id = 10,
                    type = "text",
                    icon = "ui/icons/special.png",
                    text = "[color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] к шансу противостоять любому негативному состоянию, такому как \'Оглушение\' или \'Ошеломление\'"
                });
                return ret;
            }

            q.onUpdate = @(__original) function( _properties )
            {
                if(this.getContainer().getActor().isPlacedOnMap())
                {
                    _properties.IsResistantToAnyStatuses = true;
                }
                __original( _properties);
            }
        });
	}

	//if playing reforged, force backgrounds with perk groups related to certain weapons to always roll if forcePerkGroups setting is set
	if( ::mods_getRegisteredMod("mod_reforged") != null )
	{
		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/shepherd_background", function(q) {

			q.getPerkGroupMultiplier = @(__original) function( _groupID, _perkTree )
			{
				if(::modBackgroundBonuses.conf("forcePerkGroups"))
				{
					switch(_groupID)
					{
						case "pg.rf_throwing":
							return -1;

						default:
							return __original(_groupID, _perkTree);
					}
				}
				return __original(_groupID, _perkTree);
			}	
		});

		::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/juggler_background", function(q) {

			q.getPerkGroupMultiplier = @(__original) function( _groupID, _perkTree )
			{
				if(::modBackgroundBonuses.conf("forcePerkGroups"))
				{
					switch(_groupID)
					{
						case "pg.rf_throwing":
							return -1;

						default:
							return __original(_groupID, _perkTree);
					}
				}
				return __original(_groupID, _perkTree);
			}	
		});

		if( ::mods_getRegisteredMod("mod_backgrounds_and_events") != null )
		{
			::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/carpenter_background", function(q) {

				q.getPerkGroupMultiplier = @(__original) function( _groupID, _perkTree )
				{
					if(::modBackgroundBonuses.conf("forcePerkGroups"))
					{
						switch(_groupID)
						{
							case "pg.rf_shield":
								return -1;

							default:
								return __original(_groupID, _perkTree);
						}
					}
					return __original(_groupID, _perkTree);
				}	
			});

			::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/fletcher_background", function(q) {

				q.getPerkGroupMultiplier = @(__original) function( _groupID, _perkTree )
				{
					if(::modBackgroundBonuses.conf("forcePerkGroups"))
					{
						switch(_groupID)
						{
							case "pg.rf_bow":
								return -1;

							default:
								return __original(_groupID, _perkTree);
						}
					}
					return __original(_groupID, _perkTree);
				}	
			});

			::modBackgroundBonuses.HooksMod.hook("scripts/skills/backgrounds/hackflows/pirate_background", function(q) {

				q.getPerkGroupMultiplier = @(__original) function( _groupID, _perkTree )
				{
					if(::modBackgroundBonuses.conf("forcePerkGroups"))
					{
						switch(_groupID)
						{
							case "pg.rf_crossbow":
								return -1;

							default:
								return __original(_groupID, _perkTree);
						}
					}
					return __original(_groupID, _perkTree);
				}	
			});
		}
	}

}, ::Hooks.QueueBucket.Late);

//todo: fix vagabond for roundabout movements
//check if 3h flail applies 3 bleeds
//fix gravedigger/graverobber don't add for unconscious bros left on battlefield
