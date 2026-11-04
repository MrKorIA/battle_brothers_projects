this.AI_vs_AI <- this.inherit("scripts/events/event", {
	m = {
	},
	function create()
	{
		this.m.ID = "event.test_AI";
		this.m.Title = "По пути...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
				}
			],
			function start( _event )
			{
			}

		});
		
	}
	function setResources(_r)
	{
		this.m.Resources <- _r
	}
	function setEnemy(_type)
	{
	}
	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{

	}

	function onClear()
	{

	}

	function testAI()
	{
		this.Const.World.Spawn.CultistTest <- 
		[
			{
				Cost = 2000,
				Troops = [
					{
						Type = this.Const.World.Spawn.Troops.Cultist_Fanatic,
						Num = 6
					},
					{
						Type = this.Const.World.Spawn.Troops.Cultist_Defiler,
						Num = 6
					},
					{
						Type = this.Const.World.Spawn.Troops.Cultist_Mancatcher,
						Num = 6
					},
					{
						Type = this.Const.World.Spawn.Troops.Cultist_Preacher,
						Num = 6
					},
					{
						Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice,
						Num = 6
					},
					{
						Type = this.Const.World.Spawn.Troops.Cultist_Hunter,
						Num = 6
					}
				]
			}
		]
		// this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Greenskins, difficulty , this.World.FactionManager.getFactionOfType(this.Const.FactionType.Cultists).getID());
		#this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BanditDefenders, difficulty , this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse)[0].getID());
		#this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, difficulty , this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse)[0].getID());
		#this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, difficulty , this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse)[0].getID());
		// p.IsFleeingProhibited = true;

		local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
		p.CombatID = "OrcAttack";
		p.Music = this.Const.Music.OrcsTracks;
		p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
		p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
		p.IsAutoAssigningBases = false;
		local difficulty = 1000; //group sizes
		local allies = this.Const.World.Spawn.Noble; //copypaste your allied spawnlist here
		local enemies = this.Const.World.Spawn.BanditRoamers; //copypaste your enemy spawnlist here
		this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, difficulty , this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse)[0].getID());
		this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.CultistTest, difficulty, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Cultists).getID());
		this.World.State.startScriptedCombat(p, false, false, true);
		return 0;
	}

});

