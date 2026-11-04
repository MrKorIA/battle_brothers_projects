this.ai_ogre_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Damage = 1,
		LastRoundApplied = 0
	},
	function create()
	{
		this.m.ID = "effects.spider_poison";
		this.m.Name = "Болезнь огров (" + this.m.Damage + " Stack)";
		this.m.KilledString = "Умер от болезни огров";
		this.m.Icon = "skills/status_effect_54.png";
		this.m.IconMini = "status_effect_54_mini";
		this.m.Overlay = "status_effect_54";
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.DamageOverTime;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "This character loses [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.Damage + "[/color] очков здоровья в конце каждого хода. Этот эффект исчезнет в конце хода, если в радиусе 3 клеток поблизости не будет ни одного огра.";
	}

	function applyDamage()
	{
		local actor = this.getContainer().getActor();
		local mytile = actor.getTile();
		local actors = this.Tactical.Entities.getAllInstances();
		local yes = 0;
		foreach( i in actors )
		{
			foreach( a in i )
			{
				if (a.getID() == actor.getID())
				{
					continue;
				}
				if (!a.isAlliedWith(actor) && a.getFlags().has("xxmob_ogre") && mytile.getDistanceTo(a.getTile()) > 3)
				{
					yes = 1;
					break;
				}
			}
		}
		if (yes == 1)
		{
			this.removeSelf();
		}
		else if (this.m.LastRoundApplied != this.Time.getRound())
		{
			this.m.LastRoundApplied = this.Time.getRound();
			this.spawnIcon("status_effect_54", actor.getTile());
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = this.m.Damage;
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			actor.onDamageReceived(actor, this, hitInfo);
		}
	}

	function onRefresh()
	{
		++this.m.Damage;
		this.m.Name = "Болезнь огра (" + this.m.Damage + " Стек)";
	}

	function onTurnEnd()
	{
		this.applyDamage();
	}

	function onWaitTurn()
	{
		this.applyDamage();
	}

});

