this.sacrifice_ally_skill <- this.inherit("scripts/skills/skill", {
	m = {
	},
	function create()
	{
		this.m.ID = "actives.sacrifice_ally";
		this.m.Name = "Принести в жертву союзника";
		this.m.Description = "Принести жертву во имя Давкула.";
		this.m.Icon = "skills/active_105.png";
		this.m.IconDisabled = "skills/active_105_sw.png";
		this.m.Overlay = "active_105";
		this.m.SoundOnUse = [
			"sounds/combat/dlc4/prophet_chant_03.wav",
			"sounds/combat/dlc4/prophet_chant_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.Delay = 250
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.Cooldown <- 2; // can use it after 2 turns at beginning of battle, otherwise every 3rd turn
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
			}
		];

		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Нельзя использовать, пока этот персонаж находится в режиме ближнего боя[/color]"
			});
		}

		return ret;
	}


	function isUsable()
	{
		if (!this.Tactical.isActive())
		{
			return false;
		}

		local tile = this.getContainer().getActor().getTile();
		return this.m.Cooldown == 0 && this.skill.isUsable() && !tile.hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}
	
	function onTurnEnd()
	{
		this.m.Cooldown = this.Math.max(0, this.m.Cooldown-1);
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (target == null || target.m.Type != this.Const.EntityType.Cultist_Sacrifice) return false

		return true;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Cooldown = 3
		if(_user.m.Type == this.Const.EntityType.Cultist_High_Priest) this.m.Cooldown = 2
		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " был принесён в жертву во имя Давкула!");
		}
		local target = _targetTile.getEntity();
		this.spawnIcon("perk_55", target.getTile());
		target.kill(_user, this)
		local tag = {
			User = _user,
			Skill = this
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 250, this.onDelayedEffect.bindenv(this), tag);
		
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local _user = _tag.User
		local mytile = _user.getTile();
		local actors = this.Tactical.Entities.getAllInstances();
		local acolytes = [], fanatics= [], defilers= [];

		foreach( i in actors )
		{
			foreach( a in i )
			{
				if ((a.getFaction() == _user.getFaction()) || a.isPlayerControlled() && (a.getBackground().getID() == "background.cultist" || a.getBackground().getID() == "background.converted_cultist"))
				{
					a.getSkills().add(this.new("scripts/skills/effects/sacrificed_effect"));
				}
				else if (!a.isAlliedWith(_user))
				{
					local effect = this.Tactical.spawnSpriteEffect("effect_skull_03", this.createColor("#ff0000"), a.getTile(), 0, 40, 1.0, 0.25, 0, 400, 300);
					local sacEnemy = this.new("scripts/skills/effects/sacrificed_effect_enemy")
					if(_user.m.Type == this.Const.EntityType.Cultist_High_Priest){
						if (a.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory) == null || a.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory).getID() != "sacrificial_collar"){
							sacEnemy.m.IsHighPriest = true;
						}
					}
					a.getSkills().add(sacEnemy)
				}
			}
			acolytes.extend(i.filter(@(a, b) b != null && b.m.Type == this.Const.EntityType.Cultist_Acolyte))
			fanatics.extend(i.filter(@(a, b) b != null && b.m.Type == this.Const.EntityType.Cultist_Fanatic))
			defilers.extend(i.filter(@(a, b) b != null && b.m.Type == this.Const.EntityType.Cultist_Defiler))			
		}
		this.printDebug(format("Послушников: %i Фанатиков: %i Осквернителей: %i", acolytes.len(), fanatics.len(), defilers.len()), "mod_cultists");

		local enlightened;
		switch(_user.m.Type){
			case this.Const.EntityType.Cultist_Preacher:
				enlightened = findHealthiestUnit(acolytes);
				break;
			case this.Const.EntityType.Cultist_Herald:
				enlightened = findHealthiestUnit(fanatics);
				if (enlightened==null) enlightened = findHealthiestUnit(acolytes);
				break;
			case this.Const.EntityType.Cultist_Prophet:
				enlightened = findHealthiestUnit(fanatics.extend(defilers.filter(@(a, b) this.Math.rand(0, 100)  < 10)));
				if (enlightened==null) enlightened = findHealthiestUnit(acolytes);
				break;
			case this.Const.EntityType.Cultist_High_Priest:
				enlightened = findHealthiestUnit(defilers);
				if (enlightened==null) enlightened = findHealthiestUnit(fanatics);
				break;
			default:
			    break;
		}
		if (enlightened != null){
			this.printDebug(format("найдено культистов, к которым можно применить просветление"), "mod_cultists");
			
			enlightened.getSkills().add(this.new("scripts/skills/effects/sacrificed_effect_enlightened"))
		}
	}

	function findHealthiestUnit(_units)
	{
		if (_units == null || _units.len() == 0) return
		local highest_score = 0.0
		local chosen, score, armor, armorHead, armorBody;

		foreach(unit in _units){
			if (unit == null || !unit.isAlive()) continue
			//get score combined out of health and armor %
			armorHead = this.getContainer().getActor().getArmor(this.Const.BodyPart.Head) / this.getContainer().getActor().getArmorMax(this.Const.BodyPart.Head)
			armorBody = this.getContainer().getActor().getArmor(this.Const.BodyPart.Body) / this.getContainer().getActor().getArmorMax(this.Const.BodyPart.Body)
			armor = (armorHead + armorBody) / 2
			score = (unit.getHitpointsPct() + armor) / 2
			if (chosen == null || highest_score <= score) chosen = unit
		}
		return chosen
	}

});

