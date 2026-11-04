this.sbp_skullsurgery_skill <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false
	},
	function create()
	{
		this.m.ID = "actives.sbp_skullsurgery_skill";
		this.m.Name = "105. Хирургия черепа (пассивная)";
		this.m.Icon = "ui/xxp14.png";
		this.m.Description = "При использовании цепа или булавы: [color=" + this.Const.UI.Color.PositiveValue + "]+12[/color] Навык ближнего боя";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast + 100;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
		this.m.IsHidden = false;
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

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_targetEntity == null || _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
		{
			return;
		}
		if (_bodyPart == this.Const.BodyPart.Head && _targetEntity.isAlive() && !_targetEntity.isDying() && !this.m.IsSpent)
		{
			this.m.IsSpent = true;
			local t = _targetEntity;
			for( local i = 0; i < 10; i = ++i )
			{
				t.getSkills().add(this.new("scripts/skills/effects/ai_weak_effect"));
			}
			local xsk = this.new("scripts/skills/actives/ai_fakebuff");
			xsk.m.Overlay = "";
			t.getSkills().add(xsk);
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = 10;
			hitInfo.DamageDirect = 1;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1;
			t.onDamageReceived(this.getContainer().getActor(), this, hitInfo);
		}
	}

	function onNewRound()
	{
		this.m.IsSpent = false;
	}

});

