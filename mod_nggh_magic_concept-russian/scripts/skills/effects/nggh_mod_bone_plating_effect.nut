this.nggh_mod_bone_plating_effect <- ::inherit("scripts/skills/skill", {
	m = {
		Count = 1
	},
	function setCount( _c )
	{
		this.m.Count = _c;
	}

	function create()
	{
		this.m.ID = "effects.bone_plating";
		this.m.Name = "Костяные пластины";
		this.m.Icon = "skills/boneplating_effect.png";
		this.m.IconMini = "mini_boneplating_effect";
		this.m.Overlay = "boneplating_effect";
		this.m.SoundOnHitArmor = [
			"sounds/enemies/skeleton_hurt_01.wav",
			"sounds/enemies/skeleton_hurt_02.wav",
			"sounds/enemies/skeleton_hurt_03.wav",
			"sounds/enemies/skeleton_hurt_04.wav",
			"sounds/enemies/skeleton_hurt_06.wav"
		];
		this.m.Order = ::Const.SkillOrder.Last;
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsActive = false;
	}

	function getDescription()
	{
		return "Может полностью поглотить " + (this.m.Count == 1 ? "1 удар" : " до " + this.m.Count + " ударов") + ", которые не игнорируют броню";
	}

	function onBeforeDamageReceived(_attacker, _skill, _hitInfo, _properties)
	{
		if (_hitInfo.BodyPart != ::Const.BodyPart.Body || _hitInfo.DamageDirect >= 1.0)
			return;

		_properties.DamageReceivedTotalMult = 0.0;
		::Tactical.EventLog.logEx("Урон поглощён костяными пластинами");
		::Sound.play(::MSU.Array.rand(this.m.SoundOnHitArmor), ::Const.Sound.Volume.Skill * this.m.SoundVolume, this.getContainer().getActor().getPos());
		this.spawnIcon(this.m.Overlay, this.getContainer().getActor().getTile());
		
		if (--this.m.Count <= 0)
			this.removeSelf();
	}

});
