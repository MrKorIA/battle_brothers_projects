this.sbq20p_darkaura_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbq20p_darkaura_skill";
		this.m.Name = "127. Dark Aura (passive)";
		this.m.Icon = "ui/xxp38.png";
		this.m.Description = "At the start of every 2rd turn, targets within 1 tile of you lose 15 HP. (This effect cannot reduce HP below 1)";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast + 100;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
		this.m.IsHidden = false;
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isAlive() || !actor.isPlacedOnMap()) return;
		local round = this.Time.getRound();
		if (round % 2 == 0)
		{
			this.Tactical.queryTilesInRange(actor.getTile(), 1, 1, false, [], this.onQueryTile, actor);
		}
	}

	function onQueryTile( _tile, _user )
	{
		if (_user == null || !_user.isAlive()) return;
		if (_tile.IsOccupiedByActor)
		{
			local target = _tile.getEntity();
			if (target.isAlive() && target.getCurrentProperties().DamageReceivedTotalMult > 0)
			{
				target.setHitpoints(this.Math.max(target.getHitpoints() - 15, 1));
				
				local fakeb = this.new("scripts/skills/actives/ai_fakebuff");
				fakeb.m.Overlay = "status_effect_123";
				target.getSkills().add(fakeb);				
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " suffered HP damage.");
			}
		}
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
			}
		];
		return ret;
	}

});

