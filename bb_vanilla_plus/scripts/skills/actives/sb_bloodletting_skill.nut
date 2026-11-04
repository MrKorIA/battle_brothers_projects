this.sb_bloodletting_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 5,
		Skillcool = 5
	},
	function create()
	{
		this.m.ID = "actives.sb_bloodletting_skill";
		this.m.Name = "8. Кровопускание";
		this.m.Description = "Исцелите себя или союзника с помощью кровопускания";
		this.m.Icon = "ui/xx64.png";
		this.m.IconDisabled = "ui/xx64_sw.png";
		this.m.SoundOnUse = [
			"sounds/combat/first_aid_01.wav",
			"sounds/combat/first_aid_02.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 10;
		this.m.MinRange = 0;
		this.m.MaxRange = 2;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Восстановить [color=" + this.Const.UI.Color.PositiveValue + "]0~50[/color] здоровье"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Снимает эффекты отравления/опьянения/похмелья. Даёт случайный урон от эффекта кровотечения."
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Перезарядка: 5 ходов \nПерезарядка: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] ход"
		});
		return ret;
	}

	function getCursorForTile( _tile )
	{
		return this.Const.UI.Cursor.Drink;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();
		local target = _targetTile.getEntity();
		while (target.getSkills().hasSkill("effects.goblin_poison"))
		{
			target.getSkills().removeByID("effects.goblin_poison");
		}

		while (target.getSkills().hasSkill("effects.spider_poison"))
		{
			target.getSkills().removeByID("effects.spider_poison");
		}

		while (target.getSkills().hasSkill("effects.drunk"))
		{
			target.getSkills().removeByID("effects.drunk");
		}

		while (target.getSkills().hasSkill("effects.hangover"))
		{
			target.getSkills().removeByID("effects.hangover");
		}
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
		target.playSound(this.Const.Sound.ActorEvent.DamageReceived, 2);
		this.Tactical.getShaker().shake(target, myTile, 4, this.Const.Combat.ShakeEffectHitpointsHitColor, this.Const.Combat.ShakeEffectHitpointsHitHighlight, this.Const.Combat.ShakeEffectHitpointsHitFactor, this.Const.Combat.ShakeEffectHitpointsSaturation, this.Const.ShakeCharacterLayers[this.Const.BodyPart.All], 5.0);
		target.setHitpoints(this.Math.min(target.getHitpoints() + this.Math.rand(0, 50), target.getHitpointsMax()));
		local effect = this.new("scripts/skills/effects/bleeding_effect");
		effect.setDamage(this.Math.rand(0, 8));
		target.getSkills().add(effect);
		return true;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}
		if (!this.m.Container.getActor().isAlliedWith(_targetTile.getEntity()))
		{
			return false;
		}

		return true;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else if (this.m.Skillcool < this.m.Cooldown)
		{
			return false;
		}
		return true;
	}

	function onTurnStart()
	{
		this.m.Skillcool = this.m.Skillcool + 1;
	}

	function onCombatFinished()
	{
		this.m.Skillcool = this.m.Cooldown;
	}

});

