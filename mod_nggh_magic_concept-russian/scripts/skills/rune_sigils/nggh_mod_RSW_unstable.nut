this.nggh_mod_RSW_unstable <- ::inherit("scripts/skills/skill", {
	m = {
		IsForceEnabled = false
	},
	function create()
	{
		::Legends.Effects.onCreate(this, ::Legends.Effect.NgGHRswUnstable);
		m.Description = "Рунный знак: Нестабильность";
		m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		m.Type = ::Const.SkillType.Special | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.VeryLast;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = true;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_targetEntity == null || _skill == null)
			return;

		if (!m.IsForceEnabled && ::MSU.isNull(getItem()))
			return;

		local roll = ::Math.rand(1, 100);

		if (roll > 90) {
			_hitInfo.DamageRegular *= 3.0;
			_hitInfo.DamageArmor *= 3.0;
			this.spawnIcon("status_effect_106", _targetEntity.getTile());
			::Tactical.EventLog.logEx("Этот удар разрушителен из-за руны на оружии персонажа.");
		}
		else if (roll <= 10) {
			_hitInfo.DamageRegular /= 3.0;
			_hitInfo.DamageArmor /= 3.0;
			this.spawnIcon("status_effect_111", _targetEntity.getTile());
			::Tactical.EventLog.logEx("Этот удар жалок из-за руны на оружии персонажа.");
		}		
	}

});

