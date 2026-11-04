this.mod_dark_chant <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.mod_dark_chant";
		this.m.Name = "Тёмные песнопения";
		this.m.Description = "";
		this.m.Icon = "ui/perks/perk_42_active.png";
		this.m.IconDisabled = "ui/perks/perk_42_active_sw.png";
		this.m.Overlay = "perk_42_active";
		this.m.SoundOnUse = [
			"sounds/combat/rally_the_troops_cultist.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.Delay = 1000
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 5;
	}

	function isUsable()
	{
		local hasEnemyZoc = this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions())
		return this.skill.isUsable() && !this.getContainer().hasSkill("effects.rallied") && !hasEnemyZoc;
	}

	function onUse( _user, _targetTile )
	{

		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " использует умение 'Тёмные песнопения'");
		local tag = {
			User = _user
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, this.m.Delay, this.onDelayedEffect.bindenv(this), tag);

		
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local _user = _tag.User
		local myTile = _user.getTile();
		local bravery = this.Math.floor(_user.getCurrentProperties().getBravery() * 0.4);
		local actors = this.Tactical.Entities.getAllInstances();

		foreach( i in actors )
		{
			foreach( a in i )
			{
				if (a.getID() == _user.getID())
				{
					continue;
				}

				if (myTile.getDistanceTo(a.getTile()) > 5)
				{
					continue;
				}

				if ((a.getFaction() == _user.getFaction()) || a.isPlayerControlled() && (a.getBackground().getID() == "background.cultist" || a.getBackground().getID() == "background.converted_cultist"))
				{

					local difficulty = bravery;
					local distance = a.getTile().getDistanceTo(myTile) * 10;
					local morale = a.getMoraleState();

					if (a.getMoraleState() == this.Const.MoraleState.Fleeing)
					{
						a.checkMorale(this.Const.MoraleState.Wavering - this.Const.MoraleState.Fleeing, difficulty, this.Const.MoraleCheckType.Default, "status_effect_56");
					}
					else
					{
						a.checkMorale(1, difficulty - distance, this.Const.MoraleCheckType.Default, "status_effect_56");
					}

					if (morale != a.getMoraleState())
					{
						a.getSkills().add(this.new("scripts/skills/effects/rallied_effect"));
					}
				}
				else if (!a.isAlliedWith(_user))
				{
					#local effect = this.Tactical.spawnSpriteEffect("effect_skull_03", this.createColor("#ffffff"), a.getTile(), 0, 40, 1.0, 0.25, 0, 400, 300);
					//difficulty should be negative
					local difficulty = this.Math.round(_user.getCurrentProperties().getBravery()*0.1 + a.getTile().getDistanceTo(myTile))
					this.printDebug(format("Сложность темных песнопений = %i", -difficulty), "mod_cultists");
					
					a.checkMorale(-1, this.Math.min(0, -difficulty), this.Const.MoraleCheckType.MentalAttack, "effect_skull_03");
				}
			}
		}
		_user.getSkills().add(this.new("scripts/skills/effects/rallied_effect"));
	}

});

