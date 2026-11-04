this.ai_dark_chant <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		PossibleSkills = [
			"actives.mod_dark_chant"
		],
		CurrentDanger = 0.0,
		Skill = null,
		TargetDistance = 0,
		TargetScore = 0,

	},

	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.ModDavkulPriestDarkChant;
		this.m.Order = this.Const.AI.Behavior.Order.ModDavkulPriestDarkChant;
		this.m.IsThreaded = false;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		this.m.Skill = null;

		this.m.TargetDistance = 0;
		this.m.TargetScore = 0;
		local score = this.getProperties().BehaviorMult[this.m.ID];

		if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}


		this.m.Skill = this.selectSkill(this.m.PossibleSkills);

		if (this.m.Skill == null)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}
		local score = 20 * this.getTileValue(_entity.getTile(), _entity)

		this.printDebug("возвращает "+ score + " для тёмного песнопения ", "mod_cultists")
		return score
	}

	function onExecute( _entity )
	{
		if (this.m.IsFirstExecuted)
		{
			this.getAgent().adjustCameraToTarget(_entity.getTile());
			this.m.IsFirstExecuted = false;
			return false;
		}

		this.m.Skill.use(_entity.getTile());

		if (_entity.isAlive() && !_entity.isHiddenToPlayer() && _entity.getActionPoints() >= 4)
		{
			this.getAgent().declareAction();
			this.getAgent().declareEvaluationDelay(this.m.Skill.getDelay());
		}

		this.m.Skill = null;
		return true;
	}

	function getTileValue(_tile, _entity)
	{
		local actors = this.Tactical.Entities.getAllInstances();
		local useScore = 0.0;
		local friendlyScoreInRange = 0
		local friendlyScoreBoostMorale = 0
		local enemyScoreInRange = 0
		local enemyScoreDefeatMorale = 0

		foreach( i in actors )
		{
			foreach( a in i )
			{
				if (!a.isAlive() || a.getID() == _entity.getID() || a.getCurrentProperties().TargetAttractionMult < 0.5)
				{
					continue;
				}


				local distance = a.getTile().getDistanceTo(_tile);

				if (a.getFaction() == _entity.getFaction())
				{
					if (a.getMoraleState() == this.Const.MoraleState.Ignore || a.getMoraleState() == this.Const.MoraleState.Confident || distance > 5)
					{
					}
					else friendlyScoreBoostMorale += this.Math.max(0, (5 - distance));
					
				}
				else if (!a.isAlliedWith(_entity))
				{
					if (distance <= 2 && this.has2hRange(distance, a)) enemyScoreInRange -= 20
					if (a.getMoraleState() == this.Const.MoraleState.Ignore || a.getMoraleState() == this.Const.MoraleState.Fleeing || 
						a.getCurrentProperties().MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] > 1.0 || a.getBravery() >= 80 || distance > 7){
					}
					else enemyScoreDefeatMorale += this.Math.max(0, (7 - distance));
				}

			}
		}
		useScore = friendlyScoreInRange+friendlyScoreBoostMorale+enemyScoreInRange+enemyScoreDefeatMorale
		// this.printDebug(
		// 	"Идентификатор клетки: " + _tile.ID + "\n"+
		// 	"friendlyScoreInRange: " + friendlyScoreInRange + "\n"+
		// 	"friendlyScoreBoostMorale: " + friendlyScoreBoostMorale + "\n"+
		// 	"enemyScoreInRange: " + enemyScoreInRange + "\n"+
		// 	"enemyScoreDefeatMorale: " + enemyScoreDefeatMorale + "\n"+
		// 	"Всего: " + useScore, "mod_cultists"
		// 	)
		
		return useScore
	}

	function has2hRange(_distance, _entity)
	{
		this.printDebug(format("Проверка %s", _entity.getName()), "mod_cultists");
		local mainhand = _entity.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand)
		if (mainhand != null && mainhand.isItemType(this.Const.Items.ItemType.Weapon) && "getRangeIdeal" in mainhand && mainhand.getRangeIdeal() == _distance) return true
		foreach (item in _entity.getItems().getAllItemsAtSlot(this.Const.ItemSlot.Bag)){
			if (item != null && item.isItemType(this.Const.Items.ItemType.Weapon) && "getRangeIdeal" in item && item.getRangeIdeal() == _distance) return true
		}
		return false
	}


});
