this.catching_enemy_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TargetEntity = null
		},
	function create()
	{
		this.m.ID = "effects.catching_enemy"; // unused effect, but referenced in other files so useful to use here
		this.m.Name = "Удержание врага";
		this.m.Description = "Этот персонаж удерживает врага, используя людолов.";
		this.m.Icon = "skills/manchatcher_effect_catching.png";
		this.m.IconMini = "manchatcher_effect_catching_mini";
		this.m.Overlay = "manchatcher_effect_catching";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getName()
	{
		if (this.m.TargetEntity != null) return "Удерживает персонажа " + this.m.TargetEntity.getName()
		return "Удерживает врага";
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = "Удерживает " + this.m.TargetEntity.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
	}
	
	function onDamageReceived(_attacker, _skill, _hitInfo)
	{

		this.removeSelf()
	}

	function onRemoved()
	{
		this.removeOthersEffect()

	}
	function onUpdate( _properties )
	{
		if (this.m.TargetEntity != null && this.m.TargetEntity.isAlive())
		{
			local dist = this.getContainer().getActor().getTile().getDistanceTo(this.m.TargetEntity.getTile())
			if (dist != 2){
				this.removeSelf()
				return
			}

		}
	}
	function onDeath(_fatalityType)
	{	
		this.removeSelf()
	}

	function removeOthersEffect()
	{
		if (this.m.TargetEntity != null && this.m.TargetEntity.isAlive())
		{
			this.printDebug("снят эффект 'пойман людоловом' для " + this.m.TargetEntity.getName(), "mod_cultists")
			this.m.TargetEntity.getSkills().removeByID("effects.serpent_ensnare")
			this.m.TargetEntity = null;
		}
	}
});

