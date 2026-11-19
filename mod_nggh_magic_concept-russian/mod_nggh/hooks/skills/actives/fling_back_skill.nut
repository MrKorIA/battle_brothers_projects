::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/fling_back_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Захватить цель и перебросить за себя, чтобы освободить путь вперед. Можно использовать на союзников.";
		m.Icon = "skills/active_111.png";
		m.IconDisabled = "skills/active_111_sw.png";
		m.IsIgnoringRiposte = true;
		m.IsSpearwallRelevant = false;
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]Отбрасывает[/color] цель и [color=" + ::Const.UI.Color.PositiveValue + "]делает шаг вперед[/color]"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Наносит [color=" + ::Const.UI.Color.NegativeValue + "]урон от падения[/color] в зависимости от [color=" + ::Const.UI.Color.NegativeValue + "]высоты[/color]"
			}
		]);

		if (isUpgraded())
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Имеет [color=" + ::Const.UI.Color.PositiveValue + "]100%[/color] шанс выбить дух"
			});
		
		return ret;
	}

	q.isUpgraded <- function()
	{
		return getContainer().getActor().getCurrentProperties().IsSpecializedInThrowing;
	}

	q.onAfterUpdate <- function( _properties )
	{
		m.FatigueCostMult = _properties.IsSpecializedInThrowing ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;

		if (_properties.IsSpecializedInThrowing)
			m.ActionPointCost -= 1;
	}

	q.onKnockedDown = @(__original) function( _entity, _tag )
	{
		local isSpecialized = _tag.Skill.isUpgraded();

		if (_tag.HitInfo.DamageRegular > 0 && isSpecialized)
			_tag.HitInfo.DamageRegular *= 2.0;

		__original(_entity, _tag);

		if (_tag.HitInfo.DamageInflictedHitpoints <= 0)
			return;

		if (typeof _tag.Attacker == "instance" && _tag.Attacker.isNull() || !_tag.Attacker.isAlive() || _tag.Attacker.isDying())
			return;
		
		_tag.Skill.getContainer().onTargetHit(_tag.Skill, _entity, _tag.HitInfo.BodyPart, _tag.HitInfo.DamageInflictedHitpoints, _tag.HitInfo.DamageInflictedArmor);

		if (isSpecialized && _entity.isAlive() && !_entity.isDying() && !_entity.getCurrentProperties().IsImmuneToDaze) {
			_entity.getSkills().add(::new("scripts/skills/effects/dazed_effect"));

			if (!_entity.isHiddenToPlayer())
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_tag.Attacker) + " выбил дух из противника " + ::Const.UI.getColorizedEntityName(_entity) + " на один ход");
		}
	}

	q.onTargetSelected <- function( _targetTile )
	{
		local knockToTile = findTileToKnockBackTo(getContainer().getActor().getTile(), _targetTile);

		if (knockToTile != null)
			::Tactical.getHighlighter().addOverlayIcon("mortar_target_02", knockToTile, knockToTile.Pos.X, knockToTile.Pos.Y);
	}
});
