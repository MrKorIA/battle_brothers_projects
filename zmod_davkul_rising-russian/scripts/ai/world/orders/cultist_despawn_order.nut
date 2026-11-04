this.cultist_despawn_order <- this.inherit("scripts/ai/world/world_behavior", {
	m = {},
	function create()
	{
		this.world_behavior.create();
		this.m.ID = this.Const.World.AI.Behavior.ID.Despawn;
	}

	function onSerialize( _out )
	{
		this.world_behavior.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.world_behavior.onDeserialize(_in);
	}

	function onExecute( _entity, _hasChanged )
	{
		local entities = this.World.getAllEntitiesAndOneLocationAtPos(_entity.getPos(), 1.0);
		foreach( e in entities )
		{
			if (e.isAlive() && e.isLocation() && e.m.TypeID == "location.cultist_camp")
			{
				local sacrifices = 0
				foreach(unit in _entity.m.Troops)
				{
					if (unit.ID == this.Const.EntityType.Cultist_Sacrifice) sacrifices++
				}
				this.printDebug("добавлены жертвы в лагере: " + sacrifices, "mod_cultists")
				e.addSacrifices(sacrifices)
			}
		}
		_entity.fadeOutAndDie();
		this.getController().popOrder();
		return true;
	}

});

