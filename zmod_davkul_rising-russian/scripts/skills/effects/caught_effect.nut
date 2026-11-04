this.caught_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TargetEntity = null,
		QuickHands = false,
		ShouldUpdate = false,
		CurrentWeapon = null
		},
	function create()
	{
		this.m.ID = "effects.serpent_ensnare"; // unused effect, but referenced in other files so useful to use here
		this.m.Name = "Пойман людоловом";
		this.m.Description = "";
		this.m.Icon = "skills/manchatcher_effect_caught.png";
		this.m.IconMini = "manchatcher_effect_caught_mini";
		this.m.Overlay = "manchatcher_effect_caught";
		this.m.SoundOnHitHitpoints = [
			"sounds/combat/break_free_net_01.wav",
			"sounds/combat/break_free_net_02.wav",
			"sounds/combat/break_free_net_03.wav"
		];
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = "Этот персонаж пойман людоловом на " + this.m.TargetEntity.getName() + " ход(а). Освободите его, нанеся ловцу урон или просто высвободите союзника."
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Персонаж не может двигаться[/color]"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "Смена предметов стоит [color=" + this.Const.UI.Color.NegativeValue + "]+5[/color] ОД"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-35%[/color] к защите в ближнем бою"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-35%[/color] к защите в дальнем бою"
			}			
		];
	}

	function getName()
	{
		if (this.m.TargetEntity != null) return "Пойман противником " + this.m.TargetEntity.getName()
		return "Пойман людоловом";
	}

	//called after the actor pays for the weapon switch
	function checkQuickHands()
	{
		local actor = this.getContainer().getActor()
		local currentWeapon = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null ? null : actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).getInstanceID()
		this.m.QuickHands = this.m.QuickHands && currentWeapon == this.m.CurrentWeapon
	}
	
	function setQuickHands()
	{
		local actor = this.getContainer().getActor()
		this.m.CurrentWeapon = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null ? null : actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).getInstanceID()
		this.m.QuickHands = this.getContainer().hasSkill("perk.quick_hands") && actor.getItems().m.ActionCost == 0
	}

	function onAdded()
	{
		local breakFree = this.new("scripts/skills/actives/break_free_skill");
		breakFree.m.Icon = "skills/active_74.png";
		breakFree.m.IconDisabled = "skills/active_74_sw.png";
		breakFree.m.Overlay = "active_74";
		breakFree.m.SoundOnUse = this.m.SoundOnHitHitpoints;
		breakFree.setDecal("net_destroyed");
		breakFree.setChanceBonus(0);
		this.getContainer().add(breakFree);

		
		this.setQuickHands()
		this.getContainer().getActor().getItems().m.ActionCost = this.m.QuickHands ? 5 : 9
		this.getContainer().getActor().getItems().m.ActionCost2H = 9
		this.m.ShouldUpdate = true
		this.printDebug(format("Добавлено: Есть ли бонус за быстрые руки у %s? %d", this.m.QuickHands ? "T" : "F", this.getContainer().getActor().getItems().m.ActionCost), "mod_cultists");
	}

	function onUpdate( _properties )
	{
		_properties.IsRooted = true;
		_properties.MeleeDefenseMult *= 0.65;
		_properties.RangedDefenseMult *= 0.65;
		#_properties.InitiativeMult *= 0.65;
		if (this.m.ShouldUpdate)
		{
			this.getContainer().getActor().getItems().m.ActionCost = this.m.QuickHands ? 5 : 9
			this.getContainer().getActor().getItems().m.ActionCost2H = 9
			#this.checkQuickHands()
			this.printDebug(format("Обновлено: Есть ли бонус за быстрые руки у %s? %d", this.m.QuickHands ? "T" : "F", this.getContainer().getActor().getItems().m.ActionCost), "mod_cultists");
		}
	}

	function onNewRound()
	{
		this.setQuickHands()
		this.printDebug(format("Новая игра: Есть ли бонус за быстрые руки у %s? %d", this.m.QuickHands ? "T" : "F", this.getContainer().getActor().getItems().m.ActionCost), "mod_cultists");
	}


	function onRemoved()
	{
		this.removeOthersEffect()
		this.getContainer().getActor().getSprite("status_rooted").Visible = false;
		this.getContainer().getActor().getSprite("status_rooted_back").Visible = false;
		this.getContainer().removeByID("actives.break_free")
		this.getContainer().getActor().getItems().m.ActionCost = this.m.QuickHands ? 0 : this.Const.Tactical.Settings.SwitchItemAPCost
		this.getContainer().getActor().getItems().m.ActionCost2H = this.Const.Tactical.Settings.SwitchItemAPCost
	}

	function onDeath(_fatalityType)
	{	
		this.removeSelf()
	}

	function removeOthersEffect()
	{
		if (this.m.TargetEntity != null && this.m.TargetEntity.isAlive())
		{
			this.printDebug("снят эффект 'удержание врага' для " + this.m.TargetEntity.getName(), "mod_cultists")
			this.m.TargetEntity.getSkills().removeByID("effects.catching_enemy")
			this.m.TargetEntity = null;
		}
	}

});

