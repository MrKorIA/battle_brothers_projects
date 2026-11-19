this.nggh_mod_summon_flying_skulls_skill <- ::inherit("scripts/skills/skill", {
	m = {
		Cooldown = 0
	},
	function create()
	{
		this.m.ID = "actives.flying_skulls";
		this.m.Name = "Призвать воющие черепа";
		this.m.Description = "Вызовите отряд воинственных черепов для самоубийственной миссии. За одну попытку можно породить до 10 черепов.";
		this.m.Icon = "skills/active_219.png";
		this.m.IconDisabled = "skills/active_219_sw.png";
		this.m.Overlay = "active_219";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/mirror_image_01.wav",
			"sounds/enemies/dlc6/mirror_image_02.wav",
			"sounds/enemies/dlc6/mirror_image_03.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.NonTargeted;
		this.m.Delay = 0;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAudibleWhenHidden = false;
		this.m.IsUsingActorPitch = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
		this.m.MaxLevelDifference = 4;
	}

	function onAdded()
	{
		this.getContainer().getActor().getAIAgent().addBehavior(::new("scripts/ai/tactical/behaviors/nggh_mod_ai_flying_skulls_player"));
	}

	function onRemoved()
	{
		this.getContainer().getActor().getAIAgent().removeBehavior(::Const.AI.Behavior.ID.FlyingSkulls);
	}

	function addResources()
	{
		this.skill.addResources();
		local move = [
			"sounds/enemies/dlc6/skull_move_01.wav",
			"sounds/enemies/dlc6/skull_move_02.wav",
			"sounds/enemies/dlc6/skull_move_03.wav",
			"sounds/enemies/dlc6/skull_move_04.wav"
		];
		local bang = [
			"sounds/enemies/dlc6/skull_bang_01.wav",
			"sounds/enemies/dlc6/skull_bang_02.wav",
			"sounds/enemies/dlc6/skull_bang_03.wav",
			"sounds/enemies/dlc6/skull_bang_04.wav"
		];

		foreach( r in move )
		{
			::Tactical.addResource(r);
		}

		foreach( r in bang )
		{
			::Tactical.addResource(r);
		}
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();

		if (::Tactical.isActive())
		{
			local count = this.getNumOfSkulls();

			if (count > 0)
			{
				ret.push({
					id = 8,
					type = "text",
					icon = "ui/icons/kills.png",
					text = "Количество 'Воющих черепов' на карте: [color=" + ::Const.UI.Color.PositiveValue + "]" + count + "[/color]"
				});
			}
			else
			{
				ret.push({
					id = 8,
					type = "text",
					icon = "ui/icons/kills.png",
					text = "На карте нет 'Воющих черепов'"
				});
			}

			if (this.m.Cooldown == 0 && count > 6)
			{
				ret.push({
					id = 8,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + ::Const.UI.Color.NegativeValue + "]Может порождать больше, только когда на земле меньше 7 'Воющих черепов'[/color]."
				});
			}
		}

		if (this.m.Cooldown > 0)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Можно использовать снова после " + this.m.Cooldown + " хода(ов)[/color]"
			});

			return ret;
		}

		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.m.Cooldown == 0 && this.getNumOfSkulls() <= 6;
	}

	function getNumOfSkulls()
	{
		local actor = this.getContainer().getActor();
		local faction = actor.getFaction();
		local entities = ::Tactical.Entities.getInstancesOfFaction(faction == ::Const.Faction.Player ? ::Const.Faction.PlayerAnimals : faction);
		local skulls = 0;

		foreach( e in entities )
		{
			if (!e.getFlags().has("creator"))
			{
				continue;
			}

			if (e.getFlags().get("creator") != actor.getID())
			{
				continue;
			}

			if (e.getType() == ::Const.EntityType.FlyingSkull) 
			{
				skulls = ++skulls;
			}
		}

		return skulls;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Cooldown = 1;
		::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " овладел смертью!");

		local b = _user.getAIAgent().getBehavior(::Const.AI.Behavior.ID.FlyingSkulls);

		if (b != null) {
			b.onEvaluate(_user);
			return b.onExecute(_user);
		}
		
		return false;
	}

	function onTurnStart()
	{
		this.m.Cooldown = ::Math.max(0, this.m.Cooldown - 1);
	}

	function onCombatStarted()
	{
		this.m.Cooldown = 0;		
	}

	function onCombatFinished()
	{
		this.m.Cooldown = 0;
	}

});

