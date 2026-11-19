this.nggh_mod_kraken_preferred_tentacle_mode <- ::inherit("scripts/skills/nggh_mod_toggle_mode_skill", {
	m = {},
	function create()
	{
		this.nggh_mod_toggle_mode_skill.create();
		this.m.ID = "actives.kraken_prefer_tentacle_mode";
		this.m.Name = "Привилегированный режим";
		this.m.FlagName = "tentacle_mode";
		//this.m.Description = "Режим автопилота ваших порожденных пауков.";
		this.m.Icon = "skills/active_kraken_tentacle_rage_on.png";
		this.m.IconDisabled = "skills/active_kraken_tentacle_rage_off.png";
		this.m.Order += 3;
	}

	function isHidden()
	{
		return this.skill.isHidden() || !this.getContainer().getActor().getFlags().get("tentacle_autopilot");
	}

	function getMode()
	{
		return this.getContainer().getActor().getFlags().getAsInt(this.m.FlagName);
	}

	function setMode( _integer )
	{
		if (typeof _integer == "integer")
		{
			this.getContainer().getActor().getFlags().set(this.m.FlagName, _integer);
		}
		else
		{
			this.getContainer().getActor().getFlags().set(this.m.FlagName, ::Const.KrakenTentacleMode.Ensnaring);
		}
	}

	function getName()
	{
		return this.m.Name + ": " + (this.getMode() == ::Const.KrakenTentacleMode.Ensnaring ? "[color=" + ::Const.UI.Color.PositiveValue + "]Опутывание[/color]" : "[color=" + ::Const.UI.Color.NegativeValue + "]Атака[/color]");
	}

	function getDescription()
	{
		return "Позволяет определить, какое поведение должно быть приоритетным для вновь порожденных щупалец при включенном автопилоте. [color=" + ::Const.UI.Color.NegativeValue + "]Не влияет на уже существующие щупальца[/color].";
	}

	function getIcon()
	{
		if (this.getMode() == ::Const.KrakenTentacleMode.Attacking)
		{
			return this.m.Icon;
		}

		return this.m.IconDisabled;
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
			},
		];

		if (this.getMode() == ::Const.KrakenTentacleMode.Ensnaring)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/net.png",
				text = "Порожденное щупальце будет находиться в режиме [color=" + ::Const.UI.Color.PositiveValue + "]Опутывание[/color]"
			});

			return ret;
		}
		
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/damage_dealt.png",
			text = "Порожденное щупальце будет находиться в режиме [color=" + ::Const.UI.Color.NegativeValue + "]Атака[/color]"
		});

		return ret;
	}

	function switchMode( _reset = false )
	{
		if (_reset)
		{
			this.setMode(::Const.KrakenTentacleMode.Ensnaring);
		}
		else
		{
			this.setMode(this.getMode() == ::Const.KrakenTentacleMode.Ensnaring ? ::Const.KrakenTentacleMode.Attacking : ::Const.KrakenTentacleMode.Ensnaring);
		}

		this.onAfterSwitchMode();
		return true;
	}


});

