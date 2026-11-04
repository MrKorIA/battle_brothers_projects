//better acolytes, same plan but better stats?
this.mod_cultist_fanatic_enlightened <- this.inherit("scripts/entity/tactical/cultist/mod_cultist_fanatic", {
	m = {
	},
	function create()
	{
		this.mod_cultist_fanatic.create();
		this.m.Type = this.Const.EntityType.Cultist_Fanatic_Enlightened;
	}

	function onInit()
	{
		this.mod_cultist_fanatic.onInit();
		this.m.SoundPitch = 0.7;
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_duelist"));
		local sprite = this.addSprite("duelistEyes");
		sprite.setHorizontalFlipping(true);
		sprite.Visible = true;
		sprite.setBrush("cultist_rage_eyes");
		sprite.Alpha = 200;
		sprite.varySaturation(0.3);
		this.m.Name = "Просвещённый фанатик Давкула"

	}
});

