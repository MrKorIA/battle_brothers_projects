this.vp_veteran_levels <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "special.vp_veteran_levels";
		this.m.Name = "";
		this.m.Description = "";
		this.m.Type = ::Const.SkillType.Special;
		this.m.IsSerialized = false;
		this.m.IsHidden = true;
	}

	function onUpdateLevel()
	{
		local level = this.getContainer().getActor().getLevel();
		if (level == 13 || level == 16 || level == 20 || level == 25)
		{
			this.getContainer().getActor().m.PerkPoints++;
		}
	}
});
